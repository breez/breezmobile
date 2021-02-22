import 'dart:async';
import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/entities/episode.dart';
import 'package:anytime/repository/repository.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:anytime/ui/widgets/transport_controls.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/podcast_payments/actions.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fixnum/fixnum.dart';

const maxFeePart = 0.2;

class PodcastPaymentsBloc with AsyncActionsHandler {
  final _listeningTime = Map<String, int>();
  final AudioBloc audioBloc;
  final Repository repository;

  final _amountController = BehaviorSubject<int>();
  Stream<int> get amountStream => _amountController.stream;

  Episode _currentPaidEpisode;
  BreezBridge _breezLib;
  Timer _paymentTimer;
  Map<String, double> _perDestinationPayments = Map<String, double>();

  PodcastPaymentsBloc(this.audioBloc, this.repository) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    listenAudioState();
    registerAsyncHandlers({
      PayBoost: _payBoost,
      AdjustAmount: _adjustAmount,
    });
    listenActions();
  }

  void listenAudioState() {
    Rx.combineLatest2(
        audioBloc.playingState,
        audioBloc.nowPlaying,
        (AudioState audioState, Episode episode) =>
            PlayerControlState(audioState, episode)).listen((event) async {
      _stopPaymentTimer();
      if (event.audioState == AudioState.playing) {
        _currentPaidEpisode = event.episode;
        final value = _getLightnintPaymentValue(_currentPaidEpisode);
        if (value != null) {
          if (_amountController.value == null) {
            final amount =
                (double.tryParse(value?.model?.suggested) * 100000000).floor();
            _amountController.add(amount);
          }
          startPaymentTimer(event.episode, value.recipients);
        }
      }
    });
  }

  Future _payBoost(PayBoost action) async {
    if (_currentPaidEpisode != null) {
      final value = _getLightnintPaymentValue(_currentPaidEpisode);
      if (value != null) {
        _payRecipients(
            _currentPaidEpisode, value.recipients, _amountController.value);
      }
    }
  }

  Future _adjustAmount(AdjustAmount action) async {
    _amountController.add(action.sats);
    return Future.value();
  }

  void startPaymentTimer(Episode episode, List<ValueDestination> recipients) {
    _paymentTimer = Timer.periodic(Duration(seconds: 10), (t) {
      var currentDuration = (_listeningTime[episode.contentUrl] ?? 0) + 10;
      _listeningTime[episode.contentUrl] = currentDuration;
      if (currentDuration > 0 && currentDuration % 60 == 0) {
        print(
            "sending payment for episode ${episode.contentUrl}, duration: $currentDuration");
        _payRecipients(episode, recipients, _amountController.value);
      }
    });
  }

  void _payRecipients(
      Episode episode, List<ValueDestination> recipients, int total) {
    double totalSplits =
        recipients.map((r) => r.split).reduce((agg, next) => agg + next);
    final breezShare = totalSplits / 20;
    totalSplits += breezShare;
    final withBreez = List<ValueDestination>.from([
      ValueDestination(
          address:
              "031015a7839468a3c266d662d5bb21ea4cea24226936e2864a7ca4f2c3939836e0",
          name: "Breez",
          type: "keysend",
          split: breezShare)
    ])
      ..addAll(recipients);

    withBreez.forEach((d) {
      final amount = (d.split * total / totalSplits);
      var aggregatedAmount =
          (_perDestinationPayments[d.address] ?? 0.0) + amount;
      _perDestinationPayments[d.address] = aggregatedAmount;

      final maxFee = Int64((aggregatedAmount * 1000 * maxFeePart).toInt());
      final toPay = aggregatedAmount.toInt();
      log.info(
          "starting recipient payment $aggregatedAmount from total: $total with fee: $maxFee split=${d.split}");
      if (toPay > 0 && amount <= total && maxFee > 0) {
        log.info("trying to pay $toPay to destination ${d.address}");
        _breezLib
            .sendSpontaneousPayment(d.address, Int64(toPay), d.name,
                feeLimitMsat: maxFee,
                groupKey: episode.contentUrl,
                groupName: episode.title)
            .then((payResponse) {
          if (payResponse.paymentError?.isNotEmpty == true) {
            log.info(
                "failed to pay $toPay to destination ${d.address}, error=${payResponse.paymentError} trying next time...");
            return;
          }
          _perDestinationPayments[d.address] -= toPay;
          log.info("succesfully paid $toPay to destination ${d.address}");
        }).catchError((err) {
          log.info(
              "failed to pay $toPay to destination ${d.address}, error=$err trying next time...");
        });
      }
    });
  }

  Value _getLightnintPaymentValue(Episode episode) {
    final metadata = episode?.metadata;
    if (metadata != null && metadata["feed"] != null) {
      final value = metadata["feed"]["value"];
      if (value != null && value is Map<String, dynamic>) {
        final valueObj = Value.fromJson(value);
        if (valueObj?.model?.type == "lightning" &&
            valueObj?.model?.method == 'keysend') {
          return valueObj;
        }
      }
    }
    return null;
  }

  void _stopPaymentTimer() {
    _paymentTimer?.cancel();
  }
}

class Value {
  final ValueModel model;
  final List<ValueDestination> recipients;

  Value._({this.model, this.recipients});

  factory Value.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    final recipients = <ValueDestination>[];
    final destinationsJson = map['destinations'] as List<dynamic>;
    destinationsJson.forEach((d) {
      if (d is Map<String, dynamic>) {
        recipients.add(ValueDestination.fromJson(d));
      }
    });

    return Value._(
        model: ValueModel.fromJson(map['model']), recipients: recipients);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'model': model.toJson(),
      'recipients': recipients.map((d) => d.toJson()).toList()
    };
  }
}

class ValueModel {
  final String type;
  final String method;
  final String suggested;

  ValueModel({this.type, this.method, this.suggested});

  factory ValueModel.fromJson(Map<String, dynamic> map) {
    return ValueModel(
      type: map['type'] as String,
      method: map['method'] as String,
      suggested: map['suggested'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type,
      'method': method,
      'suggested': suggested,
    };
  }
}

class ValueDestination {
  final String name;
  final String address;
  final String type;
  final double split;

  ValueDestination({this.name, this.address, this.type, this.split});

  static ValueDestination fromJson(Map<String, dynamic> json) {
    var split = json['split'] as num;
    return ValueDestination(
      name: json['name'] as String,
      address: json['address'] as String,
      type: json['type'] as String,
      split: split.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'type': type,
      'split': split
    };
  }
}

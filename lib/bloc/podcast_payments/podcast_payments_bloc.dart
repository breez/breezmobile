import 'dart:async';
import 'dart:convert';
import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/bloc/settings/settings_bloc.dart';
import 'package:anytime/entities/app_settings.dart';
import 'package:anytime/entities/episode.dart';
import 'package:anytime/repository/repository.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:anytime/ui/widgets/transport_controls.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/podcast_payments/actions.dart';
import 'package:breez/bloc/podcast_payments/model.dart';
import 'package:breez/bloc/podcast_payments/payment_options.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fixnum/fixnum.dart';

const maxFeePart = 0.2;

class PodcastPaymentsBloc with AsyncActionsHandler {
  final _listeningTime = Map<String, double>();
  final AudioBloc audioBloc;
  final SettingsBloc settingsBloc;
  final Repository repository;
  final AccountBloc accountBloc;
  final UserProfileBloc userProfile;

  final _paymentOptionsController = BehaviorSubject<PaymentOptions>();
  Stream<PaymentOptions> get paymentOptionsStream =>
      _paymentOptionsController.stream;

  final _paymentEventsController = StreamController<PaymentEvent>.broadcast();
  Stream<PaymentEvent> get paymentEventsStream =>
      _paymentEventsController.stream;

  StreamSubscription<PositionState> currentPositionSubscription;
  StreamSubscription<AppSettings> currentSettingsSubscription;

  Episode _currentPaidEpisode;
  Duration _currentEpisodeDuration;
  double _currentPlaybackSpeed = 1.0;
  BreezBridge _breezLib;
  Timer _paymentTimer;
  Map<String, double> _perDestinationPayments = Map<String, double>();
  BreezUserModel user;

  PodcastPaymentsBloc(this.userProfile, this.accountBloc, this.settingsBloc,
      this.audioBloc, this.repository) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    _paymentOptionsController.add(PaymentOptions());
    listenAudioState();
    registerAsyncHandlers({
      PayBoost: _payBoost,
    });
    listenUserProfile();
    listenActions();
  }

  void listenUserProfile() {
    userProfile.userStream.listen((u) {
      user = u;
    });
  }

  void listenAudioState() {
    Rx.combineLatest2(
            audioBloc.playingState,
            audioBloc.nowPlaying,
            (AudioState audioState, Episode episode) =>
                PlayerControlState(audioState, episode))
        .distinct((s1, s2) =>
            s1.episode.guid == s2.episode.guid &&
            s1.audioState == s2.audioState)
        .listen((event) async {
      _stopPaymentTimer();
      print("start payment timer " +
          event.audioState.toString() +
          " " +
          event.episode.guid);
      if (event.audioState == AudioState.playing) {
        _currentPaidEpisode = event.episode;
        final value = _getLightningPaymentValue(_currentPaidEpisode);
        if (value != null) {
          startPaymentTimer(event.episode, value.recipients);
        }
      }
    });
  }

  Future _payBoost(PayBoost action) async {
    _paymentEventsController
        .add(PaymentEvent(PaymentEventType.BoostStarted, action.sats));
    if (_currentPaidEpisode != null) {
      final value = _getLightningPaymentValue(_currentPaidEpisode);
      if (value != null) {
        _payRecipients(_currentPaidEpisode, value.recipients, action.sats,
            boost: true);
      }
    }
  }

  void startPaymentTimer(Episode episode, List<ValueDestination> recipients) {
    currentPositionSubscription = audioBloc.playPosition.listen((event) {
      if (event.episode.guid == _currentPaidEpisode?.guid) {
        _currentEpisodeDuration = event.position;
      }
    });

    currentSettingsSubscription = settingsBloc.settings.listen((event) {
      _currentPlaybackSpeed = event.playbackSpeed;
    });

    final paidTimeOnStart = _listeningTime[episode.contentUrl] ?? 0;
    _listeningTime[episode.contentUrl] = paidTimeOnStart;
    var paidMinutes = Duration(seconds: paidTimeOnStart.floor()).inMinutes;
    _paymentTimer = Timer.periodic(Duration(seconds: 1), (t) {
      _listeningTime[episode.contentUrl] += _currentPlaybackSpeed;
      final nextPaidMinutes =
          Duration(seconds: _listeningTime[episode.contentUrl].floor())
              .inMinutes;
      if (nextPaidMinutes > paidMinutes) {
        paidMinutes = nextPaidMinutes;
        log.info("paying recipients " + paidMinutes.toString());
        _payRecipients(episode, recipients, user.preferredSatsPerMinValue);
      }
    });
  }

  void _payRecipients(
      Episode episode, List<ValueDestination> recipients, int total,
      {bool boost = false}) {
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

    withBreez.forEach((d) async {
      final amount = (d.split * total / totalSplits);
      var payPart = amount.toInt();
      if (!boost) {
        var aggregatedAmount =
            (_perDestinationPayments[d.address] ?? 0.0) + amount;
        _perDestinationPayments[d.address] = aggregatedAmount;
        payPart = aggregatedAmount.toInt();
      }

      final lastFee = await _lastFeeForDestination(d.address);
      final netPay = payPart - lastFee.toInt();
      final maxFee = Int64((netPay * 1000 * maxFeePart).toInt());
      log.info(
          "starting recipient payment boost=$boost netPay=$netPay from total: $total with fee: $maxFee split=${d.split} lastFee = $lastFee");
      if (netPay > 0 && amount <= total && maxFee > 0) {
        log.info("trying to pay $netPay to destination ${d.address}");
        _breezLib
            .sendSpontaneousPayment(d.address, Int64(netPay), d.name,
                feeLimitMsat: maxFee,
                groupKey: _getPodcastGroupKey(episode),
                groupName: episode.title,
                tlv: _getTlv(boost: boost))
            .then((payResponse) {
          if (payResponse.paymentError?.isNotEmpty == true) {
            log.info(
                "failed to pay $netPay to destination ${d.address}, error=${payResponse.paymentError} trying next time...");
            return;
          }
          log.info("succesfully paid $netPay to destination ${d.address}");
          if (!boost) {
            _perDestinationPayments[d.address] -= payPart;
            _paymentEventsController
                .add(PaymentEvent(PaymentEventType.StreamCompleted, payPart));
          }
        }).catchError((err) {
          log.info(
              "failed to pay $netPay to destination ${d.address}, error=$err trying next time...");
        });
      }
    });
  }

  Value _getLightningPaymentValue(Episode episode) {
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

  String _getPodcastGroupKey(Episode episode) {
    final info = Map<String, dynamic>();
    info["content_url"] = episode.contentUrl;
    final metadata = episode?.metadata;
    if (metadata != null && metadata["feed"] != null) {
      info["title"] = metadata["feed"]["title"];
    }
    return json.encode(info);
  }

  void _stopPaymentTimer() {
    currentPositionSubscription?.cancel();
    currentSettingsSubscription?.cancel();
    _paymentTimer?.cancel();
  }

  Future<Int64> _lastFeeForDestination(String address) {
    return accountBloc.paymentsStream
        .map((ps) => ps.nonFilteredItems
            .firstWhere((i) => i.destination == address, orElse: () => null))
        .where((pi) => pi != null)
        .map(((pi) => pi.fee))
        .first
        .timeout(Duration(seconds: 1), onTimeout: () => Int64.ZERO);
  }

  close() {
    _paymentOptionsController.close();
  }

  Map<Int64, String> _getTlv({bool boost = false}) {
    var tlv = Map<String, dynamic>();
    tlv["podcast"] = _getPodcastTitle(_currentPaidEpisode);
    tlv["episode"] = _currentPaidEpisode.title;
    tlv["action"] = boost ? "boost" : "stream";
    tlv["time"] = _formatDuration(_currentEpisodeDuration);
    var encoded = json.encode(tlv);
    var records = Map<Int64, String>();
    records[Int64(7629169)] = encoded;
    return records;
  }

  String _getPodcastTitle(Episode episode) {
    final metadata = episode?.metadata;
    if (metadata != null && metadata["feed"] != null) {
      return metadata["feed"]["title"];
    }
    return "";
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
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
    var rawSplit = json['split'];
    num split;
    if (rawSplit is String) {
      split = double.parse(rawSplit);
    } else {
      split = rawSplit as num;
    }
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

import 'dart:async';
import 'dart:convert';

import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/bloc/settings/settings_bloc.dart';
import 'package:anytime/entities/episode.dart';
import 'package:anytime/repository/repository.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/podcast_payments/actions.dart';
import 'package:breez/bloc/podcast_payments/model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:fixnum/fixnum.dart';

import 'aggregated_payments.dart';

const maxFeePart = 0.2;

class PodcastPaymentsBloc with AsyncActionsHandler {
  final _listeningTime = Map<String, double>();
  final AudioBloc audioBloc;
  final SettingsBloc settingsBloc;
  final Repository repository;
  final AccountBloc accountBloc;
  final UserProfileBloc userProfile;

  final _paymentEventsController = StreamController<PaymentEvent>.broadcast();

  Stream<PaymentEvent> get paymentEventsStream =>
      _paymentEventsController.stream;

  BreezBridge _breezLib;
  AggregatedPayments _aggregatedPayments;
  BreezUserModel user;
  String breezReceiverNode;
  Map<String, bool> paidPositions = Map<String, bool>();

  PodcastPaymentsBloc(this.userProfile, this.accountBloc, this.settingsBloc,
      this.audioBloc, this.repository) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    _startTicker(injector);
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

  Future _payBoost(PayBoost action) async {
    var currentEpisode = await _getCurrentPlayingEpisode();
    _paymentEventsController
        .add(PaymentEvent(PaymentEventType.BoostStarted, action.sats));
    if (currentEpisode != null) {
      final value = await _getLightningPaymentValue(currentEpisode);
      if (value != null) {
        _payRecipients(
          currentEpisode,
          value.recipients,
          action.sats,
          boost: true,
          boostMessage: action.boostMessage,
          senderName: action.senderName,
        );
      }
    }
  }

  _startTicker(ServiceInjector injector) async {
    var sharedPreferences = await injector.sharedPreferences;
    _aggregatedPayments = AggregatedPayments(sharedPreferences);
    // start the payment ticker
    Timer.periodic(Duration(seconds: 1), (t) async {
      // calculate episode and playing state
      var playingState = await _getAudioState();
      if (playingState != AudioState.playing) {
        return;
      }

      // calculate episode and playing state
      var currentPlayedEpisode = await _getCurrentPlayingEpisode();
      if (currentPlayedEpisode == null) {
        return;
      }
      // calculate payment speed
      var playbackSpeed = await _getCurrentPlaybackSpeed();

      if (_listeningTime[currentPlayedEpisode.contentUrl] == null) {
        _listeningTime[currentPlayedEpisode.contentUrl] = 0.0;
      }
      // minutes before next payment
      var paidMinutes = Duration(
              seconds: _listeningTime[currentPlayedEpisode.contentUrl].floor())
          .inMinutes;
      _listeningTime[currentPlayedEpisode.contentUrl] += playbackSpeed;

      // minutes after next payment
      final nextPaidMinutes = Duration(
              seconds: _listeningTime[currentPlayedEpisode.contentUrl].floor())
          .inMinutes;

      // if minutes increased
      print("nextPaidMinutes = " +
          nextPaidMinutes.toString() +
          " playbackSpeed=" +
          playbackSpeed.toString() +
          " time = " +
          _listeningTime[currentPlayedEpisode.contentUrl].floor().toString());
      if (nextPaidMinutes > paidMinutes) {
        log.info("paying recipients " + nextPaidMinutes.toString());
        final value = await _getLightningPaymentValue(currentPlayedEpisode);
        if (value != null) {
          _payRecipients(currentPlayedEpisode, value.recipients,
              user.paymentOptions.preferredSatsPerMinValue);
        }
      }
    });
  }

  Future<AudioState> _getAudioState() {
    try {
      return audioBloc.playingState.first.timeout(Duration(seconds: 1));
    } catch (e) {
      return null;
    }
  }

  Future<Episode> _getCurrentPlayingEpisode() {
    try {
      return audioBloc.nowPlaying.first.timeout(Duration(seconds: 1));
    } catch (e) {
      return null;
    }
  }

  Future<double> _getCurrentPlaybackSpeed() async {
    try {
      var settings =
          await settingsBloc.settings.first.timeout(Duration(seconds: 1));
      return settings?.playbackSpeed;
    } catch (e) {
      return 1.0;
    }
  }

  void _payRecipients(
    Episode episode,
    List<ValueDestination> recipients,
    int total, {
    bool boost = false,
    String boostMessage = "",
    String senderName = "",
  }) async {
    if (breezReceiverNode == null) {
      try {
        breezReceiverNode = await _breezLib.receiverNode();
      } catch (err) {
        log.severe("failed to fetch receiver node: ", err);
      }
    }
    double totalSplits =
        recipients.map((r) => r.split).reduce((agg, next) => agg + next);
    final breezShare = totalSplits / 20;
    totalSplits += breezShare;
    final withBreez = List<ValueDestination>.from([
      ValueDestination(
          address: breezReceiverNode,
          name: "Breez",
          type: "keysend",
          split: breezShare)
    ])
      ..addAll(recipients);

    // get current podcast listening position
    PositionState position;
    try {
      position =
          await audioBloc.playPosition.first.timeout(Duration(seconds: 1));
    } catch (e) {}

    // calculate the minute to pay.
    var minuteToPay = position.position.inMinutes;

    // construct a position key (minute + episode guid)
    var paidPositionKey = "${episode.guid}-$minuteToPay";

    // in case not boost we want to ensure any minutes is not paid more than one time.
    if (!boost && paidPositions[paidPositionKey] == true) {
      log.info(
          "skipping paying minute $minuteToPay for episode ${episode.title}");
      return;
    }
    paidPositions[paidPositionKey] = true;

    withBreez.forEach((d) async {
      final amount = (d.split * total / totalSplits);
      var payPart = amount.toInt();
      if (!boost) {
        payPart =
            (await _aggregatedPayments.addAmount(d.address, amount)).toInt();
      }
      final customKey = d.customKey?.toString();
      final customValue = d.customValue?.toString();
      final lastFee = await _lastFeeForDestination(d.address);
      final netPay = payPart - lastFee.toInt();
      final maxFee = Int64((netPay * 1000 * maxFeePart).toInt());

      log.info(
          "starting recipient payment boost=$boost netPay=$netPay from total: $total with fee: $maxFee split=${d.split} lastFee = $lastFee");
      if (netPay > 0 && amount <= total && maxFee > 0) {
        log.info("trying to pay $netPay to destination ${d.address}");
        if (!boost) {
          await _aggregatedPayments.addAmount(d.address, -payPart.toDouble());
        }
        _breezLib
            .sendSpontaneousPayment(d.address, Int64(netPay), d.name,
                feeLimitMsat: maxFee,
                groupKey: _getPodcastGroupKey(episode),
                groupName: episode.title,
                tlv: _getTlv(
                    boost: boost,
                    episode: episode,
                    position: position,
                    customKey: customKey,
                    customValue: customValue,
                    boostMessage: boostMessage,
                    msatTotal: total * 1000,
                    senderName: senderName,
                ))
            .then((payResponse) async {
          if (payResponse.paymentError?.isNotEmpty == true) {
            if (!boost) {
              await _aggregatedPayments.addAmount(
                  d.address, payPart.toDouble());
            }
            log.info(
                "failed to pay $netPay to destination ${d.address}, error=${payResponse.paymentError} trying next time...");
            return;
          }
          log.info("succesfully paid $netPay to destination ${d.address}");
          if (!boost) {
            _paymentEventsController
                .add(PaymentEvent(PaymentEventType.StreamCompleted, payPart));
          }
        }).catchError((err) async {
          if (!boost) {
            await _aggregatedPayments.addAmount(d.address, payPart.toDouble());
          }
          log.info(
              "failed to pay $netPay to destination ${d.address}, error=$err trying next time...");
        });
      }
    });
  }

  Future<Value> _getLightningPaymentValue(Episode episode) async {
    // If the episode has a value block parsed from the RSS feed, we'll take that.
    if (episode.value != null) {
      ValueModel valueModel = ValueModel.fromJson(episode.value.toMap());
      List<ValueDestination> valueDestinations = episode.value.recipients
          .map((r) => ValueDestination.fromJson(r.toMap()))
          .toList();

      if (valueModel.type == "lightning" && valueModel.method == 'keysend') {
        return Value._(model: valueModel, recipients: valueDestinations);
      }

      return null;
    }

    // Else, we'll check if the episode has a value block defined via the PodcastIndex API.
    if (episode.episodeMetadata != null &&
        episode.episodeMetadata["episode"] != null) {
      final value = episode.episodeMetadata["episode"]["value"];
      if (value != null && value is Map<String, dynamic>) {
        final valueObj = Value.fromJson(value);
        if (valueObj?.model?.type == "lightning" &&
            valueObj?.model?.method == 'keysend') {
          return valueObj;
        }
      }
    }

    // Else, we'll take the value block defined for the entire podcast via the PodcastIndex API.
    Map<String, dynamic> metadata;
    if (episode.pguid != null && episode.pguid.isNotEmpty) {
      var podcast = await repository.findPodcastByGuid(episode.pguid);
      if (podcast != null) {
        metadata = podcast.metadata;
      }
    }
    if (metadata == null || metadata.isEmpty) {
      metadata = episode.metadata;
    }
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

  Future<Int64> _lastFeeForDestination(String address) {
    return accountBloc.paymentsStream
        .map((ps) => ps.nonFilteredItems
            .firstWhere((i) => i.destination == address, orElse: () => null))
        .where((pi) => pi != null)
        .map(((pi) => pi.fee))
        .first
        .timeout(Duration(seconds: 1), onTimeout: () => Int64.ZERO);
  }

  Map<Int64, String> _getTlv({
    bool boost = false,
    String customKey,
    String customValue,
    String boostMessage,
    Episode episode,
    PositionState position,
    int msatTotal,
    String senderName,
  }) {
    var tlv = Map<String, dynamic>();
    tlv["podcast"] = _getPodcastTitle(episode);
    tlv["episode"] = episode.title;
    tlv["action"] = boost ? "boost" : "stream";
    tlv["time"] = _formatDuration(position.position);
    tlv["feedID"] = _getPodcastIndexID(episode);
    tlv["app_name"] = "Breez";
    tlv["value_msat_total"] = msatTotal;
    tlv["sender_name"] = senderName;
    if (boost && boostMessage != null) tlv["message"] = boostMessage;
    var encoded = json.encode(tlv);
    var records = Map<Int64, String>();
    records[Int64(7629169)] = encoded;
    if (customKey != null && customValue != null) {
      int recordKey = int.tryParse(customKey);
      if (recordKey != null) {
        records[Int64(recordKey)] = customValue;
      }
    }
    return records;
  }

  String _getPodcastTitle(Episode episode) {
    final metadata = episode?.metadata;
    if (metadata != null && metadata["feed"] != null) {
      return metadata["feed"]["title"];
    }
    return "";
  }

  int _getPodcastIndexID(Episode episode) {
    final metadata = episode?.metadata;
    if (metadata != null && metadata["feed"] != null) {
      var id = metadata["feed"]["id"];
      if (id is int) {
        return id;
      }
    }
    return 0;
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

  ValueModel({
    this.type,
    this.method,
    this.suggested,
  });

  factory ValueModel.fromJson(Map<String, dynamic> map) {
    return ValueModel(
        type: map['type'] as String,
        method: map['method'] as String,
        suggested: map['suggested'] as String);
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
  final dynamic customKey;
  final dynamic customValue;

  ValueDestination(
      {this.name,
      this.address,
      this.type,
      this.split,
      this.customKey,
      this.customValue});

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
        customKey: json['customKey'],
        customValue: json['customValue']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'type': type,
      'split': split,
      'customKey': customKey,
      'customValue': customValue,
    };
  }
}

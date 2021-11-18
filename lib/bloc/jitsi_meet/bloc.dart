import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/lounge/actions.dart';
import 'package:breez/bloc/lounge/lounge_payments_bloc.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

import '../async_actions_handler.dart';

class JitsiMeetBloc with AsyncActionsHandler {
  static const String BREEZ_DATA_CONFERENCE_PROPERTY = "breez-data";

  final LoungePaymentsBloc paymentsBloc;

  String currentLoungeID;

  StreamController<String> _currentLoungeController =
      StreamController<String>();

  Sink<String> get currentLoungeSink => _currentLoungeController.sink;

  BreezBridge _breezLib;

  JitsiMeetBloc(this.paymentsBloc) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    JitsiMeet.addListener(
      JitsiMeetingListener(
        onConferenceJoined: onConferenceJoined,
        onBoost: _onBoost,
        changeSatsPerMinute: _changeSatsPerMinute,
        setCustomBoostAmount: _setCustomBoostValue,
        setCustomSatsPerMinAmount: _setCustomSatsPerMinAmount,
      ),
    );
    _listenLoungeChanges();
  }

  onConferenceJoined(Map<dynamic, dynamic> message) {
    print(json.encode(message));
  }

  Future _listenLoungeChanges() async {
    _currentLoungeController.stream.listen((loungeID) async {
      if (loungeID != null) {
        currentLoungeID = loungeID;
        var hints = await _breezLib.getLSPRoutingHints();
        var nodeID = await _getPersistentNodeID();
        var proof = _breezLib.signMessage(utf8.encode(nodeID));

        // set breez-data attribute on the conference
      }
    });
  }

  Future<String> _getPersistentNodeID() async {
    var preferences = await ServiceInjector().sharedPreferences;
    return preferences
        .getString(AccountBloc.PERSISTENT_NODE_ID_PREFERENCES_KEY);
  }

  void _onBoost(message) {
    var boostAmount = double.parse(message["boostAmount"]).toInt();
    var paymentInfo = message["paymentInfo"];
    paymentsBloc.actionsSink.add(PayBoost(
        boostAmount, this.currentLoungeID, currentLoungeID, paymentInfo));
  }

  void _changeSatsPerMinute(message) async {
    var user =
        await paymentsBloc.userProfile.userStream.firstWhere((u) => u != null);
    var satsPerMinute = double.parse(message["satsPerMinute"]).toInt();
    paymentsBloc.actionsSink.add(AdjustAmount(satsPerMinute));
    paymentsBloc.userProfile.userActionsSink.add(SetLoungePaymentOptions(user
        .loungePaymentOptions
        .copyWith(preferredSatsPerMinValue: satsPerMinute)));
  }

  void _setCustomBoostValue(message) async {
    var user =
        await paymentsBloc.userProfile.userStream.firstWhere((u) => u != null);
    var customBoostValue = double.parse(message["customBoostValue"]).toInt();
    paymentsBloc.userProfile.userActionsSink.add(SetLoungePaymentOptions(user
        .loungePaymentOptions
        .copyWith(customBoostValue: customBoostValue)));
  }

  void _setCustomSatsPerMinAmount(message) async {
    var user =
        await paymentsBloc.userProfile.userStream.firstWhere((u) => u != null);
    var customSatsPerMinValue =
        double.parse(message["customSatsPerMinValue"]).toInt();
    paymentsBloc.userProfile.userActionsSink.add(SetLoungePaymentOptions(user
        .loungePaymentOptions
        .copyWith(customSatsPerMinValue: customSatsPerMinValue)));
  }

  void close() async {
    await dispose();
    JitsiMeet.removeAllListeners();
    await _currentLoungeController.close();
  }
}

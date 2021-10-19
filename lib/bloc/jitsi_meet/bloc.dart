import 'dart:async';

import 'package:breez/bloc/lounge/actions.dart';
import 'package:breez/bloc/lounge/lounge_payments_bloc.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

import '../async_actions_handler.dart';

class JitsiMeetBloc with AsyncActionsHandler {
  final LoungePaymentsBloc paymentsBloc;

  String currentLoungeID;


  StreamController<String> _currentLoungeController =
      StreamController<String>();

  Sink<String> get currentLoungeSink => _currentLoungeController.sink;

  JitsiMeetBloc(this.paymentsBloc) {
    JitsiMeet.addListener(
      JitsiMeetingListener(
        onBoost: _onBoost,
        changeSatsPerMinute: _changeSatsPerMinute,
        setCustomBoostAmount: _setCustomBoostValue,
        setCustomSatsPerMinAmount: _setCustomSatsPerMinAmount,
      ),
    );
    _listenLoungeChanges();
  }

  Future _listenLoungeChanges() async {
    _currentLoungeController.stream.listen((loungeID) async {
      if (loungeID != null) {
        currentLoungeID = loungeID;
      }
    });
  }

  void _onBoost(message) {
    var boostAmount = double.parse(message["boostAmount"]).toInt();
    var paymentInfo = message["paymentInfo"];
    paymentsBloc.actionsSink
        .add(PayBoost(boostAmount, "", currentLoungeID, paymentInfo));
  }

  void _changeSatsPerMinute(message) async {
    var user = await paymentsBloc.userProfile.userStream.firstWhere((u) => u != null);
    var satsPerMinute = double.parse(message["satsPerMinute"]).toInt();
    paymentsBloc.actionsSink.add(AdjustAmount(satsPerMinute));
    paymentsBloc.userProfile.userActionsSink.add(SetLoungePaymentOptions(user
        .loungePaymentOptions
        .copyWith(preferredSatsPerMinValue: satsPerMinute)));
  }

  void _setCustomBoostValue(message) async {
    var user = await paymentsBloc.userProfile.userStream.firstWhere((u) => u != null);
    var customBoostValue = double.parse(message["customBoostValue"]).toInt();
    paymentsBloc.userProfile.userActionsSink.add(SetLoungePaymentOptions(user
        .loungePaymentOptions
        .copyWith(customBoostValue: customBoostValue)));
  }

  void _setCustomSatsPerMinAmount(message) async {
    var user = await paymentsBloc.userProfile.userStream.firstWhere((u) => u != null);
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

import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/lounge/repository.dart';
import 'package:breez/bloc/lounge/sqlite/repository.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pbgrpc.dart';
import 'package:breez/services/injector.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hex/hex.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'model.dart';

const maxFeePart = 0.2;

class LoungePayment {
  final String name;
  final String address;
  final double split;

  LoungePayment({this.address, this.split, this.name});
}

class LoungePaymentsBloc with AsyncActionsHandler {
  final AccountBloc accountBloc;
  final UserProfileBloc userProfile;

  final _paymentEventsController =
      StreamController<LoungePaymentEvent>.broadcast();

  Stream<LoungePaymentEvent> get paymentEventsStream =>
      _paymentEventsController.stream;

  BreezBridge _breezLib;
  BreezServer _breezServer;
  BreezUserModel user;
  String breezReceiverNode;
  Map<String, bool> paidPositions = Map<String, bool>();
  Lounge _activeLounge;
  Repository _repository;
  Timer paymentInfoTimer;

  LoungePaymentsBloc(this.userProfile, this.accountBloc) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    _breezServer = injector.breezServer;
    _repository = SqliteRepository();
    listenUserProfile();
    listenConferenceEvents();
  }

  void listenConferenceEvents() {
    JitsiMeet.addListener(
      JitsiMeetingListener(
        onConferenceTerminated: onConferenceTerminated,
        onConferenceJoined: onConferenceJoined,
        onBoost: _onBoost,
        changeSatsPerMinute: _changeSatsPerMinute,
        setCustomBoostAmount: _setCustomBoostValue,
        setCustomSatsPerMinAmount: _setCustomSatsPerMinAmount,
      ),
    );
  }

  onConferenceJoined(Map<dynamic, dynamic> message) async {
    _activeLounge = null;
    print(json.encode(message));
    var uri = Uri.parse(message["url"]);
    var loungeID = uri.pathSegments.last;
    _activeLounge = await _repository.fetchLoungeByLoungeID(loungeID);

    var myNodeID = await _getPersistentNodeID();
    if (_activeLounge != null) {
      // if conference owner (moderator) then set the payment details
      if (_activeLounge.payeeNodeID == myNodeID) {
        await setNodeInfo(myNodeID);
        paymentInfoTimer = Timer.periodic(
            Duration(minutes: 10), (timer) => setNodeInfo(myNodeID));
      }
    }
  }

  Future<String> _getPersistentNodeID() async {
    var preferences = await ServiceInjector().sharedPreferences;
    return preferences
        .getString(AccountBloc.PERSISTENT_NODE_ID_PREFERENCES_KEY);
  }

  Future setNodeInfo(String myNodeID) async {
    try {
      var hints = await _breezLib.getLSPRoutingHints();
      if (hints != null) {
        Int64 timestamp =
            Int64((DateTime.now().millisecondsSinceEpoch / 1000).round());
        var myNodeIDRaw = HEX.decode(myNodeID);
        var keyRaw = BreezServer.nodeInfoRoutingHintsKey;
        var valueRaw = utf8.encode(hints.writeToJson());
        var msgToSign = "$keyRaw-${HEX.encode(valueRaw)}-$timestamp";

        // sign the message
        var proof = await _breezLib.signMessage(utf8.encode(msgToSign));

        await _breezServer.setNodeInfo(
            timestamp, myNodeIDRaw, keyRaw, valueRaw, proof);
      }
    } catch (e) {
      log.severe("failed to set node info $e");
    }
  }

  Future<RoutingHints> getNodeInfo(String nodeID) async {
    try {
      var nodeIDRaw = HEX.decode(nodeID);
      var response = await _breezServer.getNodeInfo(
          nodeIDRaw, BreezServer.nodeInfoRoutingHintsKey);
      var hintsRaw = utf8.decode(response.value);
      return RoutingHints()..mergeFromJson(hintsRaw);
    } catch (e) {
      log.severe("failed to get node info $e");
      return null;
    }
  }

  onConferenceTerminated(Map<dynamic, dynamic> message) {
    paymentInfoTimer?.cancel();
  }

  void _onBoost(message) async {
    var boostAmount = double.parse(message["boostAmount"]).toInt();
    String nodeID = _activeLounge.payeeNodeID;
    if (nodeID == null || nodeID.isEmpty) {
      throw new Exception("payee node id not found");
    }

    // get node info
    RoutingHints hints = await getNodeInfo(nodeID);
    _paymentEventsController.add(LoungePaymentEvent(
        LoungePaymentEventType.BoostStarted, boostAmount, nodeID));
    _payLounge(_activeLounge.title, _activeLounge.loungeID,
        _activeLounge.payeeNodeID, boostAmount,
        boost: true, hints: hints);
  }

  void _changeSatsPerMinute(message) async {
    var user = await userProfile.userStream.firstWhere((u) => u != null);
    var satsPerMinute = double.parse(message["satsPerMinute"]).toInt();
    userProfile.userActionsSink.add(SetLoungePaymentOptions(user
        .loungePaymentOptions
        .copyWith(preferredSatsPerMinValue: satsPerMinute)));
  }

  void _setCustomBoostValue(message) async {
    var customBoostValue = double.parse(message["customBoostValue"]).toInt();
    userProfile.userActionsSink.add(SetLoungePaymentOptions(user
        .loungePaymentOptions
        .copyWith(customBoostValue: customBoostValue)));
  }

  void _setCustomSatsPerMinAmount(message) async {
    var customSatsPerMinValue =
        double.parse(message["customSatsPerMinValue"]).toInt();
    userProfile.userActionsSink.add(SetLoungePaymentOptions(user
        .loungePaymentOptions
        .copyWith(customSatsPerMinValue: customSatsPerMinValue)));
  }

  void listenUserProfile() {
    userProfile.userStream.listen((u) {
      user = u;
    });
  }

  void _payLounge(String title, String loungeID, String nodeID, int total,
      {bool boost = false, RoutingHints hints}) async {
    if (breezReceiverNode == null) {
      try {
        breezReceiverNode = await _breezLib.receiverNode();
      } catch (err) {
        log.severe("failed to fetch receiver node: ", err);
      }
    }

    final withBreez = List<LoungePayment>.from([
      LoungePayment(name: "Breez", address: breezReceiverNode, split: 5),
      LoungePayment(name: title, address: nodeID, split: 95)
    ]);

    withBreez.forEach((d) async {
      final amount = (d.split * total / 100);
      var payPart = amount.toInt();
      final lastFee = await _lastFeeForDestination(d.address);
      final netPay = payPart - lastFee.toInt();
      final maxFee = Int64((netPay * 1000 * maxFeePart).toInt());

      log.info(
          "starting lounge payment boost=$boost netPay=$netPay from total: $total with fee: $maxFee split=${d.split} lastFee = $lastFee");
      if (netPay > 0 && amount <= total && maxFee > 0) {
        log.info("trying to pay $netPay to lounge destination ${d.address}");
        _breezLib
            .sendSpontaneousPayment(d.address, Int64(netPay), d.name,
                feeLimitMsat: maxFee,
                groupKey: "$title-$loungeID",
                groupName: title,
                tlv: _getTlv(boost: boost),
                hints: hints)
            .then((payResponse) async {
          if (payResponse.paymentError?.isNotEmpty == true) {
            log.info(
                "failed to pay $netPay to lounge destination ${d.address}, error=${payResponse.paymentError} trying next time...");
            return;
          }
          log.info(
              "succesfully paid $netPay to lounge destination ${d.address}");
        }).catchError((err) async {
          log.info(
              "failed to pay $netPay to lounge destination ${d.address}, error=$err trying next time...");
        });
      }
    });
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

  Map<Int64, String> _getTlv({bool boost = false}) {
    var tlv = Map<String, dynamic>();
    tlv["action"] = boost ? "boost" : "stream";
    tlv["app_name"] = "Breez";
    var encoded = json.encode(tlv);
    var records = Map<Int64, String>();
    records[Int64(7629169)] = encoded;
    return records;
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:fixnum/fixnum.dart';

import 'actions.dart';
import 'model.dart';

const maxFeePart = 0.2;

class ZonePayment {
  final String name;
  final String address;
  final double split;

  ZonePayment({this.address, this.split, this.name});
}

class SatsPaymentsBloc with AsyncActionsHandler {
  final AccountBloc accountBloc;
  final UserProfileBloc userProfile;
  final Stream<SatsZone> currentZoneStream;

  final _paymentEventsController =
      StreamController<ZonePaymentEvent>.broadcast();
  Stream<ZonePaymentEvent> get paymentEventsStream =>
      _paymentEventsController.stream;

  BreezBridge _breezLib;
  BreezUserModel user;
  SatsZone _currentZone;
  String breezReceiverNode;
  Map<String, bool> paidPositions = Map<String, bool>();

  SatsPaymentsBloc(this.userProfile, this.accountBloc, this.currentZoneStream) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    registerAsyncHandlers({
      PayZoneBoost: _payBoost,
    });
    listenUserProfile();
    listenCurrentZone();
    listenActions();
  }

  void listenUserProfile() {
    userProfile.userStream.listen((u) {
      user = u;
    });
  }

  void listenCurrentZone() {
    currentZoneStream.listen((z) {
      _currentZone = z;
    });
  }

  Future _payBoost(PayZoneBoost action) async {
    if (_currentZone == null) {
      throw new Exception("must enter a zone to pay boost");
    }
    _paymentEventsController
        .add(ZonePaymentEvent(ZonePaymentEventType.BoostStarted, action.sats));
    _payZone(_currentZone, action.sats, boost: true);
  }

  void _payZone(SatsZone zone, int total, {bool boost = false}) async {
    if (breezReceiverNode == null) {
      try {
        breezReceiverNode = await _breezLib.receiverNode();
      } catch (err) {
        log.severe("failed to fetch receiver node: ", err);
      }
    }

    final withBreez = List<ZonePayment>.from([
      ZonePayment(name: "Breez", address: breezReceiverNode, split: 5),
      ZonePayment(
          name: _currentZone.title, address: _currentZone.zoneID, split: 95)
    ]);

    withBreez.forEach((d) async {
      final amount = (d.split * total / 100);
      var payPart = amount.toInt();
      final lastFee = await _lastFeeForDestination(d.address);
      final netPay = payPart - lastFee.toInt();
      final maxFee = Int64((netPay * 1000 * maxFeePart).toInt());

      log.info(
          "starting zone payment boost=$boost netPay=$netPay from total: $total with fee: $maxFee split=${d.split} lastFee = $lastFee");
      if (netPay > 0 && amount <= total && maxFee > 0) {
        log.info("trying to pay $netPay to zone destination ${d.address}");
        _breezLib
            .sendSpontaneousPayment(d.address, Int64(netPay), d.name,
                feeLimitMsat: maxFee,
                groupKey: _getZoneGroupKey(_currentZone),
                groupName: _currentZone.title,
                tlv: _getTlv(boost: boost))
            .then((payResponse) async {
          if (payResponse.paymentError?.isNotEmpty == true) {
            log.info(
                "failed to pay $netPay to zone destination ${d.address}, error=${payResponse.paymentError} trying next time...");
            return;
          }
          log.info("succesfully paid $netPay to zone destination ${d.address}");
        }).catchError((err) async {
          log.info(
              "failed to pay $netPay to zone destination ${d.address}, error=$err trying next time...");
        });
      }
    });
  }

  String _getZoneGroupKey(SatsZone satZone) {
    return "${satZone.title}-${satZone.zoneID}";
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

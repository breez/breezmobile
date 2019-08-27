import 'dart:async';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'moonpay_order.dart';

class AddFundsBloc {
  final _addFundRequestController = new StreamController<void>();
  Sink<void> get addFundRequestSink => _addFundRequestController.sink;

  final _addFundResponseController = new StreamController<AddFundResponse>();
  Stream<AddFundResponse> get addFundResponseStream => _addFundResponseController.stream;

  final _moonPayOrderController = new StreamController<MoonpayOrder>();
  Sink<MoonpayOrder> get moonPayOrderSink => _moonPayOrderController.sink;
  Stream<MoonpayOrder> get moonPayOrderStream => _moonPayOrderController.stream;

  final _orderController = new BehaviorSubject<MoonpayOrder>();
  Sink<MoonpayOrder> get orderSink => _orderController.sink;

  AddFundsBloc(String userID){
    ServiceInjector injector = ServiceInjector();
    BreezBridge breezLib = injector.breezBridge;
    _addFundRequestController.stream.listen((request){
      _addFundResponseController.add(null);
        breezLib.addFundsInit(userID)
          .then((reply) => _addFundResponseController.add(new AddFundResponse(reply)))
          .catchError(_addFundResponseController.addError);
      })
      .onDone(_dispose);

    _initializeWithMoonpayOrder(injector);
    _listenToMoonpayOrder(injector);
  }

  _initializeWithMoonpayOrder(ServiceInjector injector) {
    injector.sharedPreferences.then((preferences) {
      DateTime orderDate = DateTime.fromMillisecondsSinceEpoch(preferences.getInt("pendingMoonpayOrderTimestamp") ?? 0);
      // Expire order that lasted longer than 15 minutes
      if (DateTime.now().difference(orderDate).inMinutes >= 15) {
        _removeMoonpayOrder(preferences);
        _moonPayOrderController.add(MoonpayOrder(null, null));
      } else {
        _moonPayOrderController.add(MoonpayOrder(
            preferences.getString("pendingMoonpayOrderAddress") ?? null, preferences.getInt("pendingMoonpayOrderTimestamp") ?? null));
      }
    });
  }

  _removeMoonpayOrder(SharedPreferences preferences) {
    preferences.remove("pendingMoonpayOrderAddress");
    preferences.remove("pendingMoonpayOrderTimestamp");
  }

  _listenToMoonpayOrder(ServiceInjector injector) {
    _orderController.stream.listen((order) async {
      injector.sharedPreferences.then((preferences) {
        _saveMoonpayOrder(preferences, order);
        _moonPayOrderController.add(order);
      });
    });
  }

  _saveMoonpayOrder(SharedPreferences preferences, MoonpayOrder order) {
    preferences.setString("pendingMoonpayOrderAddress", order.address);
    preferences.setInt("pendingMoonpayOrderTimestamp", order.timestamp);
  }

  _dispose(){
    _addFundRequestController.close();
    _addFundResponseController.close();
    _moonPayOrderController.close();
    _orderController.close();
  }
}
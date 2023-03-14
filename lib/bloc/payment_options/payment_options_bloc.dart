import 'dart:async';

import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/payment_options/payment_options_actions.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';

const _kDefaultOverrideFee = false;
const _kDefaultBaseFee = 20;
const _kDefaultProportionalFee = 1.0;
const _kNoFeeOverride = -1;

const _kPaymentOptionOverrideFee = "PAYMENT_OPTIONS_OVERRIDE_FEE";
const _kPaymentOptionBaseFee = "PAYMENT_OPTIONS_BASE_FEE";
const _kPaymentOptionProportionalFee = "PAYMENT_OPTIONS_PROPORTIONAL_FEE";

class PaymentOptionsBloc with AsyncActionsHandler {
  final ServiceInjector _injector = ServiceInjector();

  final _paymentOptionsFeeEnabledStreamController = BehaviorSubject<bool>();

  Stream<bool> get paymentOptionsFeeEnabledStream =>
      _paymentOptionsFeeEnabledStreamController.stream;

  final _paymentOptionsBaseFeeStreamController = BehaviorSubject<int>();

  Stream<int> get paymentOptionsBaseFeeStream =>
      _paymentOptionsBaseFeeStreamController.stream;

  final _paymentOptionsProportionalFeeStreamController =
      BehaviorSubject<double>();

  Stream<double> get paymentOptionsProportionalFeeStream =>
      _paymentOptionsProportionalFeeStreamController.stream;

  PaymentOptionsBloc(Stream<Map<String, dynamic>> restoreLightningFeesStream) {
    registerAsyncHandlers({
      ResetPaymentFee: _resetPaymentFee,
      OverridePaymentFee: _updateOverridePaymentFee,
      UpdatePaymentBaseFee: _updatePaymentOptionsBaseFee,
      UpdatePaymentProportionalFee: _updatePaymentOptionsProportionalFee,
      CalculateFee: _calculateFee,
    });

    _loadPaymentFeeOverride();
    _loadPaymentBaseFeeOverride();
    _loadPaymentProportionalFeeOverride();
    listenActions();
    _listenRestoreRequests(restoreLightningFeesStream);
  }

  Future _resetPaymentFee(
    ResetPaymentFee action,
  ) async {
    _updateOverridePaymentFee(
      OverridePaymentFee(_kDefaultOverrideFee),
    );
    _updatePaymentOptionsBaseFee(
      UpdatePaymentBaseFee(_kDefaultBaseFee),
    );
    _updatePaymentOptionsProportionalFee(
      UpdatePaymentProportionalFee(_kDefaultProportionalFee),
    );
  }

  void _loadPaymentFeeOverride() async {
    final prefs = await _injector.sharedPreferences;
    bool paymentFeeEnabled;
    if (prefs.containsKey(_kPaymentOptionOverrideFee)) {
      paymentFeeEnabled = prefs.getBool(_kPaymentOptionOverrideFee);
    } else {
      paymentFeeEnabled = _kDefaultOverrideFee;
    }
    _paymentOptionsFeeEnabledStreamController.add(paymentFeeEnabled);
  }

  Future _updateOverridePaymentFee(
    OverridePaymentFee action,
  ) async {
    final prefs = await _injector.sharedPreferences;
    prefs.setBool(_kPaymentOptionOverrideFee, action.enabled);
    _paymentOptionsFeeEnabledStreamController.add(action.enabled);
    action.resolve(action.enabled);
  }

  void _loadPaymentBaseFeeOverride() async {
    final prefs = await _injector.sharedPreferences;
    int baseFee;
    if (prefs.containsKey(_kPaymentOptionBaseFee)) {
      baseFee = prefs.getInt(_kPaymentOptionBaseFee);
    } else {
      baseFee = _kDefaultBaseFee;
    }
    _paymentOptionsBaseFeeStreamController.add(baseFee);
  }

  Future _updatePaymentOptionsBaseFee(
    UpdatePaymentBaseFee action,
  ) async {
    final prefs = await _injector.sharedPreferences;
    var newFee = action.baseFee;
    if (newFee < 0) {
      newFee = 0;
    }
    prefs.setInt(_kPaymentOptionBaseFee, newFee);
    _paymentOptionsBaseFeeStreamController.add(newFee);
    action.resolve(newFee);
  }

  void _loadPaymentProportionalFeeOverride() async {
    final prefs = await _injector.sharedPreferences;
    double proportionalFee;
    if (prefs.containsKey(_kPaymentOptionProportionalFee)) {
      proportionalFee = prefs.getDouble(_kPaymentOptionProportionalFee);
    } else {
      proportionalFee = _kDefaultProportionalFee;
    }
    _paymentOptionsProportionalFeeStreamController.add(proportionalFee);
  }

  Future _updatePaymentOptionsProportionalFee(
    UpdatePaymentProportionalFee action,
  ) async {
    final prefs = await _injector.sharedPreferences;
    var newFee = action.proportionalFee;
    if (newFee < 0.0) {
      newFee = 0.0;
    }
    prefs.setDouble(_kPaymentOptionProportionalFee, newFee);
    _paymentOptionsProportionalFeeStreamController.add(newFee);
    action.resolve(newFee);
  }

  Future _calculateFee(
    CalculateFee action,
  ) async {
    final overrideFee = _paymentOptionsFeeEnabledStreamController.value;
    if (!overrideFee) {
      action.resolve(_kNoFeeOverride);
    } else {
      final base = _paymentOptionsBaseFeeStreamController.value;
      final proportional = _paymentOptionsProportionalFeeStreamController.value;
      final fee = base + (action.amount / 100.0 * proportional).round();
      action.resolve(fee);
    }
  }

  void _listenRestoreRequests(
      Stream<Map<String, dynamic>> restoreLightningFeesStream) {
    restoreLightningFeesStream.listen((lightningFeesPreferences) {
      _restoreLightningFees(lightningFeesPreferences);
    });
  }

  _restoreLightningFees(Map<String, dynamic> lightningFeesPreferences) {
    _updateOverridePaymentFee(
      OverridePaymentFee(lightningFeesPreferences[_kPaymentOptionOverrideFee]),
    );
    _updatePaymentOptionsBaseFee(
      UpdatePaymentBaseFee(lightningFeesPreferences[_kPaymentOptionBaseFee]),
    );
    _updatePaymentOptionsProportionalFee(
      UpdatePaymentProportionalFee(
          lightningFeesPreferences[_kPaymentOptionProportionalFee]),
    );
  }
}

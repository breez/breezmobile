import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/fastbitcoins/fastbitcoins_model.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class FastbitcoinsBloc {  
  final _validateRequestController =
      new StreamController<ValidateRequestModel>.broadcast();
  Sink<ValidateRequestModel> get validateRequestSink =>
      _validateRequestController.sink;

  final _validateResponseController =
      new StreamController<ValidateResponseModel>.broadcast();
  Stream<ValidateResponseModel> get validateResponseStream =>
      _validateResponseController.stream;

  final _redeemRequestController =
      new StreamController<RedeemRequestModel>.broadcast();
  Sink<RedeemRequestModel> get redeemRequestSink =>
      _redeemRequestController.sink;

  final _redeemResponseController =
      new StreamController<RedeemResponseModel>.broadcast();
  Stream<RedeemResponseModel> get redeemResponseStream =>
      _redeemResponseController.stream;

  String _baseURL = "https://wallet-api-test.aao-tech.com/w-api/v1/breez";
  BreezBridge _breezLib;

  FastbitcoinsBloc({String baseURL}) {
    if (baseURL != null) {
      _baseURL = baseURL;
    }
    _breezLib = ServiceInjector().breezBridge;
    _listenValidateRequests();
    _listenRedeemRequests();
  }

  void _listenValidateRequests() {
    _validateRequestController.stream.listen((request) async {
      try {
        var response = await http.post(_baseURL + "/quote",            
            body: jsonEncode(request.toJson()));
        _validateResponse(response);
        _validateResponseController
            .add(ValidateResponseModel.fromJson(jsonDecode(response.body)));
      } catch (error) {        
        _validateResponseController.addError(error);
      }
    });
  }

  void _listenRedeemRequests() {
    _redeemRequestController.stream.listen((request) async {
      try {
        String payreq = await _breezLib.addInvoice(
            Int64(request.validateResponse.satoshiAmount),
            standard: true);
        request.lightningInvoice = payreq;
        var response =
            await http.post(_baseURL + "/redeem", body: jsonEncode(request.toJson()));
        _validateResponse(response);
        _redeemResponseController
            .add(RedeemResponseModel.fromJson(jsonDecode(response.body)));
      } catch (error) {
        _redeemResponseController.addError(error);
      }
    });
  }

  void _validateResponse<T>(Response response) {
    if (response.statusCode != 200) {
      throw response.body;
    }
  }

  void close() {
    _validateRequestController.close();
    _validateResponseController.close();
    _redeemRequestController.close();
    _redeemResponseController.close();
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/fastbitcoins/fastbitcoins_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class FastbitcoinsBloc {  
  static const PRODUCTION_URL = "https://wallet-api.fastbitcoins.com/w-api/v1/breez";
  static const TESTING_URL = "https://wallet-api-test.aao-tech.com/w-api/v1/breez";

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

  String _baseURL = TESTING_URL;

  BreezBridge _breezLib;

  FastbitcoinsBloc({bool production}) {
    if (production == true) {
      _baseURL = PRODUCTION_URL;
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
        ValidateResponseModel res = ValidateResponseModel.fromJson(jsonDecode(response.body));
        if (res.error == 1 && res.kycRequired != 1) {
          throw res.errorMessage;
        }
        _validateResponseController
            .add(res);
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
            description: "Fastbitcoins.com Voucher",
            standard: true);
        request.lightningInvoice = payreq;
        log.info("fastbicoins request: " + jsonEncode(request.toJson()));
        var response =
            await http.post(_baseURL + "/redeem", body: jsonEncode(request.toJson()));
        _validateResponse(response);
        RedeemResponseModel res = RedeemResponseModel.fromJson(jsonDecode(response.body));
        if (res.error == 1) {
          throw res.errorMessage;
        }
        _redeemResponseController
            .add(res);
      } catch (error) {
        _redeemResponseController.addError(error);
      }
    });
  }

  void _validateResponse<T>(Response response) {    
    if (response.statusCode != 200) {
      log.severe('fastbitcoins response error: ${response.body.substring(0,100)}');
      throw "Service Unavailable. Please try again later.";
    }
  }

  void close() {
    _validateRequestController.close();
    _validateResponseController.close();
    _redeemRequestController.close();
    _redeemResponseController.close();
  }
}

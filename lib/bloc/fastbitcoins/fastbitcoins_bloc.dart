import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/fastbitcoins/fastbitcoins_model.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/messages.pbgrpc.dart';
import 'package:breez/services/injector.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

final _log = Logger("FastbitcoinsBloc");

class FastbitcoinsBloc {
  static const PRODUCTION_URL = "wallet-api.fastbitcoins.com";
  static const TESTING_URL = "wallet-api-test.aao-tech.com";

  final _validateRequestController = StreamController<ValidateRequestModel>.broadcast();
  Sink<ValidateRequestModel> get validateRequestSink => _validateRequestController.sink;

  final _validateResponseController = StreamController<ValidateResponseModel>.broadcast();
  Stream<ValidateResponseModel> get validateResponseStream => _validateResponseController.stream;

  final _redeemRequestController = StreamController<RedeemRequestModel>.broadcast();
  Sink<RedeemRequestModel> get redeemRequestSink => _redeemRequestController.sink;

  final _redeemResponseController = StreamController<RedeemResponseModel>.broadcast();
  Stream<RedeemResponseModel> get redeemResponseStream => _redeemResponseController.stream;

  final String baseURL;
  BreezBridge _breezLib;
  Client _client;

  FastbitcoinsBloc({
    this.baseURL = PRODUCTION_URL,
  }) {
    var injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    _client = injector.client;
    _listenValidateRequests();
    _listenRedeemRequests();
  }

  void _listenValidateRequests() {
    _validateRequestController.stream.listen((request) async {
      try {
        Uri uri = Uri.https(baseURL, "w-api/v1/breez/quote");
        var response = await _client.post(
          uri,
          body: jsonEncode(request.toJson()),
        );
        _validateResponse(response);
        ValidateResponseModel res = ValidateResponseModel.fromJson(jsonDecode(response.body));
        if (res.error == 1 && res.kycRequired != 1) {
          throw res.errorMessage;
        }
        _validateResponseController.add(res);
      } catch (error) {
        _validateResponseController.addError(error);
      }
    });
  }

  void _listenRedeemRequests() {
    _redeemRequestController.stream.listen((request) async {
      final texts = getSystemAppLocalizations();
      try {
        AddInvoiceReply payreq = await _breezLib.addInvoice(
          Int64(request.validateResponse.satoshiAmount),
          description: texts.fast_bitcoin_dot_com_voucher,
        );
        request.lightningInvoice = payreq.paymentRequest;
        _log.info("fastbitcoins request: ${jsonEncode(request.toJson())}");
        Uri uri = Uri.https(baseURL, "w-api/v1/breez/redeem");
        var response = await _client.post(
          uri,
          body: jsonEncode(request.toJson()),
        );
        _validateResponse(response);
        RedeemResponseModel res = RedeemResponseModel.fromJson(jsonDecode(response.body));
        if (res.error == 1) {
          throw res.errorMessage;
        }
        _redeemResponseController.add(res);
      } catch (error) {
        _redeemResponseController.addError(error);
      }
    });
  }

  void _validateResponse<T>(Response response) {
    if (response.statusCode != 200) {
      final body = response.body != null && response.body.length > 100
          ? response.body.substring(0, 100)
          : response.body;
      _log.severe('fastbitcoins response error: $body');
      final texts = getSystemAppLocalizations();
      throw texts.fast_bitcoin_dot_com_error_service_unavailable;
    }
  }

  void close() {
    _validateRequestController.close();
    _validateResponseController.close();
    _redeemRequestController.close();
    _redeemResponseController.close();
  }
}

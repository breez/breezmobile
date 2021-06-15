import 'dart:convert';

import 'package:breez/bloc/fastbitcoins/fastbitcoins_bloc.dart';
import 'package:breez/bloc/fastbitcoins/fastbitcoins_model.dart';
import 'package:breez/services/injector.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import 'bloc_tester.dart';
import 'mocks.dart';

void main() {
  group('fastbitcoins bloc', () {
    InjectorMock _injector = new InjectorMock();

    setUp(() async {
      ServiceInjector.configure(_injector);
    });

    tearDown(() async {
      _injector.mockHandler = null;
    });

    void _mockResponse(int code, String body) {
      _injector.mockHandler = (request) => Future.value(Response(body, code));
    }

    test("shoud validate with error", () async {
      _mockResponse(
        200,
        """{
          "email_address": "test@gmail.com",
          "code": "code",
          "value": 1,
          "currency": "USD",
          "error": 1,
          "kyc_required": 1
        }""",
      );
      FastbitcoinsBloc _fastBitcoinsBloc = new FastbitcoinsBloc();
      var tester = new BlocTester<ValidateRequestModel, ValidateResponseModel>(
          _fastBitcoinsBloc.validateResponseStream, (res) {
        print(jsonEncode(res.toJson()));
        expect(res, isNotNull);
        expect(res.error, 1);
      }, _fastBitcoinsBloc.validateRequestSink,
          new ValidateRequestModel("test@gmail.com", "code", 1, "USD"));
      await tester.run();
    });

    test("shoud redeem with error", () async {
      _mockResponse(
        200,
        """{
          "email_address": "test@gmail.com",
          "code": "code",
          "value": 1,
          "currency": "USD",
          "quotation_id": 0,
          "quotation_secret": "",
          "error": 0
        }""",
      );
      FastbitcoinsBloc _fastBitcoinsBloc = new FastbitcoinsBloc();
      var redeemRequest = new RedeemRequestModel(
          "test@gmail.com", "code", 1, "USD", 0, "")
        ..validateResponse =
            new ValidateResponseModel(0, "", 0, 0, "", 0, 1.0, 1.0, 0, 0.0, 0);
      var tester = new BlocTester<RedeemRequestModel, RedeemResponseModel>(
          _fastBitcoinsBloc.redeemResponseStream, (res) {
        print(jsonEncode(res.toJson()));
        expect(res, isNotNull);
        expect(res.error, 0);
      }, _fastBitcoinsBloc.redeemRequestSink,
          redeemRequest);
      await tester.run();
    });
  });
}

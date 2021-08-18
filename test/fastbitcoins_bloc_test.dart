import 'dart:convert';

import 'package:breez/bloc/fastbitcoins/fastbitcoins_bloc.dart';
import 'package:breez/bloc/fastbitcoins/fastbitcoins_model.dart';
import 'package:breez/services/injector.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import 'bloc_tester.dart';
import 'mocks.dart';

FastbitcoinsBloc _make() => new FastbitcoinsBloc(
      baseURL: FastbitcoinsBloc.TESTING_URL,
    );

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
      FastbitcoinsBloc _fastBitcoinsBloc = _make();
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
      FastbitcoinsBloc _fastBitcoinsBloc = _make();
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

    test("validate should throw error", () async {
      _mockResponse(
        200,
        """{
          "email_address": "test@gmail.com",
          "code": "code",
          "value": 1,
          "currency": "USD",
          "error": 1,
          "kyc_required": 0,
          "error_message": "An error message"
        }""",
      );
      FastbitcoinsBloc _fastBitcoinsBloc = _make();
      var tester = new BlocTester<ValidateRequestModel, ValidateResponseModel>(
          _fastBitcoinsBloc.validateResponseStream,
          (res) {
            fail('res should not be parsed $res');
          },
          _fastBitcoinsBloc.validateRequestSink,
          new ValidateRequestModel("test@gmail.com", "code", 1, "USD"),
          (e) {
            expect(e, 'An error message');
          });
      await tester.run();
    });

    test("redeem should throw error", () async {
      _mockResponse(
        200,
        """{
          "email_address": "test@gmail.com",
          "code": "code",
          "value": 1,
          "currency": "USD",
          "quotation_id": 0,
          "quotation_secret": "",
          "error": 1,
          "kyc_required": 1,
          "error_message": "An error message"
        }""",
      );
      FastbitcoinsBloc _fastBitcoinsBloc = _make();
      var redeemRequest = new RedeemRequestModel(
          "test@gmail.com", "code", 1, "USD", 0, "")
        ..validateResponse =
            new ValidateResponseModel(0, "", 0, 0, "", 0, 1.0, 1.0, 0, 0.0, 0);
      var tester = new BlocTester<RedeemRequestModel, RedeemResponseModel>(
          _fastBitcoinsBloc.redeemResponseStream,
          (res) {
            fail('res should not be parsed $res');
          },
          _fastBitcoinsBloc.redeemRequestSink,
          redeemRequest,
          (e) {
            expect(e, 'An error message');
          });
      await tester.run();
    });

    test("validate should throw error when status code is not 200", () async {
      _mockResponse(503, '');
      FastbitcoinsBloc _fastBitcoinsBloc = _make();
      var tester = new BlocTester<ValidateRequestModel, ValidateResponseModel>(
          _fastBitcoinsBloc.validateResponseStream,
          (res) {
            fail('res should not be parsed $res');
          },
          _fastBitcoinsBloc.validateRequestSink,
          new ValidateRequestModel("test@gmail.com", "code", 1, "USD"),
          (e) {
            expect(e, 'Service Unavailable. Please try again later.');
          });
      await tester.run();
    });

    test("redeem should throw error when status code is not 200", () async {
      _mockResponse(
        503,
        """{
          "email_address": "test@gmail.com",
          "code": "code",
          "value": 1,
          "currency": "USD",
          "quotation_id": 0,
          "quotation_secret": "",
          "error": 1,
          "kyc_required": 1,
          "error_message": "An error message"
        }""",
      );
      FastbitcoinsBloc _fastBitcoinsBloc = _make();
      var redeemRequest = new RedeemRequestModel(
          "test@gmail.com", "code", 1, "USD", 0, "")
        ..validateResponse =
            new ValidateResponseModel(0, "", 0, 0, "", 0, 1.0, 1.0, 0, 0.0, 0);
      var tester = new BlocTester<RedeemRequestModel, RedeemResponseModel>(
          _fastBitcoinsBloc.redeemResponseStream,
          (res) {
            fail('res should not be parsed $res');
          },
          _fastBitcoinsBloc.redeemRequestSink,
          redeemRequest,
          (e) {
            expect(e, 'Service Unavailable. Please try again later.');
          });
      await tester.run();
    });

    test('match production and test base urls', () async {
      FastbitcoinsBloc test = _make();
      FastbitcoinsBloc production = new FastbitcoinsBloc();
      expect(test.baseURL, FastbitcoinsBloc.TESTING_URL);
      expect(production.baseURL, FastbitcoinsBloc.PRODUCTION_URL);
    });

    test('close should close stream controller silently', () async {
      _make().close();
    });
  });

  group('Json', () {
    test('ValidateRequestModel fromJson should parse a Model', () async {
      final emailAddress = 'an email address';
      final code = 'a code';
      final value = 1.2;
      final currency = 'a currency';
      final model = ValidateRequestModel.fromJson({
        'email_address': emailAddress,
        'code': code,
        'value': value,
        'currency': currency,
      });
      expect(model.emailAddress, emailAddress);
      expect(model.code, code);
      expect(model.value, value);
      expect(model.currency, currency);
    });

    test('RedeemRequestModel fromJson should parse a Model', () async {
      final emailAddress = 'an email address';
      final code = 'a code';
      final value = 1.2;
      final currency = 'a currency';
      final quotationId = 3;
      final quotationSecret = 'a quotation secret';
      final lightningInvoice = 'a lightning invoice';
      final model = RedeemRequestModel.fromJson({
        'email_address': emailAddress,
        'code': code,
        'value': value,
        'currency': currency,
        'quotation_id': quotationId,
        'quotation_secret': quotationSecret,
        'lightning_invoice': lightningInvoice,
      });
      expect(model.emailAddress, emailAddress);
      expect(model.code, code);
      expect(model.value, value);
      expect(model.currency, currency);
      expect(model.quotationId, quotationId);
      expect(model.quotationSecret, quotationSecret);
      expect(model.lightningInvoice, lightningInvoice);
    });
  });
}

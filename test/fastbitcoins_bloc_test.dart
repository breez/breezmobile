import 'dart:convert';

import 'package:breez/bloc/fastbitcoins/fastbitcoins_bloc.dart';
import 'package:breez/bloc/fastbitcoins/fastbitcoins_model.dart';
import 'package:breez/services/injector.dart';
import 'package:test/test.dart';
import 'bloc_tester.dart';
import 'mocks.dart';
//import 'mocks.dart';

void main() {
  group('fastbitcoins bloc', () {
    InjectorMock _injector = new InjectorMock();
    FastbitcoinsBloc _fastBitcoinsBloc;

    setUp(() async {
      ServiceInjector.configure(_injector);
      _fastBitcoinsBloc = new FastbitcoinsBloc();
    });

    test("shoud validate with error", () async {
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
      var redeemRequest = new RedeemRequestModel(
          "test@gmail.com", "code", 1, "USD", 0, "")
        ..validateResponse =
            new ValidateResponseModel(0, "", 0, 0, "", 0, 1.0, 1.0, 0, 0.0, 0);
      var tester = new BlocTester<RedeemRequestModel, RedeemResponseModel>(
          _fastBitcoinsBloc.redeemResponseStream, (res) {
        print(jsonEncode(res.toJson()));
        expect(res, isNotNull);
        expect(res.error, 1);
      }, _fastBitcoinsBloc.redeemRequestSink,
          redeemRequest);
      await tester.run();
    });
  });
}

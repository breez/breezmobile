import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:mockito/mockito.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc_tester.dart';
import 'mocks.dart';

void main() {
    group('payments bloc', () {
      InjectorMock _injector = new InjectorMock();
      AccountBloc _accountBloc;

      setUp(() async {
        ServiceInjector.configure(_injector);
        when(_injector.lnd.subscribeInvoices()).thenReturn((new BehaviorSubject(seedValue: null).stream));
        when(_injector.lnd.subscribeTransactions()).thenReturn((new BehaviorSubject(seedValue: null).stream));

        _accountBloc = new AccountBloc();
      });

      test("should return empty list first time", () async {
        new BlocTester<void, List<PaymentInfo>>(_accountBloc.paymentsStream, (paymentsList) => expect(paymentsList, null));
      });
    });
  }
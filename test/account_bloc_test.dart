import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/services/lnd/generated/rpc.pb.dart';
import 'package:mockito/mockito.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/lnd/lnd.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fixnum/fixnum.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc_tester.dart';
import 'mocks.dart';

void main() {
  group('wallet bloc', () {
    InjectorMock _injector = new InjectorMock();   
    AccountBloc _accountBloc;

    setUp(() async {
      ServiceInjector.configure(_injector);    
      when(_injector.lnd.subscribeTransactions()).thenReturn(new BehaviorSubject(seedValue: null).stream);    
      when(_injector.lnd.subscribeInvoices()).thenReturn((new BehaviorSubject(seedValue: null).stream));    
      when(_injector.lnd.newAddress(NewAddressRequest_AddressType.NESTED_PUBKEY_HASH)).thenReturn(Future.value("testAddress"));
      _accountBloc = new AccountBloc();
    });

    test("should return empty address on first time", () async {      
      new BlocTester<void, String>(_accountBloc.addressesStream, (address) => expect(address, null));        
    });

    test("shoud return new address when requested", () async{            
      new BlocTester<void, String>(_accountBloc.addressesStream.skip(1), (address) => expect(address,isNotNull), _accountBloc.requestAddressSink);
    });  

    test("should return empty list first time", () async {
      new BlocTester<void, List<PaymentInfo>>(_accountBloc.paymentsStream, (paymentsList) => expect(paymentsList, null));
    });

    test("shoud calculate wallet", () async{
      LNDService lnd = _injector.lnd;
      WalletBalanceResponse expectedWalletBalance =  new WalletBalanceResponse()
          ..totalBalance = Int64(10)
          ..confirmedBalance = Int64(4)
          ..unconfirmedBalance = Int64(6);

      ChannelBalanceResponse expectedChannelBalance = new ChannelBalanceResponse()
          ..balance = Int64(10)
          ..pendingOpenBalance = Int64(20);
      
      when(lnd.walletBalance()).thenReturn(Future.value(expectedWalletBalance));        
      when(lnd.channelBalance()).thenReturn(Future.value(expectedChannelBalance));
    
      AccountModel expectedWallet = new AccountModel(null, expectedWalletBalance, expectedChannelBalance);

      
      new BlocTester<void, AccountModel>(_accountBloc.accountStream, (wallet) { 
        expect(wallet.channelBalance, expectedWallet.channBalance);
        expect(wallet.walletBalance, expectedWallet.walletBalance);
      });
    });  

  });
}
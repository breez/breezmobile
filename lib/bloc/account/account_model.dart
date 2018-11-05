import 'dart:math';

import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:fixnum/fixnum.dart';

class AccountModel { 
  final Account _accountResponse;
  final Currency _currency;
  final FundStatusReply_FundStatus addedFundsStatus;
  final String paymentRequestInProgress;
  final bool connected;
  final bool initial;

  AccountModel(this._accountResponse, this._currency, {this.initial = false, this.addedFundsStatus = FundStatusReply_FundStatus.NO_FUND, this.paymentRequestInProgress, this.connected = false});

  AccountModel.initial() : 
    this(Account()
      ..balance = Int64(0)      
      ..nonDepositableBalance = Int64(0)
      ..status = Account_AccountStatus.WAITING_DEPOSIT
      ..maxAllowedToReceive = Int64(0)
      ..maxPaymentAmount = Int64(0)      
      , Currency.BTC, initial: true);
  AccountModel copyWith({Account accountResponse, Currency currency, FundStatusReply_FundStatus addedFundsStatus, String paymentRequestInProgress, bool connected}) {
    return AccountModel(
      accountResponse ?? this._accountResponse, 
      currency ?? this.currency, 
      addedFundsStatus: addedFundsStatus ?? this.addedFundsStatus, 
      connected: connected ?? this.connected,
      paymentRequestInProgress: paymentRequestInProgress ?? this.paymentRequestInProgress);
  }

  String get id => _accountResponse.id;  
  bool get waitingDepositConfirmation => addedFundsStatus == FundStatusReply_FundStatus.WAITING_CONFIRMATION;  
  bool get depositConfirmed => addedFundsStatus == FundStatusReply_FundStatus.CONFIRMED;  
  bool get processiongBreezConnection => _accountResponse.status == Account_AccountStatus.PROCESSING_BREEZ_CONNECTION;
  bool get processingWithdrawal => _accountResponse.status == Account_AccountStatus.PROCESSING_WITHDRAWAL;
  bool get active => _accountResponse.status == Account_AccountStatus.ACTIVE;  
  Int64 get balance => _accountResponse.balance;  
  Int64 get nonDepositableBalance => _accountResponse.nonDepositableBalance;
  String get statusLine => _accountResponse.status.toString();
  Currency get currency => _currency;
  Int64 get maxAllowedToReceive => _accountResponse.maxAllowedToReceive;
  Int64 get maxAllowedToPay => Int64(min(_accountResponse.maxAllowedToPay.toInt(), _accountResponse.maxPaymentAmount.toInt()));
  Int64 get maxPaymentAmount => _accountResponse.maxPaymentAmount;

  String get statusMessage {
    if (this.waitingDepositConfirmation) {
      return "Breez is waiting for BTC transfer to be confirmed. Confirmation usually takes ~10 minutes to be completed";
    }
    else if (depositConfirmed) {
      if (this.processiongBreezConnection) {
        return "Breez is opening a secure channel with our server (this usually takes ~10 minutes to be completed)";
      }
      if (this.active) {
        return "Transferring funds";
      }
    }        
    
    return null;
  }
}

class PaymentsModel {
  final List<PaymentInfo> paymentsList;
  final PaymentFilterModel filter;
  final DateTime firstDate;

  PaymentsModel(this.paymentsList, this.filter, [this.firstDate]);

  PaymentsModel.initial() : this(null, null, DateTime(DateTime.now().year));

  PaymentsModel copyWith({List<PaymentInfo> paymentsList, PaymentFilterModel filter, DateTime firstDate}) {
    return PaymentsModel(
        paymentsList ?? this.paymentsList,
        filter ?? this.filter,
        firstDate ?? this.firstDate);
  }
}

class PaymentFilterModel {
  final List<PaymentType> paymentType;
  final DateTime startDate;
  final DateTime endDate;
  final bool initial;

  PaymentFilterModel(this.paymentType, this.startDate, this.endDate,{this.initial = false});

  PaymentFilterModel.initial() : this([PaymentType.SENT,PaymentType.DEPOSIT,PaymentType.WITHDRAWAL,PaymentType.RECEIVED], null, null, initial: true);

  PaymentFilterModel copyWith({List<PaymentType> filter, DateTime startDate, DateTime endDate}) {
    return PaymentFilterModel(
        filter ?? this.paymentType,
        startDate ?? this.startDate,
        endDate ?? this.endDate);
  }
}

enum PaymentType { DEPOSIT, WITHDRAWAL, SENT, RECEIVED }

class PaymentInfo {
  final Payment _paymentResponse;
  final Currency _currency;

  Map _typeMap = {
    Payment_PaymentType.DEPOSIT: PaymentType.DEPOSIT,
    Payment_PaymentType.WITHDRAWAL: PaymentType.WITHDRAWAL, 
    Payment_PaymentType.SENT: PaymentType.SENT, 
    Payment_PaymentType.RECEIVED: PaymentType.RECEIVED,
  };

  PaymentType get type => _typeMap[_paymentResponse.type];  
  Int64 get amount => _paymentResponse.amount;
  Int64 get creationTimestamp => _paymentResponse.creationTimestamp;  
  String get destination => _paymentResponse.destination;
  String get redeemTxID => _paymentResponse.redeemTxID;
  String get paymentHash => _paymentResponse.paymentHash;
  String get description => type == PaymentType.DEPOSIT || type == PaymentType.WITHDRAWAL ? "Bitcoin Transfer" : _paymentResponse.invoiceMemo?.description;
  String get imageURL {    
    String url = (type == PaymentType.SENT ? _paymentResponse.invoiceMemo?.payeeImageURL : _paymentResponse.invoiceMemo?.payerImageURL);
    return (url == null || url.isEmpty) ? null : url;      
  }
  String get title {
    if (type == PaymentType.DEPOSIT || type == PaymentType.WITHDRAWAL){
      return "Bitcoin Transfer";
    }
    String peerName = (type == PaymentType.SENT ? _paymentResponse.invoiceMemo?.payeeName : _paymentResponse.invoiceMemo?.payerName);
    return (peerName == null || peerName.isEmpty) ? "Unknown" : peerName;
  }
  Currency get currency => _currency;

  PaymentInfo(this._paymentResponse, this._currency);
  PaymentInfo copyWith(Currency currency) {
    return PaymentInfo(this._paymentResponse, currency);
  }
}

class AddFundResponse {
  AddFundReply _addfundReply;
  AddFundResponse(this._addfundReply);

  String get errorMessage => _addfundReply.errorMessage;
  Int64 get maxAllowedDeposit => _addfundReply.maxAllowedDeposit;
  String get address => _addfundReply.address;
}

class RemoveFundRequestModel {
  final Int64 amount;
  final String address;

  RemoveFundRequestModel(this.amount, this.address);
}

class RemoveFundResponseModel {
  final RemoveFundReply _reply;
  String get transactionID => _reply.txid;
  String get errorMessage => _reply.errorMessage;

  RemoveFundResponseModel(this._reply);
}

class RefundableDepositModel {
  final String address;
  final Int64 amount;
  final bool refundBroadcasted;

  RefundableDepositModel(this.address, this.amount, this.refundBroadcasted);    
}

class BroadcastRefundRequestModel {
  final String fromAddress;
  final String toAddress;
  final Int64 amount;

  BroadcastRefundRequestModel(this.fromAddress, this.toAddress, this.amount);
}

class BroadcastRefundResponseModel {
  final BroadcastRefundRequestModel request;
  final String txID;

  BroadcastRefundResponseModel(this.request, this.txID);
}

class MockPaymentInfo implements PaymentInfo {
  static bool isMockData = false;
  MockPaymentInfo(this.amount, this.fee, this.hash, this.type, this.creationTimestamp, this.description, this.imageURL);
  static final miliPerDay = 1000 * 3600 * 24;
  static List<PaymentInfo> createMockData() {
    int now = DateTime.now().millisecondsSinceEpoch;
    return new List<PaymentInfo>.unmodifiable([
      new MockPaymentInfo(Int64(75300), Int64(9950), "123", PaymentType.DEPOSIT, Int64( ((now - miliPerDay * 7)  / 1000).ceil()), "Bitcoin Transfer", null),
      new MockPaymentInfo(Int64(34500), Int64(9950), "123", PaymentType.SENT, Int64( ((now - miliPerDay * 7)  / 1000).ceil()), "Hotel payment", "https://api.adorable.io/avatars/100/hotel@gmail.com.png"),
      new MockPaymentInfo(Int64(452300), Int64(9950), "123", PaymentType.SENT, Int64( ((now - miliPerDay * 6)  / 1000).ceil()), "Kindergarden Payment", "https://api.adorable.io/avatars/100/kindergarden@gmail.com.png"),
      new MockPaymentInfo(Int64(4400), Int64(9950), "123", PaymentType.RECEIVED, Int64( ((now - miliPerDay * 4)  / 1000).ceil()), "Order Refund", "https://api.adorable.io/avatars/100/order@gmail.com.png"),
      new MockPaymentInfo(Int64(1000000), Int64(9950), "123", PaymentType.RECEIVED, Int64( ((now - miliPerDay * 3) / 1000).ceil()), "Trip Refund", "https://api.adorable.io/avatars/100/myfriendr@gmail.com.png"),
      new MockPaymentInfo(Int64(11200), Int64(9950), "123", PaymentType.WITHDRAWAL, Int64( ((now - miliPerDay *2) / 1000).ceil()), "Electricity Bill", "https://api.adorable.io/avatars/100/electricity@gmail.com.png"),
      new MockPaymentInfo(Int64(2000000), Int64(9950), "123", PaymentType.SENT, Int64( ((now - miliPerDay)  / 1000).ceil()), "Barber payment", "https://api.adorable.io/avatars/100/barber@gmail.com.png"),
      new MockPaymentInfo(Int64(532000), Int64(9950), "123", PaymentType.RECEIVED, Int64( ((now - miliPerDay) / 1000).ceil()), "Bet Winner", "https://api.adorable.io/avatars/100/looser@gmail.com.png"),
    ]);
  }
  
  Payment get _paymentResponse => null;
  final Int64 amount;
  final Int64 fee;
  final String hash;
  final Int64 creationTimestamp;
  final PaymentType type;
  final String description;
  final String imageURL;
  Map _typeMap;

  // TODO: implement _currency
  @override
  Currency get _currency => Currency.BTC;

  // @override
  // String get formattedAmount => CurrencyFormatter.format(amount, _currency);

  @override
  PaymentInfo copyWith(Currency currency) {
    return null;
  }

  // TODO: implement currency
  @override
  Currency get currency => Currency.BTC;

  // TODO: implement title
  @override
  String get title => description;

  // TODO: implement destination
  @override
  String get destination => "02f6725f9c1c40333b67faea92fd211c183050f28df32cac3f9d69685fe9665432";

  // TODO: implement paymentHash
  @override
  String get paymentHash => "c794bc55ec111256e41ba7c53f6aafadf39975a47abf52d496b662cdc4d5a90e";

  // TODO: implement redeemTxID
  @override
  String get redeemTxID => null;
}

///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library data_rpc;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

import 'rpc.pbenum.dart';

export 'rpc.pbenum.dart';

class ChainStatus extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ChainStatus')
    ..a<int>(1, 'blockHeight', PbFieldType.OU3)
    ..aOB(2, 'syncedToChain')
    ..hasRequiredFields = false
  ;

  ChainStatus() : super();
  ChainStatus.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ChainStatus.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ChainStatus clone() => new ChainStatus()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ChainStatus create() => new ChainStatus();
  static PbList<ChainStatus> createRepeated() => new PbList<ChainStatus>();
  static ChainStatus getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyChainStatus();
    return _defaultInstance;
  }
  static ChainStatus _defaultInstance;
  static void $checkItem(ChainStatus v) {
    if (v is! ChainStatus) checkItemFailed(v, 'ChainStatus');
  }

  int get blockHeight => $_get(0, 0);
  set blockHeight(int v) { $_setUnsignedInt32(0, v); }
  bool hasBlockHeight() => $_has(0);
  void clearBlockHeight() => clearField(1);

  bool get syncedToChain => $_get(1, false);
  set syncedToChain(bool v) { $_setBool(1, v); }
  bool hasSyncedToChain() => $_has(1);
  void clearSyncedToChain() => clearField(2);
}

class _ReadonlyChainStatus extends ChainStatus with ReadonlyMessageMixin {}

class Account extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Account')
    ..aOS(1, 'id')
    ..aInt64(2, 'balance')
    ..aInt64(3, 'walletBalance')
    ..e<Account_AccountStatus>(4, 'status', PbFieldType.OE, Account_AccountStatus.WAITING_DEPOSIT, Account_AccountStatus.valueOf, Account_AccountStatus.values)
    ..aInt64(5, 'maxAllowedToReceive')
    ..aInt64(6, 'maxAllowedToPay')
    ..aInt64(7, 'maxPaymentAmount')
    ..hasRequiredFields = false
  ;

  Account() : super();
  Account.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Account.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Account clone() => new Account()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Account create() => new Account();
  static PbList<Account> createRepeated() => new PbList<Account>();
  static Account getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyAccount();
    return _defaultInstance;
  }
  static Account _defaultInstance;
  static void $checkItem(Account v) {
    if (v is! Account) checkItemFailed(v, 'Account');
  }

  String get id => $_getS(0, '');
  set id(String v) { $_setString(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  Int64 get balance => $_getI64(1);
  set balance(Int64 v) { $_setInt64(1, v); }
  bool hasBalance() => $_has(1);
  void clearBalance() => clearField(2);

  Int64 get walletBalance => $_getI64(2);
  set walletBalance(Int64 v) { $_setInt64(2, v); }
  bool hasWalletBalance() => $_has(2);
  void clearWalletBalance() => clearField(3);

  Account_AccountStatus get status => $_getN(3);
  set status(Account_AccountStatus v) { setField(4, v); }
  bool hasStatus() => $_has(3);
  void clearStatus() => clearField(4);

  Int64 get maxAllowedToReceive => $_getI64(4);
  set maxAllowedToReceive(Int64 v) { $_setInt64(4, v); }
  bool hasMaxAllowedToReceive() => $_has(4);
  void clearMaxAllowedToReceive() => clearField(5);

  Int64 get maxAllowedToPay => $_getI64(5);
  set maxAllowedToPay(Int64 v) { $_setInt64(5, v); }
  bool hasMaxAllowedToPay() => $_has(5);
  void clearMaxAllowedToPay() => clearField(6);

  Int64 get maxPaymentAmount => $_getI64(6);
  set maxPaymentAmount(Int64 v) { $_setInt64(6, v); }
  bool hasMaxPaymentAmount() => $_has(6);
  void clearMaxPaymentAmount() => clearField(7);
}

class _ReadonlyAccount extends Account with ReadonlyMessageMixin {}

class Payment extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Payment')
    ..e<Payment_PaymentType>(1, 'type', PbFieldType.OE, Payment_PaymentType.DEPOSIT, Payment_PaymentType.valueOf, Payment_PaymentType.values)
    ..aInt64(3, 'amount')
    ..aInt64(4, 'creationTimestamp')
    ..a<InvoiceMemo>(6, 'invoiceMemo', PbFieldType.OM, InvoiceMemo.getDefault, InvoiceMemo.create)
    ..aOS(7, 'redeemTxID')
    ..aOS(8, 'paymentHash')
    ..aOS(9, 'destination')
    ..hasRequiredFields = false
  ;

  Payment() : super();
  Payment.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Payment.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Payment clone() => new Payment()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Payment create() => new Payment();
  static PbList<Payment> createRepeated() => new PbList<Payment>();
  static Payment getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyPayment();
    return _defaultInstance;
  }
  static Payment _defaultInstance;
  static void $checkItem(Payment v) {
    if (v is! Payment) checkItemFailed(v, 'Payment');
  }

  Payment_PaymentType get type => $_getN(0);
  set type(Payment_PaymentType v) { setField(1, v); }
  bool hasType() => $_has(0);
  void clearType() => clearField(1);

  Int64 get amount => $_getI64(1);
  set amount(Int64 v) { $_setInt64(1, v); }
  bool hasAmount() => $_has(1);
  void clearAmount() => clearField(3);

  Int64 get creationTimestamp => $_getI64(2);
  set creationTimestamp(Int64 v) { $_setInt64(2, v); }
  bool hasCreationTimestamp() => $_has(2);
  void clearCreationTimestamp() => clearField(4);

  InvoiceMemo get invoiceMemo => $_getN(3);
  set invoiceMemo(InvoiceMemo v) { setField(6, v); }
  bool hasInvoiceMemo() => $_has(3);
  void clearInvoiceMemo() => clearField(6);

  String get redeemTxID => $_getS(4, '');
  set redeemTxID(String v) { $_setString(4, v); }
  bool hasRedeemTxID() => $_has(4);
  void clearRedeemTxID() => clearField(7);

  String get paymentHash => $_getS(5, '');
  set paymentHash(String v) { $_setString(5, v); }
  bool hasPaymentHash() => $_has(5);
  void clearPaymentHash() => clearField(8);

  String get destination => $_getS(6, '');
  set destination(String v) { $_setString(6, v); }
  bool hasDestination() => $_has(6);
  void clearDestination() => clearField(9);
}

class _ReadonlyPayment extends Payment with ReadonlyMessageMixin {}

class PaymentsList extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PaymentsList')
    ..pp<Payment>(1, 'paymentsList', PbFieldType.PM, Payment.$checkItem, Payment.create)
    ..hasRequiredFields = false
  ;

  PaymentsList() : super();
  PaymentsList.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PaymentsList.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PaymentsList clone() => new PaymentsList()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PaymentsList create() => new PaymentsList();
  static PbList<PaymentsList> createRepeated() => new PbList<PaymentsList>();
  static PaymentsList getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyPaymentsList();
    return _defaultInstance;
  }
  static PaymentsList _defaultInstance;
  static void $checkItem(PaymentsList v) {
    if (v is! PaymentsList) checkItemFailed(v, 'PaymentsList');
  }

  List<Payment> get paymentsList => $_getList(0);
}

class _ReadonlyPaymentsList extends PaymentsList with ReadonlyMessageMixin {}

class SendWalletCoinsRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SendWalletCoinsRequest')
    ..aOS(1, 'address')
    ..aInt64(2, 'amount')
    ..aInt64(3, 'satPerByteFee')
    ..hasRequiredFields = false
  ;

  SendWalletCoinsRequest() : super();
  SendWalletCoinsRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SendWalletCoinsRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SendWalletCoinsRequest clone() => new SendWalletCoinsRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SendWalletCoinsRequest create() => new SendWalletCoinsRequest();
  static PbList<SendWalletCoinsRequest> createRepeated() => new PbList<SendWalletCoinsRequest>();
  static SendWalletCoinsRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlySendWalletCoinsRequest();
    return _defaultInstance;
  }
  static SendWalletCoinsRequest _defaultInstance;
  static void $checkItem(SendWalletCoinsRequest v) {
    if (v is! SendWalletCoinsRequest) checkItemFailed(v, 'SendWalletCoinsRequest');
  }

  String get address => $_getS(0, '');
  set address(String v) { $_setString(0, v); }
  bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  Int64 get amount => $_getI64(1);
  set amount(Int64 v) { $_setInt64(1, v); }
  bool hasAmount() => $_has(1);
  void clearAmount() => clearField(2);

  Int64 get satPerByteFee => $_getI64(2);
  set satPerByteFee(Int64 v) { $_setInt64(2, v); }
  bool hasSatPerByteFee() => $_has(2);
  void clearSatPerByteFee() => clearField(3);
}

class _ReadonlySendWalletCoinsRequest extends SendWalletCoinsRequest with ReadonlyMessageMixin {}

class PayInvoiceRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PayInvoiceRequest')
    ..aInt64(1, 'amount')
    ..aOS(2, 'paymentRequest')
    ..hasRequiredFields = false
  ;

  PayInvoiceRequest() : super();
  PayInvoiceRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PayInvoiceRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PayInvoiceRequest clone() => new PayInvoiceRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PayInvoiceRequest create() => new PayInvoiceRequest();
  static PbList<PayInvoiceRequest> createRepeated() => new PbList<PayInvoiceRequest>();
  static PayInvoiceRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyPayInvoiceRequest();
    return _defaultInstance;
  }
  static PayInvoiceRequest _defaultInstance;
  static void $checkItem(PayInvoiceRequest v) {
    if (v is! PayInvoiceRequest) checkItemFailed(v, 'PayInvoiceRequest');
  }

  Int64 get amount => $_getI64(0);
  set amount(Int64 v) { $_setInt64(0, v); }
  bool hasAmount() => $_has(0);
  void clearAmount() => clearField(1);

  String get paymentRequest => $_getS(1, '');
  set paymentRequest(String v) { $_setString(1, v); }
  bool hasPaymentRequest() => $_has(1);
  void clearPaymentRequest() => clearField(2);
}

class _ReadonlyPayInvoiceRequest extends PayInvoiceRequest with ReadonlyMessageMixin {}

class InvoiceMemo extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('InvoiceMemo')
    ..aOS(1, 'description')
    ..aInt64(2, 'amount')
    ..aOS(3, 'payeeName')
    ..aOS(4, 'payeeImageURL')
    ..aOS(5, 'payerName')
    ..aOS(6, 'payerImageURL')
    ..aOB(7, 'transferRequest')
    ..aInt64(8, 'expiry')
    ..hasRequiredFields = false
  ;

  InvoiceMemo() : super();
  InvoiceMemo.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  InvoiceMemo.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  InvoiceMemo clone() => new InvoiceMemo()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static InvoiceMemo create() => new InvoiceMemo();
  static PbList<InvoiceMemo> createRepeated() => new PbList<InvoiceMemo>();
  static InvoiceMemo getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyInvoiceMemo();
    return _defaultInstance;
  }
  static InvoiceMemo _defaultInstance;
  static void $checkItem(InvoiceMemo v) {
    if (v is! InvoiceMemo) checkItemFailed(v, 'InvoiceMemo');
  }

  String get description => $_getS(0, '');
  set description(String v) { $_setString(0, v); }
  bool hasDescription() => $_has(0);
  void clearDescription() => clearField(1);

  Int64 get amount => $_getI64(1);
  set amount(Int64 v) { $_setInt64(1, v); }
  bool hasAmount() => $_has(1);
  void clearAmount() => clearField(2);

  String get payeeName => $_getS(2, '');
  set payeeName(String v) { $_setString(2, v); }
  bool hasPayeeName() => $_has(2);
  void clearPayeeName() => clearField(3);

  String get payeeImageURL => $_getS(3, '');
  set payeeImageURL(String v) { $_setString(3, v); }
  bool hasPayeeImageURL() => $_has(3);
  void clearPayeeImageURL() => clearField(4);

  String get payerName => $_getS(4, '');
  set payerName(String v) { $_setString(4, v); }
  bool hasPayerName() => $_has(4);
  void clearPayerName() => clearField(5);

  String get payerImageURL => $_getS(5, '');
  set payerImageURL(String v) { $_setString(5, v); }
  bool hasPayerImageURL() => $_has(5);
  void clearPayerImageURL() => clearField(6);

  bool get transferRequest => $_get(6, false);
  set transferRequest(bool v) { $_setBool(6, v); }
  bool hasTransferRequest() => $_has(6);
  void clearTransferRequest() => clearField(7);

  Int64 get expiry => $_getI64(7);
  set expiry(Int64 v) { $_setInt64(7, v); }
  bool hasExpiry() => $_has(7);
  void clearExpiry() => clearField(8);
}

class _ReadonlyInvoiceMemo extends InvoiceMemo with ReadonlyMessageMixin {}

class Invoice extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Invoice')
    ..a<InvoiceMemo>(1, 'memo', PbFieldType.OM, InvoiceMemo.getDefault, InvoiceMemo.create)
    ..aOB(2, 'settled')
    ..aInt64(3, 'amtPaid')
    ..hasRequiredFields = false
  ;

  Invoice() : super();
  Invoice.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Invoice.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Invoice clone() => new Invoice()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Invoice create() => new Invoice();
  static PbList<Invoice> createRepeated() => new PbList<Invoice>();
  static Invoice getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyInvoice();
    return _defaultInstance;
  }
  static Invoice _defaultInstance;
  static void $checkItem(Invoice v) {
    if (v is! Invoice) checkItemFailed(v, 'Invoice');
  }

  InvoiceMemo get memo => $_getN(0);
  set memo(InvoiceMemo v) { setField(1, v); }
  bool hasMemo() => $_has(0);
  void clearMemo() => clearField(1);

  bool get settled => $_get(1, false);
  set settled(bool v) { $_setBool(1, v); }
  bool hasSettled() => $_has(1);
  void clearSettled() => clearField(2);

  Int64 get amtPaid => $_getI64(2);
  set amtPaid(Int64 v) { $_setInt64(2, v); }
  bool hasAmtPaid() => $_has(2);
  void clearAmtPaid() => clearField(3);
}

class _ReadonlyInvoice extends Invoice with ReadonlyMessageMixin {}

class NotificationEvent extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NotificationEvent')
    ..e<NotificationEvent_NotificationType>(1, 'type', PbFieldType.OE, NotificationEvent_NotificationType.READY, NotificationEvent_NotificationType.valueOf, NotificationEvent_NotificationType.values)
    ..pPS(2, 'data')
    ..hasRequiredFields = false
  ;

  NotificationEvent() : super();
  NotificationEvent.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NotificationEvent.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NotificationEvent clone() => new NotificationEvent()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NotificationEvent create() => new NotificationEvent();
  static PbList<NotificationEvent> createRepeated() => new PbList<NotificationEvent>();
  static NotificationEvent getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNotificationEvent();
    return _defaultInstance;
  }
  static NotificationEvent _defaultInstance;
  static void $checkItem(NotificationEvent v) {
    if (v is! NotificationEvent) checkItemFailed(v, 'NotificationEvent');
  }

  NotificationEvent_NotificationType get type => $_getN(0);
  set type(NotificationEvent_NotificationType v) { setField(1, v); }
  bool hasType() => $_has(0);
  void clearType() => clearField(1);

  List<String> get data => $_getList(1);
}

class _ReadonlyNotificationEvent extends NotificationEvent with ReadonlyMessageMixin {}

class AddFundInitReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AddFundInitReply')
    ..aOS(1, 'address')
    ..aInt64(2, 'maxAllowedDeposit')
    ..aOS(3, 'errorMessage')
    ..aOS(4, 'backupJson')
    ..hasRequiredFields = false
  ;

  AddFundInitReply() : super();
  AddFundInitReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundInitReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundInitReply clone() => new AddFundInitReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static AddFundInitReply create() => new AddFundInitReply();
  static PbList<AddFundInitReply> createRepeated() => new PbList<AddFundInitReply>();
  static AddFundInitReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyAddFundInitReply();
    return _defaultInstance;
  }
  static AddFundInitReply _defaultInstance;
  static void $checkItem(AddFundInitReply v) {
    if (v is! AddFundInitReply) checkItemFailed(v, 'AddFundInitReply');
  }

  String get address => $_getS(0, '');
  set address(String v) { $_setString(0, v); }
  bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  Int64 get maxAllowedDeposit => $_getI64(1);
  set maxAllowedDeposit(Int64 v) { $_setInt64(1, v); }
  bool hasMaxAllowedDeposit() => $_has(1);
  void clearMaxAllowedDeposit() => clearField(2);

  String get errorMessage => $_getS(2, '');
  set errorMessage(String v) { $_setString(2, v); }
  bool hasErrorMessage() => $_has(2);
  void clearErrorMessage() => clearField(3);

  String get backupJson => $_getS(3, '');
  set backupJson(String v) { $_setString(3, v); }
  bool hasBackupJson() => $_has(3);
  void clearBackupJson() => clearField(4);
}

class _ReadonlyAddFundInitReply extends AddFundInitReply with ReadonlyMessageMixin {}

class AddFundReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AddFundReply')
    ..aOS(1, 'errorMessage')
    ..hasRequiredFields = false
  ;

  AddFundReply() : super();
  AddFundReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundReply clone() => new AddFundReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static AddFundReply create() => new AddFundReply();
  static PbList<AddFundReply> createRepeated() => new PbList<AddFundReply>();
  static AddFundReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyAddFundReply();
    return _defaultInstance;
  }
  static AddFundReply _defaultInstance;
  static void $checkItem(AddFundReply v) {
    if (v is! AddFundReply) checkItemFailed(v, 'AddFundReply');
  }

  String get errorMessage => $_getS(0, '');
  set errorMessage(String v) { $_setString(0, v); }
  bool hasErrorMessage() => $_has(0);
  void clearErrorMessage() => clearField(1);
}

class _ReadonlyAddFundReply extends AddFundReply with ReadonlyMessageMixin {}

class RefundRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RefundRequest')
    ..aOS(1, 'address')
    ..aOS(2, 'refundAddress')
    ..hasRequiredFields = false
  ;

  RefundRequest() : super();
  RefundRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RefundRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RefundRequest clone() => new RefundRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RefundRequest create() => new RefundRequest();
  static PbList<RefundRequest> createRepeated() => new PbList<RefundRequest>();
  static RefundRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRefundRequest();
    return _defaultInstance;
  }
  static RefundRequest _defaultInstance;
  static void $checkItem(RefundRequest v) {
    if (v is! RefundRequest) checkItemFailed(v, 'RefundRequest');
  }

  String get address => $_getS(0, '');
  set address(String v) { $_setString(0, v); }
  bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  String get refundAddress => $_getS(1, '');
  set refundAddress(String v) { $_setString(1, v); }
  bool hasRefundAddress() => $_has(1);
  void clearRefundAddress() => clearField(2);
}

class _ReadonlyRefundRequest extends RefundRequest with ReadonlyMessageMixin {}

class FundStatusReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FundStatusReply')
    ..e<FundStatusReply_FundStatus>(1, 'status', PbFieldType.OE, FundStatusReply_FundStatus.NO_FUND, FundStatusReply_FundStatus.valueOf, FundStatusReply_FundStatus.values)
    ..hasRequiredFields = false
  ;

  FundStatusReply() : super();
  FundStatusReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FundStatusReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FundStatusReply clone() => new FundStatusReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FundStatusReply create() => new FundStatusReply();
  static PbList<FundStatusReply> createRepeated() => new PbList<FundStatusReply>();
  static FundStatusReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyFundStatusReply();
    return _defaultInstance;
  }
  static FundStatusReply _defaultInstance;
  static void $checkItem(FundStatusReply v) {
    if (v is! FundStatusReply) checkItemFailed(v, 'FundStatusReply');
  }

  FundStatusReply_FundStatus get status => $_getN(0);
  set status(FundStatusReply_FundStatus v) { setField(1, v); }
  bool hasStatus() => $_has(0);
  void clearStatus() => clearField(1);
}

class _ReadonlyFundStatusReply extends FundStatusReply with ReadonlyMessageMixin {}

class RemoveFundRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RemoveFundRequest')
    ..aOS(1, 'address')
    ..aInt64(2, 'amount')
    ..hasRequiredFields = false
  ;

  RemoveFundRequest() : super();
  RemoveFundRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RemoveFundRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RemoveFundRequest clone() => new RemoveFundRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RemoveFundRequest create() => new RemoveFundRequest();
  static PbList<RemoveFundRequest> createRepeated() => new PbList<RemoveFundRequest>();
  static RemoveFundRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRemoveFundRequest();
    return _defaultInstance;
  }
  static RemoveFundRequest _defaultInstance;
  static void $checkItem(RemoveFundRequest v) {
    if (v is! RemoveFundRequest) checkItemFailed(v, 'RemoveFundRequest');
  }

  String get address => $_getS(0, '');
  set address(String v) { $_setString(0, v); }
  bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  Int64 get amount => $_getI64(1);
  set amount(Int64 v) { $_setInt64(1, v); }
  bool hasAmount() => $_has(1);
  void clearAmount() => clearField(2);
}

class _ReadonlyRemoveFundRequest extends RemoveFundRequest with ReadonlyMessageMixin {}

class RemoveFundReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RemoveFundReply')
    ..aOS(1, 'txid')
    ..aOS(2, 'errorMessage')
    ..hasRequiredFields = false
  ;

  RemoveFundReply() : super();
  RemoveFundReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RemoveFundReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RemoveFundReply clone() => new RemoveFundReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RemoveFundReply create() => new RemoveFundReply();
  static PbList<RemoveFundReply> createRepeated() => new PbList<RemoveFundReply>();
  static RemoveFundReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRemoveFundReply();
    return _defaultInstance;
  }
  static RemoveFundReply _defaultInstance;
  static void $checkItem(RemoveFundReply v) {
    if (v is! RemoveFundReply) checkItemFailed(v, 'RemoveFundReply');
  }

  String get txid => $_getS(0, '');
  set txid(String v) { $_setString(0, v); }
  bool hasTxid() => $_has(0);
  void clearTxid() => clearField(1);

  String get errorMessage => $_getS(1, '');
  set errorMessage(String v) { $_setString(1, v); }
  bool hasErrorMessage() => $_has(1);
  void clearErrorMessage() => clearField(2);
}

class _ReadonlyRemoveFundReply extends RemoveFundReply with ReadonlyMessageMixin {}

class SwapAddressInfo extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SwapAddressInfo')
    ..aOS(1, 'address')
    ..aOS(2, 'paymentHash')
    ..aInt64(3, 'confirmedAmount')
    ..pPS(4, 'confirmedTransactionIds')
    ..aInt64(5, 'paidAmount')
    ..a<int>(6, 'lockHeight', PbFieldType.OU3)
    ..aOS(7, 'errorMessage')
    ..aOS(8, 'lastRefundTxID')
    ..hasRequiredFields = false
  ;

  SwapAddressInfo() : super();
  SwapAddressInfo.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SwapAddressInfo.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SwapAddressInfo clone() => new SwapAddressInfo()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SwapAddressInfo create() => new SwapAddressInfo();
  static PbList<SwapAddressInfo> createRepeated() => new PbList<SwapAddressInfo>();
  static SwapAddressInfo getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlySwapAddressInfo();
    return _defaultInstance;
  }
  static SwapAddressInfo _defaultInstance;
  static void $checkItem(SwapAddressInfo v) {
    if (v is! SwapAddressInfo) checkItemFailed(v, 'SwapAddressInfo');
  }

  String get address => $_getS(0, '');
  set address(String v) { $_setString(0, v); }
  bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  String get paymentHash => $_getS(1, '');
  set paymentHash(String v) { $_setString(1, v); }
  bool hasPaymentHash() => $_has(1);
  void clearPaymentHash() => clearField(2);

  Int64 get confirmedAmount => $_getI64(2);
  set confirmedAmount(Int64 v) { $_setInt64(2, v); }
  bool hasConfirmedAmount() => $_has(2);
  void clearConfirmedAmount() => clearField(3);

  List<String> get confirmedTransactionIds => $_getList(3);

  Int64 get paidAmount => $_getI64(4);
  set paidAmount(Int64 v) { $_setInt64(4, v); }
  bool hasPaidAmount() => $_has(4);
  void clearPaidAmount() => clearField(5);

  int get lockHeight => $_get(5, 0);
  set lockHeight(int v) { $_setUnsignedInt32(5, v); }
  bool hasLockHeight() => $_has(5);
  void clearLockHeight() => clearField(6);

  String get errorMessage => $_getS(6, '');
  set errorMessage(String v) { $_setString(6, v); }
  bool hasErrorMessage() => $_has(6);
  void clearErrorMessage() => clearField(7);

  String get lastRefundTxID => $_getS(7, '');
  set lastRefundTxID(String v) { $_setString(7, v); }
  bool hasLastRefundTxID() => $_has(7);
  void clearLastRefundTxID() => clearField(8);
}

class _ReadonlySwapAddressInfo extends SwapAddressInfo with ReadonlyMessageMixin {}

class SwapAddressList extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SwapAddressList')
    ..pp<SwapAddressInfo>(1, 'addresses', PbFieldType.PM, SwapAddressInfo.$checkItem, SwapAddressInfo.create)
    ..hasRequiredFields = false
  ;

  SwapAddressList() : super();
  SwapAddressList.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SwapAddressList.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SwapAddressList clone() => new SwapAddressList()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SwapAddressList create() => new SwapAddressList();
  static PbList<SwapAddressList> createRepeated() => new PbList<SwapAddressList>();
  static SwapAddressList getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlySwapAddressList();
    return _defaultInstance;
  }
  static SwapAddressList _defaultInstance;
  static void $checkItem(SwapAddressList v) {
    if (v is! SwapAddressList) checkItemFailed(v, 'SwapAddressList');
  }

  List<SwapAddressInfo> get addresses => $_getList(0);
}

class _ReadonlySwapAddressList extends SwapAddressList with ReadonlyMessageMixin {}

class CreateRatchetSessionRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CreateRatchetSessionRequest')
    ..aOS(1, 'secret')
    ..aOS(2, 'remotePubKey')
    ..aOS(3, 'sessionID')
    ..a<Int64>(4, 'expiry', PbFieldType.OU6, Int64.ZERO)
    ..hasRequiredFields = false
  ;

  CreateRatchetSessionRequest() : super();
  CreateRatchetSessionRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateRatchetSessionRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateRatchetSessionRequest clone() => new CreateRatchetSessionRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CreateRatchetSessionRequest create() => new CreateRatchetSessionRequest();
  static PbList<CreateRatchetSessionRequest> createRepeated() => new PbList<CreateRatchetSessionRequest>();
  static CreateRatchetSessionRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCreateRatchetSessionRequest();
    return _defaultInstance;
  }
  static CreateRatchetSessionRequest _defaultInstance;
  static void $checkItem(CreateRatchetSessionRequest v) {
    if (v is! CreateRatchetSessionRequest) checkItemFailed(v, 'CreateRatchetSessionRequest');
  }

  String get secret => $_getS(0, '');
  set secret(String v) { $_setString(0, v); }
  bool hasSecret() => $_has(0);
  void clearSecret() => clearField(1);

  String get remotePubKey => $_getS(1, '');
  set remotePubKey(String v) { $_setString(1, v); }
  bool hasRemotePubKey() => $_has(1);
  void clearRemotePubKey() => clearField(2);

  String get sessionID => $_getS(2, '');
  set sessionID(String v) { $_setString(2, v); }
  bool hasSessionID() => $_has(2);
  void clearSessionID() => clearField(3);

  Int64 get expiry => $_getI64(3);
  set expiry(Int64 v) { $_setInt64(3, v); }
  bool hasExpiry() => $_has(3);
  void clearExpiry() => clearField(4);
}

class _ReadonlyCreateRatchetSessionRequest extends CreateRatchetSessionRequest with ReadonlyMessageMixin {}

class CreateRatchetSessionReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CreateRatchetSessionReply')
    ..aOS(1, 'sessionID')
    ..aOS(2, 'secret')
    ..aOS(3, 'pubKey')
    ..hasRequiredFields = false
  ;

  CreateRatchetSessionReply() : super();
  CreateRatchetSessionReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateRatchetSessionReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateRatchetSessionReply clone() => new CreateRatchetSessionReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CreateRatchetSessionReply create() => new CreateRatchetSessionReply();
  static PbList<CreateRatchetSessionReply> createRepeated() => new PbList<CreateRatchetSessionReply>();
  static CreateRatchetSessionReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCreateRatchetSessionReply();
    return _defaultInstance;
  }
  static CreateRatchetSessionReply _defaultInstance;
  static void $checkItem(CreateRatchetSessionReply v) {
    if (v is! CreateRatchetSessionReply) checkItemFailed(v, 'CreateRatchetSessionReply');
  }

  String get sessionID => $_getS(0, '');
  set sessionID(String v) { $_setString(0, v); }
  bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  String get secret => $_getS(1, '');
  set secret(String v) { $_setString(1, v); }
  bool hasSecret() => $_has(1);
  void clearSecret() => clearField(2);

  String get pubKey => $_getS(2, '');
  set pubKey(String v) { $_setString(2, v); }
  bool hasPubKey() => $_has(2);
  void clearPubKey() => clearField(3);
}

class _ReadonlyCreateRatchetSessionReply extends CreateRatchetSessionReply with ReadonlyMessageMixin {}

class RatchetSessionInfoReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RatchetSessionInfoReply')
    ..aOS(1, 'sessionID')
    ..aOB(2, 'initiated')
    ..aOS(3, 'userInfo')
    ..hasRequiredFields = false
  ;

  RatchetSessionInfoReply() : super();
  RatchetSessionInfoReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RatchetSessionInfoReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RatchetSessionInfoReply clone() => new RatchetSessionInfoReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RatchetSessionInfoReply create() => new RatchetSessionInfoReply();
  static PbList<RatchetSessionInfoReply> createRepeated() => new PbList<RatchetSessionInfoReply>();
  static RatchetSessionInfoReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRatchetSessionInfoReply();
    return _defaultInstance;
  }
  static RatchetSessionInfoReply _defaultInstance;
  static void $checkItem(RatchetSessionInfoReply v) {
    if (v is! RatchetSessionInfoReply) checkItemFailed(v, 'RatchetSessionInfoReply');
  }

  String get sessionID => $_getS(0, '');
  set sessionID(String v) { $_setString(0, v); }
  bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  bool get initiated => $_get(1, false);
  set initiated(bool v) { $_setBool(1, v); }
  bool hasInitiated() => $_has(1);
  void clearInitiated() => clearField(2);

  String get userInfo => $_getS(2, '');
  set userInfo(String v) { $_setString(2, v); }
  bool hasUserInfo() => $_has(2);
  void clearUserInfo() => clearField(3);
}

class _ReadonlyRatchetSessionInfoReply extends RatchetSessionInfoReply with ReadonlyMessageMixin {}

class RatchetSessionSetInfoRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RatchetSessionSetInfoRequest')
    ..aOS(1, 'sessionID')
    ..aOS(2, 'userInfo')
    ..hasRequiredFields = false
  ;

  RatchetSessionSetInfoRequest() : super();
  RatchetSessionSetInfoRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RatchetSessionSetInfoRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RatchetSessionSetInfoRequest clone() => new RatchetSessionSetInfoRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RatchetSessionSetInfoRequest create() => new RatchetSessionSetInfoRequest();
  static PbList<RatchetSessionSetInfoRequest> createRepeated() => new PbList<RatchetSessionSetInfoRequest>();
  static RatchetSessionSetInfoRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRatchetSessionSetInfoRequest();
    return _defaultInstance;
  }
  static RatchetSessionSetInfoRequest _defaultInstance;
  static void $checkItem(RatchetSessionSetInfoRequest v) {
    if (v is! RatchetSessionSetInfoRequest) checkItemFailed(v, 'RatchetSessionSetInfoRequest');
  }

  String get sessionID => $_getS(0, '');
  set sessionID(String v) { $_setString(0, v); }
  bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  String get userInfo => $_getS(1, '');
  set userInfo(String v) { $_setString(1, v); }
  bool hasUserInfo() => $_has(1);
  void clearUserInfo() => clearField(2);
}

class _ReadonlyRatchetSessionSetInfoRequest extends RatchetSessionSetInfoRequest with ReadonlyMessageMixin {}

class RatchetEncryptRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RatchetEncryptRequest')
    ..aOS(1, 'sessionID')
    ..aOS(2, 'message')
    ..hasRequiredFields = false
  ;

  RatchetEncryptRequest() : super();
  RatchetEncryptRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RatchetEncryptRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RatchetEncryptRequest clone() => new RatchetEncryptRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RatchetEncryptRequest create() => new RatchetEncryptRequest();
  static PbList<RatchetEncryptRequest> createRepeated() => new PbList<RatchetEncryptRequest>();
  static RatchetEncryptRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRatchetEncryptRequest();
    return _defaultInstance;
  }
  static RatchetEncryptRequest _defaultInstance;
  static void $checkItem(RatchetEncryptRequest v) {
    if (v is! RatchetEncryptRequest) checkItemFailed(v, 'RatchetEncryptRequest');
  }

  String get sessionID => $_getS(0, '');
  set sessionID(String v) { $_setString(0, v); }
  bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  String get message => $_getS(1, '');
  set message(String v) { $_setString(1, v); }
  bool hasMessage() => $_has(1);
  void clearMessage() => clearField(2);
}

class _ReadonlyRatchetEncryptRequest extends RatchetEncryptRequest with ReadonlyMessageMixin {}

class RatchetDecryptRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RatchetDecryptRequest')
    ..aOS(1, 'sessionID')
    ..aOS(2, 'encryptedMessage')
    ..hasRequiredFields = false
  ;

  RatchetDecryptRequest() : super();
  RatchetDecryptRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RatchetDecryptRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RatchetDecryptRequest clone() => new RatchetDecryptRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RatchetDecryptRequest create() => new RatchetDecryptRequest();
  static PbList<RatchetDecryptRequest> createRepeated() => new PbList<RatchetDecryptRequest>();
  static RatchetDecryptRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRatchetDecryptRequest();
    return _defaultInstance;
  }
  static RatchetDecryptRequest _defaultInstance;
  static void $checkItem(RatchetDecryptRequest v) {
    if (v is! RatchetDecryptRequest) checkItemFailed(v, 'RatchetDecryptRequest');
  }

  String get sessionID => $_getS(0, '');
  set sessionID(String v) { $_setString(0, v); }
  bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  String get encryptedMessage => $_getS(1, '');
  set encryptedMessage(String v) { $_setString(1, v); }
  bool hasEncryptedMessage() => $_has(1);
  void clearEncryptedMessage() => clearField(2);
}

class _ReadonlyRatchetDecryptRequest extends RatchetDecryptRequest with ReadonlyMessageMixin {}

class BootstrapFilesRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('BootstrapFilesRequest')
    ..aOS(1, 'workingDir')
    ..pPS(2, 'fullPaths')
    ..hasRequiredFields = false
  ;

  BootstrapFilesRequest() : super();
  BootstrapFilesRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  BootstrapFilesRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  BootstrapFilesRequest clone() => new BootstrapFilesRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static BootstrapFilesRequest create() => new BootstrapFilesRequest();
  static PbList<BootstrapFilesRequest> createRepeated() => new PbList<BootstrapFilesRequest>();
  static BootstrapFilesRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyBootstrapFilesRequest();
    return _defaultInstance;
  }
  static BootstrapFilesRequest _defaultInstance;
  static void $checkItem(BootstrapFilesRequest v) {
    if (v is! BootstrapFilesRequest) checkItemFailed(v, 'BootstrapFilesRequest');
  }

  String get workingDir => $_getS(0, '');
  set workingDir(String v) { $_setString(0, v); }
  bool hasWorkingDir() => $_has(0);
  void clearWorkingDir() => clearField(1);

  List<String> get fullPaths => $_getList(1);
}

class _ReadonlyBootstrapFilesRequest extends BootstrapFilesRequest with ReadonlyMessageMixin {}


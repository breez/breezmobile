///
//  Generated code. Do not modify.
//  source: rpc.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'rpc.pbenum.dart';

export 'rpc.pbenum.dart';

class ChainStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ChainStatus', package: const $pb.PackageName('data'))
    ..a<int>(1, 'blockHeight', $pb.PbFieldType.OU3)
    ..aOB(2, 'syncedToChain')
    ..hasRequiredFields = false
  ;

  ChainStatus() : super();
  ChainStatus.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ChainStatus.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ChainStatus clone() => new ChainStatus()..mergeFromMessage(this);
  ChainStatus copyWith(void Function(ChainStatus) updates) => super.copyWith((message) => updates(message as ChainStatus));
  $pb.BuilderInfo get info_ => _i;
  static ChainStatus create() => new ChainStatus();
  ChainStatus createEmptyInstance() => create();
  static $pb.PbList<ChainStatus> createRepeated() => new $pb.PbList<ChainStatus>();
  static ChainStatus getDefault() => _defaultInstance ??= create()..freeze();
  static ChainStatus _defaultInstance;

  int get blockHeight => $_get(0, 0);
  set blockHeight(int v) { $_setUnsignedInt32(0, v); }
  bool hasBlockHeight() => $_has(0);
  void clearBlockHeight() => clearField(1);

  bool get syncedToChain => $_get(1, false);
  set syncedToChain(bool v) { $_setBool(1, v); }
  bool hasSyncedToChain() => $_has(1);
  void clearSyncedToChain() => clearField(2);
}

class Account extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Account', package: const $pb.PackageName('data'))
    ..aOS(1, 'id')
    ..aInt64(2, 'balance')
    ..aInt64(3, 'walletBalance')
    ..e<Account_AccountStatus>(4, 'status', $pb.PbFieldType.OE, Account_AccountStatus.WAITING_DEPOSIT, Account_AccountStatus.valueOf, Account_AccountStatus.values)
    ..aInt64(5, 'maxAllowedToReceive')
    ..aInt64(6, 'maxAllowedToPay')
    ..aInt64(7, 'maxPaymentAmount')
    ..aInt64(8, 'routingNodeFee')
    ..aOB(9, 'enabled')
    ..aInt64(10, 'maxChanReserve')
    ..hasRequiredFields = false
  ;

  Account() : super();
  Account.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Account.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Account clone() => new Account()..mergeFromMessage(this);
  Account copyWith(void Function(Account) updates) => super.copyWith((message) => updates(message as Account));
  $pb.BuilderInfo get info_ => _i;
  static Account create() => new Account();
  Account createEmptyInstance() => create();
  static $pb.PbList<Account> createRepeated() => new $pb.PbList<Account>();
  static Account getDefault() => _defaultInstance ??= create()..freeze();
  static Account _defaultInstance;

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

  Int64 get routingNodeFee => $_getI64(7);
  set routingNodeFee(Int64 v) { $_setInt64(7, v); }
  bool hasRoutingNodeFee() => $_has(7);
  void clearRoutingNodeFee() => clearField(8);

  bool get enabled => $_get(8, false);
  set enabled(bool v) { $_setBool(8, v); }
  bool hasEnabled() => $_has(8);
  void clearEnabled() => clearField(9);

  Int64 get maxChanReserve => $_getI64(9);
  set maxChanReserve(Int64 v) { $_setInt64(9, v); }
  bool hasMaxChanReserve() => $_has(9);
  void clearMaxChanReserve() => clearField(10);
}

class Payment extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Payment', package: const $pb.PackageName('data'))
    ..e<Payment_PaymentType>(1, 'type', $pb.PbFieldType.OE, Payment_PaymentType.DEPOSIT, Payment_PaymentType.valueOf, Payment_PaymentType.values)
    ..aInt64(3, 'amount')
    ..aInt64(4, 'creationTimestamp')
    ..a<InvoiceMemo>(6, 'invoiceMemo', $pb.PbFieldType.OM, InvoiceMemo.getDefault, InvoiceMemo.create)
    ..aOS(7, 'redeemTxID')
    ..aOS(8, 'paymentHash')
    ..aOS(9, 'destination')
    ..a<int>(10, 'pendingExpirationHeight', $pb.PbFieldType.OU3)
    ..aInt64(11, 'pendingExpirationTimestamp')
    ..aInt64(12, 'fee')
    ..hasRequiredFields = false
  ;

  Payment() : super();
  Payment.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Payment.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Payment clone() => new Payment()..mergeFromMessage(this);
  Payment copyWith(void Function(Payment) updates) => super.copyWith((message) => updates(message as Payment));
  $pb.BuilderInfo get info_ => _i;
  static Payment create() => new Payment();
  Payment createEmptyInstance() => create();
  static $pb.PbList<Payment> createRepeated() => new $pb.PbList<Payment>();
  static Payment getDefault() => _defaultInstance ??= create()..freeze();
  static Payment _defaultInstance;

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

  int get pendingExpirationHeight => $_get(7, 0);
  set pendingExpirationHeight(int v) { $_setUnsignedInt32(7, v); }
  bool hasPendingExpirationHeight() => $_has(7);
  void clearPendingExpirationHeight() => clearField(10);

  Int64 get pendingExpirationTimestamp => $_getI64(8);
  set pendingExpirationTimestamp(Int64 v) { $_setInt64(8, v); }
  bool hasPendingExpirationTimestamp() => $_has(8);
  void clearPendingExpirationTimestamp() => clearField(11);

  Int64 get fee => $_getI64(9);
  set fee(Int64 v) { $_setInt64(9, v); }
  bool hasFee() => $_has(9);
  void clearFee() => clearField(12);
}

class PaymentsList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PaymentsList', package: const $pb.PackageName('data'))
    ..pc<Payment>(1, 'paymentsList', $pb.PbFieldType.PM,Payment.create)
    ..hasRequiredFields = false
  ;

  PaymentsList() : super();
  PaymentsList.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PaymentsList.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PaymentsList clone() => new PaymentsList()..mergeFromMessage(this);
  PaymentsList copyWith(void Function(PaymentsList) updates) => super.copyWith((message) => updates(message as PaymentsList));
  $pb.BuilderInfo get info_ => _i;
  static PaymentsList create() => new PaymentsList();
  PaymentsList createEmptyInstance() => create();
  static $pb.PbList<PaymentsList> createRepeated() => new $pb.PbList<PaymentsList>();
  static PaymentsList getDefault() => _defaultInstance ??= create()..freeze();
  static PaymentsList _defaultInstance;

  List<Payment> get paymentsList => $_getList(0);
}

class PaymentResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PaymentResponse', package: const $pb.PackageName('data'))
    ..aOS(1, 'paymentError')
    ..aOS(2, 'traceReport')
    ..hasRequiredFields = false
  ;

  PaymentResponse() : super();
  PaymentResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PaymentResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PaymentResponse clone() => new PaymentResponse()..mergeFromMessage(this);
  PaymentResponse copyWith(void Function(PaymentResponse) updates) => super.copyWith((message) => updates(message as PaymentResponse));
  $pb.BuilderInfo get info_ => _i;
  static PaymentResponse create() => new PaymentResponse();
  PaymentResponse createEmptyInstance() => create();
  static $pb.PbList<PaymentResponse> createRepeated() => new $pb.PbList<PaymentResponse>();
  static PaymentResponse getDefault() => _defaultInstance ??= create()..freeze();
  static PaymentResponse _defaultInstance;

  String get paymentError => $_getS(0, '');
  set paymentError(String v) { $_setString(0, v); }
  bool hasPaymentError() => $_has(0);
  void clearPaymentError() => clearField(1);

  String get traceReport => $_getS(1, '');
  set traceReport(String v) { $_setString(1, v); }
  bool hasTraceReport() => $_has(1);
  void clearTraceReport() => clearField(2);
}

class SendWalletCoinsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SendWalletCoinsRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'address')
    ..aInt64(2, 'amount')
    ..aInt64(3, 'satPerByteFee')
    ..hasRequiredFields = false
  ;

  SendWalletCoinsRequest() : super();
  SendWalletCoinsRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SendWalletCoinsRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SendWalletCoinsRequest clone() => new SendWalletCoinsRequest()..mergeFromMessage(this);
  SendWalletCoinsRequest copyWith(void Function(SendWalletCoinsRequest) updates) => super.copyWith((message) => updates(message as SendWalletCoinsRequest));
  $pb.BuilderInfo get info_ => _i;
  static SendWalletCoinsRequest create() => new SendWalletCoinsRequest();
  SendWalletCoinsRequest createEmptyInstance() => create();
  static $pb.PbList<SendWalletCoinsRequest> createRepeated() => new $pb.PbList<SendWalletCoinsRequest>();
  static SendWalletCoinsRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SendWalletCoinsRequest _defaultInstance;

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

class PayInvoiceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PayInvoiceRequest', package: const $pb.PackageName('data'))
    ..aInt64(1, 'amount')
    ..aOS(2, 'paymentRequest')
    ..hasRequiredFields = false
  ;

  PayInvoiceRequest() : super();
  PayInvoiceRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PayInvoiceRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PayInvoiceRequest clone() => new PayInvoiceRequest()..mergeFromMessage(this);
  PayInvoiceRequest copyWith(void Function(PayInvoiceRequest) updates) => super.copyWith((message) => updates(message as PayInvoiceRequest));
  $pb.BuilderInfo get info_ => _i;
  static PayInvoiceRequest create() => new PayInvoiceRequest();
  PayInvoiceRequest createEmptyInstance() => create();
  static $pb.PbList<PayInvoiceRequest> createRepeated() => new $pb.PbList<PayInvoiceRequest>();
  static PayInvoiceRequest getDefault() => _defaultInstance ??= create()..freeze();
  static PayInvoiceRequest _defaultInstance;

  Int64 get amount => $_getI64(0);
  set amount(Int64 v) { $_setInt64(0, v); }
  bool hasAmount() => $_has(0);
  void clearAmount() => clearField(1);

  String get paymentRequest => $_getS(1, '');
  set paymentRequest(String v) { $_setString(1, v); }
  bool hasPaymentRequest() => $_has(1);
  void clearPaymentRequest() => clearField(2);
}

class InvoiceMemo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('InvoiceMemo', package: const $pb.PackageName('data'))
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
  InvoiceMemo.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  InvoiceMemo.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  InvoiceMemo clone() => new InvoiceMemo()..mergeFromMessage(this);
  InvoiceMemo copyWith(void Function(InvoiceMemo) updates) => super.copyWith((message) => updates(message as InvoiceMemo));
  $pb.BuilderInfo get info_ => _i;
  static InvoiceMemo create() => new InvoiceMemo();
  InvoiceMemo createEmptyInstance() => create();
  static $pb.PbList<InvoiceMemo> createRepeated() => new $pb.PbList<InvoiceMemo>();
  static InvoiceMemo getDefault() => _defaultInstance ??= create()..freeze();
  static InvoiceMemo _defaultInstance;

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

class Invoice extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Invoice', package: const $pb.PackageName('data'))
    ..a<InvoiceMemo>(1, 'memo', $pb.PbFieldType.OM, InvoiceMemo.getDefault, InvoiceMemo.create)
    ..aOB(2, 'settled')
    ..aInt64(3, 'amtPaid')
    ..hasRequiredFields = false
  ;

  Invoice() : super();
  Invoice.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Invoice.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Invoice clone() => new Invoice()..mergeFromMessage(this);
  Invoice copyWith(void Function(Invoice) updates) => super.copyWith((message) => updates(message as Invoice));
  $pb.BuilderInfo get info_ => _i;
  static Invoice create() => new Invoice();
  Invoice createEmptyInstance() => create();
  static $pb.PbList<Invoice> createRepeated() => new $pb.PbList<Invoice>();
  static Invoice getDefault() => _defaultInstance ??= create()..freeze();
  static Invoice _defaultInstance;

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

class NotificationEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NotificationEvent', package: const $pb.PackageName('data'))
    ..e<NotificationEvent_NotificationType>(1, 'type', $pb.PbFieldType.OE, NotificationEvent_NotificationType.READY, NotificationEvent_NotificationType.valueOf, NotificationEvent_NotificationType.values)
    ..pPS(2, 'data')
    ..hasRequiredFields = false
  ;

  NotificationEvent() : super();
  NotificationEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NotificationEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NotificationEvent clone() => new NotificationEvent()..mergeFromMessage(this);
  NotificationEvent copyWith(void Function(NotificationEvent) updates) => super.copyWith((message) => updates(message as NotificationEvent));
  $pb.BuilderInfo get info_ => _i;
  static NotificationEvent create() => new NotificationEvent();
  NotificationEvent createEmptyInstance() => create();
  static $pb.PbList<NotificationEvent> createRepeated() => new $pb.PbList<NotificationEvent>();
  static NotificationEvent getDefault() => _defaultInstance ??= create()..freeze();
  static NotificationEvent _defaultInstance;

  NotificationEvent_NotificationType get type => $_getN(0);
  set type(NotificationEvent_NotificationType v) { setField(1, v); }
  bool hasType() => $_has(0);
  void clearType() => clearField(1);

  List<String> get data => $_getList(1);
}

class AddFundInitReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AddFundInitReply', package: const $pb.PackageName('data'))
    ..aOS(1, 'address')
    ..aInt64(2, 'maxAllowedDeposit')
    ..aOS(3, 'errorMessage')
    ..aOS(4, 'backupJson')
    ..aInt64(5, 'requiredReserve')
    ..hasRequiredFields = false
  ;

  AddFundInitReply() : super();
  AddFundInitReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundInitReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundInitReply clone() => new AddFundInitReply()..mergeFromMessage(this);
  AddFundInitReply copyWith(void Function(AddFundInitReply) updates) => super.copyWith((message) => updates(message as AddFundInitReply));
  $pb.BuilderInfo get info_ => _i;
  static AddFundInitReply create() => new AddFundInitReply();
  AddFundInitReply createEmptyInstance() => create();
  static $pb.PbList<AddFundInitReply> createRepeated() => new $pb.PbList<AddFundInitReply>();
  static AddFundInitReply getDefault() => _defaultInstance ??= create()..freeze();
  static AddFundInitReply _defaultInstance;

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

  Int64 get requiredReserve => $_getI64(4);
  set requiredReserve(Int64 v) { $_setInt64(4, v); }
  bool hasRequiredReserve() => $_has(4);
  void clearRequiredReserve() => clearField(5);
}

class AddFundReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AddFundReply', package: const $pb.PackageName('data'))
    ..aOS(1, 'errorMessage')
    ..hasRequiredFields = false
  ;

  AddFundReply() : super();
  AddFundReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundReply clone() => new AddFundReply()..mergeFromMessage(this);
  AddFundReply copyWith(void Function(AddFundReply) updates) => super.copyWith((message) => updates(message as AddFundReply));
  $pb.BuilderInfo get info_ => _i;
  static AddFundReply create() => new AddFundReply();
  AddFundReply createEmptyInstance() => create();
  static $pb.PbList<AddFundReply> createRepeated() => new $pb.PbList<AddFundReply>();
  static AddFundReply getDefault() => _defaultInstance ??= create()..freeze();
  static AddFundReply _defaultInstance;

  String get errorMessage => $_getS(0, '');
  set errorMessage(String v) { $_setString(0, v); }
  bool hasErrorMessage() => $_has(0);
  void clearErrorMessage() => clearField(1);
}

class RefundRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RefundRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'address')
    ..aOS(2, 'refundAddress')
    ..hasRequiredFields = false
  ;

  RefundRequest() : super();
  RefundRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RefundRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RefundRequest clone() => new RefundRequest()..mergeFromMessage(this);
  RefundRequest copyWith(void Function(RefundRequest) updates) => super.copyWith((message) => updates(message as RefundRequest));
  $pb.BuilderInfo get info_ => _i;
  static RefundRequest create() => new RefundRequest();
  RefundRequest createEmptyInstance() => create();
  static $pb.PbList<RefundRequest> createRepeated() => new $pb.PbList<RefundRequest>();
  static RefundRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RefundRequest _defaultInstance;

  String get address => $_getS(0, '');
  set address(String v) { $_setString(0, v); }
  bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  String get refundAddress => $_getS(1, '');
  set refundAddress(String v) { $_setString(1, v); }
  bool hasRefundAddress() => $_has(1);
  void clearRefundAddress() => clearField(2);
}

class FundStatusReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FundStatusReply', package: const $pb.PackageName('data'))
    ..e<FundStatusReply_FundStatus>(1, 'status', $pb.PbFieldType.OE, FundStatusReply_FundStatus.NO_FUND, FundStatusReply_FundStatus.valueOf, FundStatusReply_FundStatus.values)
    ..aOS(2, 'errorMessage')
    ..hasRequiredFields = false
  ;

  FundStatusReply() : super();
  FundStatusReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FundStatusReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FundStatusReply clone() => new FundStatusReply()..mergeFromMessage(this);
  FundStatusReply copyWith(void Function(FundStatusReply) updates) => super.copyWith((message) => updates(message as FundStatusReply));
  $pb.BuilderInfo get info_ => _i;
  static FundStatusReply create() => new FundStatusReply();
  FundStatusReply createEmptyInstance() => create();
  static $pb.PbList<FundStatusReply> createRepeated() => new $pb.PbList<FundStatusReply>();
  static FundStatusReply getDefault() => _defaultInstance ??= create()..freeze();
  static FundStatusReply _defaultInstance;

  FundStatusReply_FundStatus get status => $_getN(0);
  set status(FundStatusReply_FundStatus v) { setField(1, v); }
  bool hasStatus() => $_has(0);
  void clearStatus() => clearField(1);

  String get errorMessage => $_getS(1, '');
  set errorMessage(String v) { $_setString(1, v); }
  bool hasErrorMessage() => $_has(1);
  void clearErrorMessage() => clearField(2);
}

class RemoveFundRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RemoveFundRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'address')
    ..aInt64(2, 'amount')
    ..hasRequiredFields = false
  ;

  RemoveFundRequest() : super();
  RemoveFundRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RemoveFundRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RemoveFundRequest clone() => new RemoveFundRequest()..mergeFromMessage(this);
  RemoveFundRequest copyWith(void Function(RemoveFundRequest) updates) => super.copyWith((message) => updates(message as RemoveFundRequest));
  $pb.BuilderInfo get info_ => _i;
  static RemoveFundRequest create() => new RemoveFundRequest();
  RemoveFundRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveFundRequest> createRepeated() => new $pb.PbList<RemoveFundRequest>();
  static RemoveFundRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RemoveFundRequest _defaultInstance;

  String get address => $_getS(0, '');
  set address(String v) { $_setString(0, v); }
  bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  Int64 get amount => $_getI64(1);
  set amount(Int64 v) { $_setInt64(1, v); }
  bool hasAmount() => $_has(1);
  void clearAmount() => clearField(2);
}

class RemoveFundReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RemoveFundReply', package: const $pb.PackageName('data'))
    ..aOS(1, 'txid')
    ..aOS(2, 'errorMessage')
    ..hasRequiredFields = false
  ;

  RemoveFundReply() : super();
  RemoveFundReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RemoveFundReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RemoveFundReply clone() => new RemoveFundReply()..mergeFromMessage(this);
  RemoveFundReply copyWith(void Function(RemoveFundReply) updates) => super.copyWith((message) => updates(message as RemoveFundReply));
  $pb.BuilderInfo get info_ => _i;
  static RemoveFundReply create() => new RemoveFundReply();
  RemoveFundReply createEmptyInstance() => create();
  static $pb.PbList<RemoveFundReply> createRepeated() => new $pb.PbList<RemoveFundReply>();
  static RemoveFundReply getDefault() => _defaultInstance ??= create()..freeze();
  static RemoveFundReply _defaultInstance;

  String get txid => $_getS(0, '');
  set txid(String v) { $_setString(0, v); }
  bool hasTxid() => $_has(0);
  void clearTxid() => clearField(1);

  String get errorMessage => $_getS(1, '');
  set errorMessage(String v) { $_setString(1, v); }
  bool hasErrorMessage() => $_has(1);
  void clearErrorMessage() => clearField(2);
}

class SwapAddressInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SwapAddressInfo', package: const $pb.PackageName('data'))
    ..aOS(1, 'address')
    ..aOS(2, 'paymentHash')
    ..aInt64(3, 'confirmedAmount')
    ..pPS(4, 'confirmedTransactionIds')
    ..aInt64(5, 'paidAmount')
    ..a<int>(6, 'lockHeight', $pb.PbFieldType.OU3)
    ..aOS(7, 'errorMessage')
    ..aOS(8, 'lastRefundTxID')
    ..hasRequiredFields = false
  ;

  SwapAddressInfo() : super();
  SwapAddressInfo.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SwapAddressInfo.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SwapAddressInfo clone() => new SwapAddressInfo()..mergeFromMessage(this);
  SwapAddressInfo copyWith(void Function(SwapAddressInfo) updates) => super.copyWith((message) => updates(message as SwapAddressInfo));
  $pb.BuilderInfo get info_ => _i;
  static SwapAddressInfo create() => new SwapAddressInfo();
  SwapAddressInfo createEmptyInstance() => create();
  static $pb.PbList<SwapAddressInfo> createRepeated() => new $pb.PbList<SwapAddressInfo>();
  static SwapAddressInfo getDefault() => _defaultInstance ??= create()..freeze();
  static SwapAddressInfo _defaultInstance;

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

class SwapAddressList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SwapAddressList', package: const $pb.PackageName('data'))
    ..pc<SwapAddressInfo>(1, 'addresses', $pb.PbFieldType.PM,SwapAddressInfo.create)
    ..hasRequiredFields = false
  ;

  SwapAddressList() : super();
  SwapAddressList.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SwapAddressList.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SwapAddressList clone() => new SwapAddressList()..mergeFromMessage(this);
  SwapAddressList copyWith(void Function(SwapAddressList) updates) => super.copyWith((message) => updates(message as SwapAddressList));
  $pb.BuilderInfo get info_ => _i;
  static SwapAddressList create() => new SwapAddressList();
  SwapAddressList createEmptyInstance() => create();
  static $pb.PbList<SwapAddressList> createRepeated() => new $pb.PbList<SwapAddressList>();
  static SwapAddressList getDefault() => _defaultInstance ??= create()..freeze();
  static SwapAddressList _defaultInstance;

  List<SwapAddressInfo> get addresses => $_getList(0);
}

class CreateRatchetSessionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateRatchetSessionRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'secret')
    ..aOS(2, 'remotePubKey')
    ..aOS(3, 'sessionID')
    ..a<Int64>(4, 'expiry', $pb.PbFieldType.OU6, Int64.ZERO)
    ..hasRequiredFields = false
  ;

  CreateRatchetSessionRequest() : super();
  CreateRatchetSessionRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateRatchetSessionRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateRatchetSessionRequest clone() => new CreateRatchetSessionRequest()..mergeFromMessage(this);
  CreateRatchetSessionRequest copyWith(void Function(CreateRatchetSessionRequest) updates) => super.copyWith((message) => updates(message as CreateRatchetSessionRequest));
  $pb.BuilderInfo get info_ => _i;
  static CreateRatchetSessionRequest create() => new CreateRatchetSessionRequest();
  CreateRatchetSessionRequest createEmptyInstance() => create();
  static $pb.PbList<CreateRatchetSessionRequest> createRepeated() => new $pb.PbList<CreateRatchetSessionRequest>();
  static CreateRatchetSessionRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CreateRatchetSessionRequest _defaultInstance;

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

class CreateRatchetSessionReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateRatchetSessionReply', package: const $pb.PackageName('data'))
    ..aOS(1, 'sessionID')
    ..aOS(2, 'secret')
    ..aOS(3, 'pubKey')
    ..hasRequiredFields = false
  ;

  CreateRatchetSessionReply() : super();
  CreateRatchetSessionReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateRatchetSessionReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateRatchetSessionReply clone() => new CreateRatchetSessionReply()..mergeFromMessage(this);
  CreateRatchetSessionReply copyWith(void Function(CreateRatchetSessionReply) updates) => super.copyWith((message) => updates(message as CreateRatchetSessionReply));
  $pb.BuilderInfo get info_ => _i;
  static CreateRatchetSessionReply create() => new CreateRatchetSessionReply();
  CreateRatchetSessionReply createEmptyInstance() => create();
  static $pb.PbList<CreateRatchetSessionReply> createRepeated() => new $pb.PbList<CreateRatchetSessionReply>();
  static CreateRatchetSessionReply getDefault() => _defaultInstance ??= create()..freeze();
  static CreateRatchetSessionReply _defaultInstance;

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

class RatchetSessionInfoReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RatchetSessionInfoReply', package: const $pb.PackageName('data'))
    ..aOS(1, 'sessionID')
    ..aOB(2, 'initiated')
    ..aOS(3, 'userInfo')
    ..hasRequiredFields = false
  ;

  RatchetSessionInfoReply() : super();
  RatchetSessionInfoReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RatchetSessionInfoReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RatchetSessionInfoReply clone() => new RatchetSessionInfoReply()..mergeFromMessage(this);
  RatchetSessionInfoReply copyWith(void Function(RatchetSessionInfoReply) updates) => super.copyWith((message) => updates(message as RatchetSessionInfoReply));
  $pb.BuilderInfo get info_ => _i;
  static RatchetSessionInfoReply create() => new RatchetSessionInfoReply();
  RatchetSessionInfoReply createEmptyInstance() => create();
  static $pb.PbList<RatchetSessionInfoReply> createRepeated() => new $pb.PbList<RatchetSessionInfoReply>();
  static RatchetSessionInfoReply getDefault() => _defaultInstance ??= create()..freeze();
  static RatchetSessionInfoReply _defaultInstance;

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

class RatchetSessionSetInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RatchetSessionSetInfoRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'sessionID')
    ..aOS(2, 'userInfo')
    ..hasRequiredFields = false
  ;

  RatchetSessionSetInfoRequest() : super();
  RatchetSessionSetInfoRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RatchetSessionSetInfoRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RatchetSessionSetInfoRequest clone() => new RatchetSessionSetInfoRequest()..mergeFromMessage(this);
  RatchetSessionSetInfoRequest copyWith(void Function(RatchetSessionSetInfoRequest) updates) => super.copyWith((message) => updates(message as RatchetSessionSetInfoRequest));
  $pb.BuilderInfo get info_ => _i;
  static RatchetSessionSetInfoRequest create() => new RatchetSessionSetInfoRequest();
  RatchetSessionSetInfoRequest createEmptyInstance() => create();
  static $pb.PbList<RatchetSessionSetInfoRequest> createRepeated() => new $pb.PbList<RatchetSessionSetInfoRequest>();
  static RatchetSessionSetInfoRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RatchetSessionSetInfoRequest _defaultInstance;

  String get sessionID => $_getS(0, '');
  set sessionID(String v) { $_setString(0, v); }
  bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  String get userInfo => $_getS(1, '');
  set userInfo(String v) { $_setString(1, v); }
  bool hasUserInfo() => $_has(1);
  void clearUserInfo() => clearField(2);
}

class RatchetEncryptRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RatchetEncryptRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'sessionID')
    ..aOS(2, 'message')
    ..hasRequiredFields = false
  ;

  RatchetEncryptRequest() : super();
  RatchetEncryptRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RatchetEncryptRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RatchetEncryptRequest clone() => new RatchetEncryptRequest()..mergeFromMessage(this);
  RatchetEncryptRequest copyWith(void Function(RatchetEncryptRequest) updates) => super.copyWith((message) => updates(message as RatchetEncryptRequest));
  $pb.BuilderInfo get info_ => _i;
  static RatchetEncryptRequest create() => new RatchetEncryptRequest();
  RatchetEncryptRequest createEmptyInstance() => create();
  static $pb.PbList<RatchetEncryptRequest> createRepeated() => new $pb.PbList<RatchetEncryptRequest>();
  static RatchetEncryptRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RatchetEncryptRequest _defaultInstance;

  String get sessionID => $_getS(0, '');
  set sessionID(String v) { $_setString(0, v); }
  bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  String get message => $_getS(1, '');
  set message(String v) { $_setString(1, v); }
  bool hasMessage() => $_has(1);
  void clearMessage() => clearField(2);
}

class RatchetDecryptRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RatchetDecryptRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'sessionID')
    ..aOS(2, 'encryptedMessage')
    ..hasRequiredFields = false
  ;

  RatchetDecryptRequest() : super();
  RatchetDecryptRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RatchetDecryptRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RatchetDecryptRequest clone() => new RatchetDecryptRequest()..mergeFromMessage(this);
  RatchetDecryptRequest copyWith(void Function(RatchetDecryptRequest) updates) => super.copyWith((message) => updates(message as RatchetDecryptRequest));
  $pb.BuilderInfo get info_ => _i;
  static RatchetDecryptRequest create() => new RatchetDecryptRequest();
  RatchetDecryptRequest createEmptyInstance() => create();
  static $pb.PbList<RatchetDecryptRequest> createRepeated() => new $pb.PbList<RatchetDecryptRequest>();
  static RatchetDecryptRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RatchetDecryptRequest _defaultInstance;

  String get sessionID => $_getS(0, '');
  set sessionID(String v) { $_setString(0, v); }
  bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  String get encryptedMessage => $_getS(1, '');
  set encryptedMessage(String v) { $_setString(1, v); }
  bool hasEncryptedMessage() => $_has(1);
  void clearEncryptedMessage() => clearField(2);
}

class BootstrapFilesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('BootstrapFilesRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'workingDir')
    ..pPS(2, 'fullPaths')
    ..hasRequiredFields = false
  ;

  BootstrapFilesRequest() : super();
  BootstrapFilesRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  BootstrapFilesRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  BootstrapFilesRequest clone() => new BootstrapFilesRequest()..mergeFromMessage(this);
  BootstrapFilesRequest copyWith(void Function(BootstrapFilesRequest) updates) => super.copyWith((message) => updates(message as BootstrapFilesRequest));
  $pb.BuilderInfo get info_ => _i;
  static BootstrapFilesRequest create() => new BootstrapFilesRequest();
  BootstrapFilesRequest createEmptyInstance() => create();
  static $pb.PbList<BootstrapFilesRequest> createRepeated() => new $pb.PbList<BootstrapFilesRequest>();
  static BootstrapFilesRequest getDefault() => _defaultInstance ??= create()..freeze();
  static BootstrapFilesRequest _defaultInstance;

  String get workingDir => $_getS(0, '');
  set workingDir(String v) { $_setString(0, v); }
  bool hasWorkingDir() => $_has(0);
  void clearWorkingDir() => clearField(1);

  List<String> get fullPaths => $_getList(1);
}


///
//  Generated code. Do not modify.
//  source: rpc.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

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
  static $pb.PbList<ChainStatus> createRepeated() => new $pb.PbList<ChainStatus>();
  static ChainStatus getDefault() => _defaultInstance ??= create()..freeze();
  static ChainStatus _defaultInstance;
  static void $checkItem(ChainStatus v) {
    if (v is! ChainStatus) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

class Account extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Account', package: const $pb.PackageName('data'))
    ..aOS(1, 'id')
    ..aInt64(2, 'balance')
    ..aInt64(3, 'nonDepositableBalance')
    ..e<Account_AccountStatus>(4, 'status', $pb.PbFieldType.OE, Account_AccountStatus.WAITING_DEPOSIT, Account_AccountStatus.valueOf, Account_AccountStatus.values)
    ..aInt64(5, 'maxAllowedToReceive')
    ..aInt64(6, 'maxAllowedToPay')
    ..aInt64(7, 'maxPaymentAmount')
    ..hasRequiredFields = false
  ;

  Account() : super();
  Account.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Account.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Account clone() => new Account()..mergeFromMessage(this);
  Account copyWith(void Function(Account) updates) => super.copyWith((message) => updates(message as Account));
  $pb.BuilderInfo get info_ => _i;
  static Account create() => new Account();
  static $pb.PbList<Account> createRepeated() => new $pb.PbList<Account>();
  static Account getDefault() => _defaultInstance ??= create()..freeze();
  static Account _defaultInstance;
  static void $checkItem(Account v) {
    if (v is! Account) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get id => $_getS(0, '');
  set id(String v) { $_setString(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  Int64 get balance => $_getI64(1);
  set balance(Int64 v) { $_setInt64(1, v); }
  bool hasBalance() => $_has(1);
  void clearBalance() => clearField(2);

  Int64 get nonDepositableBalance => $_getI64(2);
  set nonDepositableBalance(Int64 v) { $_setInt64(2, v); }
  bool hasNonDepositableBalance() => $_has(2);
  void clearNonDepositableBalance() => clearField(3);

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

class Payment extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Payment', package: const $pb.PackageName('data'))
    ..e<Payment_PaymentType>(1, 'type', $pb.PbFieldType.OE, Payment_PaymentType.DEPOSIT, Payment_PaymentType.valueOf, Payment_PaymentType.values)
    ..aInt64(3, 'amount')
    ..aInt64(4, 'creationTimestamp')
    ..a<InvoiceMemo>(6, 'invoiceMemo', $pb.PbFieldType.OM, InvoiceMemo.getDefault, InvoiceMemo.create)
    ..aOS(7, 'redeemTxID')
    ..aOS(8, 'paymentHash')
    ..aOS(9, 'destination')
    ..hasRequiredFields = false
  ;

  Payment() : super();
  Payment.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Payment.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Payment clone() => new Payment()..mergeFromMessage(this);
  Payment copyWith(void Function(Payment) updates) => super.copyWith((message) => updates(message as Payment));
  $pb.BuilderInfo get info_ => _i;
  static Payment create() => new Payment();
  static $pb.PbList<Payment> createRepeated() => new $pb.PbList<Payment>();
  static Payment getDefault() => _defaultInstance ??= create()..freeze();
  static Payment _defaultInstance;
  static void $checkItem(Payment v) {
    if (v is! Payment) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

class PaymentsList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PaymentsList', package: const $pb.PackageName('data'))
    ..pp<Payment>(1, 'paymentsList', $pb.PbFieldType.PM, Payment.$checkItem, Payment.create)
    ..hasRequiredFields = false
  ;

  PaymentsList() : super();
  PaymentsList.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PaymentsList.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PaymentsList clone() => new PaymentsList()..mergeFromMessage(this);
  PaymentsList copyWith(void Function(PaymentsList) updates) => super.copyWith((message) => updates(message as PaymentsList));
  $pb.BuilderInfo get info_ => _i;
  static PaymentsList create() => new PaymentsList();
  static $pb.PbList<PaymentsList> createRepeated() => new $pb.PbList<PaymentsList>();
  static PaymentsList getDefault() => _defaultInstance ??= create()..freeze();
  static PaymentsList _defaultInstance;
  static void $checkItem(PaymentsList v) {
    if (v is! PaymentsList) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<Payment> get paymentsList => $_getList(0);
}

class SendNonDepositedCoinsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SendNonDepositedCoinsRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'address')
    ..hasRequiredFields = false
  ;

  SendNonDepositedCoinsRequest() : super();
  SendNonDepositedCoinsRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SendNonDepositedCoinsRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SendNonDepositedCoinsRequest clone() => new SendNonDepositedCoinsRequest()..mergeFromMessage(this);
  SendNonDepositedCoinsRequest copyWith(void Function(SendNonDepositedCoinsRequest) updates) => super.copyWith((message) => updates(message as SendNonDepositedCoinsRequest));
  $pb.BuilderInfo get info_ => _i;
  static SendNonDepositedCoinsRequest create() => new SendNonDepositedCoinsRequest();
  static $pb.PbList<SendNonDepositedCoinsRequest> createRepeated() => new $pb.PbList<SendNonDepositedCoinsRequest>();
  static SendNonDepositedCoinsRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SendNonDepositedCoinsRequest _defaultInstance;
  static void $checkItem(SendNonDepositedCoinsRequest v) {
    if (v is! SendNonDepositedCoinsRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get address => $_getS(0, '');
  set address(String v) { $_setString(0, v); }
  bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);
}

class PayInvoiceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PayInvoiceRequest', package: const $pb.PackageName('data'))
    ..aInt64(1, 'amount')
    ..aOS(2, 'paymentRequest')
    ..aOS(3, 'description')
    ..hasRequiredFields = false
  ;

  PayInvoiceRequest() : super();
  PayInvoiceRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PayInvoiceRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PayInvoiceRequest clone() => new PayInvoiceRequest()..mergeFromMessage(this);
  PayInvoiceRequest copyWith(void Function(PayInvoiceRequest) updates) => super.copyWith((message) => updates(message as PayInvoiceRequest));
  $pb.BuilderInfo get info_ => _i;
  static PayInvoiceRequest create() => new PayInvoiceRequest();
  static $pb.PbList<PayInvoiceRequest> createRepeated() => new $pb.PbList<PayInvoiceRequest>();
  static PayInvoiceRequest getDefault() => _defaultInstance ??= create()..freeze();
  static PayInvoiceRequest _defaultInstance;
  static void $checkItem(PayInvoiceRequest v) {
    if (v is! PayInvoiceRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get amount => $_getI64(0);
  set amount(Int64 v) { $_setInt64(0, v); }
  bool hasAmount() => $_has(0);
  void clearAmount() => clearField(1);

  String get paymentRequest => $_getS(1, '');
  set paymentRequest(String v) { $_setString(1, v); }
  bool hasPaymentRequest() => $_has(1);
  void clearPaymentRequest() => clearField(2);

  String get description => $_getS(2, '');
  set description(String v) { $_setString(2, v); }
  bool hasDescription() => $_has(2);
  void clearDescription() => clearField(3);
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
  static $pb.PbList<InvoiceMemo> createRepeated() => new $pb.PbList<InvoiceMemo>();
  static InvoiceMemo getDefault() => _defaultInstance ??= create()..freeze();
  static InvoiceMemo _defaultInstance;
  static void $checkItem(InvoiceMemo v) {
    if (v is! InvoiceMemo) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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
  static $pb.PbList<Invoice> createRepeated() => new $pb.PbList<Invoice>();
  static Invoice getDefault() => _defaultInstance ??= create()..freeze();
  static Invoice _defaultInstance;
  static void $checkItem(Invoice v) {
    if (v is! Invoice) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

class NotificationEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NotificationEvent', package: const $pb.PackageName('data'))
    ..e<NotificationEvent_NotificationType>(1, 'type', $pb.PbFieldType.OE, NotificationEvent_NotificationType.READY, NotificationEvent_NotificationType.valueOf, NotificationEvent_NotificationType.values)
    ..hasRequiredFields = false
  ;

  NotificationEvent() : super();
  NotificationEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NotificationEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NotificationEvent clone() => new NotificationEvent()..mergeFromMessage(this);
  NotificationEvent copyWith(void Function(NotificationEvent) updates) => super.copyWith((message) => updates(message as NotificationEvent));
  $pb.BuilderInfo get info_ => _i;
  static NotificationEvent create() => new NotificationEvent();
  static $pb.PbList<NotificationEvent> createRepeated() => new $pb.PbList<NotificationEvent>();
  static NotificationEvent getDefault() => _defaultInstance ??= create()..freeze();
  static NotificationEvent _defaultInstance;
  static void $checkItem(NotificationEvent v) {
    if (v is! NotificationEvent) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  NotificationEvent_NotificationType get type => $_getN(0);
  set type(NotificationEvent_NotificationType v) { setField(1, v); }
  bool hasType() => $_has(0);
  void clearType() => clearField(1);
}

class AddFundInitReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AddFundInitReply', package: const $pb.PackageName('data'))
    ..aOS(1, 'address')
    ..aInt64(2, 'maxAllowedDeposit')
    ..aOS(3, 'errorMessage')
    ..aOS(4, 'backupJson')
    ..hasRequiredFields = false
  ;

  AddFundInitReply() : super();
  AddFundInitReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundInitReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundInitReply clone() => new AddFundInitReply()..mergeFromMessage(this);
  AddFundInitReply copyWith(void Function(AddFundInitReply) updates) => super.copyWith((message) => updates(message as AddFundInitReply));
  $pb.BuilderInfo get info_ => _i;
  static AddFundInitReply create() => new AddFundInitReply();
  static $pb.PbList<AddFundInitReply> createRepeated() => new $pb.PbList<AddFundInitReply>();
  static AddFundInitReply getDefault() => _defaultInstance ??= create()..freeze();
  static AddFundInitReply _defaultInstance;
  static void $checkItem(AddFundInitReply v) {
    if (v is! AddFundInitReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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
  static $pb.PbList<AddFundReply> createRepeated() => new $pb.PbList<AddFundReply>();
  static AddFundReply getDefault() => _defaultInstance ??= create()..freeze();
  static AddFundReply _defaultInstance;
  static void $checkItem(AddFundReply v) {
    if (v is! AddFundReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

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
  static $pb.PbList<RefundRequest> createRepeated() => new $pb.PbList<RefundRequest>();
  static RefundRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RefundRequest _defaultInstance;
  static void $checkItem(RefundRequest v) {
    if (v is! RefundRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

class FundStatusReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FundStatusReply', package: const $pb.PackageName('data'))
    ..e<FundStatusReply_FundStatus>(1, 'status', $pb.PbFieldType.OE, FundStatusReply_FundStatus.NO_FUND, FundStatusReply_FundStatus.valueOf, FundStatusReply_FundStatus.values)
    ..hasRequiredFields = false
  ;

  FundStatusReply() : super();
  FundStatusReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FundStatusReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FundStatusReply clone() => new FundStatusReply()..mergeFromMessage(this);
  FundStatusReply copyWith(void Function(FundStatusReply) updates) => super.copyWith((message) => updates(message as FundStatusReply));
  $pb.BuilderInfo get info_ => _i;
  static FundStatusReply create() => new FundStatusReply();
  static $pb.PbList<FundStatusReply> createRepeated() => new $pb.PbList<FundStatusReply>();
  static FundStatusReply getDefault() => _defaultInstance ??= create()..freeze();
  static FundStatusReply _defaultInstance;
  static void $checkItem(FundStatusReply v) {
    if (v is! FundStatusReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  FundStatusReply_FundStatus get status => $_getN(0);
  set status(FundStatusReply_FundStatus v) { setField(1, v); }
  bool hasStatus() => $_has(0);
  void clearStatus() => clearField(1);
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
  static $pb.PbList<RemoveFundRequest> createRepeated() => new $pb.PbList<RemoveFundRequest>();
  static RemoveFundRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RemoveFundRequest _defaultInstance;
  static void $checkItem(RemoveFundRequest v) {
    if (v is! RemoveFundRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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
  static $pb.PbList<RemoveFundReply> createRepeated() => new $pb.PbList<RemoveFundReply>();
  static RemoveFundReply getDefault() => _defaultInstance ??= create()..freeze();
  static RemoveFundReply _defaultInstance;
  static void $checkItem(RemoveFundReply v) {
    if (v is! RemoveFundReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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
  static $pb.PbList<SwapAddressInfo> createRepeated() => new $pb.PbList<SwapAddressInfo>();
  static SwapAddressInfo getDefault() => _defaultInstance ??= create()..freeze();
  static SwapAddressInfo _defaultInstance;
  static void $checkItem(SwapAddressInfo v) {
    if (v is! SwapAddressInfo) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

class SwapAddressList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SwapAddressList', package: const $pb.PackageName('data'))
    ..pp<SwapAddressInfo>(1, 'addresses', $pb.PbFieldType.PM, SwapAddressInfo.$checkItem, SwapAddressInfo.create)
    ..hasRequiredFields = false
  ;

  SwapAddressList() : super();
  SwapAddressList.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SwapAddressList.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SwapAddressList clone() => new SwapAddressList()..mergeFromMessage(this);
  SwapAddressList copyWith(void Function(SwapAddressList) updates) => super.copyWith((message) => updates(message as SwapAddressList));
  $pb.BuilderInfo get info_ => _i;
  static SwapAddressList create() => new SwapAddressList();
  static $pb.PbList<SwapAddressList> createRepeated() => new $pb.PbList<SwapAddressList>();
  static SwapAddressList getDefault() => _defaultInstance ??= create()..freeze();
  static SwapAddressList _defaultInstance;
  static void $checkItem(SwapAddressList v) {
    if (v is! SwapAddressList) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<SwapAddressInfo> get addresses => $_getList(0);
}


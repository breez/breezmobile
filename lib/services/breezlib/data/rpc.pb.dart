///
//  Generated code. Do not modify.
//  source: rpc.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'rpc.pbenum.dart';

export 'rpc.pbenum.dart';

class ChainStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ChainStatus', package: const $pb.PackageName('data'))
    ..a<$core.int>(1, 'blockHeight', $pb.PbFieldType.OU3)
    ..aOB(2, 'syncedToChain')
    ..hasRequiredFields = false
  ;

  ChainStatus() : super();
  ChainStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ChainStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ChainStatus clone() => ChainStatus()..mergeFromMessage(this);
  ChainStatus copyWith(void Function(ChainStatus) updates) => super.copyWith((message) => updates(message as ChainStatus));
  $pb.BuilderInfo get info_ => _i;
  static ChainStatus create() => ChainStatus();
  ChainStatus createEmptyInstance() => create();
  static $pb.PbList<ChainStatus> createRepeated() => $pb.PbList<ChainStatus>();
  static ChainStatus getDefault() => _defaultInstance ??= create()..freeze();
  static ChainStatus _defaultInstance;

  $core.int get blockHeight => $_get(0, 0);
  set blockHeight($core.int v) { $_setUnsignedInt32(0, v); }
  $core.bool hasBlockHeight() => $_has(0);
  void clearBlockHeight() => clearField(1);

  $core.bool get syncedToChain => $_get(1, false);
  set syncedToChain($core.bool v) { $_setBool(1, v); }
  $core.bool hasSyncedToChain() => $_has(1);
  void clearSyncedToChain() => clearField(2);
}

class Account extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Account', package: const $pb.PackageName('data'))
    ..aOS(1, 'id')
    ..aInt64(2, 'balance')
    ..aInt64(3, 'walletBalance')
    ..e<Account_AccountStatus>(4, 'status', $pb.PbFieldType.OE, Account_AccountStatus.DISCONNECTED, Account_AccountStatus.valueOf, Account_AccountStatus.values)
    ..aInt64(5, 'maxAllowedToReceive')
    ..aInt64(6, 'maxAllowedToPay')
    ..aInt64(7, 'maxPaymentAmount')
    ..aInt64(8, 'routingNodeFee')
    ..aOB(9, 'enabled')
    ..aInt64(10, 'maxChanReserve')
    ..aOB(11, 'readyForPayments')
    ..aOS(12, 'channelPoint')
    ..hasRequiredFields = false
  ;

  Account() : super();
  Account.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Account.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Account clone() => Account()..mergeFromMessage(this);
  Account copyWith(void Function(Account) updates) => super.copyWith((message) => updates(message as Account));
  $pb.BuilderInfo get info_ => _i;
  static Account create() => Account();
  Account createEmptyInstance() => create();
  static $pb.PbList<Account> createRepeated() => $pb.PbList<Account>();
  static Account getDefault() => _defaultInstance ??= create()..freeze();
  static Account _defaultInstance;

  $core.String get id => $_getS(0, '');
  set id($core.String v) { $_setString(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  Int64 get balance => $_getI64(1);
  set balance(Int64 v) { $_setInt64(1, v); }
  $core.bool hasBalance() => $_has(1);
  void clearBalance() => clearField(2);

  Int64 get walletBalance => $_getI64(2);
  set walletBalance(Int64 v) { $_setInt64(2, v); }
  $core.bool hasWalletBalance() => $_has(2);
  void clearWalletBalance() => clearField(3);

  Account_AccountStatus get status => $_getN(3);
  set status(Account_AccountStatus v) { setField(4, v); }
  $core.bool hasStatus() => $_has(3);
  void clearStatus() => clearField(4);

  Int64 get maxAllowedToReceive => $_getI64(4);
  set maxAllowedToReceive(Int64 v) { $_setInt64(4, v); }
  $core.bool hasMaxAllowedToReceive() => $_has(4);
  void clearMaxAllowedToReceive() => clearField(5);

  Int64 get maxAllowedToPay => $_getI64(5);
  set maxAllowedToPay(Int64 v) { $_setInt64(5, v); }
  $core.bool hasMaxAllowedToPay() => $_has(5);
  void clearMaxAllowedToPay() => clearField(6);

  Int64 get maxPaymentAmount => $_getI64(6);
  set maxPaymentAmount(Int64 v) { $_setInt64(6, v); }
  $core.bool hasMaxPaymentAmount() => $_has(6);
  void clearMaxPaymentAmount() => clearField(7);

  Int64 get routingNodeFee => $_getI64(7);
  set routingNodeFee(Int64 v) { $_setInt64(7, v); }
  $core.bool hasRoutingNodeFee() => $_has(7);
  void clearRoutingNodeFee() => clearField(8);

  $core.bool get enabled => $_get(8, false);
  set enabled($core.bool v) { $_setBool(8, v); }
  $core.bool hasEnabled() => $_has(8);
  void clearEnabled() => clearField(9);

  Int64 get maxChanReserve => $_getI64(9);
  set maxChanReserve(Int64 v) { $_setInt64(9, v); }
  $core.bool hasMaxChanReserve() => $_has(9);
  void clearMaxChanReserve() => clearField(10);

  $core.bool get readyForPayments => $_get(10, false);
  set readyForPayments($core.bool v) { $_setBool(10, v); }
  $core.bool hasReadyForPayments() => $_has(10);
  void clearReadyForPayments() => clearField(11);

  $core.String get channelPoint => $_getS(11, '');
  set channelPoint($core.String v) { $_setString(11, v); }
  $core.bool hasChannelPoint() => $_has(11);
  void clearChannelPoint() => clearField(12);
}

class Payment extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Payment', package: const $pb.PackageName('data'))
    ..e<Payment_PaymentType>(1, 'type', $pb.PbFieldType.OE, Payment_PaymentType.DEPOSIT, Payment_PaymentType.valueOf, Payment_PaymentType.values)
    ..aInt64(3, 'amount')
    ..aInt64(4, 'creationTimestamp')
    ..a<InvoiceMemo>(6, 'invoiceMemo', $pb.PbFieldType.OM, InvoiceMemo.getDefault, InvoiceMemo.create)
    ..aOS(7, 'redeemTxID')
    ..aOS(8, 'paymentHash')
    ..aOS(9, 'destination')
    ..a<$core.int>(10, 'pendingExpirationHeight', $pb.PbFieldType.OU3)
    ..aInt64(11, 'pendingExpirationTimestamp')
    ..aInt64(12, 'fee')
    ..aOS(13, 'preimage')
    ..hasRequiredFields = false
  ;

  Payment() : super();
  Payment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Payment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Payment clone() => Payment()..mergeFromMessage(this);
  Payment copyWith(void Function(Payment) updates) => super.copyWith((message) => updates(message as Payment));
  $pb.BuilderInfo get info_ => _i;
  static Payment create() => Payment();
  Payment createEmptyInstance() => create();
  static $pb.PbList<Payment> createRepeated() => $pb.PbList<Payment>();
  static Payment getDefault() => _defaultInstance ??= create()..freeze();
  static Payment _defaultInstance;

  Payment_PaymentType get type => $_getN(0);
  set type(Payment_PaymentType v) { setField(1, v); }
  $core.bool hasType() => $_has(0);
  void clearType() => clearField(1);

  Int64 get amount => $_getI64(1);
  set amount(Int64 v) { $_setInt64(1, v); }
  $core.bool hasAmount() => $_has(1);
  void clearAmount() => clearField(3);

  Int64 get creationTimestamp => $_getI64(2);
  set creationTimestamp(Int64 v) { $_setInt64(2, v); }
  $core.bool hasCreationTimestamp() => $_has(2);
  void clearCreationTimestamp() => clearField(4);

  InvoiceMemo get invoiceMemo => $_getN(3);
  set invoiceMemo(InvoiceMemo v) { setField(6, v); }
  $core.bool hasInvoiceMemo() => $_has(3);
  void clearInvoiceMemo() => clearField(6);

  $core.String get redeemTxID => $_getS(4, '');
  set redeemTxID($core.String v) { $_setString(4, v); }
  $core.bool hasRedeemTxID() => $_has(4);
  void clearRedeemTxID() => clearField(7);

  $core.String get paymentHash => $_getS(5, '');
  set paymentHash($core.String v) { $_setString(5, v); }
  $core.bool hasPaymentHash() => $_has(5);
  void clearPaymentHash() => clearField(8);

  $core.String get destination => $_getS(6, '');
  set destination($core.String v) { $_setString(6, v); }
  $core.bool hasDestination() => $_has(6);
  void clearDestination() => clearField(9);

  $core.int get pendingExpirationHeight => $_get(7, 0);
  set pendingExpirationHeight($core.int v) { $_setUnsignedInt32(7, v); }
  $core.bool hasPendingExpirationHeight() => $_has(7);
  void clearPendingExpirationHeight() => clearField(10);

  Int64 get pendingExpirationTimestamp => $_getI64(8);
  set pendingExpirationTimestamp(Int64 v) { $_setInt64(8, v); }
  $core.bool hasPendingExpirationTimestamp() => $_has(8);
  void clearPendingExpirationTimestamp() => clearField(11);

  Int64 get fee => $_getI64(9);
  set fee(Int64 v) { $_setInt64(9, v); }
  $core.bool hasFee() => $_has(9);
  void clearFee() => clearField(12);

  $core.String get preimage => $_getS(10, '');
  set preimage($core.String v) { $_setString(10, v); }
  $core.bool hasPreimage() => $_has(10);
  void clearPreimage() => clearField(13);
}

class PaymentsList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PaymentsList', package: const $pb.PackageName('data'))
    ..pc<Payment>(1, 'paymentsList', $pb.PbFieldType.PM,Payment.create)
    ..hasRequiredFields = false
  ;

  PaymentsList() : super();
  PaymentsList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PaymentsList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PaymentsList clone() => PaymentsList()..mergeFromMessage(this);
  PaymentsList copyWith(void Function(PaymentsList) updates) => super.copyWith((message) => updates(message as PaymentsList));
  $pb.BuilderInfo get info_ => _i;
  static PaymentsList create() => PaymentsList();
  PaymentsList createEmptyInstance() => create();
  static $pb.PbList<PaymentsList> createRepeated() => $pb.PbList<PaymentsList>();
  static PaymentsList getDefault() => _defaultInstance ??= create()..freeze();
  static PaymentsList _defaultInstance;

  $core.List<Payment> get paymentsList => $_getList(0);
}

class PaymentResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PaymentResponse', package: const $pb.PackageName('data'))
    ..aOS(1, 'paymentError')
    ..aOS(2, 'traceReport')
    ..hasRequiredFields = false
  ;

  PaymentResponse() : super();
  PaymentResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PaymentResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PaymentResponse clone() => PaymentResponse()..mergeFromMessage(this);
  PaymentResponse copyWith(void Function(PaymentResponse) updates) => super.copyWith((message) => updates(message as PaymentResponse));
  $pb.BuilderInfo get info_ => _i;
  static PaymentResponse create() => PaymentResponse();
  PaymentResponse createEmptyInstance() => create();
  static $pb.PbList<PaymentResponse> createRepeated() => $pb.PbList<PaymentResponse>();
  static PaymentResponse getDefault() => _defaultInstance ??= create()..freeze();
  static PaymentResponse _defaultInstance;

  $core.String get paymentError => $_getS(0, '');
  set paymentError($core.String v) { $_setString(0, v); }
  $core.bool hasPaymentError() => $_has(0);
  void clearPaymentError() => clearField(1);

  $core.String get traceReport => $_getS(1, '');
  set traceReport($core.String v) { $_setString(1, v); }
  $core.bool hasTraceReport() => $_has(1);
  void clearTraceReport() => clearField(2);
}

class SendWalletCoinsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SendWalletCoinsRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'address')
    ..aInt64(2, 'satPerByteFee')
    ..hasRequiredFields = false
  ;

  SendWalletCoinsRequest() : super();
  SendWalletCoinsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SendWalletCoinsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SendWalletCoinsRequest clone() => SendWalletCoinsRequest()..mergeFromMessage(this);
  SendWalletCoinsRequest copyWith(void Function(SendWalletCoinsRequest) updates) => super.copyWith((message) => updates(message as SendWalletCoinsRequest));
  $pb.BuilderInfo get info_ => _i;
  static SendWalletCoinsRequest create() => SendWalletCoinsRequest();
  SendWalletCoinsRequest createEmptyInstance() => create();
  static $pb.PbList<SendWalletCoinsRequest> createRepeated() => $pb.PbList<SendWalletCoinsRequest>();
  static SendWalletCoinsRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SendWalletCoinsRequest _defaultInstance;

  $core.String get address => $_getS(0, '');
  set address($core.String v) { $_setString(0, v); }
  $core.bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  Int64 get satPerByteFee => $_getI64(1);
  set satPerByteFee(Int64 v) { $_setInt64(1, v); }
  $core.bool hasSatPerByteFee() => $_has(1);
  void clearSatPerByteFee() => clearField(2);
}

class PayInvoiceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PayInvoiceRequest', package: const $pb.PackageName('data'))
    ..aInt64(1, 'amount')
    ..aOS(2, 'paymentRequest')
    ..hasRequiredFields = false
  ;

  PayInvoiceRequest() : super();
  PayInvoiceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PayInvoiceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PayInvoiceRequest clone() => PayInvoiceRequest()..mergeFromMessage(this);
  PayInvoiceRequest copyWith(void Function(PayInvoiceRequest) updates) => super.copyWith((message) => updates(message as PayInvoiceRequest));
  $pb.BuilderInfo get info_ => _i;
  static PayInvoiceRequest create() => PayInvoiceRequest();
  PayInvoiceRequest createEmptyInstance() => create();
  static $pb.PbList<PayInvoiceRequest> createRepeated() => $pb.PbList<PayInvoiceRequest>();
  static PayInvoiceRequest getDefault() => _defaultInstance ??= create()..freeze();
  static PayInvoiceRequest _defaultInstance;

  Int64 get amount => $_getI64(0);
  set amount(Int64 v) { $_setInt64(0, v); }
  $core.bool hasAmount() => $_has(0);
  void clearAmount() => clearField(1);

  $core.String get paymentRequest => $_getS(1, '');
  set paymentRequest($core.String v) { $_setString(1, v); }
  $core.bool hasPaymentRequest() => $_has(1);
  void clearPaymentRequest() => clearField(2);
}

class InvoiceMemo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('InvoiceMemo', package: const $pb.PackageName('data'))
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
  InvoiceMemo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  InvoiceMemo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  InvoiceMemo clone() => InvoiceMemo()..mergeFromMessage(this);
  InvoiceMemo copyWith(void Function(InvoiceMemo) updates) => super.copyWith((message) => updates(message as InvoiceMemo));
  $pb.BuilderInfo get info_ => _i;
  static InvoiceMemo create() => InvoiceMemo();
  InvoiceMemo createEmptyInstance() => create();
  static $pb.PbList<InvoiceMemo> createRepeated() => $pb.PbList<InvoiceMemo>();
  static InvoiceMemo getDefault() => _defaultInstance ??= create()..freeze();
  static InvoiceMemo _defaultInstance;

  $core.String get description => $_getS(0, '');
  set description($core.String v) { $_setString(0, v); }
  $core.bool hasDescription() => $_has(0);
  void clearDescription() => clearField(1);

  Int64 get amount => $_getI64(1);
  set amount(Int64 v) { $_setInt64(1, v); }
  $core.bool hasAmount() => $_has(1);
  void clearAmount() => clearField(2);

  $core.String get payeeName => $_getS(2, '');
  set payeeName($core.String v) { $_setString(2, v); }
  $core.bool hasPayeeName() => $_has(2);
  void clearPayeeName() => clearField(3);

  $core.String get payeeImageURL => $_getS(3, '');
  set payeeImageURL($core.String v) { $_setString(3, v); }
  $core.bool hasPayeeImageURL() => $_has(3);
  void clearPayeeImageURL() => clearField(4);

  $core.String get payerName => $_getS(4, '');
  set payerName($core.String v) { $_setString(4, v); }
  $core.bool hasPayerName() => $_has(4);
  void clearPayerName() => clearField(5);

  $core.String get payerImageURL => $_getS(5, '');
  set payerImageURL($core.String v) { $_setString(5, v); }
  $core.bool hasPayerImageURL() => $_has(5);
  void clearPayerImageURL() => clearField(6);

  $core.bool get transferRequest => $_get(6, false);
  set transferRequest($core.bool v) { $_setBool(6, v); }
  $core.bool hasTransferRequest() => $_has(6);
  void clearTransferRequest() => clearField(7);

  Int64 get expiry => $_getI64(7);
  set expiry(Int64 v) { $_setInt64(7, v); }
  $core.bool hasExpiry() => $_has(7);
  void clearExpiry() => clearField(8);
}

class Invoice extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Invoice', package: const $pb.PackageName('data'))
    ..a<InvoiceMemo>(1, 'memo', $pb.PbFieldType.OM, InvoiceMemo.getDefault, InvoiceMemo.create)
    ..aOB(2, 'settled')
    ..aInt64(3, 'amtPaid')
    ..hasRequiredFields = false
  ;

  Invoice() : super();
  Invoice.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Invoice.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Invoice clone() => Invoice()..mergeFromMessage(this);
  Invoice copyWith(void Function(Invoice) updates) => super.copyWith((message) => updates(message as Invoice));
  $pb.BuilderInfo get info_ => _i;
  static Invoice create() => Invoice();
  Invoice createEmptyInstance() => create();
  static $pb.PbList<Invoice> createRepeated() => $pb.PbList<Invoice>();
  static Invoice getDefault() => _defaultInstance ??= create()..freeze();
  static Invoice _defaultInstance;

  InvoiceMemo get memo => $_getN(0);
  set memo(InvoiceMemo v) { setField(1, v); }
  $core.bool hasMemo() => $_has(0);
  void clearMemo() => clearField(1);

  $core.bool get settled => $_get(1, false);
  set settled($core.bool v) { $_setBool(1, v); }
  $core.bool hasSettled() => $_has(1);
  void clearSettled() => clearField(2);

  Int64 get amtPaid => $_getI64(2);
  set amtPaid(Int64 v) { $_setInt64(2, v); }
  $core.bool hasAmtPaid() => $_has(2);
  void clearAmtPaid() => clearField(3);
}

class NotificationEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('NotificationEvent', package: const $pb.PackageName('data'))
    ..e<NotificationEvent_NotificationType>(1, 'type', $pb.PbFieldType.OE, NotificationEvent_NotificationType.READY, NotificationEvent_NotificationType.valueOf, NotificationEvent_NotificationType.values)
    ..pPS(2, 'data')
    ..hasRequiredFields = false
  ;

  NotificationEvent() : super();
  NotificationEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NotificationEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NotificationEvent clone() => NotificationEvent()..mergeFromMessage(this);
  NotificationEvent copyWith(void Function(NotificationEvent) updates) => super.copyWith((message) => updates(message as NotificationEvent));
  $pb.BuilderInfo get info_ => _i;
  static NotificationEvent create() => NotificationEvent();
  NotificationEvent createEmptyInstance() => create();
  static $pb.PbList<NotificationEvent> createRepeated() => $pb.PbList<NotificationEvent>();
  static NotificationEvent getDefault() => _defaultInstance ??= create()..freeze();
  static NotificationEvent _defaultInstance;

  NotificationEvent_NotificationType get type => $_getN(0);
  set type(NotificationEvent_NotificationType v) { setField(1, v); }
  $core.bool hasType() => $_has(0);
  void clearType() => clearField(1);

  $core.List<$core.String> get data => $_getList(1);
}

class AddFundInitReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AddFundInitReply', package: const $pb.PackageName('data'))
    ..aOS(1, 'address')
    ..aInt64(2, 'maxAllowedDeposit')
    ..aOS(3, 'errorMessage')
    ..aOS(4, 'backupJson')
    ..aInt64(5, 'requiredReserve')
    ..hasRequiredFields = false
  ;

  AddFundInitReply() : super();
  AddFundInitReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundInitReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundInitReply clone() => AddFundInitReply()..mergeFromMessage(this);
  AddFundInitReply copyWith(void Function(AddFundInitReply) updates) => super.copyWith((message) => updates(message as AddFundInitReply));
  $pb.BuilderInfo get info_ => _i;
  static AddFundInitReply create() => AddFundInitReply();
  AddFundInitReply createEmptyInstance() => create();
  static $pb.PbList<AddFundInitReply> createRepeated() => $pb.PbList<AddFundInitReply>();
  static AddFundInitReply getDefault() => _defaultInstance ??= create()..freeze();
  static AddFundInitReply _defaultInstance;

  $core.String get address => $_getS(0, '');
  set address($core.String v) { $_setString(0, v); }
  $core.bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  Int64 get maxAllowedDeposit => $_getI64(1);
  set maxAllowedDeposit(Int64 v) { $_setInt64(1, v); }
  $core.bool hasMaxAllowedDeposit() => $_has(1);
  void clearMaxAllowedDeposit() => clearField(2);

  $core.String get errorMessage => $_getS(2, '');
  set errorMessage($core.String v) { $_setString(2, v); }
  $core.bool hasErrorMessage() => $_has(2);
  void clearErrorMessage() => clearField(3);

  $core.String get backupJson => $_getS(3, '');
  set backupJson($core.String v) { $_setString(3, v); }
  $core.bool hasBackupJson() => $_has(3);
  void clearBackupJson() => clearField(4);

  Int64 get requiredReserve => $_getI64(4);
  set requiredReserve(Int64 v) { $_setInt64(4, v); }
  $core.bool hasRequiredReserve() => $_has(4);
  void clearRequiredReserve() => clearField(5);
}

class AddFundReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AddFundReply', package: const $pb.PackageName('data'))
    ..aOS(1, 'errorMessage')
    ..hasRequiredFields = false
  ;

  AddFundReply() : super();
  AddFundReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundReply clone() => AddFundReply()..mergeFromMessage(this);
  AddFundReply copyWith(void Function(AddFundReply) updates) => super.copyWith((message) => updates(message as AddFundReply));
  $pb.BuilderInfo get info_ => _i;
  static AddFundReply create() => AddFundReply();
  AddFundReply createEmptyInstance() => create();
  static $pb.PbList<AddFundReply> createRepeated() => $pb.PbList<AddFundReply>();
  static AddFundReply getDefault() => _defaultInstance ??= create()..freeze();
  static AddFundReply _defaultInstance;

  $core.String get errorMessage => $_getS(0, '');
  set errorMessage($core.String v) { $_setString(0, v); }
  $core.bool hasErrorMessage() => $_has(0);
  void clearErrorMessage() => clearField(1);
}

class RefundRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RefundRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'address')
    ..aOS(2, 'refundAddress')
    ..a<$core.int>(3, 'targetConf', $pb.PbFieldType.O3)
    ..aInt64(4, 'satPerByte')
    ..hasRequiredFields = false
  ;

  RefundRequest() : super();
  RefundRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RefundRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RefundRequest clone() => RefundRequest()..mergeFromMessage(this);
  RefundRequest copyWith(void Function(RefundRequest) updates) => super.copyWith((message) => updates(message as RefundRequest));
  $pb.BuilderInfo get info_ => _i;
  static RefundRequest create() => RefundRequest();
  RefundRequest createEmptyInstance() => create();
  static $pb.PbList<RefundRequest> createRepeated() => $pb.PbList<RefundRequest>();
  static RefundRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RefundRequest _defaultInstance;

  $core.String get address => $_getS(0, '');
  set address($core.String v) { $_setString(0, v); }
  $core.bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  $core.String get refundAddress => $_getS(1, '');
  set refundAddress($core.String v) { $_setString(1, v); }
  $core.bool hasRefundAddress() => $_has(1);
  void clearRefundAddress() => clearField(2);

  $core.int get targetConf => $_get(2, 0);
  set targetConf($core.int v) { $_setSignedInt32(2, v); }
  $core.bool hasTargetConf() => $_has(2);
  void clearTargetConf() => clearField(3);

  Int64 get satPerByte => $_getI64(3);
  set satPerByte(Int64 v) { $_setInt64(3, v); }
  $core.bool hasSatPerByte() => $_has(3);
  void clearSatPerByte() => clearField(4);
}

class AddFundError extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AddFundError', package: const $pb.PackageName('data'))
    ..a<SwapAddressInfo>(1, 'swapAddressInfo', $pb.PbFieldType.OM, SwapAddressInfo.getDefault, SwapAddressInfo.create)
    ..a<$core.double>(2, 'hoursToUnlock', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  AddFundError() : super();
  AddFundError.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundError.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundError clone() => AddFundError()..mergeFromMessage(this);
  AddFundError copyWith(void Function(AddFundError) updates) => super.copyWith((message) => updates(message as AddFundError));
  $pb.BuilderInfo get info_ => _i;
  static AddFundError create() => AddFundError();
  AddFundError createEmptyInstance() => create();
  static $pb.PbList<AddFundError> createRepeated() => $pb.PbList<AddFundError>();
  static AddFundError getDefault() => _defaultInstance ??= create()..freeze();
  static AddFundError _defaultInstance;

  SwapAddressInfo get swapAddressInfo => $_getN(0);
  set swapAddressInfo(SwapAddressInfo v) { setField(1, v); }
  $core.bool hasSwapAddressInfo() => $_has(0);
  void clearSwapAddressInfo() => clearField(1);

  $core.double get hoursToUnlock => $_getN(1);
  set hoursToUnlock($core.double v) { $_setFloat(1, v); }
  $core.bool hasHoursToUnlock() => $_has(1);
  void clearHoursToUnlock() => clearField(2);
}

class FundStatusReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FundStatusReply', package: const $pb.PackageName('data'))
    ..pc<SwapAddressInfo>(1, 'unConfirmedAddresses', $pb.PbFieldType.PM,SwapAddressInfo.create)
    ..pc<SwapAddressInfo>(2, 'confirmedAddresses', $pb.PbFieldType.PM,SwapAddressInfo.create)
    ..pc<SwapAddressInfo>(3, 'refundableAddresses', $pb.PbFieldType.PM,SwapAddressInfo.create)
    ..hasRequiredFields = false
  ;

  FundStatusReply() : super();
  FundStatusReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FundStatusReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FundStatusReply clone() => FundStatusReply()..mergeFromMessage(this);
  FundStatusReply copyWith(void Function(FundStatusReply) updates) => super.copyWith((message) => updates(message as FundStatusReply));
  $pb.BuilderInfo get info_ => _i;
  static FundStatusReply create() => FundStatusReply();
  FundStatusReply createEmptyInstance() => create();
  static $pb.PbList<FundStatusReply> createRepeated() => $pb.PbList<FundStatusReply>();
  static FundStatusReply getDefault() => _defaultInstance ??= create()..freeze();
  static FundStatusReply _defaultInstance;

  $core.List<SwapAddressInfo> get unConfirmedAddresses => $_getList(0);

  $core.List<SwapAddressInfo> get confirmedAddresses => $_getList(1);

  $core.List<SwapAddressInfo> get refundableAddresses => $_getList(2);
}

class RemoveFundRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RemoveFundRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'address')
    ..aInt64(2, 'amount')
    ..hasRequiredFields = false
  ;

  RemoveFundRequest() : super();
  RemoveFundRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RemoveFundRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RemoveFundRequest clone() => RemoveFundRequest()..mergeFromMessage(this);
  RemoveFundRequest copyWith(void Function(RemoveFundRequest) updates) => super.copyWith((message) => updates(message as RemoveFundRequest));
  $pb.BuilderInfo get info_ => _i;
  static RemoveFundRequest create() => RemoveFundRequest();
  RemoveFundRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveFundRequest> createRepeated() => $pb.PbList<RemoveFundRequest>();
  static RemoveFundRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RemoveFundRequest _defaultInstance;

  $core.String get address => $_getS(0, '');
  set address($core.String v) { $_setString(0, v); }
  $core.bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  Int64 get amount => $_getI64(1);
  set amount(Int64 v) { $_setInt64(1, v); }
  $core.bool hasAmount() => $_has(1);
  void clearAmount() => clearField(2);
}

class RemoveFundReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RemoveFundReply', package: const $pb.PackageName('data'))
    ..aOS(1, 'txid')
    ..aOS(2, 'errorMessage')
    ..hasRequiredFields = false
  ;

  RemoveFundReply() : super();
  RemoveFundReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RemoveFundReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RemoveFundReply clone() => RemoveFundReply()..mergeFromMessage(this);
  RemoveFundReply copyWith(void Function(RemoveFundReply) updates) => super.copyWith((message) => updates(message as RemoveFundReply));
  $pb.BuilderInfo get info_ => _i;
  static RemoveFundReply create() => RemoveFundReply();
  RemoveFundReply createEmptyInstance() => create();
  static $pb.PbList<RemoveFundReply> createRepeated() => $pb.PbList<RemoveFundReply>();
  static RemoveFundReply getDefault() => _defaultInstance ??= create()..freeze();
  static RemoveFundReply _defaultInstance;

  $core.String get txid => $_getS(0, '');
  set txid($core.String v) { $_setString(0, v); }
  $core.bool hasTxid() => $_has(0);
  void clearTxid() => clearField(1);

  $core.String get errorMessage => $_getS(1, '');
  set errorMessage($core.String v) { $_setString(1, v); }
  $core.bool hasErrorMessage() => $_has(1);
  void clearErrorMessage() => clearField(2);
}

class SwapAddressInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SwapAddressInfo', package: const $pb.PackageName('data'))
    ..aOS(1, 'address')
    ..aOS(2, 'paymentHash')
    ..aInt64(3, 'confirmedAmount')
    ..pPS(4, 'confirmedTransactionIds')
    ..aInt64(5, 'paidAmount')
    ..a<$core.int>(6, 'lockHeight', $pb.PbFieldType.OU3)
    ..aOS(7, 'errorMessage')
    ..aOS(8, 'lastRefundTxID')
    ..e<SwapError>(9, 'swapError', $pb.PbFieldType.OE, SwapError.NO_ERROR, SwapError.valueOf, SwapError.values)
    ..aOS(10, 'fundingTxID')
    ..a<$core.double>(11, 'hoursToUnlock', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  SwapAddressInfo() : super();
  SwapAddressInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SwapAddressInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SwapAddressInfo clone() => SwapAddressInfo()..mergeFromMessage(this);
  SwapAddressInfo copyWith(void Function(SwapAddressInfo) updates) => super.copyWith((message) => updates(message as SwapAddressInfo));
  $pb.BuilderInfo get info_ => _i;
  static SwapAddressInfo create() => SwapAddressInfo();
  SwapAddressInfo createEmptyInstance() => create();
  static $pb.PbList<SwapAddressInfo> createRepeated() => $pb.PbList<SwapAddressInfo>();
  static SwapAddressInfo getDefault() => _defaultInstance ??= create()..freeze();
  static SwapAddressInfo _defaultInstance;

  $core.String get address => $_getS(0, '');
  set address($core.String v) { $_setString(0, v); }
  $core.bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  $core.String get paymentHash => $_getS(1, '');
  set paymentHash($core.String v) { $_setString(1, v); }
  $core.bool hasPaymentHash() => $_has(1);
  void clearPaymentHash() => clearField(2);

  Int64 get confirmedAmount => $_getI64(2);
  set confirmedAmount(Int64 v) { $_setInt64(2, v); }
  $core.bool hasConfirmedAmount() => $_has(2);
  void clearConfirmedAmount() => clearField(3);

  $core.List<$core.String> get confirmedTransactionIds => $_getList(3);

  Int64 get paidAmount => $_getI64(4);
  set paidAmount(Int64 v) { $_setInt64(4, v); }
  $core.bool hasPaidAmount() => $_has(4);
  void clearPaidAmount() => clearField(5);

  $core.int get lockHeight => $_get(5, 0);
  set lockHeight($core.int v) { $_setUnsignedInt32(5, v); }
  $core.bool hasLockHeight() => $_has(5);
  void clearLockHeight() => clearField(6);

  $core.String get errorMessage => $_getS(6, '');
  set errorMessage($core.String v) { $_setString(6, v); }
  $core.bool hasErrorMessage() => $_has(6);
  void clearErrorMessage() => clearField(7);

  $core.String get lastRefundTxID => $_getS(7, '');
  set lastRefundTxID($core.String v) { $_setString(7, v); }
  $core.bool hasLastRefundTxID() => $_has(7);
  void clearLastRefundTxID() => clearField(8);

  SwapError get swapError => $_getN(8);
  set swapError(SwapError v) { setField(9, v); }
  $core.bool hasSwapError() => $_has(8);
  void clearSwapError() => clearField(9);

  $core.String get fundingTxID => $_getS(9, '');
  set fundingTxID($core.String v) { $_setString(9, v); }
  $core.bool hasFundingTxID() => $_has(9);
  void clearFundingTxID() => clearField(10);

  $core.double get hoursToUnlock => $_getN(10);
  set hoursToUnlock($core.double v) { $_setFloat(10, v); }
  $core.bool hasHoursToUnlock() => $_has(10);
  void clearHoursToUnlock() => clearField(11);
}

class SwapAddressList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SwapAddressList', package: const $pb.PackageName('data'))
    ..pc<SwapAddressInfo>(1, 'addresses', $pb.PbFieldType.PM,SwapAddressInfo.create)
    ..hasRequiredFields = false
  ;

  SwapAddressList() : super();
  SwapAddressList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SwapAddressList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SwapAddressList clone() => SwapAddressList()..mergeFromMessage(this);
  SwapAddressList copyWith(void Function(SwapAddressList) updates) => super.copyWith((message) => updates(message as SwapAddressList));
  $pb.BuilderInfo get info_ => _i;
  static SwapAddressList create() => SwapAddressList();
  SwapAddressList createEmptyInstance() => create();
  static $pb.PbList<SwapAddressList> createRepeated() => $pb.PbList<SwapAddressList>();
  static SwapAddressList getDefault() => _defaultInstance ??= create()..freeze();
  static SwapAddressList _defaultInstance;

  $core.List<SwapAddressInfo> get addresses => $_getList(0);
}

class CreateRatchetSessionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CreateRatchetSessionRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'secret')
    ..aOS(2, 'remotePubKey')
    ..aOS(3, 'sessionID')
    ..a<Int64>(4, 'expiry', $pb.PbFieldType.OU6, Int64.ZERO)
    ..hasRequiredFields = false
  ;

  CreateRatchetSessionRequest() : super();
  CreateRatchetSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateRatchetSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateRatchetSessionRequest clone() => CreateRatchetSessionRequest()..mergeFromMessage(this);
  CreateRatchetSessionRequest copyWith(void Function(CreateRatchetSessionRequest) updates) => super.copyWith((message) => updates(message as CreateRatchetSessionRequest));
  $pb.BuilderInfo get info_ => _i;
  static CreateRatchetSessionRequest create() => CreateRatchetSessionRequest();
  CreateRatchetSessionRequest createEmptyInstance() => create();
  static $pb.PbList<CreateRatchetSessionRequest> createRepeated() => $pb.PbList<CreateRatchetSessionRequest>();
  static CreateRatchetSessionRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CreateRatchetSessionRequest _defaultInstance;

  $core.String get secret => $_getS(0, '');
  set secret($core.String v) { $_setString(0, v); }
  $core.bool hasSecret() => $_has(0);
  void clearSecret() => clearField(1);

  $core.String get remotePubKey => $_getS(1, '');
  set remotePubKey($core.String v) { $_setString(1, v); }
  $core.bool hasRemotePubKey() => $_has(1);
  void clearRemotePubKey() => clearField(2);

  $core.String get sessionID => $_getS(2, '');
  set sessionID($core.String v) { $_setString(2, v); }
  $core.bool hasSessionID() => $_has(2);
  void clearSessionID() => clearField(3);

  Int64 get expiry => $_getI64(3);
  set expiry(Int64 v) { $_setInt64(3, v); }
  $core.bool hasExpiry() => $_has(3);
  void clearExpiry() => clearField(4);
}

class CreateRatchetSessionReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CreateRatchetSessionReply', package: const $pb.PackageName('data'))
    ..aOS(1, 'sessionID')
    ..aOS(2, 'secret')
    ..aOS(3, 'pubKey')
    ..hasRequiredFields = false
  ;

  CreateRatchetSessionReply() : super();
  CreateRatchetSessionReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateRatchetSessionReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateRatchetSessionReply clone() => CreateRatchetSessionReply()..mergeFromMessage(this);
  CreateRatchetSessionReply copyWith(void Function(CreateRatchetSessionReply) updates) => super.copyWith((message) => updates(message as CreateRatchetSessionReply));
  $pb.BuilderInfo get info_ => _i;
  static CreateRatchetSessionReply create() => CreateRatchetSessionReply();
  CreateRatchetSessionReply createEmptyInstance() => create();
  static $pb.PbList<CreateRatchetSessionReply> createRepeated() => $pb.PbList<CreateRatchetSessionReply>();
  static CreateRatchetSessionReply getDefault() => _defaultInstance ??= create()..freeze();
  static CreateRatchetSessionReply _defaultInstance;

  $core.String get sessionID => $_getS(0, '');
  set sessionID($core.String v) { $_setString(0, v); }
  $core.bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  $core.String get secret => $_getS(1, '');
  set secret($core.String v) { $_setString(1, v); }
  $core.bool hasSecret() => $_has(1);
  void clearSecret() => clearField(2);

  $core.String get pubKey => $_getS(2, '');
  set pubKey($core.String v) { $_setString(2, v); }
  $core.bool hasPubKey() => $_has(2);
  void clearPubKey() => clearField(3);
}

class RatchetSessionInfoReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RatchetSessionInfoReply', package: const $pb.PackageName('data'))
    ..aOS(1, 'sessionID')
    ..aOB(2, 'initiated')
    ..aOS(3, 'userInfo')
    ..hasRequiredFields = false
  ;

  RatchetSessionInfoReply() : super();
  RatchetSessionInfoReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RatchetSessionInfoReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RatchetSessionInfoReply clone() => RatchetSessionInfoReply()..mergeFromMessage(this);
  RatchetSessionInfoReply copyWith(void Function(RatchetSessionInfoReply) updates) => super.copyWith((message) => updates(message as RatchetSessionInfoReply));
  $pb.BuilderInfo get info_ => _i;
  static RatchetSessionInfoReply create() => RatchetSessionInfoReply();
  RatchetSessionInfoReply createEmptyInstance() => create();
  static $pb.PbList<RatchetSessionInfoReply> createRepeated() => $pb.PbList<RatchetSessionInfoReply>();
  static RatchetSessionInfoReply getDefault() => _defaultInstance ??= create()..freeze();
  static RatchetSessionInfoReply _defaultInstance;

  $core.String get sessionID => $_getS(0, '');
  set sessionID($core.String v) { $_setString(0, v); }
  $core.bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  $core.bool get initiated => $_get(1, false);
  set initiated($core.bool v) { $_setBool(1, v); }
  $core.bool hasInitiated() => $_has(1);
  void clearInitiated() => clearField(2);

  $core.String get userInfo => $_getS(2, '');
  set userInfo($core.String v) { $_setString(2, v); }
  $core.bool hasUserInfo() => $_has(2);
  void clearUserInfo() => clearField(3);
}

class RatchetSessionSetInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RatchetSessionSetInfoRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'sessionID')
    ..aOS(2, 'userInfo')
    ..hasRequiredFields = false
  ;

  RatchetSessionSetInfoRequest() : super();
  RatchetSessionSetInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RatchetSessionSetInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RatchetSessionSetInfoRequest clone() => RatchetSessionSetInfoRequest()..mergeFromMessage(this);
  RatchetSessionSetInfoRequest copyWith(void Function(RatchetSessionSetInfoRequest) updates) => super.copyWith((message) => updates(message as RatchetSessionSetInfoRequest));
  $pb.BuilderInfo get info_ => _i;
  static RatchetSessionSetInfoRequest create() => RatchetSessionSetInfoRequest();
  RatchetSessionSetInfoRequest createEmptyInstance() => create();
  static $pb.PbList<RatchetSessionSetInfoRequest> createRepeated() => $pb.PbList<RatchetSessionSetInfoRequest>();
  static RatchetSessionSetInfoRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RatchetSessionSetInfoRequest _defaultInstance;

  $core.String get sessionID => $_getS(0, '');
  set sessionID($core.String v) { $_setString(0, v); }
  $core.bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  $core.String get userInfo => $_getS(1, '');
  set userInfo($core.String v) { $_setString(1, v); }
  $core.bool hasUserInfo() => $_has(1);
  void clearUserInfo() => clearField(2);
}

class RatchetEncryptRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RatchetEncryptRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'sessionID')
    ..aOS(2, 'message')
    ..hasRequiredFields = false
  ;

  RatchetEncryptRequest() : super();
  RatchetEncryptRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RatchetEncryptRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RatchetEncryptRequest clone() => RatchetEncryptRequest()..mergeFromMessage(this);
  RatchetEncryptRequest copyWith(void Function(RatchetEncryptRequest) updates) => super.copyWith((message) => updates(message as RatchetEncryptRequest));
  $pb.BuilderInfo get info_ => _i;
  static RatchetEncryptRequest create() => RatchetEncryptRequest();
  RatchetEncryptRequest createEmptyInstance() => create();
  static $pb.PbList<RatchetEncryptRequest> createRepeated() => $pb.PbList<RatchetEncryptRequest>();
  static RatchetEncryptRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RatchetEncryptRequest _defaultInstance;

  $core.String get sessionID => $_getS(0, '');
  set sessionID($core.String v) { $_setString(0, v); }
  $core.bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  $core.String get message => $_getS(1, '');
  set message($core.String v) { $_setString(1, v); }
  $core.bool hasMessage() => $_has(1);
  void clearMessage() => clearField(2);
}

class RatchetDecryptRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RatchetDecryptRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'sessionID')
    ..aOS(2, 'encryptedMessage')
    ..hasRequiredFields = false
  ;

  RatchetDecryptRequest() : super();
  RatchetDecryptRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RatchetDecryptRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RatchetDecryptRequest clone() => RatchetDecryptRequest()..mergeFromMessage(this);
  RatchetDecryptRequest copyWith(void Function(RatchetDecryptRequest) updates) => super.copyWith((message) => updates(message as RatchetDecryptRequest));
  $pb.BuilderInfo get info_ => _i;
  static RatchetDecryptRequest create() => RatchetDecryptRequest();
  RatchetDecryptRequest createEmptyInstance() => create();
  static $pb.PbList<RatchetDecryptRequest> createRepeated() => $pb.PbList<RatchetDecryptRequest>();
  static RatchetDecryptRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RatchetDecryptRequest _defaultInstance;

  $core.String get sessionID => $_getS(0, '');
  set sessionID($core.String v) { $_setString(0, v); }
  $core.bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  $core.String get encryptedMessage => $_getS(1, '');
  set encryptedMessage($core.String v) { $_setString(1, v); }
  $core.bool hasEncryptedMessage() => $_has(1);
  void clearEncryptedMessage() => clearField(2);
}

class BootstrapFilesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('BootstrapFilesRequest', package: const $pb.PackageName('data'))
    ..aOS(1, 'workingDir')
    ..pPS(2, 'fullPaths')
    ..hasRequiredFields = false
  ;

  BootstrapFilesRequest() : super();
  BootstrapFilesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  BootstrapFilesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  BootstrapFilesRequest clone() => BootstrapFilesRequest()..mergeFromMessage(this);
  BootstrapFilesRequest copyWith(void Function(BootstrapFilesRequest) updates) => super.copyWith((message) => updates(message as BootstrapFilesRequest));
  $pb.BuilderInfo get info_ => _i;
  static BootstrapFilesRequest create() => BootstrapFilesRequest();
  BootstrapFilesRequest createEmptyInstance() => create();
  static $pb.PbList<BootstrapFilesRequest> createRepeated() => $pb.PbList<BootstrapFilesRequest>();
  static BootstrapFilesRequest getDefault() => _defaultInstance ??= create()..freeze();
  static BootstrapFilesRequest _defaultInstance;

  $core.String get workingDir => $_getS(0, '');
  set workingDir($core.String v) { $_setString(0, v); }
  $core.bool hasWorkingDir() => $_has(0);
  void clearWorkingDir() => clearField(1);

  $core.List<$core.String> get fullPaths => $_getList(1);
}

class Peers extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Peers', package: const $pb.PackageName('data'))
    ..aOB(1, 'isDefault')
    ..pPS(2, 'peer')
    ..hasRequiredFields = false
  ;

  Peers() : super();
  Peers.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Peers.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Peers clone() => Peers()..mergeFromMessage(this);
  Peers copyWith(void Function(Peers) updates) => super.copyWith((message) => updates(message as Peers));
  $pb.BuilderInfo get info_ => _i;
  static Peers create() => Peers();
  Peers createEmptyInstance() => create();
  static $pb.PbList<Peers> createRepeated() => $pb.PbList<Peers>();
  static Peers getDefault() => _defaultInstance ??= create()..freeze();
  static Peers _defaultInstance;

  $core.bool get isDefault => $_get(0, false);
  set isDefault($core.bool v) { $_setBool(0, v); }
  $core.bool hasIsDefault() => $_has(0);
  void clearIsDefault() => clearField(1);

  $core.List<$core.String> get peer => $_getList(1);
}

class rate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('rate', package: const $pb.PackageName('data'))
    ..aOS(1, 'coin')
    ..a<$core.double>(2, 'value', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  rate() : super();
  rate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  rate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  rate clone() => rate()..mergeFromMessage(this);
  rate copyWith(void Function(rate) updates) => super.copyWith((message) => updates(message as rate));
  $pb.BuilderInfo get info_ => _i;
  static rate create() => rate();
  rate createEmptyInstance() => create();
  static $pb.PbList<rate> createRepeated() => $pb.PbList<rate>();
  static rate getDefault() => _defaultInstance ??= create()..freeze();
  static rate _defaultInstance;

  $core.String get coin => $_getS(0, '');
  set coin($core.String v) { $_setString(0, v); }
  $core.bool hasCoin() => $_has(0);
  void clearCoin() => clearField(1);

  $core.double get value => $_getN(1);
  set value($core.double v) { $_setDouble(1, v); }
  $core.bool hasValue() => $_has(1);
  void clearValue() => clearField(2);
}

class Rates extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Rates', package: const $pb.PackageName('data'))
    ..pc<rate>(1, 'rates', $pb.PbFieldType.PM,rate.create)
    ..hasRequiredFields = false
  ;

  Rates() : super();
  Rates.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Rates.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Rates clone() => Rates()..mergeFromMessage(this);
  Rates copyWith(void Function(Rates) updates) => super.copyWith((message) => updates(message as Rates));
  $pb.BuilderInfo get info_ => _i;
  static Rates create() => Rates();
  Rates createEmptyInstance() => create();
  static $pb.PbList<Rates> createRepeated() => $pb.PbList<Rates>();
  static Rates getDefault() => _defaultInstance ??= create()..freeze();
  static Rates _defaultInstance;

  $core.List<rate> get rates => $_getList(0);
}

class LSPInformation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LSPInformation', package: const $pb.PackageName('data'))
    ..aOS(1, 'name')
    ..aOS(2, 'pubkey')
    ..aOS(3, 'host')
    ..aInt64(4, 'channelCapacity')
    ..a<$core.int>(5, 'targetConf', $pb.PbFieldType.O3)
    ..aInt64(6, 'baseFeeMsat')
    ..a<$core.double>(7, 'feeRate', $pb.PbFieldType.OD)
    ..a<$core.int>(8, 'timeLockDelta', $pb.PbFieldType.OU3)
    ..aInt64(9, 'minHtlcMsat')
    ..hasRequiredFields = false
  ;

  LSPInformation() : super();
  LSPInformation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LSPInformation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LSPInformation clone() => LSPInformation()..mergeFromMessage(this);
  LSPInformation copyWith(void Function(LSPInformation) updates) => super.copyWith((message) => updates(message as LSPInformation));
  $pb.BuilderInfo get info_ => _i;
  static LSPInformation create() => LSPInformation();
  LSPInformation createEmptyInstance() => create();
  static $pb.PbList<LSPInformation> createRepeated() => $pb.PbList<LSPInformation>();
  static LSPInformation getDefault() => _defaultInstance ??= create()..freeze();
  static LSPInformation _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) { $_setString(0, v); }
  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  $core.String get pubkey => $_getS(1, '');
  set pubkey($core.String v) { $_setString(1, v); }
  $core.bool hasPubkey() => $_has(1);
  void clearPubkey() => clearField(2);

  $core.String get host => $_getS(2, '');
  set host($core.String v) { $_setString(2, v); }
  $core.bool hasHost() => $_has(2);
  void clearHost() => clearField(3);

  Int64 get channelCapacity => $_getI64(3);
  set channelCapacity(Int64 v) { $_setInt64(3, v); }
  $core.bool hasChannelCapacity() => $_has(3);
  void clearChannelCapacity() => clearField(4);

  $core.int get targetConf => $_get(4, 0);
  set targetConf($core.int v) { $_setSignedInt32(4, v); }
  $core.bool hasTargetConf() => $_has(4);
  void clearTargetConf() => clearField(5);

  Int64 get baseFeeMsat => $_getI64(5);
  set baseFeeMsat(Int64 v) { $_setInt64(5, v); }
  $core.bool hasBaseFeeMsat() => $_has(5);
  void clearBaseFeeMsat() => clearField(6);

  $core.double get feeRate => $_getN(6);
  set feeRate($core.double v) { $_setDouble(6, v); }
  $core.bool hasFeeRate() => $_has(6);
  void clearFeeRate() => clearField(7);

  $core.int get timeLockDelta => $_get(7, 0);
  set timeLockDelta($core.int v) { $_setUnsignedInt32(7, v); }
  $core.bool hasTimeLockDelta() => $_has(7);
  void clearTimeLockDelta() => clearField(8);

  Int64 get minHtlcMsat => $_getI64(8);
  set minHtlcMsat(Int64 v) { $_setInt64(8, v); }
  $core.bool hasMinHtlcMsat() => $_has(8);
  void clearMinHtlcMsat() => clearField(9);
}

class LSPList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LSPList', package: const $pb.PackageName('data'))
    ..m<$core.String, LSPInformation>(1, 'lsps', 'LSPList.LspsEntry',$pb.PbFieldType.OS, $pb.PbFieldType.OM, LSPInformation.create, null, null , const $pb.PackageName('data'))
    ..hasRequiredFields = false
  ;

  LSPList() : super();
  LSPList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LSPList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LSPList clone() => LSPList()..mergeFromMessage(this);
  LSPList copyWith(void Function(LSPList) updates) => super.copyWith((message) => updates(message as LSPList));
  $pb.BuilderInfo get info_ => _i;
  static LSPList create() => LSPList();
  LSPList createEmptyInstance() => create();
  static $pb.PbList<LSPList> createRepeated() => $pb.PbList<LSPList>();
  static LSPList getDefault() => _defaultInstance ??= create()..freeze();
  static LSPList _defaultInstance;

  $core.Map<$core.String, LSPInformation> get lsps => $_getMap(0);
}


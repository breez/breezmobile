///
//  Generated code. Do not modify.
//  source: rpc.proto
//
// @dart = 2.7
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'rpc.pbenum.dart';

export 'rpc.pbenum.dart';

class ListPaymentsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListPaymentsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  ListPaymentsRequest._() : super();
  factory ListPaymentsRequest() => create();
  factory ListPaymentsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPaymentsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListPaymentsRequest clone() => ListPaymentsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListPaymentsRequest copyWith(void Function(ListPaymentsRequest) updates) => super.copyWith((message) => updates(message as ListPaymentsRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListPaymentsRequest create() => ListPaymentsRequest._();
  ListPaymentsRequest createEmptyInstance() => create();
  static $pb.PbList<ListPaymentsRequest> createRepeated() => $pb.PbList<ListPaymentsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListPaymentsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPaymentsRequest>(create);
  static ListPaymentsRequest _defaultInstance;
}

class RestartDaemonRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RestartDaemonRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  RestartDaemonRequest._() : super();
  factory RestartDaemonRequest() => create();
  factory RestartDaemonRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RestartDaemonRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RestartDaemonRequest clone() => RestartDaemonRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RestartDaemonRequest copyWith(void Function(RestartDaemonRequest) updates) => super.copyWith((message) => updates(message as RestartDaemonRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RestartDaemonRequest create() => RestartDaemonRequest._();
  RestartDaemonRequest createEmptyInstance() => create();
  static $pb.PbList<RestartDaemonRequest> createRepeated() => $pb.PbList<RestartDaemonRequest>();
  @$core.pragma('dart2js:noInline')
  static RestartDaemonRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RestartDaemonRequest>(create);
  static RestartDaemonRequest _defaultInstance;
}

class RestartDaemonReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RestartDaemonReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  RestartDaemonReply._() : super();
  factory RestartDaemonReply() => create();
  factory RestartDaemonReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RestartDaemonReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RestartDaemonReply clone() => RestartDaemonReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RestartDaemonReply copyWith(void Function(RestartDaemonReply) updates) => super.copyWith((message) => updates(message as RestartDaemonReply)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RestartDaemonReply create() => RestartDaemonReply._();
  RestartDaemonReply createEmptyInstance() => create();
  static $pb.PbList<RestartDaemonReply> createRepeated() => $pb.PbList<RestartDaemonReply>();
  @$core.pragma('dart2js:noInline')
  static RestartDaemonReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RestartDaemonReply>(create);
  static RestartDaemonReply _defaultInstance;
}

class AddFundInitRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddFundInitRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notificationToken', protoName: 'notificationToken')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lspID', protoName: 'lspID')
    ..hasRequiredFields = false
  ;

  AddFundInitRequest._() : super();
  factory AddFundInitRequest({
    $core.String notificationToken,
    $core.String lspID,
  }) {
    final _result = create();
    if (notificationToken != null) {
      _result.notificationToken = notificationToken;
    }
    if (lspID != null) {
      _result.lspID = lspID;
    }
    return _result;
  }
  factory AddFundInitRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundInitRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddFundInitRequest clone() => AddFundInitRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddFundInitRequest copyWith(void Function(AddFundInitRequest) updates) => super.copyWith((message) => updates(message as AddFundInitRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddFundInitRequest create() => AddFundInitRequest._();
  AddFundInitRequest createEmptyInstance() => create();
  static $pb.PbList<AddFundInitRequest> createRepeated() => $pb.PbList<AddFundInitRequest>();
  @$core.pragma('dart2js:noInline')
  static AddFundInitRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddFundInitRequest>(create);
  static AddFundInitRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notificationToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set notificationToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNotificationToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotificationToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get lspID => $_getSZ(1);
  @$pb.TagNumber(2)
  set lspID($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLspID() => $_has(1);
  @$pb.TagNumber(2)
  void clearLspID() => clearField(2);
}

class FundStatusRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FundStatusRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notificationToken', protoName: 'notificationToken')
    ..hasRequiredFields = false
  ;

  FundStatusRequest._() : super();
  factory FundStatusRequest({
    $core.String notificationToken,
  }) {
    final _result = create();
    if (notificationToken != null) {
      _result.notificationToken = notificationToken;
    }
    return _result;
  }
  factory FundStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FundStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FundStatusRequest clone() => FundStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FundStatusRequest copyWith(void Function(FundStatusRequest) updates) => super.copyWith((message) => updates(message as FundStatusRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FundStatusRequest create() => FundStatusRequest._();
  FundStatusRequest createEmptyInstance() => create();
  static $pb.PbList<FundStatusRequest> createRepeated() => $pb.PbList<FundStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static FundStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FundStatusRequest>(create);
  static FundStatusRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notificationToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set notificationToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNotificationToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotificationToken() => clearField(1);
}

class AddInvoiceReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddInvoiceReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentRequest', protoName: 'paymentRequest')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lspFee')
    ..hasRequiredFields = false
  ;

  AddInvoiceReply._() : super();
  factory AddInvoiceReply({
    $core.String paymentRequest,
    $fixnum.Int64 lspFee,
  }) {
    final _result = create();
    if (paymentRequest != null) {
      _result.paymentRequest = paymentRequest;
    }
    if (lspFee != null) {
      _result.lspFee = lspFee;
    }
    return _result;
  }
  factory AddInvoiceReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddInvoiceReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddInvoiceReply clone() => AddInvoiceReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddInvoiceReply copyWith(void Function(AddInvoiceReply) updates) => super.copyWith((message) => updates(message as AddInvoiceReply)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddInvoiceReply create() => AddInvoiceReply._();
  AddInvoiceReply createEmptyInstance() => create();
  static $pb.PbList<AddInvoiceReply> createRepeated() => $pb.PbList<AddInvoiceReply>();
  @$core.pragma('dart2js:noInline')
  static AddInvoiceReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddInvoiceReply>(create);
  static AddInvoiceReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get paymentRequest => $_getSZ(0);
  @$pb.TagNumber(1)
  set paymentRequest($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPaymentRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentRequest() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get lspFee => $_getI64(1);
  @$pb.TagNumber(2)
  set lspFee($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLspFee() => $_has(1);
  @$pb.TagNumber(2)
  void clearLspFee() => clearField(2);
}

class ChainStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChainStatus', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockHeight', $pb.PbFieldType.OU3, protoName: 'blockHeight')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'syncedToChain', protoName: 'syncedToChain')
    ..hasRequiredFields = false
  ;

  ChainStatus._() : super();
  factory ChainStatus({
    $core.int blockHeight,
    $core.bool syncedToChain,
  }) {
    final _result = create();
    if (blockHeight != null) {
      _result.blockHeight = blockHeight;
    }
    if (syncedToChain != null) {
      _result.syncedToChain = syncedToChain;
    }
    return _result;
  }
  factory ChainStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChainStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChainStatus clone() => ChainStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChainStatus copyWith(void Function(ChainStatus) updates) => super.copyWith((message) => updates(message as ChainStatus)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ChainStatus create() => ChainStatus._();
  ChainStatus createEmptyInstance() => create();
  static $pb.PbList<ChainStatus> createRepeated() => $pb.PbList<ChainStatus>();
  @$core.pragma('dart2js:noInline')
  static ChainStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChainStatus>(create);
  static ChainStatus _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get blockHeight => $_getIZ(0);
  @$pb.TagNumber(1)
  set blockHeight($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBlockHeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlockHeight() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get syncedToChain => $_getBF(1);
  @$pb.TagNumber(2)
  set syncedToChain($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSyncedToChain() => $_has(1);
  @$pb.TagNumber(2)
  void clearSyncedToChain() => clearField(2);
}

class Account extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Account', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'balance')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'walletBalance', protoName: 'walletBalance')
    ..e<Account_AccountStatus>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: Account_AccountStatus.DISCONNECTED, valueOf: Account_AccountStatus.valueOf, enumValues: Account_AccountStatus.values)
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxAllowedToReceive', protoName: 'maxAllowedToReceive')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxAllowedToPay', protoName: 'maxAllowedToPay')
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxPaymentAmount', protoName: 'maxPaymentAmount')
    ..aInt64(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'routingNodeFee', protoName: 'routingNodeFee')
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..aInt64(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxChanReserve', protoName: 'maxChanReserve')
    ..aOS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'channelPoint', protoName: 'channelPoint')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'readyForPayments', protoName: 'readyForPayments')
    ..aInt64(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tipHeight', protoName: 'tipHeight')
    ..pPS(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectedPeers', protoName: 'connectedPeers')
    ..aInt64(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxInboundLiquidity')
    ..pPS(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'unconfirmedChannels')
    ..hasRequiredFields = false
  ;

  Account._() : super();
  factory Account({
    $core.String id,
    $fixnum.Int64 balance,
    $fixnum.Int64 walletBalance,
    Account_AccountStatus status,
    $fixnum.Int64 maxAllowedToReceive,
    $fixnum.Int64 maxAllowedToPay,
    $fixnum.Int64 maxPaymentAmount,
    $fixnum.Int64 routingNodeFee,
    $core.bool enabled,
    $fixnum.Int64 maxChanReserve,
    $core.String channelPoint,
    $core.bool readyForPayments,
    $fixnum.Int64 tipHeight,
    $core.Iterable<$core.String> connectedPeers,
    $fixnum.Int64 maxInboundLiquidity,
    $core.Iterable<$core.String> unconfirmedChannels,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (balance != null) {
      _result.balance = balance;
    }
    if (walletBalance != null) {
      _result.walletBalance = walletBalance;
    }
    if (status != null) {
      _result.status = status;
    }
    if (maxAllowedToReceive != null) {
      _result.maxAllowedToReceive = maxAllowedToReceive;
    }
    if (maxAllowedToPay != null) {
      _result.maxAllowedToPay = maxAllowedToPay;
    }
    if (maxPaymentAmount != null) {
      _result.maxPaymentAmount = maxPaymentAmount;
    }
    if (routingNodeFee != null) {
      _result.routingNodeFee = routingNodeFee;
    }
    if (enabled != null) {
      _result.enabled = enabled;
    }
    if (maxChanReserve != null) {
      _result.maxChanReserve = maxChanReserve;
    }
    if (channelPoint != null) {
      _result.channelPoint = channelPoint;
    }
    if (readyForPayments != null) {
      _result.readyForPayments = readyForPayments;
    }
    if (tipHeight != null) {
      _result.tipHeight = tipHeight;
    }
    if (connectedPeers != null) {
      _result.connectedPeers.addAll(connectedPeers);
    }
    if (maxInboundLiquidity != null) {
      _result.maxInboundLiquidity = maxInboundLiquidity;
    }
    if (unconfirmedChannels != null) {
      _result.unconfirmedChannels.addAll(unconfirmedChannels);
    }
    return _result;
  }
  factory Account.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Account.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Account clone() => Account()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Account copyWith(void Function(Account) updates) => super.copyWith((message) => updates(message as Account)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Account create() => Account._();
  Account createEmptyInstance() => create();
  static $pb.PbList<Account> createRepeated() => $pb.PbList<Account>();
  @$core.pragma('dart2js:noInline')
  static Account getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Account>(create);
  static Account _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get balance => $_getI64(1);
  @$pb.TagNumber(2)
  set balance($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBalance() => $_has(1);
  @$pb.TagNumber(2)
  void clearBalance() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get walletBalance => $_getI64(2);
  @$pb.TagNumber(3)
  set walletBalance($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWalletBalance() => $_has(2);
  @$pb.TagNumber(3)
  void clearWalletBalance() => clearField(3);

  @$pb.TagNumber(4)
  Account_AccountStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(Account_AccountStatus v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get maxAllowedToReceive => $_getI64(4);
  @$pb.TagNumber(5)
  set maxAllowedToReceive($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMaxAllowedToReceive() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxAllowedToReceive() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get maxAllowedToPay => $_getI64(5);
  @$pb.TagNumber(6)
  set maxAllowedToPay($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMaxAllowedToPay() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxAllowedToPay() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get maxPaymentAmount => $_getI64(6);
  @$pb.TagNumber(7)
  set maxPaymentAmount($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMaxPaymentAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxPaymentAmount() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get routingNodeFee => $_getI64(7);
  @$pb.TagNumber(8)
  set routingNodeFee($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasRoutingNodeFee() => $_has(7);
  @$pb.TagNumber(8)
  void clearRoutingNodeFee() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get enabled => $_getBF(8);
  @$pb.TagNumber(9)
  set enabled($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasEnabled() => $_has(8);
  @$pb.TagNumber(9)
  void clearEnabled() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get maxChanReserve => $_getI64(9);
  @$pb.TagNumber(10)
  set maxChanReserve($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasMaxChanReserve() => $_has(9);
  @$pb.TagNumber(10)
  void clearMaxChanReserve() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get channelPoint => $_getSZ(10);
  @$pb.TagNumber(11)
  set channelPoint($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasChannelPoint() => $_has(10);
  @$pb.TagNumber(11)
  void clearChannelPoint() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get readyForPayments => $_getBF(11);
  @$pb.TagNumber(12)
  set readyForPayments($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasReadyForPayments() => $_has(11);
  @$pb.TagNumber(12)
  void clearReadyForPayments() => clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get tipHeight => $_getI64(12);
  @$pb.TagNumber(13)
  set tipHeight($fixnum.Int64 v) { $_setInt64(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasTipHeight() => $_has(12);
  @$pb.TagNumber(13)
  void clearTipHeight() => clearField(13);

  @$pb.TagNumber(14)
  $core.List<$core.String> get connectedPeers => $_getList(13);

  @$pb.TagNumber(15)
  $fixnum.Int64 get maxInboundLiquidity => $_getI64(14);
  @$pb.TagNumber(15)
  set maxInboundLiquidity($fixnum.Int64 v) { $_setInt64(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasMaxInboundLiquidity() => $_has(14);
  @$pb.TagNumber(15)
  void clearMaxInboundLiquidity() => clearField(15);

  @$pb.TagNumber(16)
  $core.List<$core.String> get unconfirmedChannels => $_getList(15);
}

class Payment extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Payment', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..e<Payment_PaymentType>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: Payment_PaymentType.DEPOSIT, valueOf: Payment_PaymentType.valueOf, enumValues: Payment_PaymentType.values)
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creationTimestamp', protoName: 'creationTimestamp')
    ..aOM<InvoiceMemo>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'invoiceMemo', protoName: 'invoiceMemo', subBuilder: InvoiceMemo.create)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'redeemTxID', protoName: 'redeemTxID')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentHash', protoName: 'paymentHash')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'destination')
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'PendingExpirationHeight', $pb.PbFieldType.OU3, protoName: 'PendingExpirationHeight')
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'PendingExpirationTimestamp', protoName: 'PendingExpirationTimestamp')
    ..aInt64(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fee')
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'preimage')
    ..aOS(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'closedChannelPoint', protoName: 'closedChannelPoint')
    ..aOB(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isChannelPending', protoName: 'isChannelPending')
    ..aOB(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isChannelCloseConfimed', protoName: 'isChannelCloseConfimed')
    ..aOS(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'closedChannelTxID', protoName: 'closedChannelTxID')
    ..aOB(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isKeySend', protoName: 'isKeySend')
    ..aOB(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'PendingFull', protoName: 'PendingFull')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'closedChannelRemoteTxID', protoName: 'closedChannelRemoteTxID')
    ..aOS(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'closedChannelSweepTxID', protoName: 'closedChannelSweepTxID')
    ..aOS(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupKey', protoName: 'groupKey')
    ..aOS(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupName', protoName: 'groupName')
    ..aOM<LNUrlPayInfo>(24, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lnurlPayInfo', protoName: 'lnurlPayInfo', subBuilder: LNUrlPayInfo.create)
    ..pPS(25, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'routeHops', protoName: 'routeHops')
    ..hasRequiredFields = false
  ;

  Payment._() : super();
  factory Payment({
    Payment_PaymentType type,
    $fixnum.Int64 amount,
    $fixnum.Int64 creationTimestamp,
    InvoiceMemo invoiceMemo,
    $core.String redeemTxID,
    $core.String paymentHash,
    $core.String destination,
    $core.int pendingExpirationHeight,
    $fixnum.Int64 pendingExpirationTimestamp,
    $fixnum.Int64 fee,
    $core.String preimage,
    $core.String closedChannelPoint,
    $core.bool isChannelPending,
    $core.bool isChannelCloseConfimed,
    $core.String closedChannelTxID,
    $core.bool isKeySend,
    $core.bool pendingFull,
    $core.String closedChannelRemoteTxID,
    $core.String closedChannelSweepTxID,
    $core.String groupKey,
    $core.String groupName,
    LNUrlPayInfo lnurlPayInfo,
    $core.Iterable<$core.String> routeHops,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (creationTimestamp != null) {
      _result.creationTimestamp = creationTimestamp;
    }
    if (invoiceMemo != null) {
      _result.invoiceMemo = invoiceMemo;
    }
    if (redeemTxID != null) {
      _result.redeemTxID = redeemTxID;
    }
    if (paymentHash != null) {
      _result.paymentHash = paymentHash;
    }
    if (destination != null) {
      _result.destination = destination;
    }
    if (pendingExpirationHeight != null) {
      _result.pendingExpirationHeight = pendingExpirationHeight;
    }
    if (pendingExpirationTimestamp != null) {
      _result.pendingExpirationTimestamp = pendingExpirationTimestamp;
    }
    if (fee != null) {
      _result.fee = fee;
    }
    if (preimage != null) {
      _result.preimage = preimage;
    }
    if (closedChannelPoint != null) {
      _result.closedChannelPoint = closedChannelPoint;
    }
    if (isChannelPending != null) {
      _result.isChannelPending = isChannelPending;
    }
    if (isChannelCloseConfimed != null) {
      _result.isChannelCloseConfimed = isChannelCloseConfimed;
    }
    if (closedChannelTxID != null) {
      _result.closedChannelTxID = closedChannelTxID;
    }
    if (isKeySend != null) {
      _result.isKeySend = isKeySend;
    }
    if (pendingFull != null) {
      _result.pendingFull = pendingFull;
    }
    if (closedChannelRemoteTxID != null) {
      _result.closedChannelRemoteTxID = closedChannelRemoteTxID;
    }
    if (closedChannelSweepTxID != null) {
      _result.closedChannelSweepTxID = closedChannelSweepTxID;
    }
    if (groupKey != null) {
      _result.groupKey = groupKey;
    }
    if (groupName != null) {
      _result.groupName = groupName;
    }
    if (lnurlPayInfo != null) {
      _result.lnurlPayInfo = lnurlPayInfo;
    }
    if (routeHops != null) {
      _result.routeHops.addAll(routeHops);
    }
    return _result;
  }
  factory Payment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Payment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Payment clone() => Payment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Payment copyWith(void Function(Payment) updates) => super.copyWith((message) => updates(message as Payment)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Payment create() => Payment._();
  Payment createEmptyInstance() => create();
  static $pb.PbList<Payment> createRepeated() => $pb.PbList<Payment>();
  @$core.pragma('dart2js:noInline')
  static Payment getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Payment>(create);
  static Payment _defaultInstance;

  @$pb.TagNumber(1)
  Payment_PaymentType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(Payment_PaymentType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get amount => $_getI64(1);
  @$pb.TagNumber(3)
  set amount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get creationTimestamp => $_getI64(2);
  @$pb.TagNumber(4)
  set creationTimestamp($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasCreationTimestamp() => $_has(2);
  @$pb.TagNumber(4)
  void clearCreationTimestamp() => clearField(4);

  @$pb.TagNumber(6)
  InvoiceMemo get invoiceMemo => $_getN(3);
  @$pb.TagNumber(6)
  set invoiceMemo(InvoiceMemo v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasInvoiceMemo() => $_has(3);
  @$pb.TagNumber(6)
  void clearInvoiceMemo() => clearField(6);
  @$pb.TagNumber(6)
  InvoiceMemo ensureInvoiceMemo() => $_ensure(3);

  @$pb.TagNumber(7)
  $core.String get redeemTxID => $_getSZ(4);
  @$pb.TagNumber(7)
  set redeemTxID($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(7)
  $core.bool hasRedeemTxID() => $_has(4);
  @$pb.TagNumber(7)
  void clearRedeemTxID() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get paymentHash => $_getSZ(5);
  @$pb.TagNumber(8)
  set paymentHash($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(8)
  $core.bool hasPaymentHash() => $_has(5);
  @$pb.TagNumber(8)
  void clearPaymentHash() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get destination => $_getSZ(6);
  @$pb.TagNumber(9)
  set destination($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(9)
  $core.bool hasDestination() => $_has(6);
  @$pb.TagNumber(9)
  void clearDestination() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get pendingExpirationHeight => $_getIZ(7);
  @$pb.TagNumber(10)
  set pendingExpirationHeight($core.int v) { $_setUnsignedInt32(7, v); }
  @$pb.TagNumber(10)
  $core.bool hasPendingExpirationHeight() => $_has(7);
  @$pb.TagNumber(10)
  void clearPendingExpirationHeight() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get pendingExpirationTimestamp => $_getI64(8);
  @$pb.TagNumber(11)
  set pendingExpirationTimestamp($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(11)
  $core.bool hasPendingExpirationTimestamp() => $_has(8);
  @$pb.TagNumber(11)
  void clearPendingExpirationTimestamp() => clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get fee => $_getI64(9);
  @$pb.TagNumber(12)
  set fee($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(12)
  $core.bool hasFee() => $_has(9);
  @$pb.TagNumber(12)
  void clearFee() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get preimage => $_getSZ(10);
  @$pb.TagNumber(13)
  set preimage($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(13)
  $core.bool hasPreimage() => $_has(10);
  @$pb.TagNumber(13)
  void clearPreimage() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get closedChannelPoint => $_getSZ(11);
  @$pb.TagNumber(14)
  set closedChannelPoint($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(14)
  $core.bool hasClosedChannelPoint() => $_has(11);
  @$pb.TagNumber(14)
  void clearClosedChannelPoint() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get isChannelPending => $_getBF(12);
  @$pb.TagNumber(15)
  set isChannelPending($core.bool v) { $_setBool(12, v); }
  @$pb.TagNumber(15)
  $core.bool hasIsChannelPending() => $_has(12);
  @$pb.TagNumber(15)
  void clearIsChannelPending() => clearField(15);

  @$pb.TagNumber(16)
  $core.bool get isChannelCloseConfimed => $_getBF(13);
  @$pb.TagNumber(16)
  set isChannelCloseConfimed($core.bool v) { $_setBool(13, v); }
  @$pb.TagNumber(16)
  $core.bool hasIsChannelCloseConfimed() => $_has(13);
  @$pb.TagNumber(16)
  void clearIsChannelCloseConfimed() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get closedChannelTxID => $_getSZ(14);
  @$pb.TagNumber(17)
  set closedChannelTxID($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(17)
  $core.bool hasClosedChannelTxID() => $_has(14);
  @$pb.TagNumber(17)
  void clearClosedChannelTxID() => clearField(17);

  @$pb.TagNumber(18)
  $core.bool get isKeySend => $_getBF(15);
  @$pb.TagNumber(18)
  set isKeySend($core.bool v) { $_setBool(15, v); }
  @$pb.TagNumber(18)
  $core.bool hasIsKeySend() => $_has(15);
  @$pb.TagNumber(18)
  void clearIsKeySend() => clearField(18);

  @$pb.TagNumber(19)
  $core.bool get pendingFull => $_getBF(16);
  @$pb.TagNumber(19)
  set pendingFull($core.bool v) { $_setBool(16, v); }
  @$pb.TagNumber(19)
  $core.bool hasPendingFull() => $_has(16);
  @$pb.TagNumber(19)
  void clearPendingFull() => clearField(19);

  @$pb.TagNumber(20)
  $core.String get closedChannelRemoteTxID => $_getSZ(17);
  @$pb.TagNumber(20)
  set closedChannelRemoteTxID($core.String v) { $_setString(17, v); }
  @$pb.TagNumber(20)
  $core.bool hasClosedChannelRemoteTxID() => $_has(17);
  @$pb.TagNumber(20)
  void clearClosedChannelRemoteTxID() => clearField(20);

  @$pb.TagNumber(21)
  $core.String get closedChannelSweepTxID => $_getSZ(18);
  @$pb.TagNumber(21)
  set closedChannelSweepTxID($core.String v) { $_setString(18, v); }
  @$pb.TagNumber(21)
  $core.bool hasClosedChannelSweepTxID() => $_has(18);
  @$pb.TagNumber(21)
  void clearClosedChannelSweepTxID() => clearField(21);

  @$pb.TagNumber(22)
  $core.String get groupKey => $_getSZ(19);
  @$pb.TagNumber(22)
  set groupKey($core.String v) { $_setString(19, v); }
  @$pb.TagNumber(22)
  $core.bool hasGroupKey() => $_has(19);
  @$pb.TagNumber(22)
  void clearGroupKey() => clearField(22);

  @$pb.TagNumber(23)
  $core.String get groupName => $_getSZ(20);
  @$pb.TagNumber(23)
  set groupName($core.String v) { $_setString(20, v); }
  @$pb.TagNumber(23)
  $core.bool hasGroupName() => $_has(20);
  @$pb.TagNumber(23)
  void clearGroupName() => clearField(23);

  @$pb.TagNumber(24)
  LNUrlPayInfo get lnurlPayInfo => $_getN(21);
  @$pb.TagNumber(24)
  set lnurlPayInfo(LNUrlPayInfo v) { setField(24, v); }
  @$pb.TagNumber(24)
  $core.bool hasLnurlPayInfo() => $_has(21);
  @$pb.TagNumber(24)
  void clearLnurlPayInfo() => clearField(24);
  @$pb.TagNumber(24)
  LNUrlPayInfo ensureLnurlPayInfo() => $_ensure(21);

  @$pb.TagNumber(25)
  $core.List<$core.String> get routeHops => $_getList(22);
}

class PaymentsList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PaymentsList', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..pc<Payment>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentsList', $pb.PbFieldType.PM, protoName: 'paymentsList', subBuilder: Payment.create)
    ..hasRequiredFields = false
  ;

  PaymentsList._() : super();
  factory PaymentsList({
    $core.Iterable<Payment> paymentsList,
  }) {
    final _result = create();
    if (paymentsList != null) {
      _result.paymentsList.addAll(paymentsList);
    }
    return _result;
  }
  factory PaymentsList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PaymentsList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PaymentsList clone() => PaymentsList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PaymentsList copyWith(void Function(PaymentsList) updates) => super.copyWith((message) => updates(message as PaymentsList)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PaymentsList create() => PaymentsList._();
  PaymentsList createEmptyInstance() => create();
  static $pb.PbList<PaymentsList> createRepeated() => $pb.PbList<PaymentsList>();
  @$core.pragma('dart2js:noInline')
  static PaymentsList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaymentsList>(create);
  static PaymentsList _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Payment> get paymentsList => $_getList(0);
}

class PaymentResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PaymentResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentError', protoName: 'paymentError')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'traceReport', protoName: 'traceReport')
    ..hasRequiredFields = false
  ;

  PaymentResponse._() : super();
  factory PaymentResponse({
    $core.String paymentError,
    $core.String traceReport,
  }) {
    final _result = create();
    if (paymentError != null) {
      _result.paymentError = paymentError;
    }
    if (traceReport != null) {
      _result.traceReport = traceReport;
    }
    return _result;
  }
  factory PaymentResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PaymentResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PaymentResponse clone() => PaymentResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PaymentResponse copyWith(void Function(PaymentResponse) updates) => super.copyWith((message) => updates(message as PaymentResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PaymentResponse create() => PaymentResponse._();
  PaymentResponse createEmptyInstance() => create();
  static $pb.PbList<PaymentResponse> createRepeated() => $pb.PbList<PaymentResponse>();
  @$core.pragma('dart2js:noInline')
  static PaymentResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaymentResponse>(create);
  static PaymentResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get paymentError => $_getSZ(0);
  @$pb.TagNumber(1)
  set paymentError($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPaymentError() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentError() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get traceReport => $_getSZ(1);
  @$pb.TagNumber(2)
  set traceReport($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTraceReport() => $_has(1);
  @$pb.TagNumber(2)
  void clearTraceReport() => clearField(2);
}

class SendWalletCoinsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SendWalletCoinsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'satPerByteFee', protoName: 'satPerByteFee')
    ..hasRequiredFields = false
  ;

  SendWalletCoinsRequest._() : super();
  factory SendWalletCoinsRequest({
    $core.String address,
    $fixnum.Int64 satPerByteFee,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (satPerByteFee != null) {
      _result.satPerByteFee = satPerByteFee;
    }
    return _result;
  }
  factory SendWalletCoinsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SendWalletCoinsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SendWalletCoinsRequest clone() => SendWalletCoinsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SendWalletCoinsRequest copyWith(void Function(SendWalletCoinsRequest) updates) => super.copyWith((message) => updates(message as SendWalletCoinsRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SendWalletCoinsRequest create() => SendWalletCoinsRequest._();
  SendWalletCoinsRequest createEmptyInstance() => create();
  static $pb.PbList<SendWalletCoinsRequest> createRepeated() => $pb.PbList<SendWalletCoinsRequest>();
  @$core.pragma('dart2js:noInline')
  static SendWalletCoinsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendWalletCoinsRequest>(create);
  static SendWalletCoinsRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get satPerByteFee => $_getI64(1);
  @$pb.TagNumber(2)
  set satPerByteFee($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSatPerByteFee() => $_has(1);
  @$pb.TagNumber(2)
  void clearSatPerByteFee() => clearField(2);
}

class PayInvoiceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PayInvoiceRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentRequest', protoName: 'paymentRequest')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'skipCheckMaxAmount', protoName: 'skipCheckMaxAmount')
    ..hasRequiredFields = false
  ;

  PayInvoiceRequest._() : super();
  factory PayInvoiceRequest({
    $fixnum.Int64 amount,
    $core.String paymentRequest,
    $core.bool skipCheckMaxAmount,
  }) {
    final _result = create();
    if (amount != null) {
      _result.amount = amount;
    }
    if (paymentRequest != null) {
      _result.paymentRequest = paymentRequest;
    }
    if (skipCheckMaxAmount != null) {
      _result.skipCheckMaxAmount = skipCheckMaxAmount;
    }
    return _result;
  }
  factory PayInvoiceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PayInvoiceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PayInvoiceRequest clone() => PayInvoiceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PayInvoiceRequest copyWith(void Function(PayInvoiceRequest) updates) => super.copyWith((message) => updates(message as PayInvoiceRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PayInvoiceRequest create() => PayInvoiceRequest._();
  PayInvoiceRequest createEmptyInstance() => create();
  static $pb.PbList<PayInvoiceRequest> createRepeated() => $pb.PbList<PayInvoiceRequest>();
  @$core.pragma('dart2js:noInline')
  static PayInvoiceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PayInvoiceRequest>(create);
  static PayInvoiceRequest _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get amount => $_getI64(0);
  @$pb.TagNumber(1)
  set amount($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmount() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get paymentRequest => $_getSZ(1);
  @$pb.TagNumber(2)
  set paymentRequest($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPaymentRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaymentRequest() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get skipCheckMaxAmount => $_getBF(2);
  @$pb.TagNumber(3)
  set skipCheckMaxAmount($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSkipCheckMaxAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearSkipCheckMaxAmount() => clearField(3);
}

class SpontaneousPaymentRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SpontaneousPaymentRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'destNode', protoName: 'destNode')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupKey', protoName: 'groupKey')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupName', protoName: 'groupName')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'feeLimitMsat', protoName: 'feeLimitMsat')
    ..m<$fixnum.Int64, $core.String>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tlv', entryClassName: 'SpontaneousPaymentRequest.TlvEntry', keyFieldType: $pb.PbFieldType.O6, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('data'))
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'skipCheckMaxAmount', protoName: 'skipCheckMaxAmount')
    ..pPS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hops')
    ..hasRequiredFields = false
  ;

  SpontaneousPaymentRequest._() : super();
  factory SpontaneousPaymentRequest({
    $fixnum.Int64 amount,
    $core.String destNode,
    $core.String description,
    $core.String groupKey,
    $core.String groupName,
    $fixnum.Int64 feeLimitMsat,
    $core.Map<$fixnum.Int64, $core.String> tlv,
    $core.bool skipCheckMaxAmount,
    $core.Iterable<$core.String> hops,
  }) {
    final _result = create();
    if (amount != null) {
      _result.amount = amount;
    }
    if (destNode != null) {
      _result.destNode = destNode;
    }
    if (description != null) {
      _result.description = description;
    }
    if (groupKey != null) {
      _result.groupKey = groupKey;
    }
    if (groupName != null) {
      _result.groupName = groupName;
    }
    if (feeLimitMsat != null) {
      _result.feeLimitMsat = feeLimitMsat;
    }
    if (tlv != null) {
      _result.tlv.addAll(tlv);
    }
    if (skipCheckMaxAmount != null) {
      _result.skipCheckMaxAmount = skipCheckMaxAmount;
    }
    if (hops != null) {
      _result.hops.addAll(hops);
    }
    return _result;
  }
  factory SpontaneousPaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SpontaneousPaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SpontaneousPaymentRequest clone() => SpontaneousPaymentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SpontaneousPaymentRequest copyWith(void Function(SpontaneousPaymentRequest) updates) => super.copyWith((message) => updates(message as SpontaneousPaymentRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SpontaneousPaymentRequest create() => SpontaneousPaymentRequest._();
  SpontaneousPaymentRequest createEmptyInstance() => create();
  static $pb.PbList<SpontaneousPaymentRequest> createRepeated() => $pb.PbList<SpontaneousPaymentRequest>();
  @$core.pragma('dart2js:noInline')
  static SpontaneousPaymentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SpontaneousPaymentRequest>(create);
  static SpontaneousPaymentRequest _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get amount => $_getI64(0);
  @$pb.TagNumber(1)
  set amount($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmount() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get destNode => $_getSZ(1);
  @$pb.TagNumber(2)
  set destNode($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDestNode() => $_has(1);
  @$pb.TagNumber(2)
  void clearDestNode() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get groupKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set groupKey($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasGroupKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearGroupKey() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get groupName => $_getSZ(4);
  @$pb.TagNumber(5)
  set groupName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasGroupName() => $_has(4);
  @$pb.TagNumber(5)
  void clearGroupName() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get feeLimitMsat => $_getI64(5);
  @$pb.TagNumber(6)
  set feeLimitMsat($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasFeeLimitMsat() => $_has(5);
  @$pb.TagNumber(6)
  void clearFeeLimitMsat() => clearField(6);

  @$pb.TagNumber(7)
  $core.Map<$fixnum.Int64, $core.String> get tlv => $_getMap(6);

  @$pb.TagNumber(8)
  $core.bool get skipCheckMaxAmount => $_getBF(7);
  @$pb.TagNumber(8)
  set skipCheckMaxAmount($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSkipCheckMaxAmount() => $_has(7);
  @$pb.TagNumber(8)
  void clearSkipCheckMaxAmount() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<$core.String> get hops => $_getList(8);
}

class InvoiceMemo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'InvoiceMemo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'payeeName', protoName: 'payeeName')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'payeeImageURL', protoName: 'payeeImageURL')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'payerName', protoName: 'payerName')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'payerImageURL', protoName: 'payerImageURL')
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transferRequest', protoName: 'transferRequest')
    ..aInt64(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expiry')
    ..a<$core.List<$core.int>>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'preimage', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  InvoiceMemo._() : super();
  factory InvoiceMemo({
    $core.String description,
    $fixnum.Int64 amount,
    $core.String payeeName,
    $core.String payeeImageURL,
    $core.String payerName,
    $core.String payerImageURL,
    $core.bool transferRequest,
    $fixnum.Int64 expiry,
    $core.List<$core.int> preimage,
  }) {
    final _result = create();
    if (description != null) {
      _result.description = description;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (payeeName != null) {
      _result.payeeName = payeeName;
    }
    if (payeeImageURL != null) {
      _result.payeeImageURL = payeeImageURL;
    }
    if (payerName != null) {
      _result.payerName = payerName;
    }
    if (payerImageURL != null) {
      _result.payerImageURL = payerImageURL;
    }
    if (transferRequest != null) {
      _result.transferRequest = transferRequest;
    }
    if (expiry != null) {
      _result.expiry = expiry;
    }
    if (preimage != null) {
      _result.preimage = preimage;
    }
    return _result;
  }
  factory InvoiceMemo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InvoiceMemo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InvoiceMemo clone() => InvoiceMemo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InvoiceMemo copyWith(void Function(InvoiceMemo) updates) => super.copyWith((message) => updates(message as InvoiceMemo)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InvoiceMemo create() => InvoiceMemo._();
  InvoiceMemo createEmptyInstance() => create();
  static $pb.PbList<InvoiceMemo> createRepeated() => $pb.PbList<InvoiceMemo>();
  @$core.pragma('dart2js:noInline')
  static InvoiceMemo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InvoiceMemo>(create);
  static InvoiceMemo _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get description => $_getSZ(0);
  @$pb.TagNumber(1)
  set description($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearDescription() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get amount => $_getI64(1);
  @$pb.TagNumber(2)
  set amount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get payeeName => $_getSZ(2);
  @$pb.TagNumber(3)
  set payeeName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPayeeName() => $_has(2);
  @$pb.TagNumber(3)
  void clearPayeeName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get payeeImageURL => $_getSZ(3);
  @$pb.TagNumber(4)
  set payeeImageURL($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPayeeImageURL() => $_has(3);
  @$pb.TagNumber(4)
  void clearPayeeImageURL() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get payerName => $_getSZ(4);
  @$pb.TagNumber(5)
  set payerName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPayerName() => $_has(4);
  @$pb.TagNumber(5)
  void clearPayerName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get payerImageURL => $_getSZ(5);
  @$pb.TagNumber(6)
  set payerImageURL($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPayerImageURL() => $_has(5);
  @$pb.TagNumber(6)
  void clearPayerImageURL() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get transferRequest => $_getBF(6);
  @$pb.TagNumber(7)
  set transferRequest($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTransferRequest() => $_has(6);
  @$pb.TagNumber(7)
  void clearTransferRequest() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get expiry => $_getI64(7);
  @$pb.TagNumber(8)
  set expiry($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasExpiry() => $_has(7);
  @$pb.TagNumber(8)
  void clearExpiry() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<$core.int> get preimage => $_getN(8);
  @$pb.TagNumber(9)
  set preimage($core.List<$core.int> v) { $_setBytes(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasPreimage() => $_has(8);
  @$pb.TagNumber(9)
  void clearPreimage() => clearField(9);
}

class AddInvoiceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddInvoiceRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOM<InvoiceMemo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'invoiceDetails', protoName: 'invoiceDetails', subBuilder: InvoiceMemo.create)
    ..aOM<LSPInformation>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lspInfo', protoName: 'lspInfo', subBuilder: LSPInformation.create)
    ..hasRequiredFields = false
  ;

  AddInvoiceRequest._() : super();
  factory AddInvoiceRequest({
    InvoiceMemo invoiceDetails,
    LSPInformation lspInfo,
  }) {
    final _result = create();
    if (invoiceDetails != null) {
      _result.invoiceDetails = invoiceDetails;
    }
    if (lspInfo != null) {
      _result.lspInfo = lspInfo;
    }
    return _result;
  }
  factory AddInvoiceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddInvoiceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddInvoiceRequest clone() => AddInvoiceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddInvoiceRequest copyWith(void Function(AddInvoiceRequest) updates) => super.copyWith((message) => updates(message as AddInvoiceRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddInvoiceRequest create() => AddInvoiceRequest._();
  AddInvoiceRequest createEmptyInstance() => create();
  static $pb.PbList<AddInvoiceRequest> createRepeated() => $pb.PbList<AddInvoiceRequest>();
  @$core.pragma('dart2js:noInline')
  static AddInvoiceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddInvoiceRequest>(create);
  static AddInvoiceRequest _defaultInstance;

  @$pb.TagNumber(1)
  InvoiceMemo get invoiceDetails => $_getN(0);
  @$pb.TagNumber(1)
  set invoiceDetails(InvoiceMemo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasInvoiceDetails() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvoiceDetails() => clearField(1);
  @$pb.TagNumber(1)
  InvoiceMemo ensureInvoiceDetails() => $_ensure(0);

  @$pb.TagNumber(2)
  LSPInformation get lspInfo => $_getN(1);
  @$pb.TagNumber(2)
  set lspInfo(LSPInformation v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasLspInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearLspInfo() => clearField(2);
  @$pb.TagNumber(2)
  LSPInformation ensureLspInfo() => $_ensure(1);
}

class Invoice extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Invoice', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOM<InvoiceMemo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'memo', subBuilder: InvoiceMemo.create)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'settled')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amtPaid', protoName: 'amtPaid')
    ..hasRequiredFields = false
  ;

  Invoice._() : super();
  factory Invoice({
    InvoiceMemo memo,
    $core.bool settled,
    $fixnum.Int64 amtPaid,
  }) {
    final _result = create();
    if (memo != null) {
      _result.memo = memo;
    }
    if (settled != null) {
      _result.settled = settled;
    }
    if (amtPaid != null) {
      _result.amtPaid = amtPaid;
    }
    return _result;
  }
  factory Invoice.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Invoice.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Invoice clone() => Invoice()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Invoice copyWith(void Function(Invoice) updates) => super.copyWith((message) => updates(message as Invoice)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Invoice create() => Invoice._();
  Invoice createEmptyInstance() => create();
  static $pb.PbList<Invoice> createRepeated() => $pb.PbList<Invoice>();
  @$core.pragma('dart2js:noInline')
  static Invoice getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Invoice>(create);
  static Invoice _defaultInstance;

  @$pb.TagNumber(1)
  InvoiceMemo get memo => $_getN(0);
  @$pb.TagNumber(1)
  set memo(InvoiceMemo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMemo() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemo() => clearField(1);
  @$pb.TagNumber(1)
  InvoiceMemo ensureMemo() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get settled => $_getBF(1);
  @$pb.TagNumber(2)
  set settled($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSettled() => $_has(1);
  @$pb.TagNumber(2)
  void clearSettled() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get amtPaid => $_getI64(2);
  @$pb.TagNumber(3)
  set amtPaid($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmtPaid() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmtPaid() => clearField(3);
}

class SyncLSPChannelsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SyncLSPChannelsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOM<LSPInformation>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lspInfo', protoName: 'lspInfo', subBuilder: LSPInformation.create)
    ..hasRequiredFields = false
  ;

  SyncLSPChannelsRequest._() : super();
  factory SyncLSPChannelsRequest({
    LSPInformation lspInfo,
  }) {
    final _result = create();
    if (lspInfo != null) {
      _result.lspInfo = lspInfo;
    }
    return _result;
  }
  factory SyncLSPChannelsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncLSPChannelsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncLSPChannelsRequest clone() => SyncLSPChannelsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncLSPChannelsRequest copyWith(void Function(SyncLSPChannelsRequest) updates) => super.copyWith((message) => updates(message as SyncLSPChannelsRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SyncLSPChannelsRequest create() => SyncLSPChannelsRequest._();
  SyncLSPChannelsRequest createEmptyInstance() => create();
  static $pb.PbList<SyncLSPChannelsRequest> createRepeated() => $pb.PbList<SyncLSPChannelsRequest>();
  @$core.pragma('dart2js:noInline')
  static SyncLSPChannelsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncLSPChannelsRequest>(create);
  static SyncLSPChannelsRequest _defaultInstance;

  @$pb.TagNumber(1)
  LSPInformation get lspInfo => $_getN(0);
  @$pb.TagNumber(1)
  set lspInfo(LSPInformation v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLspInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearLspInfo() => clearField(1);
  @$pb.TagNumber(1)
  LSPInformation ensureLspInfo() => $_ensure(0);
}

class SyncLSPChannelsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SyncLSPChannelsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hasMismatch', protoName: 'hasMismatch')
    ..hasRequiredFields = false
  ;

  SyncLSPChannelsResponse._() : super();
  factory SyncLSPChannelsResponse({
    $core.bool hasMismatch,
  }) {
    final _result = create();
    if (hasMismatch != null) {
      _result.hasMismatch = hasMismatch;
    }
    return _result;
  }
  factory SyncLSPChannelsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncLSPChannelsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncLSPChannelsResponse clone() => SyncLSPChannelsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncLSPChannelsResponse copyWith(void Function(SyncLSPChannelsResponse) updates) => super.copyWith((message) => updates(message as SyncLSPChannelsResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SyncLSPChannelsResponse create() => SyncLSPChannelsResponse._();
  SyncLSPChannelsResponse createEmptyInstance() => create();
  static $pb.PbList<SyncLSPChannelsResponse> createRepeated() => $pb.PbList<SyncLSPChannelsResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncLSPChannelsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncLSPChannelsResponse>(create);
  static SyncLSPChannelsResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get hasMismatch => $_getBF(0);
  @$pb.TagNumber(1)
  set hasMismatch($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHasMismatch() => $_has(0);
  @$pb.TagNumber(1)
  void clearHasMismatch() => clearField(1);
}

class UnconfirmedChannelsStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UnconfirmedChannelsStatus', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..pc<UnconfirmedChannelStatus>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'statuses', $pb.PbFieldType.PM, subBuilder: UnconfirmedChannelStatus.create)
    ..hasRequiredFields = false
  ;

  UnconfirmedChannelsStatus._() : super();
  factory UnconfirmedChannelsStatus({
    $core.Iterable<UnconfirmedChannelStatus> statuses,
  }) {
    final _result = create();
    if (statuses != null) {
      _result.statuses.addAll(statuses);
    }
    return _result;
  }
  factory UnconfirmedChannelsStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnconfirmedChannelsStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnconfirmedChannelsStatus clone() => UnconfirmedChannelsStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnconfirmedChannelsStatus copyWith(void Function(UnconfirmedChannelsStatus) updates) => super.copyWith((message) => updates(message as UnconfirmedChannelsStatus)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UnconfirmedChannelsStatus create() => UnconfirmedChannelsStatus._();
  UnconfirmedChannelsStatus createEmptyInstance() => create();
  static $pb.PbList<UnconfirmedChannelsStatus> createRepeated() => $pb.PbList<UnconfirmedChannelsStatus>();
  @$core.pragma('dart2js:noInline')
  static UnconfirmedChannelsStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnconfirmedChannelsStatus>(create);
  static UnconfirmedChannelsStatus _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<UnconfirmedChannelStatus> get statuses => $_getList(0);
}

class UnconfirmedChannelStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UnconfirmedChannelStatus', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'channelPoint', protoName: 'channelPoint')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'heightHint', protoName: 'heightHint')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lspConfirmedHeight', protoName: 'lspConfirmedHeight')
    ..hasRequiredFields = false
  ;

  UnconfirmedChannelStatus._() : super();
  factory UnconfirmedChannelStatus({
    $core.String channelPoint,
    $fixnum.Int64 heightHint,
    $fixnum.Int64 lspConfirmedHeight,
  }) {
    final _result = create();
    if (channelPoint != null) {
      _result.channelPoint = channelPoint;
    }
    if (heightHint != null) {
      _result.heightHint = heightHint;
    }
    if (lspConfirmedHeight != null) {
      _result.lspConfirmedHeight = lspConfirmedHeight;
    }
    return _result;
  }
  factory UnconfirmedChannelStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnconfirmedChannelStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnconfirmedChannelStatus clone() => UnconfirmedChannelStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnconfirmedChannelStatus copyWith(void Function(UnconfirmedChannelStatus) updates) => super.copyWith((message) => updates(message as UnconfirmedChannelStatus)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UnconfirmedChannelStatus create() => UnconfirmedChannelStatus._();
  UnconfirmedChannelStatus createEmptyInstance() => create();
  static $pb.PbList<UnconfirmedChannelStatus> createRepeated() => $pb.PbList<UnconfirmedChannelStatus>();
  @$core.pragma('dart2js:noInline')
  static UnconfirmedChannelStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnconfirmedChannelStatus>(create);
  static UnconfirmedChannelStatus _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelPoint => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelPoint($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChannelPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelPoint() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get heightHint => $_getI64(1);
  @$pb.TagNumber(2)
  set heightHint($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeightHint() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeightHint() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get lspConfirmedHeight => $_getI64(2);
  @$pb.TagNumber(3)
  set lspConfirmedHeight($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLspConfirmedHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearLspConfirmedHeight() => clearField(3);
}

class CheckLSPClosedChannelMismatchRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CheckLSPClosedChannelMismatchRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOM<LSPInformation>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lspInfo', protoName: 'lspInfo', subBuilder: LSPInformation.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chanPoint', protoName: 'chanPoint')
    ..hasRequiredFields = false
  ;

  CheckLSPClosedChannelMismatchRequest._() : super();
  factory CheckLSPClosedChannelMismatchRequest({
    LSPInformation lspInfo,
    $core.String chanPoint,
  }) {
    final _result = create();
    if (lspInfo != null) {
      _result.lspInfo = lspInfo;
    }
    if (chanPoint != null) {
      _result.chanPoint = chanPoint;
    }
    return _result;
  }
  factory CheckLSPClosedChannelMismatchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CheckLSPClosedChannelMismatchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CheckLSPClosedChannelMismatchRequest clone() => CheckLSPClosedChannelMismatchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CheckLSPClosedChannelMismatchRequest copyWith(void Function(CheckLSPClosedChannelMismatchRequest) updates) => super.copyWith((message) => updates(message as CheckLSPClosedChannelMismatchRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CheckLSPClosedChannelMismatchRequest create() => CheckLSPClosedChannelMismatchRequest._();
  CheckLSPClosedChannelMismatchRequest createEmptyInstance() => create();
  static $pb.PbList<CheckLSPClosedChannelMismatchRequest> createRepeated() => $pb.PbList<CheckLSPClosedChannelMismatchRequest>();
  @$core.pragma('dart2js:noInline')
  static CheckLSPClosedChannelMismatchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckLSPClosedChannelMismatchRequest>(create);
  static CheckLSPClosedChannelMismatchRequest _defaultInstance;

  @$pb.TagNumber(1)
  LSPInformation get lspInfo => $_getN(0);
  @$pb.TagNumber(1)
  set lspInfo(LSPInformation v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLspInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearLspInfo() => clearField(1);
  @$pb.TagNumber(1)
  LSPInformation ensureLspInfo() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get chanPoint => $_getSZ(1);
  @$pb.TagNumber(2)
  set chanPoint($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasChanPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearChanPoint() => clearField(2);
}

class CheckLSPClosedChannelMismatchResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CheckLSPClosedChannelMismatchResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mismatch')
    ..hasRequiredFields = false
  ;

  CheckLSPClosedChannelMismatchResponse._() : super();
  factory CheckLSPClosedChannelMismatchResponse({
    $core.bool mismatch,
  }) {
    final _result = create();
    if (mismatch != null) {
      _result.mismatch = mismatch;
    }
    return _result;
  }
  factory CheckLSPClosedChannelMismatchResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CheckLSPClosedChannelMismatchResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CheckLSPClosedChannelMismatchResponse clone() => CheckLSPClosedChannelMismatchResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CheckLSPClosedChannelMismatchResponse copyWith(void Function(CheckLSPClosedChannelMismatchResponse) updates) => super.copyWith((message) => updates(message as CheckLSPClosedChannelMismatchResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CheckLSPClosedChannelMismatchResponse create() => CheckLSPClosedChannelMismatchResponse._();
  CheckLSPClosedChannelMismatchResponse createEmptyInstance() => create();
  static $pb.PbList<CheckLSPClosedChannelMismatchResponse> createRepeated() => $pb.PbList<CheckLSPClosedChannelMismatchResponse>();
  @$core.pragma('dart2js:noInline')
  static CheckLSPClosedChannelMismatchResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckLSPClosedChannelMismatchResponse>(create);
  static CheckLSPClosedChannelMismatchResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get mismatch => $_getBF(0);
  @$pb.TagNumber(1)
  set mismatch($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMismatch() => $_has(0);
  @$pb.TagNumber(1)
  void clearMismatch() => clearField(1);
}

class ResetClosedChannelChainInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ResetClosedChannelChainInfoRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chanPoint', protoName: 'chanPoint')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockHeight', protoName: 'blockHeight')
    ..hasRequiredFields = false
  ;

  ResetClosedChannelChainInfoRequest._() : super();
  factory ResetClosedChannelChainInfoRequest({
    $core.String chanPoint,
    $fixnum.Int64 blockHeight,
  }) {
    final _result = create();
    if (chanPoint != null) {
      _result.chanPoint = chanPoint;
    }
    if (blockHeight != null) {
      _result.blockHeight = blockHeight;
    }
    return _result;
  }
  factory ResetClosedChannelChainInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResetClosedChannelChainInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResetClosedChannelChainInfoRequest clone() => ResetClosedChannelChainInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResetClosedChannelChainInfoRequest copyWith(void Function(ResetClosedChannelChainInfoRequest) updates) => super.copyWith((message) => updates(message as ResetClosedChannelChainInfoRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ResetClosedChannelChainInfoRequest create() => ResetClosedChannelChainInfoRequest._();
  ResetClosedChannelChainInfoRequest createEmptyInstance() => create();
  static $pb.PbList<ResetClosedChannelChainInfoRequest> createRepeated() => $pb.PbList<ResetClosedChannelChainInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static ResetClosedChannelChainInfoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResetClosedChannelChainInfoRequest>(create);
  static ResetClosedChannelChainInfoRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get chanPoint => $_getSZ(0);
  @$pb.TagNumber(1)
  set chanPoint($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChanPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearChanPoint() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get blockHeight => $_getI64(1);
  @$pb.TagNumber(2)
  set blockHeight($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBlockHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearBlockHeight() => clearField(2);
}

class ResetClosedChannelChainInfoReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ResetClosedChannelChainInfoReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  ResetClosedChannelChainInfoReply._() : super();
  factory ResetClosedChannelChainInfoReply() => create();
  factory ResetClosedChannelChainInfoReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResetClosedChannelChainInfoReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResetClosedChannelChainInfoReply clone() => ResetClosedChannelChainInfoReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResetClosedChannelChainInfoReply copyWith(void Function(ResetClosedChannelChainInfoReply) updates) => super.copyWith((message) => updates(message as ResetClosedChannelChainInfoReply)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ResetClosedChannelChainInfoReply create() => ResetClosedChannelChainInfoReply._();
  ResetClosedChannelChainInfoReply createEmptyInstance() => create();
  static $pb.PbList<ResetClosedChannelChainInfoReply> createRepeated() => $pb.PbList<ResetClosedChannelChainInfoReply>();
  @$core.pragma('dart2js:noInline')
  static ResetClosedChannelChainInfoReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResetClosedChannelChainInfoReply>(create);
  static ResetClosedChannelChainInfoReply _defaultInstance;
}

class NotificationEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NotificationEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..e<NotificationEvent_NotificationType>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: NotificationEvent_NotificationType.READY, valueOf: NotificationEvent_NotificationType.valueOf, enumValues: NotificationEvent_NotificationType.values)
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data')
    ..hasRequiredFields = false
  ;

  NotificationEvent._() : super();
  factory NotificationEvent({
    NotificationEvent_NotificationType type,
    $core.Iterable<$core.String> data,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (data != null) {
      _result.data.addAll(data);
    }
    return _result;
  }
  factory NotificationEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NotificationEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NotificationEvent clone() => NotificationEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NotificationEvent copyWith(void Function(NotificationEvent) updates) => super.copyWith((message) => updates(message as NotificationEvent)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NotificationEvent create() => NotificationEvent._();
  NotificationEvent createEmptyInstance() => create();
  static $pb.PbList<NotificationEvent> createRepeated() => $pb.PbList<NotificationEvent>();
  @$core.pragma('dart2js:noInline')
  static NotificationEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NotificationEvent>(create);
  static NotificationEvent _defaultInstance;

  @$pb.TagNumber(1)
  NotificationEvent_NotificationType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(NotificationEvent_NotificationType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get data => $_getList(1);
}

class AddFundInitReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddFundInitReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxAllowedDeposit', protoName: 'maxAllowedDeposit')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMessage', protoName: 'errorMessage')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backupJson', protoName: 'backupJson')
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'requiredReserve', protoName: 'requiredReserve')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minAllowedDeposit', protoName: 'minAllowedDeposit')
    ..hasRequiredFields = false
  ;

  AddFundInitReply._() : super();
  factory AddFundInitReply({
    $core.String address,
    $fixnum.Int64 maxAllowedDeposit,
    $core.String errorMessage,
    $core.String backupJson,
    $fixnum.Int64 requiredReserve,
    $fixnum.Int64 minAllowedDeposit,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (maxAllowedDeposit != null) {
      _result.maxAllowedDeposit = maxAllowedDeposit;
    }
    if (errorMessage != null) {
      _result.errorMessage = errorMessage;
    }
    if (backupJson != null) {
      _result.backupJson = backupJson;
    }
    if (requiredReserve != null) {
      _result.requiredReserve = requiredReserve;
    }
    if (minAllowedDeposit != null) {
      _result.minAllowedDeposit = minAllowedDeposit;
    }
    return _result;
  }
  factory AddFundInitReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundInitReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddFundInitReply clone() => AddFundInitReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddFundInitReply copyWith(void Function(AddFundInitReply) updates) => super.copyWith((message) => updates(message as AddFundInitReply)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddFundInitReply create() => AddFundInitReply._();
  AddFundInitReply createEmptyInstance() => create();
  static $pb.PbList<AddFundInitReply> createRepeated() => $pb.PbList<AddFundInitReply>();
  @$core.pragma('dart2js:noInline')
  static AddFundInitReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddFundInitReply>(create);
  static AddFundInitReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxAllowedDeposit => $_getI64(1);
  @$pb.TagNumber(2)
  set maxAllowedDeposit($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaxAllowedDeposit() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxAllowedDeposit() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get errorMessage => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorMessage($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasErrorMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorMessage() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get backupJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set backupJson($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBackupJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearBackupJson() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get requiredReserve => $_getI64(4);
  @$pb.TagNumber(5)
  set requiredReserve($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRequiredReserve() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequiredReserve() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get minAllowedDeposit => $_getI64(5);
  @$pb.TagNumber(6)
  set minAllowedDeposit($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMinAllowedDeposit() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinAllowedDeposit() => clearField(6);
}

class AddFundReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddFundReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMessage', protoName: 'errorMessage')
    ..hasRequiredFields = false
  ;

  AddFundReply._() : super();
  factory AddFundReply({
    $core.String errorMessage,
  }) {
    final _result = create();
    if (errorMessage != null) {
      _result.errorMessage = errorMessage;
    }
    return _result;
  }
  factory AddFundReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddFundReply clone() => AddFundReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddFundReply copyWith(void Function(AddFundReply) updates) => super.copyWith((message) => updates(message as AddFundReply)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddFundReply create() => AddFundReply._();
  AddFundReply createEmptyInstance() => create();
  static $pb.PbList<AddFundReply> createRepeated() => $pb.PbList<AddFundReply>();
  @$core.pragma('dart2js:noInline')
  static AddFundReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddFundReply>(create);
  static AddFundReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get errorMessage => $_getSZ(0);
  @$pb.TagNumber(1)
  set errorMessage($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasErrorMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorMessage() => clearField(1);
}

class RefundRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RefundRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'refundAddress', protoName: 'refundAddress')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetConf', $pb.PbFieldType.O3)
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'satPerByte')
    ..hasRequiredFields = false
  ;

  RefundRequest._() : super();
  factory RefundRequest({
    $core.String address,
    $core.String refundAddress,
    $core.int targetConf,
    $fixnum.Int64 satPerByte,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (refundAddress != null) {
      _result.refundAddress = refundAddress;
    }
    if (targetConf != null) {
      _result.targetConf = targetConf;
    }
    if (satPerByte != null) {
      _result.satPerByte = satPerByte;
    }
    return _result;
  }
  factory RefundRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RefundRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RefundRequest clone() => RefundRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RefundRequest copyWith(void Function(RefundRequest) updates) => super.copyWith((message) => updates(message as RefundRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RefundRequest create() => RefundRequest._();
  RefundRequest createEmptyInstance() => create();
  static $pb.PbList<RefundRequest> createRepeated() => $pb.PbList<RefundRequest>();
  @$core.pragma('dart2js:noInline')
  static RefundRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RefundRequest>(create);
  static RefundRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get refundAddress => $_getSZ(1);
  @$pb.TagNumber(2)
  set refundAddress($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRefundAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearRefundAddress() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get targetConf => $_getIZ(2);
  @$pb.TagNumber(3)
  set targetConf($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTargetConf() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetConf() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get satPerByte => $_getI64(3);
  @$pb.TagNumber(4)
  set satPerByte($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSatPerByte() => $_has(3);
  @$pb.TagNumber(4)
  void clearSatPerByte() => clearField(4);
}

class AddFundError extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddFundError', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOM<SwapAddressInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapAddressInfo', protoName: 'swapAddressInfo', subBuilder: SwapAddressInfo.create)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hoursToUnlock', $pb.PbFieldType.OF, protoName: 'hoursToUnlock')
    ..hasRequiredFields = false
  ;

  AddFundError._() : super();
  factory AddFundError({
    SwapAddressInfo swapAddressInfo,
    $core.double hoursToUnlock,
  }) {
    final _result = create();
    if (swapAddressInfo != null) {
      _result.swapAddressInfo = swapAddressInfo;
    }
    if (hoursToUnlock != null) {
      _result.hoursToUnlock = hoursToUnlock;
    }
    return _result;
  }
  factory AddFundError.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundError.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddFundError clone() => AddFundError()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddFundError copyWith(void Function(AddFundError) updates) => super.copyWith((message) => updates(message as AddFundError)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddFundError create() => AddFundError._();
  AddFundError createEmptyInstance() => create();
  static $pb.PbList<AddFundError> createRepeated() => $pb.PbList<AddFundError>();
  @$core.pragma('dart2js:noInline')
  static AddFundError getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddFundError>(create);
  static AddFundError _defaultInstance;

  @$pb.TagNumber(1)
  SwapAddressInfo get swapAddressInfo => $_getN(0);
  @$pb.TagNumber(1)
  set swapAddressInfo(SwapAddressInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSwapAddressInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearSwapAddressInfo() => clearField(1);
  @$pb.TagNumber(1)
  SwapAddressInfo ensureSwapAddressInfo() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get hoursToUnlock => $_getN(1);
  @$pb.TagNumber(2)
  set hoursToUnlock($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHoursToUnlock() => $_has(1);
  @$pb.TagNumber(2)
  void clearHoursToUnlock() => clearField(2);
}

class FundStatusReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FundStatusReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..pc<SwapAddressInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'unConfirmedAddresses', $pb.PbFieldType.PM, protoName: 'unConfirmedAddresses', subBuilder: SwapAddressInfo.create)
    ..pc<SwapAddressInfo>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'confirmedAddresses', $pb.PbFieldType.PM, protoName: 'confirmedAddresses', subBuilder: SwapAddressInfo.create)
    ..pc<SwapAddressInfo>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'refundableAddresses', $pb.PbFieldType.PM, protoName: 'refundableAddresses', subBuilder: SwapAddressInfo.create)
    ..hasRequiredFields = false
  ;

  FundStatusReply._() : super();
  factory FundStatusReply({
    $core.Iterable<SwapAddressInfo> unConfirmedAddresses,
    $core.Iterable<SwapAddressInfo> confirmedAddresses,
    $core.Iterable<SwapAddressInfo> refundableAddresses,
  }) {
    final _result = create();
    if (unConfirmedAddresses != null) {
      _result.unConfirmedAddresses.addAll(unConfirmedAddresses);
    }
    if (confirmedAddresses != null) {
      _result.confirmedAddresses.addAll(confirmedAddresses);
    }
    if (refundableAddresses != null) {
      _result.refundableAddresses.addAll(refundableAddresses);
    }
    return _result;
  }
  factory FundStatusReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FundStatusReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FundStatusReply clone() => FundStatusReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FundStatusReply copyWith(void Function(FundStatusReply) updates) => super.copyWith((message) => updates(message as FundStatusReply)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FundStatusReply create() => FundStatusReply._();
  FundStatusReply createEmptyInstance() => create();
  static $pb.PbList<FundStatusReply> createRepeated() => $pb.PbList<FundStatusReply>();
  @$core.pragma('dart2js:noInline')
  static FundStatusReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FundStatusReply>(create);
  static FundStatusReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SwapAddressInfo> get unConfirmedAddresses => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<SwapAddressInfo> get confirmedAddresses => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<SwapAddressInfo> get refundableAddresses => $_getList(2);
}

class RemoveFundRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemoveFundRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..hasRequiredFields = false
  ;

  RemoveFundRequest._() : super();
  factory RemoveFundRequest({
    $core.String address,
    $fixnum.Int64 amount,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    return _result;
  }
  factory RemoveFundRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveFundRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveFundRequest clone() => RemoveFundRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveFundRequest copyWith(void Function(RemoveFundRequest) updates) => super.copyWith((message) => updates(message as RemoveFundRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemoveFundRequest create() => RemoveFundRequest._();
  RemoveFundRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveFundRequest> createRepeated() => $pb.PbList<RemoveFundRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveFundRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveFundRequest>(create);
  static RemoveFundRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get amount => $_getI64(1);
  @$pb.TagNumber(2)
  set amount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);
}

class RemoveFundReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemoveFundReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMessage', protoName: 'errorMessage')
    ..hasRequiredFields = false
  ;

  RemoveFundReply._() : super();
  factory RemoveFundReply({
    $core.String txid,
    $core.String errorMessage,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    if (errorMessage != null) {
      _result.errorMessage = errorMessage;
    }
    return _result;
  }
  factory RemoveFundReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveFundReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveFundReply clone() => RemoveFundReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveFundReply copyWith(void Function(RemoveFundReply) updates) => super.copyWith((message) => updates(message as RemoveFundReply)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemoveFundReply create() => RemoveFundReply._();
  RemoveFundReply createEmptyInstance() => create();
  static $pb.PbList<RemoveFundReply> createRepeated() => $pb.PbList<RemoveFundReply>();
  @$core.pragma('dart2js:noInline')
  static RemoveFundReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveFundReply>(create);
  static RemoveFundReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => clearField(2);
}

class SwapAddressInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SwapAddressInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'PaymentHash', protoName: 'PaymentHash')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ConfirmedAmount', protoName: 'ConfirmedAmount')
    ..pPS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ConfirmedTransactionIds', protoName: 'ConfirmedTransactionIds')
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'PaidAmount', protoName: 'PaidAmount')
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lockHeight', $pb.PbFieldType.OU3, protoName: 'lockHeight')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMessage', protoName: 'errorMessage')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastRefundTxID', protoName: 'lastRefundTxID')
    ..e<SwapError>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapError', $pb.PbFieldType.OE, protoName: 'swapError', defaultOrMaker: SwapError.NO_ERROR, valueOf: SwapError.valueOf, enumValues: SwapError.values)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'FundingTxID', protoName: 'FundingTxID')
    ..a<$core.double>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hoursToUnlock', $pb.PbFieldType.OF, protoName: 'hoursToUnlock')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nonBlocking', protoName: 'nonBlocking')
    ..hasRequiredFields = false
  ;

  SwapAddressInfo._() : super();
  factory SwapAddressInfo({
    $core.String address,
    $core.String paymentHash,
    $fixnum.Int64 confirmedAmount,
    $core.Iterable<$core.String> confirmedTransactionIds,
    $fixnum.Int64 paidAmount,
    $core.int lockHeight,
    $core.String errorMessage,
    $core.String lastRefundTxID,
    SwapError swapError,
    $core.String fundingTxID,
    $core.double hoursToUnlock,
    $core.bool nonBlocking,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (paymentHash != null) {
      _result.paymentHash = paymentHash;
    }
    if (confirmedAmount != null) {
      _result.confirmedAmount = confirmedAmount;
    }
    if (confirmedTransactionIds != null) {
      _result.confirmedTransactionIds.addAll(confirmedTransactionIds);
    }
    if (paidAmount != null) {
      _result.paidAmount = paidAmount;
    }
    if (lockHeight != null) {
      _result.lockHeight = lockHeight;
    }
    if (errorMessage != null) {
      _result.errorMessage = errorMessage;
    }
    if (lastRefundTxID != null) {
      _result.lastRefundTxID = lastRefundTxID;
    }
    if (swapError != null) {
      _result.swapError = swapError;
    }
    if (fundingTxID != null) {
      _result.fundingTxID = fundingTxID;
    }
    if (hoursToUnlock != null) {
      _result.hoursToUnlock = hoursToUnlock;
    }
    if (nonBlocking != null) {
      _result.nonBlocking = nonBlocking;
    }
    return _result;
  }
  factory SwapAddressInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SwapAddressInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SwapAddressInfo clone() => SwapAddressInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SwapAddressInfo copyWith(void Function(SwapAddressInfo) updates) => super.copyWith((message) => updates(message as SwapAddressInfo)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SwapAddressInfo create() => SwapAddressInfo._();
  SwapAddressInfo createEmptyInstance() => create();
  static $pb.PbList<SwapAddressInfo> createRepeated() => $pb.PbList<SwapAddressInfo>();
  @$core.pragma('dart2js:noInline')
  static SwapAddressInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SwapAddressInfo>(create);
  static SwapAddressInfo _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get paymentHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set paymentHash($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPaymentHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaymentHash() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get confirmedAmount => $_getI64(2);
  @$pb.TagNumber(3)
  set confirmedAmount($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasConfirmedAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfirmedAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.String> get confirmedTransactionIds => $_getList(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get paidAmount => $_getI64(4);
  @$pb.TagNumber(5)
  set paidAmount($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPaidAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearPaidAmount() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get lockHeight => $_getIZ(5);
  @$pb.TagNumber(6)
  set lockHeight($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLockHeight() => $_has(5);
  @$pb.TagNumber(6)
  void clearLockHeight() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get errorMessage => $_getSZ(6);
  @$pb.TagNumber(7)
  set errorMessage($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasErrorMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearErrorMessage() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get lastRefundTxID => $_getSZ(7);
  @$pb.TagNumber(8)
  set lastRefundTxID($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasLastRefundTxID() => $_has(7);
  @$pb.TagNumber(8)
  void clearLastRefundTxID() => clearField(8);

  @$pb.TagNumber(9)
  SwapError get swapError => $_getN(8);
  @$pb.TagNumber(9)
  set swapError(SwapError v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasSwapError() => $_has(8);
  @$pb.TagNumber(9)
  void clearSwapError() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get fundingTxID => $_getSZ(9);
  @$pb.TagNumber(10)
  set fundingTxID($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasFundingTxID() => $_has(9);
  @$pb.TagNumber(10)
  void clearFundingTxID() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get hoursToUnlock => $_getN(10);
  @$pb.TagNumber(11)
  set hoursToUnlock($core.double v) { $_setFloat(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasHoursToUnlock() => $_has(10);
  @$pb.TagNumber(11)
  void clearHoursToUnlock() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get nonBlocking => $_getBF(11);
  @$pb.TagNumber(12)
  set nonBlocking($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasNonBlocking() => $_has(11);
  @$pb.TagNumber(12)
  void clearNonBlocking() => clearField(12);
}

class SwapAddressList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SwapAddressList', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..pc<SwapAddressInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addresses', $pb.PbFieldType.PM, subBuilder: SwapAddressInfo.create)
    ..hasRequiredFields = false
  ;

  SwapAddressList._() : super();
  factory SwapAddressList({
    $core.Iterable<SwapAddressInfo> addresses,
  }) {
    final _result = create();
    if (addresses != null) {
      _result.addresses.addAll(addresses);
    }
    return _result;
  }
  factory SwapAddressList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SwapAddressList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SwapAddressList clone() => SwapAddressList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SwapAddressList copyWith(void Function(SwapAddressList) updates) => super.copyWith((message) => updates(message as SwapAddressList)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SwapAddressList create() => SwapAddressList._();
  SwapAddressList createEmptyInstance() => create();
  static $pb.PbList<SwapAddressList> createRepeated() => $pb.PbList<SwapAddressList>();
  @$core.pragma('dart2js:noInline')
  static SwapAddressList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SwapAddressList>(create);
  static SwapAddressList _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SwapAddressInfo> get addresses => $_getList(0);
}

class CreateRatchetSessionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateRatchetSessionRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'secret')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'remotePubKey', protoName: 'remotePubKey')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionID', protoName: 'sessionID')
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expiry', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  CreateRatchetSessionRequest._() : super();
  factory CreateRatchetSessionRequest({
    $core.String secret,
    $core.String remotePubKey,
    $core.String sessionID,
    $fixnum.Int64 expiry,
  }) {
    final _result = create();
    if (secret != null) {
      _result.secret = secret;
    }
    if (remotePubKey != null) {
      _result.remotePubKey = remotePubKey;
    }
    if (sessionID != null) {
      _result.sessionID = sessionID;
    }
    if (expiry != null) {
      _result.expiry = expiry;
    }
    return _result;
  }
  factory CreateRatchetSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateRatchetSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateRatchetSessionRequest clone() => CreateRatchetSessionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateRatchetSessionRequest copyWith(void Function(CreateRatchetSessionRequest) updates) => super.copyWith((message) => updates(message as CreateRatchetSessionRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateRatchetSessionRequest create() => CreateRatchetSessionRequest._();
  CreateRatchetSessionRequest createEmptyInstance() => create();
  static $pb.PbList<CreateRatchetSessionRequest> createRepeated() => $pb.PbList<CreateRatchetSessionRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateRatchetSessionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRatchetSessionRequest>(create);
  static CreateRatchetSessionRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get secret => $_getSZ(0);
  @$pb.TagNumber(1)
  set secret($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSecret() => $_has(0);
  @$pb.TagNumber(1)
  void clearSecret() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get remotePubKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set remotePubKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRemotePubKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemotePubKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get sessionID => $_getSZ(2);
  @$pb.TagNumber(3)
  set sessionID($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSessionID() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionID() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiry => $_getI64(3);
  @$pb.TagNumber(4)
  set expiry($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasExpiry() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiry() => clearField(4);
}

class CreateRatchetSessionReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateRatchetSessionReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionID', protoName: 'sessionID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'secret')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubKey', protoName: 'pubKey')
    ..hasRequiredFields = false
  ;

  CreateRatchetSessionReply._() : super();
  factory CreateRatchetSessionReply({
    $core.String sessionID,
    $core.String secret,
    $core.String pubKey,
  }) {
    final _result = create();
    if (sessionID != null) {
      _result.sessionID = sessionID;
    }
    if (secret != null) {
      _result.secret = secret;
    }
    if (pubKey != null) {
      _result.pubKey = pubKey;
    }
    return _result;
  }
  factory CreateRatchetSessionReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateRatchetSessionReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateRatchetSessionReply clone() => CreateRatchetSessionReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateRatchetSessionReply copyWith(void Function(CreateRatchetSessionReply) updates) => super.copyWith((message) => updates(message as CreateRatchetSessionReply)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateRatchetSessionReply create() => CreateRatchetSessionReply._();
  CreateRatchetSessionReply createEmptyInstance() => create();
  static $pb.PbList<CreateRatchetSessionReply> createRepeated() => $pb.PbList<CreateRatchetSessionReply>();
  @$core.pragma('dart2js:noInline')
  static CreateRatchetSessionReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRatchetSessionReply>(create);
  static CreateRatchetSessionReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionID => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get secret => $_getSZ(1);
  @$pb.TagNumber(2)
  set secret($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearSecret() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get pubKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set pubKey($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPubKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearPubKey() => clearField(3);
}

class RatchetSessionInfoReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RatchetSessionInfoReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionID', protoName: 'sessionID')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'initiated')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userInfo', protoName: 'userInfo')
    ..hasRequiredFields = false
  ;

  RatchetSessionInfoReply._() : super();
  factory RatchetSessionInfoReply({
    $core.String sessionID,
    $core.bool initiated,
    $core.String userInfo,
  }) {
    final _result = create();
    if (sessionID != null) {
      _result.sessionID = sessionID;
    }
    if (initiated != null) {
      _result.initiated = initiated;
    }
    if (userInfo != null) {
      _result.userInfo = userInfo;
    }
    return _result;
  }
  factory RatchetSessionInfoReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RatchetSessionInfoReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RatchetSessionInfoReply clone() => RatchetSessionInfoReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RatchetSessionInfoReply copyWith(void Function(RatchetSessionInfoReply) updates) => super.copyWith((message) => updates(message as RatchetSessionInfoReply)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RatchetSessionInfoReply create() => RatchetSessionInfoReply._();
  RatchetSessionInfoReply createEmptyInstance() => create();
  static $pb.PbList<RatchetSessionInfoReply> createRepeated() => $pb.PbList<RatchetSessionInfoReply>();
  @$core.pragma('dart2js:noInline')
  static RatchetSessionInfoReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RatchetSessionInfoReply>(create);
  static RatchetSessionInfoReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionID => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionID() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get initiated => $_getBF(1);
  @$pb.TagNumber(2)
  set initiated($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInitiated() => $_has(1);
  @$pb.TagNumber(2)
  void clearInitiated() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get userInfo => $_getSZ(2);
  @$pb.TagNumber(3)
  set userInfo($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUserInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserInfo() => clearField(3);
}

class RatchetSessionSetInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RatchetSessionSetInfoRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionID', protoName: 'sessionID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userInfo', protoName: 'userInfo')
    ..hasRequiredFields = false
  ;

  RatchetSessionSetInfoRequest._() : super();
  factory RatchetSessionSetInfoRequest({
    $core.String sessionID,
    $core.String userInfo,
  }) {
    final _result = create();
    if (sessionID != null) {
      _result.sessionID = sessionID;
    }
    if (userInfo != null) {
      _result.userInfo = userInfo;
    }
    return _result;
  }
  factory RatchetSessionSetInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RatchetSessionSetInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RatchetSessionSetInfoRequest clone() => RatchetSessionSetInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RatchetSessionSetInfoRequest copyWith(void Function(RatchetSessionSetInfoRequest) updates) => super.copyWith((message) => updates(message as RatchetSessionSetInfoRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RatchetSessionSetInfoRequest create() => RatchetSessionSetInfoRequest._();
  RatchetSessionSetInfoRequest createEmptyInstance() => create();
  static $pb.PbList<RatchetSessionSetInfoRequest> createRepeated() => $pb.PbList<RatchetSessionSetInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static RatchetSessionSetInfoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RatchetSessionSetInfoRequest>(create);
  static RatchetSessionSetInfoRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionID => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userInfo => $_getSZ(1);
  @$pb.TagNumber(2)
  set userInfo($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserInfo() => clearField(2);
}

class RatchetEncryptRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RatchetEncryptRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionID', protoName: 'sessionID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  RatchetEncryptRequest._() : super();
  factory RatchetEncryptRequest({
    $core.String sessionID,
    $core.String message,
  }) {
    final _result = create();
    if (sessionID != null) {
      _result.sessionID = sessionID;
    }
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory RatchetEncryptRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RatchetEncryptRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RatchetEncryptRequest clone() => RatchetEncryptRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RatchetEncryptRequest copyWith(void Function(RatchetEncryptRequest) updates) => super.copyWith((message) => updates(message as RatchetEncryptRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RatchetEncryptRequest create() => RatchetEncryptRequest._();
  RatchetEncryptRequest createEmptyInstance() => create();
  static $pb.PbList<RatchetEncryptRequest> createRepeated() => $pb.PbList<RatchetEncryptRequest>();
  @$core.pragma('dart2js:noInline')
  static RatchetEncryptRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RatchetEncryptRequest>(create);
  static RatchetEncryptRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionID => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class RatchetDecryptRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RatchetDecryptRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionID', protoName: 'sessionID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'encryptedMessage', protoName: 'encryptedMessage')
    ..hasRequiredFields = false
  ;

  RatchetDecryptRequest._() : super();
  factory RatchetDecryptRequest({
    $core.String sessionID,
    $core.String encryptedMessage,
  }) {
    final _result = create();
    if (sessionID != null) {
      _result.sessionID = sessionID;
    }
    if (encryptedMessage != null) {
      _result.encryptedMessage = encryptedMessage;
    }
    return _result;
  }
  factory RatchetDecryptRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RatchetDecryptRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RatchetDecryptRequest clone() => RatchetDecryptRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RatchetDecryptRequest copyWith(void Function(RatchetDecryptRequest) updates) => super.copyWith((message) => updates(message as RatchetDecryptRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RatchetDecryptRequest create() => RatchetDecryptRequest._();
  RatchetDecryptRequest createEmptyInstance() => create();
  static $pb.PbList<RatchetDecryptRequest> createRepeated() => $pb.PbList<RatchetDecryptRequest>();
  @$core.pragma('dart2js:noInline')
  static RatchetDecryptRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RatchetDecryptRequest>(create);
  static RatchetDecryptRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionID => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get encryptedMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set encryptedMessage($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEncryptedMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncryptedMessage() => clearField(2);
}

class BootstrapFilesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BootstrapFilesRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'WorkingDir', protoName: 'WorkingDir')
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'FullPaths', protoName: 'FullPaths')
    ..hasRequiredFields = false
  ;

  BootstrapFilesRequest._() : super();
  factory BootstrapFilesRequest({
    $core.String workingDir,
    $core.Iterable<$core.String> fullPaths,
  }) {
    final _result = create();
    if (workingDir != null) {
      _result.workingDir = workingDir;
    }
    if (fullPaths != null) {
      _result.fullPaths.addAll(fullPaths);
    }
    return _result;
  }
  factory BootstrapFilesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BootstrapFilesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BootstrapFilesRequest clone() => BootstrapFilesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BootstrapFilesRequest copyWith(void Function(BootstrapFilesRequest) updates) => super.copyWith((message) => updates(message as BootstrapFilesRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BootstrapFilesRequest create() => BootstrapFilesRequest._();
  BootstrapFilesRequest createEmptyInstance() => create();
  static $pb.PbList<BootstrapFilesRequest> createRepeated() => $pb.PbList<BootstrapFilesRequest>();
  @$core.pragma('dart2js:noInline')
  static BootstrapFilesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BootstrapFilesRequest>(create);
  static BootstrapFilesRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workingDir => $_getSZ(0);
  @$pb.TagNumber(1)
  set workingDir($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWorkingDir() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkingDir() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get fullPaths => $_getList(1);
}

class Peers extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Peers', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isDefault', protoName: 'isDefault')
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peer')
    ..hasRequiredFields = false
  ;

  Peers._() : super();
  factory Peers({
    $core.bool isDefault,
    $core.Iterable<$core.String> peer,
  }) {
    final _result = create();
    if (isDefault != null) {
      _result.isDefault = isDefault;
    }
    if (peer != null) {
      _result.peer.addAll(peer);
    }
    return _result;
  }
  factory Peers.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Peers.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Peers clone() => Peers()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Peers copyWith(void Function(Peers) updates) => super.copyWith((message) => updates(message as Peers)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Peers create() => Peers._();
  Peers createEmptyInstance() => create();
  static $pb.PbList<Peers> createRepeated() => $pb.PbList<Peers>();
  @$core.pragma('dart2js:noInline')
  static Peers getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Peers>(create);
  static Peers _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isDefault => $_getBF(0);
  @$pb.TagNumber(1)
  set isDefault($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsDefault() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsDefault() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get peer => $_getList(1);
}

class TxSpentURL extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TxSpentURL', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'URL', protoName: 'URL')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isDefault', protoName: 'isDefault')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'disabled')
    ..hasRequiredFields = false
  ;

  TxSpentURL._() : super();
  factory TxSpentURL({
    $core.String uRL,
    $core.bool isDefault,
    $core.bool disabled,
  }) {
    final _result = create();
    if (uRL != null) {
      _result.uRL = uRL;
    }
    if (isDefault != null) {
      _result.isDefault = isDefault;
    }
    if (disabled != null) {
      _result.disabled = disabled;
    }
    return _result;
  }
  factory TxSpentURL.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TxSpentURL.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TxSpentURL clone() => TxSpentURL()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TxSpentURL copyWith(void Function(TxSpentURL) updates) => super.copyWith((message) => updates(message as TxSpentURL)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TxSpentURL create() => TxSpentURL._();
  TxSpentURL createEmptyInstance() => create();
  static $pb.PbList<TxSpentURL> createRepeated() => $pb.PbList<TxSpentURL>();
  @$core.pragma('dart2js:noInline')
  static TxSpentURL getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TxSpentURL>(create);
  static TxSpentURL _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uRL => $_getSZ(0);
  @$pb.TagNumber(1)
  set uRL($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasURL() => $_has(0);
  @$pb.TagNumber(1)
  void clearURL() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isDefault => $_getBF(1);
  @$pb.TagNumber(2)
  set isDefault($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsDefault() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsDefault() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get disabled => $_getBF(2);
  @$pb.TagNumber(3)
  set disabled($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDisabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisabled() => clearField(3);
}

class rate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'rate', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coin')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  rate._() : super();
  factory rate({
    $core.String coin,
    $core.double value,
  }) {
    final _result = create();
    if (coin != null) {
      _result.coin = coin;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory rate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory rate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  rate clone() => rate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  rate copyWith(void Function(rate) updates) => super.copyWith((message) => updates(message as rate)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static rate create() => rate._();
  rate createEmptyInstance() => create();
  static $pb.PbList<rate> createRepeated() => $pb.PbList<rate>();
  @$core.pragma('dart2js:noInline')
  static rate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<rate>(create);
  static rate _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get coin => $_getSZ(0);
  @$pb.TagNumber(1)
  set coin($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCoin() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoin() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class Rates extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Rates', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..pc<rate>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rates', $pb.PbFieldType.PM, subBuilder: rate.create)
    ..hasRequiredFields = false
  ;

  Rates._() : super();
  factory Rates({
    $core.Iterable<rate> rates,
  }) {
    final _result = create();
    if (rates != null) {
      _result.rates.addAll(rates);
    }
    return _result;
  }
  factory Rates.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Rates.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Rates clone() => Rates()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Rates copyWith(void Function(Rates) updates) => super.copyWith((message) => updates(message as Rates)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Rates create() => Rates._();
  Rates createEmptyInstance() => create();
  static $pb.PbList<Rates> createRepeated() => $pb.PbList<Rates>();
  @$core.pragma('dart2js:noInline')
  static Rates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Rates>(create);
  static Rates _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<rate> get rates => $_getList(0);
}

class LSPInformation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LSPInformation', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'widgetUrl')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'host')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'channelCapacity')
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetConf', $pb.PbFieldType.O3)
    ..aInt64(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'baseFeeMsat')
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'feeRate', $pb.PbFieldType.OD)
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timeLockDelta', $pb.PbFieldType.OU3)
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minHtlcMsat')
    ..aInt64(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'channelFeePermyriad')
    ..a<$core.List<$core.int>>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lspPubkey', $pb.PbFieldType.OY)
    ..aInt64(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxInactiveDuration')
    ..aInt64(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'channelMinimumFeeMsat')
    ..hasRequiredFields = false
  ;

  LSPInformation._() : super();
  factory LSPInformation({
    $core.String id,
    $core.String name,
    $core.String widgetUrl,
    $core.String pubkey,
    $core.String host,
    $fixnum.Int64 channelCapacity,
    $core.int targetConf,
    $fixnum.Int64 baseFeeMsat,
    $core.double feeRate,
    $core.int timeLockDelta,
    $fixnum.Int64 minHtlcMsat,
    $fixnum.Int64 channelFeePermyriad,
    $core.List<$core.int> lspPubkey,
    $fixnum.Int64 maxInactiveDuration,
    $fixnum.Int64 channelMinimumFeeMsat,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (widgetUrl != null) {
      _result.widgetUrl = widgetUrl;
    }
    if (pubkey != null) {
      _result.pubkey = pubkey;
    }
    if (host != null) {
      _result.host = host;
    }
    if (channelCapacity != null) {
      _result.channelCapacity = channelCapacity;
    }
    if (targetConf != null) {
      _result.targetConf = targetConf;
    }
    if (baseFeeMsat != null) {
      _result.baseFeeMsat = baseFeeMsat;
    }
    if (feeRate != null) {
      _result.feeRate = feeRate;
    }
    if (timeLockDelta != null) {
      _result.timeLockDelta = timeLockDelta;
    }
    if (minHtlcMsat != null) {
      _result.minHtlcMsat = minHtlcMsat;
    }
    if (channelFeePermyriad != null) {
      _result.channelFeePermyriad = channelFeePermyriad;
    }
    if (lspPubkey != null) {
      _result.lspPubkey = lspPubkey;
    }
    if (maxInactiveDuration != null) {
      _result.maxInactiveDuration = maxInactiveDuration;
    }
    if (channelMinimumFeeMsat != null) {
      _result.channelMinimumFeeMsat = channelMinimumFeeMsat;
    }
    return _result;
  }
  factory LSPInformation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LSPInformation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LSPInformation clone() => LSPInformation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LSPInformation copyWith(void Function(LSPInformation) updates) => super.copyWith((message) => updates(message as LSPInformation)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LSPInformation create() => LSPInformation._();
  LSPInformation createEmptyInstance() => create();
  static $pb.PbList<LSPInformation> createRepeated() => $pb.PbList<LSPInformation>();
  @$core.pragma('dart2js:noInline')
  static LSPInformation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LSPInformation>(create);
  static LSPInformation _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get widgetUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set widgetUrl($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWidgetUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearWidgetUrl() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get pubkey => $_getSZ(3);
  @$pb.TagNumber(4)
  set pubkey($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPubkey() => $_has(3);
  @$pb.TagNumber(4)
  void clearPubkey() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get host => $_getSZ(4);
  @$pb.TagNumber(5)
  set host($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasHost() => $_has(4);
  @$pb.TagNumber(5)
  void clearHost() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get channelCapacity => $_getI64(5);
  @$pb.TagNumber(6)
  set channelCapacity($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasChannelCapacity() => $_has(5);
  @$pb.TagNumber(6)
  void clearChannelCapacity() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get targetConf => $_getIZ(6);
  @$pb.TagNumber(7)
  set targetConf($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTargetConf() => $_has(6);
  @$pb.TagNumber(7)
  void clearTargetConf() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get baseFeeMsat => $_getI64(7);
  @$pb.TagNumber(8)
  set baseFeeMsat($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasBaseFeeMsat() => $_has(7);
  @$pb.TagNumber(8)
  void clearBaseFeeMsat() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get feeRate => $_getN(8);
  @$pb.TagNumber(9)
  set feeRate($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasFeeRate() => $_has(8);
  @$pb.TagNumber(9)
  void clearFeeRate() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get timeLockDelta => $_getIZ(9);
  @$pb.TagNumber(10)
  set timeLockDelta($core.int v) { $_setUnsignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasTimeLockDelta() => $_has(9);
  @$pb.TagNumber(10)
  void clearTimeLockDelta() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get minHtlcMsat => $_getI64(10);
  @$pb.TagNumber(11)
  set minHtlcMsat($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasMinHtlcMsat() => $_has(10);
  @$pb.TagNumber(11)
  void clearMinHtlcMsat() => clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get channelFeePermyriad => $_getI64(11);
  @$pb.TagNumber(12)
  set channelFeePermyriad($fixnum.Int64 v) { $_setInt64(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasChannelFeePermyriad() => $_has(11);
  @$pb.TagNumber(12)
  void clearChannelFeePermyriad() => clearField(12);

  @$pb.TagNumber(13)
  $core.List<$core.int> get lspPubkey => $_getN(12);
  @$pb.TagNumber(13)
  set lspPubkey($core.List<$core.int> v) { $_setBytes(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasLspPubkey() => $_has(12);
  @$pb.TagNumber(13)
  void clearLspPubkey() => clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get maxInactiveDuration => $_getI64(13);
  @$pb.TagNumber(14)
  set maxInactiveDuration($fixnum.Int64 v) { $_setInt64(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasMaxInactiveDuration() => $_has(13);
  @$pb.TagNumber(14)
  void clearMaxInactiveDuration() => clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get channelMinimumFeeMsat => $_getI64(14);
  @$pb.TagNumber(15)
  set channelMinimumFeeMsat($fixnum.Int64 v) { $_setInt64(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasChannelMinimumFeeMsat() => $_has(14);
  @$pb.TagNumber(15)
  void clearChannelMinimumFeeMsat() => clearField(15);
}

class LSPListRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LSPListRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  LSPListRequest._() : super();
  factory LSPListRequest() => create();
  factory LSPListRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LSPListRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LSPListRequest clone() => LSPListRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LSPListRequest copyWith(void Function(LSPListRequest) updates) => super.copyWith((message) => updates(message as LSPListRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LSPListRequest create() => LSPListRequest._();
  LSPListRequest createEmptyInstance() => create();
  static $pb.PbList<LSPListRequest> createRepeated() => $pb.PbList<LSPListRequest>();
  @$core.pragma('dart2js:noInline')
  static LSPListRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LSPListRequest>(create);
  static LSPListRequest _defaultInstance;
}

class LSPList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LSPList', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..m<$core.String, LSPInformation>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lsps', entryClassName: 'LSPList.LspsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: LSPInformation.create, packageName: const $pb.PackageName('data'))
    ..hasRequiredFields = false
  ;

  LSPList._() : super();
  factory LSPList({
    $core.Map<$core.String, LSPInformation> lsps,
  }) {
    final _result = create();
    if (lsps != null) {
      _result.lsps.addAll(lsps);
    }
    return _result;
  }
  factory LSPList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LSPList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LSPList clone() => LSPList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LSPList copyWith(void Function(LSPList) updates) => super.copyWith((message) => updates(message as LSPList)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LSPList create() => LSPList._();
  LSPList createEmptyInstance() => create();
  static $pb.PbList<LSPList> createRepeated() => $pb.PbList<LSPList>();
  @$core.pragma('dart2js:noInline')
  static LSPList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LSPList>(create);
  static LSPList _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, LSPInformation> get lsps => $_getMap(0);
}

class LSPActivity extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LSPActivity', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..m<$core.String, $fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'activity', entryClassName: 'LSPActivity.ActivityEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.O6, packageName: const $pb.PackageName('data'))
    ..hasRequiredFields = false
  ;

  LSPActivity._() : super();
  factory LSPActivity({
    $core.Map<$core.String, $fixnum.Int64> activity,
  }) {
    final _result = create();
    if (activity != null) {
      _result.activity.addAll(activity);
    }
    return _result;
  }
  factory LSPActivity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LSPActivity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LSPActivity clone() => LSPActivity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LSPActivity copyWith(void Function(LSPActivity) updates) => super.copyWith((message) => updates(message as LSPActivity)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LSPActivity create() => LSPActivity._();
  LSPActivity createEmptyInstance() => create();
  static $pb.PbList<LSPActivity> createRepeated() => $pb.PbList<LSPActivity>();
  @$core.pragma('dart2js:noInline')
  static LSPActivity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LSPActivity>(create);
  static LSPActivity _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, $fixnum.Int64> get activity => $_getMap(0);
}

class ConnectLSPRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectLSPRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lspId')
    ..hasRequiredFields = false
  ;

  ConnectLSPRequest._() : super();
  factory ConnectLSPRequest({
    $core.String lspId,
  }) {
    final _result = create();
    if (lspId != null) {
      _result.lspId = lspId;
    }
    return _result;
  }
  factory ConnectLSPRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectLSPRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectLSPRequest clone() => ConnectLSPRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectLSPRequest copyWith(void Function(ConnectLSPRequest) updates) => super.copyWith((message) => updates(message as ConnectLSPRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectLSPRequest create() => ConnectLSPRequest._();
  ConnectLSPRequest createEmptyInstance() => create();
  static $pb.PbList<ConnectLSPRequest> createRepeated() => $pb.PbList<ConnectLSPRequest>();
  @$core.pragma('dart2js:noInline')
  static ConnectLSPRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectLSPRequest>(create);
  static ConnectLSPRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lspId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lspId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLspId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLspId() => clearField(1);
}

class ConnectLSPReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectLSPReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  ConnectLSPReply._() : super();
  factory ConnectLSPReply() => create();
  factory ConnectLSPReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectLSPReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectLSPReply clone() => ConnectLSPReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectLSPReply copyWith(void Function(ConnectLSPReply) updates) => super.copyWith((message) => updates(message as ConnectLSPReply)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectLSPReply create() => ConnectLSPReply._();
  ConnectLSPReply createEmptyInstance() => create();
  static $pb.PbList<ConnectLSPReply> createRepeated() => $pb.PbList<ConnectLSPReply>();
  @$core.pragma('dart2js:noInline')
  static ConnectLSPReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectLSPReply>(create);
  static ConnectLSPReply _defaultInstance;
}

enum LNUrlResponse_Action {
  withdraw, 
  channel, 
  auth, 
  payResponse1, 
  notSet
}

class LNUrlResponse extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, LNUrlResponse_Action> _LNUrlResponse_ActionByTag = {
    1 : LNUrlResponse_Action.withdraw,
    2 : LNUrlResponse_Action.channel,
    3 : LNUrlResponse_Action.auth,
    4 : LNUrlResponse_Action.payResponse1,
    0 : LNUrlResponse_Action.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LNUrlResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<LNUrlWithdraw>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'withdraw', subBuilder: LNUrlWithdraw.create)
    ..aOM<LNURLChannel>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'channel', subBuilder: LNURLChannel.create)
    ..aOM<LNURLAuth>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'auth', subBuilder: LNURLAuth.create)
    ..aOM<LNURLPayResponse1>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'payResponse1', protoName: 'payResponse1', subBuilder: LNURLPayResponse1.create)
    ..hasRequiredFields = false
  ;

  LNUrlResponse._() : super();
  factory LNUrlResponse({
    LNUrlWithdraw withdraw,
    LNURLChannel channel,
    LNURLAuth auth,
    LNURLPayResponse1 payResponse1,
  }) {
    final _result = create();
    if (withdraw != null) {
      _result.withdraw = withdraw;
    }
    if (channel != null) {
      _result.channel = channel;
    }
    if (auth != null) {
      _result.auth = auth;
    }
    if (payResponse1 != null) {
      _result.payResponse1 = payResponse1;
    }
    return _result;
  }
  factory LNUrlResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LNUrlResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LNUrlResponse clone() => LNUrlResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LNUrlResponse copyWith(void Function(LNUrlResponse) updates) => super.copyWith((message) => updates(message as LNUrlResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LNUrlResponse create() => LNUrlResponse._();
  LNUrlResponse createEmptyInstance() => create();
  static $pb.PbList<LNUrlResponse> createRepeated() => $pb.PbList<LNUrlResponse>();
  @$core.pragma('dart2js:noInline')
  static LNUrlResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LNUrlResponse>(create);
  static LNUrlResponse _defaultInstance;

  LNUrlResponse_Action whichAction() => _LNUrlResponse_ActionByTag[$_whichOneof(0)];
  void clearAction() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  LNUrlWithdraw get withdraw => $_getN(0);
  @$pb.TagNumber(1)
  set withdraw(LNUrlWithdraw v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasWithdraw() => $_has(0);
  @$pb.TagNumber(1)
  void clearWithdraw() => clearField(1);
  @$pb.TagNumber(1)
  LNUrlWithdraw ensureWithdraw() => $_ensure(0);

  @$pb.TagNumber(2)
  LNURLChannel get channel => $_getN(1);
  @$pb.TagNumber(2)
  set channel(LNURLChannel v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasChannel() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannel() => clearField(2);
  @$pb.TagNumber(2)
  LNURLChannel ensureChannel() => $_ensure(1);

  @$pb.TagNumber(3)
  LNURLAuth get auth => $_getN(2);
  @$pb.TagNumber(3)
  set auth(LNURLAuth v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuth() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuth() => clearField(3);
  @$pb.TagNumber(3)
  LNURLAuth ensureAuth() => $_ensure(2);

  @$pb.TagNumber(4)
  LNURLPayResponse1 get payResponse1 => $_getN(3);
  @$pb.TagNumber(4)
  set payResponse1(LNURLPayResponse1 v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasPayResponse1() => $_has(3);
  @$pb.TagNumber(4)
  void clearPayResponse1() => clearField(4);
  @$pb.TagNumber(4)
  LNURLPayResponse1 ensurePayResponse1() => $_ensure(3);
}

class LNUrlWithdraw extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LNUrlWithdraw', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minAmount')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxAmount')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'defaultDescription')
    ..hasRequiredFields = false
  ;

  LNUrlWithdraw._() : super();
  factory LNUrlWithdraw({
    $fixnum.Int64 minAmount,
    $fixnum.Int64 maxAmount,
    $core.String defaultDescription,
  }) {
    final _result = create();
    if (minAmount != null) {
      _result.minAmount = minAmount;
    }
    if (maxAmount != null) {
      _result.maxAmount = maxAmount;
    }
    if (defaultDescription != null) {
      _result.defaultDescription = defaultDescription;
    }
    return _result;
  }
  factory LNUrlWithdraw.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LNUrlWithdraw.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LNUrlWithdraw clone() => LNUrlWithdraw()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LNUrlWithdraw copyWith(void Function(LNUrlWithdraw) updates) => super.copyWith((message) => updates(message as LNUrlWithdraw)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LNUrlWithdraw create() => LNUrlWithdraw._();
  LNUrlWithdraw createEmptyInstance() => create();
  static $pb.PbList<LNUrlWithdraw> createRepeated() => $pb.PbList<LNUrlWithdraw>();
  @$core.pragma('dart2js:noInline')
  static LNUrlWithdraw getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LNUrlWithdraw>(create);
  static LNUrlWithdraw _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get minAmount => $_getI64(0);
  @$pb.TagNumber(1)
  set minAmount($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMinAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinAmount() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set maxAmount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaxAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get defaultDescription => $_getSZ(2);
  @$pb.TagNumber(3)
  set defaultDescription($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDefaultDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDefaultDescription() => clearField(3);
}

class LNURLChannel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LNURLChannel', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'k1')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callback')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uri')
    ..hasRequiredFields = false
  ;

  LNURLChannel._() : super();
  factory LNURLChannel({
    $core.String k1,
    $core.String callback,
    $core.String uri,
  }) {
    final _result = create();
    if (k1 != null) {
      _result.k1 = k1;
    }
    if (callback != null) {
      _result.callback = callback;
    }
    if (uri != null) {
      _result.uri = uri;
    }
    return _result;
  }
  factory LNURLChannel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LNURLChannel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LNURLChannel clone() => LNURLChannel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LNURLChannel copyWith(void Function(LNURLChannel) updates) => super.copyWith((message) => updates(message as LNURLChannel)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LNURLChannel create() => LNURLChannel._();
  LNURLChannel createEmptyInstance() => create();
  static $pb.PbList<LNURLChannel> createRepeated() => $pb.PbList<LNURLChannel>();
  @$core.pragma('dart2js:noInline')
  static LNURLChannel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LNURLChannel>(create);
  static LNURLChannel _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get k1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set k1($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasK1() => $_has(0);
  @$pb.TagNumber(1)
  void clearK1() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get callback => $_getSZ(1);
  @$pb.TagNumber(2)
  set callback($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCallback() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallback() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => clearField(3);
}

class LNURLAuth extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LNURLAuth', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tag')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'k1')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callback')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'host')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'jwt')
    ..hasRequiredFields = false
  ;

  LNURLAuth._() : super();
  factory LNURLAuth({
    $core.String tag,
    $core.String k1,
    $core.String callback,
    $core.String host,
    $core.bool jwt,
  }) {
    final _result = create();
    if (tag != null) {
      _result.tag = tag;
    }
    if (k1 != null) {
      _result.k1 = k1;
    }
    if (callback != null) {
      _result.callback = callback;
    }
    if (host != null) {
      _result.host = host;
    }
    if (jwt != null) {
      _result.jwt = jwt;
    }
    return _result;
  }
  factory LNURLAuth.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LNURLAuth.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LNURLAuth clone() => LNURLAuth()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LNURLAuth copyWith(void Function(LNURLAuth) updates) => super.copyWith((message) => updates(message as LNURLAuth)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LNURLAuth create() => LNURLAuth._();
  LNURLAuth createEmptyInstance() => create();
  static $pb.PbList<LNURLAuth> createRepeated() => $pb.PbList<LNURLAuth>();
  @$core.pragma('dart2js:noInline')
  static LNURLAuth getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LNURLAuth>(create);
  static LNURLAuth _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tag => $_getSZ(0);
  @$pb.TagNumber(1)
  set tag($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearTag() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get k1 => $_getSZ(1);
  @$pb.TagNumber(2)
  set k1($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasK1() => $_has(1);
  @$pb.TagNumber(2)
  void clearK1() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get callback => $_getSZ(2);
  @$pb.TagNumber(3)
  set callback($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCallback() => $_has(2);
  @$pb.TagNumber(3)
  void clearCallback() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get host => $_getSZ(3);
  @$pb.TagNumber(4)
  set host($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHost() => $_has(3);
  @$pb.TagNumber(4)
  void clearHost() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get jwt => $_getBF(4);
  @$pb.TagNumber(5)
  set jwt($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasJwt() => $_has(4);
  @$pb.TagNumber(5)
  void clearJwt() => clearField(5);
}

class LNUrlPayMetadata extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LNUrlPayMetadata', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'entry')
    ..hasRequiredFields = false
  ;

  LNUrlPayMetadata._() : super();
  factory LNUrlPayMetadata({
    $core.Iterable<$core.String> entry,
  }) {
    final _result = create();
    if (entry != null) {
      _result.entry.addAll(entry);
    }
    return _result;
  }
  factory LNUrlPayMetadata.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LNUrlPayMetadata.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LNUrlPayMetadata clone() => LNUrlPayMetadata()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LNUrlPayMetadata copyWith(void Function(LNUrlPayMetadata) updates) => super.copyWith((message) => updates(message as LNUrlPayMetadata)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LNUrlPayMetadata create() => LNUrlPayMetadata._();
  LNUrlPayMetadata createEmptyInstance() => create();
  static $pb.PbList<LNUrlPayMetadata> createRepeated() => $pb.PbList<LNUrlPayMetadata>();
  @$core.pragma('dart2js:noInline')
  static LNUrlPayMetadata getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LNUrlPayMetadata>(create);
  static LNUrlPayMetadata _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get entry => $_getList(0);
}

class LNURLPayResponse1 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LNURLPayResponse1', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callback')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minAmount')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxAmount')
    ..pc<LNUrlPayMetadata>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'metadata', $pb.PbFieldType.PM, subBuilder: LNUrlPayMetadata.create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tag')
    ..a<$fixnum.Int64>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fromNodes')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'comment')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'host')
    ..hasRequiredFields = false
  ;

  LNURLPayResponse1._() : super();
  factory LNURLPayResponse1({
    $core.String callback,
    $fixnum.Int64 minAmount,
    $fixnum.Int64 maxAmount,
    $core.Iterable<LNUrlPayMetadata> metadata,
    $core.String tag,
    $fixnum.Int64 amount,
    $core.String fromNodes,
    $core.String comment,
    $core.String host,
  }) {
    final _result = create();
    if (callback != null) {
      _result.callback = callback;
    }
    if (minAmount != null) {
      _result.minAmount = minAmount;
    }
    if (maxAmount != null) {
      _result.maxAmount = maxAmount;
    }
    if (metadata != null) {
      _result.metadata.addAll(metadata);
    }
    if (tag != null) {
      _result.tag = tag;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (fromNodes != null) {
      _result.fromNodes = fromNodes;
    }
    if (comment != null) {
      _result.comment = comment;
    }
    if (host != null) {
      _result.host = host;
    }
    return _result;
  }
  factory LNURLPayResponse1.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LNURLPayResponse1.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LNURLPayResponse1 clone() => LNURLPayResponse1()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LNURLPayResponse1 copyWith(void Function(LNURLPayResponse1) updates) => super.copyWith((message) => updates(message as LNURLPayResponse1)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LNURLPayResponse1 create() => LNURLPayResponse1._();
  LNURLPayResponse1 createEmptyInstance() => create();
  static $pb.PbList<LNURLPayResponse1> createRepeated() => $pb.PbList<LNURLPayResponse1>();
  @$core.pragma('dart2js:noInline')
  static LNURLPayResponse1 getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LNURLPayResponse1>(create);
  static LNURLPayResponse1 _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callback => $_getSZ(0);
  @$pb.TagNumber(1)
  set callback($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCallback() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallback() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get minAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set minAmount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMinAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinAmount() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get maxAmount => $_getI64(2);
  @$pb.TagNumber(3)
  set maxAmount($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<LNUrlPayMetadata> get metadata => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get tag => $_getSZ(4);
  @$pb.TagNumber(5)
  set tag($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTag() => $_has(4);
  @$pb.TagNumber(5)
  void clearTag() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get amount => $_getI64(5);
  @$pb.TagNumber(6)
  set amount($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearAmount() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get fromNodes => $_getSZ(6);
  @$pb.TagNumber(7)
  set fromNodes($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasFromNodes() => $_has(6);
  @$pb.TagNumber(7)
  void clearFromNodes() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get comment => $_getSZ(7);
  @$pb.TagNumber(8)
  set comment($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasComment() => $_has(7);
  @$pb.TagNumber(8)
  void clearComment() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get host => $_getSZ(8);
  @$pb.TagNumber(9)
  set host($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasHost() => $_has(8);
  @$pb.TagNumber(9)
  void clearHost() => clearField(9);
}

class SuccessAction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SuccessAction', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tag')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'url')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ciphertext')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iv')
    ..hasRequiredFields = false
  ;

  SuccessAction._() : super();
  factory SuccessAction({
    $core.String tag,
    $core.String description,
    $core.String url,
    $core.String message,
    $core.String ciphertext,
    $core.String iv,
  }) {
    final _result = create();
    if (tag != null) {
      _result.tag = tag;
    }
    if (description != null) {
      _result.description = description;
    }
    if (url != null) {
      _result.url = url;
    }
    if (message != null) {
      _result.message = message;
    }
    if (ciphertext != null) {
      _result.ciphertext = ciphertext;
    }
    if (iv != null) {
      _result.iv = iv;
    }
    return _result;
  }
  factory SuccessAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SuccessAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SuccessAction clone() => SuccessAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SuccessAction copyWith(void Function(SuccessAction) updates) => super.copyWith((message) => updates(message as SuccessAction)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SuccessAction create() => SuccessAction._();
  SuccessAction createEmptyInstance() => create();
  static $pb.PbList<SuccessAction> createRepeated() => $pb.PbList<SuccessAction>();
  @$core.pragma('dart2js:noInline')
  static SuccessAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SuccessAction>(create);
  static SuccessAction _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tag => $_getSZ(0);
  @$pb.TagNumber(1)
  set tag($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearTag() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get ciphertext => $_getSZ(4);
  @$pb.TagNumber(5)
  set ciphertext($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCiphertext() => $_has(4);
  @$pb.TagNumber(5)
  void clearCiphertext() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get iv => $_getSZ(5);
  @$pb.TagNumber(6)
  set iv($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIv() => $_has(5);
  @$pb.TagNumber(6)
  void clearIv() => clearField(6);
}

class LNUrlPayInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LNUrlPayInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentHash', protoName: 'paymentHash')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'invoice')
    ..aOM<SuccessAction>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'successAction', subBuilder: SuccessAction.create)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'comment')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'invoiceDescription')
    ..pc<LNUrlPayMetadata>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'metadata', $pb.PbFieldType.PM, subBuilder: LNUrlPayMetadata.create)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'host')
    ..hasRequiredFields = false
  ;

  LNUrlPayInfo._() : super();
  factory LNUrlPayInfo({
    $core.String paymentHash,
    $core.String invoice,
    SuccessAction successAction,
    $core.String comment,
    $core.String invoiceDescription,
    $core.Iterable<LNUrlPayMetadata> metadata,
    $core.String host,
  }) {
    final _result = create();
    if (paymentHash != null) {
      _result.paymentHash = paymentHash;
    }
    if (invoice != null) {
      _result.invoice = invoice;
    }
    if (successAction != null) {
      _result.successAction = successAction;
    }
    if (comment != null) {
      _result.comment = comment;
    }
    if (invoiceDescription != null) {
      _result.invoiceDescription = invoiceDescription;
    }
    if (metadata != null) {
      _result.metadata.addAll(metadata);
    }
    if (host != null) {
      _result.host = host;
    }
    return _result;
  }
  factory LNUrlPayInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LNUrlPayInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LNUrlPayInfo clone() => LNUrlPayInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LNUrlPayInfo copyWith(void Function(LNUrlPayInfo) updates) => super.copyWith((message) => updates(message as LNUrlPayInfo)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LNUrlPayInfo create() => LNUrlPayInfo._();
  LNUrlPayInfo createEmptyInstance() => create();
  static $pb.PbList<LNUrlPayInfo> createRepeated() => $pb.PbList<LNUrlPayInfo>();
  @$core.pragma('dart2js:noInline')
  static LNUrlPayInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LNUrlPayInfo>(create);
  static LNUrlPayInfo _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get paymentHash => $_getSZ(0);
  @$pb.TagNumber(1)
  set paymentHash($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPaymentHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentHash() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get invoice => $_getSZ(1);
  @$pb.TagNumber(2)
  set invoice($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInvoice() => $_has(1);
  @$pb.TagNumber(2)
  void clearInvoice() => clearField(2);

  @$pb.TagNumber(3)
  SuccessAction get successAction => $_getN(2);
  @$pb.TagNumber(3)
  set successAction(SuccessAction v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSuccessAction() => $_has(2);
  @$pb.TagNumber(3)
  void clearSuccessAction() => clearField(3);
  @$pb.TagNumber(3)
  SuccessAction ensureSuccessAction() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get comment => $_getSZ(3);
  @$pb.TagNumber(4)
  set comment($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasComment() => $_has(3);
  @$pb.TagNumber(4)
  void clearComment() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get invoiceDescription => $_getSZ(4);
  @$pb.TagNumber(5)
  set invoiceDescription($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasInvoiceDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearInvoiceDescription() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<LNUrlPayMetadata> get metadata => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get host => $_getSZ(6);
  @$pb.TagNumber(7)
  set host($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasHost() => $_has(6);
  @$pb.TagNumber(7)
  void clearHost() => clearField(7);
}

class LNUrlPayInfoList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LNUrlPayInfoList', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..pc<LNUrlPayInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'infoList', $pb.PbFieldType.PM, protoName: 'infoList', subBuilder: LNUrlPayInfo.create)
    ..hasRequiredFields = false
  ;

  LNUrlPayInfoList._() : super();
  factory LNUrlPayInfoList({
    $core.Iterable<LNUrlPayInfo> infoList,
  }) {
    final _result = create();
    if (infoList != null) {
      _result.infoList.addAll(infoList);
    }
    return _result;
  }
  factory LNUrlPayInfoList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LNUrlPayInfoList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LNUrlPayInfoList clone() => LNUrlPayInfoList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LNUrlPayInfoList copyWith(void Function(LNUrlPayInfoList) updates) => super.copyWith((message) => updates(message as LNUrlPayInfoList)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LNUrlPayInfoList create() => LNUrlPayInfoList._();
  LNUrlPayInfoList createEmptyInstance() => create();
  static $pb.PbList<LNUrlPayInfoList> createRepeated() => $pb.PbList<LNUrlPayInfoList>();
  @$core.pragma('dart2js:noInline')
  static LNUrlPayInfoList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LNUrlPayInfoList>(create);
  static LNUrlPayInfoList _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<LNUrlPayInfo> get infoList => $_getList(0);
}

class ReverseSwapRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReverseSwapRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'feesHash')
    ..hasRequiredFields = false
  ;

  ReverseSwapRequest._() : super();
  factory ReverseSwapRequest({
    $core.String address,
    $fixnum.Int64 amount,
    $core.String feesHash,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (feesHash != null) {
      _result.feesHash = feesHash;
    }
    return _result;
  }
  factory ReverseSwapRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReverseSwapRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReverseSwapRequest clone() => ReverseSwapRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReverseSwapRequest copyWith(void Function(ReverseSwapRequest) updates) => super.copyWith((message) => updates(message as ReverseSwapRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReverseSwapRequest create() => ReverseSwapRequest._();
  ReverseSwapRequest createEmptyInstance() => create();
  static $pb.PbList<ReverseSwapRequest> createRepeated() => $pb.PbList<ReverseSwapRequest>();
  @$core.pragma('dart2js:noInline')
  static ReverseSwapRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReverseSwapRequest>(create);
  static ReverseSwapRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get amount => $_getI64(1);
  @$pb.TagNumber(2)
  set amount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get feesHash => $_getSZ(2);
  @$pb.TagNumber(3)
  set feesHash($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFeesHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeesHash() => clearField(3);
}

class ReverseSwap extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReverseSwap', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'invoice')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'script')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lockupAddress')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'preimage')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'claimAddress')
    ..aInt64(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lnAmount')
    ..aInt64(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'onchainAmount')
    ..aInt64(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timeoutBlockHeight')
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startBlockHeight')
    ..aInt64(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'claimFee')
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'claimTxid')
    ..hasRequiredFields = false
  ;

  ReverseSwap._() : super();
  factory ReverseSwap({
    $core.String id,
    $core.String invoice,
    $core.String script,
    $core.String lockupAddress,
    $core.String preimage,
    $core.String key,
    $core.String claimAddress,
    $fixnum.Int64 lnAmount,
    $fixnum.Int64 onchainAmount,
    $fixnum.Int64 timeoutBlockHeight,
    $fixnum.Int64 startBlockHeight,
    $fixnum.Int64 claimFee,
    $core.String claimTxid,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (invoice != null) {
      _result.invoice = invoice;
    }
    if (script != null) {
      _result.script = script;
    }
    if (lockupAddress != null) {
      _result.lockupAddress = lockupAddress;
    }
    if (preimage != null) {
      _result.preimage = preimage;
    }
    if (key != null) {
      _result.key = key;
    }
    if (claimAddress != null) {
      _result.claimAddress = claimAddress;
    }
    if (lnAmount != null) {
      _result.lnAmount = lnAmount;
    }
    if (onchainAmount != null) {
      _result.onchainAmount = onchainAmount;
    }
    if (timeoutBlockHeight != null) {
      _result.timeoutBlockHeight = timeoutBlockHeight;
    }
    if (startBlockHeight != null) {
      _result.startBlockHeight = startBlockHeight;
    }
    if (claimFee != null) {
      _result.claimFee = claimFee;
    }
    if (claimTxid != null) {
      _result.claimTxid = claimTxid;
    }
    return _result;
  }
  factory ReverseSwap.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReverseSwap.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReverseSwap clone() => ReverseSwap()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReverseSwap copyWith(void Function(ReverseSwap) updates) => super.copyWith((message) => updates(message as ReverseSwap)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReverseSwap create() => ReverseSwap._();
  ReverseSwap createEmptyInstance() => create();
  static $pb.PbList<ReverseSwap> createRepeated() => $pb.PbList<ReverseSwap>();
  @$core.pragma('dart2js:noInline')
  static ReverseSwap getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReverseSwap>(create);
  static ReverseSwap _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get invoice => $_getSZ(1);
  @$pb.TagNumber(2)
  set invoice($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInvoice() => $_has(1);
  @$pb.TagNumber(2)
  void clearInvoice() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get script => $_getSZ(2);
  @$pb.TagNumber(3)
  set script($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasScript() => $_has(2);
  @$pb.TagNumber(3)
  void clearScript() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get lockupAddress => $_getSZ(3);
  @$pb.TagNumber(4)
  set lockupAddress($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLockupAddress() => $_has(3);
  @$pb.TagNumber(4)
  void clearLockupAddress() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get preimage => $_getSZ(4);
  @$pb.TagNumber(5)
  set preimage($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPreimage() => $_has(4);
  @$pb.TagNumber(5)
  void clearPreimage() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get key => $_getSZ(5);
  @$pb.TagNumber(6)
  set key($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasKey() => $_has(5);
  @$pb.TagNumber(6)
  void clearKey() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get claimAddress => $_getSZ(6);
  @$pb.TagNumber(7)
  set claimAddress($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasClaimAddress() => $_has(6);
  @$pb.TagNumber(7)
  void clearClaimAddress() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get lnAmount => $_getI64(7);
  @$pb.TagNumber(8)
  set lnAmount($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasLnAmount() => $_has(7);
  @$pb.TagNumber(8)
  void clearLnAmount() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get onchainAmount => $_getI64(8);
  @$pb.TagNumber(9)
  set onchainAmount($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasOnchainAmount() => $_has(8);
  @$pb.TagNumber(9)
  void clearOnchainAmount() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get timeoutBlockHeight => $_getI64(9);
  @$pb.TagNumber(10)
  set timeoutBlockHeight($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasTimeoutBlockHeight() => $_has(9);
  @$pb.TagNumber(10)
  void clearTimeoutBlockHeight() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get startBlockHeight => $_getI64(10);
  @$pb.TagNumber(11)
  set startBlockHeight($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasStartBlockHeight() => $_has(10);
  @$pb.TagNumber(11)
  void clearStartBlockHeight() => clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get claimFee => $_getI64(11);
  @$pb.TagNumber(12)
  set claimFee($fixnum.Int64 v) { $_setInt64(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasClaimFee() => $_has(11);
  @$pb.TagNumber(12)
  void clearClaimFee() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get claimTxid => $_getSZ(12);
  @$pb.TagNumber(13)
  set claimTxid($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasClaimTxid() => $_has(12);
  @$pb.TagNumber(13)
  void clearClaimTxid() => clearField(13);
}

class ReverseSwapFees extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReverseSwapFees', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'percentage', $pb.PbFieldType.OD)
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lockup')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'claim')
    ..hasRequiredFields = false
  ;

  ReverseSwapFees._() : super();
  factory ReverseSwapFees({
    $core.double percentage,
    $fixnum.Int64 lockup,
    $fixnum.Int64 claim,
  }) {
    final _result = create();
    if (percentage != null) {
      _result.percentage = percentage;
    }
    if (lockup != null) {
      _result.lockup = lockup;
    }
    if (claim != null) {
      _result.claim = claim;
    }
    return _result;
  }
  factory ReverseSwapFees.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReverseSwapFees.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReverseSwapFees clone() => ReverseSwapFees()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReverseSwapFees copyWith(void Function(ReverseSwapFees) updates) => super.copyWith((message) => updates(message as ReverseSwapFees)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReverseSwapFees create() => ReverseSwapFees._();
  ReverseSwapFees createEmptyInstance() => create();
  static $pb.PbList<ReverseSwapFees> createRepeated() => $pb.PbList<ReverseSwapFees>();
  @$core.pragma('dart2js:noInline')
  static ReverseSwapFees getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReverseSwapFees>(create);
  static ReverseSwapFees _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get percentage => $_getN(0);
  @$pb.TagNumber(1)
  set percentage($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPercentage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPercentage() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get lockup => $_getI64(1);
  @$pb.TagNumber(2)
  set lockup($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLockup() => $_has(1);
  @$pb.TagNumber(2)
  void clearLockup() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get claim => $_getI64(2);
  @$pb.TagNumber(3)
  set claim($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasClaim() => $_has(2);
  @$pb.TagNumber(3)
  void clearClaim() => clearField(3);
}

class ReverseSwapInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReverseSwapInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'min')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'max')
    ..aOM<ReverseSwapFees>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fees', subBuilder: ReverseSwapFees.create)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'feesHash')
    ..hasRequiredFields = false
  ;

  ReverseSwapInfo._() : super();
  factory ReverseSwapInfo({
    $fixnum.Int64 min,
    $fixnum.Int64 max,
    ReverseSwapFees fees,
    $core.String feesHash,
  }) {
    final _result = create();
    if (min != null) {
      _result.min = min;
    }
    if (max != null) {
      _result.max = max;
    }
    if (fees != null) {
      _result.fees = fees;
    }
    if (feesHash != null) {
      _result.feesHash = feesHash;
    }
    return _result;
  }
  factory ReverseSwapInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReverseSwapInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReverseSwapInfo clone() => ReverseSwapInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReverseSwapInfo copyWith(void Function(ReverseSwapInfo) updates) => super.copyWith((message) => updates(message as ReverseSwapInfo)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReverseSwapInfo create() => ReverseSwapInfo._();
  ReverseSwapInfo createEmptyInstance() => create();
  static $pb.PbList<ReverseSwapInfo> createRepeated() => $pb.PbList<ReverseSwapInfo>();
  @$core.pragma('dart2js:noInline')
  static ReverseSwapInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReverseSwapInfo>(create);
  static ReverseSwapInfo _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get min => $_getI64(0);
  @$pb.TagNumber(1)
  set min($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMin() => $_has(0);
  @$pb.TagNumber(1)
  void clearMin() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get max => $_getI64(1);
  @$pb.TagNumber(2)
  set max($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMax() => $_has(1);
  @$pb.TagNumber(2)
  void clearMax() => clearField(2);

  @$pb.TagNumber(3)
  ReverseSwapFees get fees => $_getN(2);
  @$pb.TagNumber(3)
  set fees(ReverseSwapFees v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFees() => $_has(2);
  @$pb.TagNumber(3)
  void clearFees() => clearField(3);
  @$pb.TagNumber(3)
  ReverseSwapFees ensureFees() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get feesHash => $_getSZ(3);
  @$pb.TagNumber(4)
  set feesHash($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFeesHash() => $_has(3);
  @$pb.TagNumber(4)
  void clearFeesHash() => clearField(4);
}

class ReverseSwapPaymentRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReverseSwapPaymentRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hash')
    ..aOM<PushNotificationDetails>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pushNotificationDetails', subBuilder: PushNotificationDetails.create)
    ..hasRequiredFields = false
  ;

  ReverseSwapPaymentRequest._() : super();
  factory ReverseSwapPaymentRequest({
    $core.String hash,
    PushNotificationDetails pushNotificationDetails,
  }) {
    final _result = create();
    if (hash != null) {
      _result.hash = hash;
    }
    if (pushNotificationDetails != null) {
      _result.pushNotificationDetails = pushNotificationDetails;
    }
    return _result;
  }
  factory ReverseSwapPaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReverseSwapPaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReverseSwapPaymentRequest clone() => ReverseSwapPaymentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReverseSwapPaymentRequest copyWith(void Function(ReverseSwapPaymentRequest) updates) => super.copyWith((message) => updates(message as ReverseSwapPaymentRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReverseSwapPaymentRequest create() => ReverseSwapPaymentRequest._();
  ReverseSwapPaymentRequest createEmptyInstance() => create();
  static $pb.PbList<ReverseSwapPaymentRequest> createRepeated() => $pb.PbList<ReverseSwapPaymentRequest>();
  @$core.pragma('dart2js:noInline')
  static ReverseSwapPaymentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReverseSwapPaymentRequest>(create);
  static ReverseSwapPaymentRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hash => $_getSZ(0);
  @$pb.TagNumber(1)
  set hash($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => clearField(1);

  @$pb.TagNumber(2)
  PushNotificationDetails get pushNotificationDetails => $_getN(1);
  @$pb.TagNumber(2)
  set pushNotificationDetails(PushNotificationDetails v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPushNotificationDetails() => $_has(1);
  @$pb.TagNumber(2)
  void clearPushNotificationDetails() => clearField(2);
  @$pb.TagNumber(2)
  PushNotificationDetails ensurePushNotificationDetails() => $_ensure(1);
}

class PushNotificationDetails extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PushNotificationDetails', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'body')
    ..hasRequiredFields = false
  ;

  PushNotificationDetails._() : super();
  factory PushNotificationDetails({
    $core.String deviceId,
    $core.String title,
    $core.String body,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    if (title != null) {
      _result.title = title;
    }
    if (body != null) {
      _result.body = body;
    }
    return _result;
  }
  factory PushNotificationDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PushNotificationDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PushNotificationDetails clone() => PushNotificationDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PushNotificationDetails copyWith(void Function(PushNotificationDetails) updates) => super.copyWith((message) => updates(message as PushNotificationDetails)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PushNotificationDetails create() => PushNotificationDetails._();
  PushNotificationDetails createEmptyInstance() => create();
  static $pb.PbList<PushNotificationDetails> createRepeated() => $pb.PbList<PushNotificationDetails>();
  @$core.pragma('dart2js:noInline')
  static PushNotificationDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PushNotificationDetails>(create);
  static PushNotificationDetails _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get body => $_getSZ(2);
  @$pb.TagNumber(3)
  set body($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBody() => $_has(2);
  @$pb.TagNumber(3)
  void clearBody() => clearField(3);
}

class ReverseSwapPaymentStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReverseSwapPaymentStatus', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hash')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'eta', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ReverseSwapPaymentStatus._() : super();
  factory ReverseSwapPaymentStatus({
    $core.String hash,
    $core.int eta,
  }) {
    final _result = create();
    if (hash != null) {
      _result.hash = hash;
    }
    if (eta != null) {
      _result.eta = eta;
    }
    return _result;
  }
  factory ReverseSwapPaymentStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReverseSwapPaymentStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReverseSwapPaymentStatus clone() => ReverseSwapPaymentStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReverseSwapPaymentStatus copyWith(void Function(ReverseSwapPaymentStatus) updates) => super.copyWith((message) => updates(message as ReverseSwapPaymentStatus)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReverseSwapPaymentStatus create() => ReverseSwapPaymentStatus._();
  ReverseSwapPaymentStatus createEmptyInstance() => create();
  static $pb.PbList<ReverseSwapPaymentStatus> createRepeated() => $pb.PbList<ReverseSwapPaymentStatus>();
  @$core.pragma('dart2js:noInline')
  static ReverseSwapPaymentStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReverseSwapPaymentStatus>(create);
  static ReverseSwapPaymentStatus _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hash => $_getSZ(0);
  @$pb.TagNumber(1)
  set hash($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => clearField(1);

  @$pb.TagNumber(3)
  $core.int get eta => $_getIZ(1);
  @$pb.TagNumber(3)
  set eta($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasEta() => $_has(1);
  @$pb.TagNumber(3)
  void clearEta() => clearField(3);
}

class ReverseSwapPaymentStatuses extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReverseSwapPaymentStatuses', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..pc<ReverseSwapPaymentStatus>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentsStatus', $pb.PbFieldType.PM, subBuilder: ReverseSwapPaymentStatus.create)
    ..hasRequiredFields = false
  ;

  ReverseSwapPaymentStatuses._() : super();
  factory ReverseSwapPaymentStatuses({
    $core.Iterable<ReverseSwapPaymentStatus> paymentsStatus,
  }) {
    final _result = create();
    if (paymentsStatus != null) {
      _result.paymentsStatus.addAll(paymentsStatus);
    }
    return _result;
  }
  factory ReverseSwapPaymentStatuses.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReverseSwapPaymentStatuses.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReverseSwapPaymentStatuses clone() => ReverseSwapPaymentStatuses()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReverseSwapPaymentStatuses copyWith(void Function(ReverseSwapPaymentStatuses) updates) => super.copyWith((message) => updates(message as ReverseSwapPaymentStatuses)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReverseSwapPaymentStatuses create() => ReverseSwapPaymentStatuses._();
  ReverseSwapPaymentStatuses createEmptyInstance() => create();
  static $pb.PbList<ReverseSwapPaymentStatuses> createRepeated() => $pb.PbList<ReverseSwapPaymentStatuses>();
  @$core.pragma('dart2js:noInline')
  static ReverseSwapPaymentStatuses getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReverseSwapPaymentStatuses>(create);
  static ReverseSwapPaymentStatuses _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ReverseSwapPaymentStatus> get paymentsStatus => $_getList(0);
}

class ReverseSwapClaimFee extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReverseSwapClaimFee', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hash')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fee')
    ..hasRequiredFields = false
  ;

  ReverseSwapClaimFee._() : super();
  factory ReverseSwapClaimFee({
    $core.String hash,
    $fixnum.Int64 fee,
  }) {
    final _result = create();
    if (hash != null) {
      _result.hash = hash;
    }
    if (fee != null) {
      _result.fee = fee;
    }
    return _result;
  }
  factory ReverseSwapClaimFee.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReverseSwapClaimFee.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReverseSwapClaimFee clone() => ReverseSwapClaimFee()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReverseSwapClaimFee copyWith(void Function(ReverseSwapClaimFee) updates) => super.copyWith((message) => updates(message as ReverseSwapClaimFee)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReverseSwapClaimFee create() => ReverseSwapClaimFee._();
  ReverseSwapClaimFee createEmptyInstance() => create();
  static $pb.PbList<ReverseSwapClaimFee> createRepeated() => $pb.PbList<ReverseSwapClaimFee>();
  @$core.pragma('dart2js:noInline')
  static ReverseSwapClaimFee getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReverseSwapClaimFee>(create);
  static ReverseSwapClaimFee _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hash => $_getSZ(0);
  @$pb.TagNumber(1)
  set hash($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fee => $_getI64(1);
  @$pb.TagNumber(2)
  set fee($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFee() => $_has(1);
  @$pb.TagNumber(2)
  void clearFee() => clearField(2);
}

class ClaimFeeEstimates extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ClaimFeeEstimates', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..m<$core.int, $fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fees', entryClassName: 'ClaimFeeEstimates.FeesEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.O6, packageName: const $pb.PackageName('data'))
    ..hasRequiredFields = false
  ;

  ClaimFeeEstimates._() : super();
  factory ClaimFeeEstimates({
    $core.Map<$core.int, $fixnum.Int64> fees,
  }) {
    final _result = create();
    if (fees != null) {
      _result.fees.addAll(fees);
    }
    return _result;
  }
  factory ClaimFeeEstimates.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClaimFeeEstimates.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClaimFeeEstimates clone() => ClaimFeeEstimates()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClaimFeeEstimates copyWith(void Function(ClaimFeeEstimates) updates) => super.copyWith((message) => updates(message as ClaimFeeEstimates)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClaimFeeEstimates create() => ClaimFeeEstimates._();
  ClaimFeeEstimates createEmptyInstance() => create();
  static $pb.PbList<ClaimFeeEstimates> createRepeated() => $pb.PbList<ClaimFeeEstimates>();
  @$core.pragma('dart2js:noInline')
  static ClaimFeeEstimates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClaimFeeEstimates>(create);
  static ClaimFeeEstimates _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.int, $fixnum.Int64> get fees => $_getMap(0);
}

class UnspendLockupInformation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UnspendLockupInformation', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'heightHint', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lockupScript', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'claimTxHash', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  UnspendLockupInformation._() : super();
  factory UnspendLockupInformation({
    $core.int heightHint,
    $core.List<$core.int> lockupScript,
    $core.List<$core.int> claimTxHash,
  }) {
    final _result = create();
    if (heightHint != null) {
      _result.heightHint = heightHint;
    }
    if (lockupScript != null) {
      _result.lockupScript = lockupScript;
    }
    if (claimTxHash != null) {
      _result.claimTxHash = claimTxHash;
    }
    return _result;
  }
  factory UnspendLockupInformation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnspendLockupInformation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnspendLockupInformation clone() => UnspendLockupInformation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnspendLockupInformation copyWith(void Function(UnspendLockupInformation) updates) => super.copyWith((message) => updates(message as UnspendLockupInformation)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UnspendLockupInformation create() => UnspendLockupInformation._();
  UnspendLockupInformation createEmptyInstance() => create();
  static $pb.PbList<UnspendLockupInformation> createRepeated() => $pb.PbList<UnspendLockupInformation>();
  @$core.pragma('dart2js:noInline')
  static UnspendLockupInformation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnspendLockupInformation>(create);
  static UnspendLockupInformation _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get heightHint => $_getIZ(0);
  @$pb.TagNumber(1)
  set heightHint($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHeightHint() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeightHint() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get lockupScript => $_getN(1);
  @$pb.TagNumber(2)
  set lockupScript($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLockupScript() => $_has(1);
  @$pb.TagNumber(2)
  void clearLockupScript() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get claimTxHash => $_getN(2);
  @$pb.TagNumber(3)
  set claimTxHash($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasClaimTxHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearClaimTxHash() => clearField(3);
}

class TransactionDetails extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TransactionDetails', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tx', $pb.PbFieldType.OY)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txHash')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fees')
    ..hasRequiredFields = false
  ;

  TransactionDetails._() : super();
  factory TransactionDetails({
    $core.List<$core.int> tx,
    $core.String txHash,
    $fixnum.Int64 fees,
  }) {
    final _result = create();
    if (tx != null) {
      _result.tx = tx;
    }
    if (txHash != null) {
      _result.txHash = txHash;
    }
    if (fees != null) {
      _result.fees = fees;
    }
    return _result;
  }
  factory TransactionDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransactionDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransactionDetails clone() => TransactionDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransactionDetails copyWith(void Function(TransactionDetails) updates) => super.copyWith((message) => updates(message as TransactionDetails)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TransactionDetails create() => TransactionDetails._();
  TransactionDetails createEmptyInstance() => create();
  static $pb.PbList<TransactionDetails> createRepeated() => $pb.PbList<TransactionDetails>();
  @$core.pragma('dart2js:noInline')
  static TransactionDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransactionDetails>(create);
  static TransactionDetails _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get tx => $_getN(0);
  @$pb.TagNumber(1)
  set tx($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTx() => $_has(0);
  @$pb.TagNumber(1)
  void clearTx() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get txHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set txHash($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTxHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearTxHash() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get fees => $_getI64(2);
  @$pb.TagNumber(3)
  set fees($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFees() => $_has(2);
  @$pb.TagNumber(3)
  void clearFees() => clearField(3);
}

class SweepAllCoinsTransactions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SweepAllCoinsTransactions', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amt')
    ..m<$core.int, TransactionDetails>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transactions', entryClassName: 'SweepAllCoinsTransactions.TransactionsEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OM, valueCreator: TransactionDetails.create, packageName: const $pb.PackageName('data'))
    ..hasRequiredFields = false
  ;

  SweepAllCoinsTransactions._() : super();
  factory SweepAllCoinsTransactions({
    $fixnum.Int64 amt,
    $core.Map<$core.int, TransactionDetails> transactions,
  }) {
    final _result = create();
    if (amt != null) {
      _result.amt = amt;
    }
    if (transactions != null) {
      _result.transactions.addAll(transactions);
    }
    return _result;
  }
  factory SweepAllCoinsTransactions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SweepAllCoinsTransactions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SweepAllCoinsTransactions clone() => SweepAllCoinsTransactions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SweepAllCoinsTransactions copyWith(void Function(SweepAllCoinsTransactions) updates) => super.copyWith((message) => updates(message as SweepAllCoinsTransactions)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SweepAllCoinsTransactions create() => SweepAllCoinsTransactions._();
  SweepAllCoinsTransactions createEmptyInstance() => create();
  static $pb.PbList<SweepAllCoinsTransactions> createRepeated() => $pb.PbList<SweepAllCoinsTransactions>();
  @$core.pragma('dart2js:noInline')
  static SweepAllCoinsTransactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SweepAllCoinsTransactions>(create);
  static SweepAllCoinsTransactions _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get amt => $_getI64(0);
  @$pb.TagNumber(1)
  set amt($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAmt() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmt() => clearField(1);

  @$pb.TagNumber(2)
  $core.Map<$core.int, TransactionDetails> get transactions => $_getMap(1);
}

class DownloadBackupResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DownloadBackupResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'data'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'files')
    ..hasRequiredFields = false
  ;

  DownloadBackupResponse._() : super();
  factory DownloadBackupResponse({
    $core.Iterable<$core.String> files,
  }) {
    final _result = create();
    if (files != null) {
      _result.files.addAll(files);
    }
    return _result;
  }
  factory DownloadBackupResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DownloadBackupResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DownloadBackupResponse clone() => DownloadBackupResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DownloadBackupResponse copyWith(void Function(DownloadBackupResponse) updates) => super.copyWith((message) => updates(message as DownloadBackupResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DownloadBackupResponse create() => DownloadBackupResponse._();
  DownloadBackupResponse createEmptyInstance() => create();
  static $pb.PbList<DownloadBackupResponse> createRepeated() => $pb.PbList<DownloadBackupResponse>();
  @$core.pragma('dart2js:noInline')
  static DownloadBackupResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DownloadBackupResponse>(create);
  static DownloadBackupResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get files => $_getList(0);
}


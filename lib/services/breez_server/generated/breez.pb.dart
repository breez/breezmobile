//
//  Generated code. Do not modify.
//  source: breez.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'breez.pbenum.dart';

export 'breez.pbenum.dart';

class SignUrlRequest extends $pb.GeneratedMessage {
  factory SignUrlRequest({
    $core.String? baseUrl,
    $core.String? queryString,
  }) {
    final $result = create();
    if (baseUrl != null) {
      $result.baseUrl = baseUrl;
    }
    if (queryString != null) {
      $result.queryString = queryString;
    }
    return $result;
  }
  SignUrlRequest._() : super();
  factory SignUrlRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignUrlRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SignUrlRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'base_url', protoName: 'baseUrl')
    ..aOS(2, _omitFieldNames ? '' : 'query_string', protoName: 'queryString')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignUrlRequest clone() => SignUrlRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignUrlRequest copyWith(void Function(SignUrlRequest) updates) => super.copyWith((message) => updates(message as SignUrlRequest)) as SignUrlRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignUrlRequest create() => SignUrlRequest._();
  SignUrlRequest createEmptyInstance() => create();
  static $pb.PbList<SignUrlRequest> createRepeated() => $pb.PbList<SignUrlRequest>();
  @$core.pragma('dart2js:noInline')
  static SignUrlRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignUrlRequest>(create);
  static SignUrlRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get baseUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set baseUrl($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBaseUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseUrl() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get queryString => $_getSZ(1);
  @$pb.TagNumber(2)
  set queryString($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasQueryString() => $_has(1);
  @$pb.TagNumber(2)
  void clearQueryString() => clearField(2);
}

class SignUrlResponse extends $pb.GeneratedMessage {
  factory SignUrlResponse({
    $core.String? fullUrl,
  }) {
    final $result = create();
    if (fullUrl != null) {
      $result.fullUrl = fullUrl;
    }
    return $result;
  }
  SignUrlResponse._() : super();
  factory SignUrlResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignUrlResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SignUrlResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'full_url', protoName: 'fullUrl')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignUrlResponse clone() => SignUrlResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignUrlResponse copyWith(void Function(SignUrlResponse) updates) => super.copyWith((message) => updates(message as SignUrlResponse)) as SignUrlResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignUrlResponse create() => SignUrlResponse._();
  SignUrlResponse createEmptyInstance() => create();
  static $pb.PbList<SignUrlResponse> createRepeated() => $pb.PbList<SignUrlResponse>();
  @$core.pragma('dart2js:noInline')
  static SignUrlResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignUrlResponse>(create);
  static SignUrlResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fullUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set fullUrl($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFullUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearFullUrl() => clearField(1);
}

class InactiveNotifyRequest extends $pb.GeneratedMessage {
  factory InactiveNotifyRequest({
    $core.List<$core.int>? pubkey,
    $core.int? days,
  }) {
    final $result = create();
    if (pubkey != null) {
      $result.pubkey = pubkey;
    }
    if (days != null) {
      $result.days = days;
    }
    return $result;
  }
  InactiveNotifyRequest._() : super();
  factory InactiveNotifyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InactiveNotifyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InactiveNotifyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'pubkey', $pb.PbFieldType.OY)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'days', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InactiveNotifyRequest clone() => InactiveNotifyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InactiveNotifyRequest copyWith(void Function(InactiveNotifyRequest) updates) => super.copyWith((message) => updates(message as InactiveNotifyRequest)) as InactiveNotifyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InactiveNotifyRequest create() => InactiveNotifyRequest._();
  InactiveNotifyRequest createEmptyInstance() => create();
  static $pb.PbList<InactiveNotifyRequest> createRepeated() => $pb.PbList<InactiveNotifyRequest>();
  @$core.pragma('dart2js:noInline')
  static InactiveNotifyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InactiveNotifyRequest>(create);
  static InactiveNotifyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get pubkey => $_getN(0);
  @$pb.TagNumber(1)
  set pubkey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPubkey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPubkey() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get days => $_getIZ(1);
  @$pb.TagNumber(2)
  set days($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDays() => $_has(1);
  @$pb.TagNumber(2)
  void clearDays() => clearField(2);
}

class InactiveNotifyResponse extends $pb.GeneratedMessage {
  factory InactiveNotifyResponse() => create();
  InactiveNotifyResponse._() : super();
  factory InactiveNotifyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InactiveNotifyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InactiveNotifyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InactiveNotifyResponse clone() => InactiveNotifyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InactiveNotifyResponse copyWith(void Function(InactiveNotifyResponse) updates) => super.copyWith((message) => updates(message as InactiveNotifyResponse)) as InactiveNotifyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InactiveNotifyResponse create() => InactiveNotifyResponse._();
  InactiveNotifyResponse createEmptyInstance() => create();
  static $pb.PbList<InactiveNotifyResponse> createRepeated() => $pb.PbList<InactiveNotifyResponse>();
  @$core.pragma('dart2js:noInline')
  static InactiveNotifyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InactiveNotifyResponse>(create);
  static InactiveNotifyResponse? _defaultInstance;
}

class RegisterPaymentNotificationRequest extends $pb.GeneratedMessage {
  factory RegisterPaymentNotificationRequest({
    $core.String? lspId,
    $core.List<$core.int>? blob,
  }) {
    final $result = create();
    if (lspId != null) {
      $result.lspId = lspId;
    }
    if (blob != null) {
      $result.blob = blob;
    }
    return $result;
  }
  RegisterPaymentNotificationRequest._() : super();
  factory RegisterPaymentNotificationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPaymentNotificationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterPaymentNotificationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lspId')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'blob', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterPaymentNotificationRequest clone() => RegisterPaymentNotificationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterPaymentNotificationRequest copyWith(void Function(RegisterPaymentNotificationRequest) updates) => super.copyWith((message) => updates(message as RegisterPaymentNotificationRequest)) as RegisterPaymentNotificationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPaymentNotificationRequest create() => RegisterPaymentNotificationRequest._();
  RegisterPaymentNotificationRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterPaymentNotificationRequest> createRepeated() => $pb.PbList<RegisterPaymentNotificationRequest>();
  @$core.pragma('dart2js:noInline')
  static RegisterPaymentNotificationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterPaymentNotificationRequest>(create);
  static RegisterPaymentNotificationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lspId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lspId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLspId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLspId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get blob => $_getN(1);
  @$pb.TagNumber(2)
  set blob($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBlob() => $_has(1);
  @$pb.TagNumber(2)
  void clearBlob() => clearField(2);
}

class RegisterPaymentNotificationResponse extends $pb.GeneratedMessage {
  factory RegisterPaymentNotificationResponse() => create();
  RegisterPaymentNotificationResponse._() : super();
  factory RegisterPaymentNotificationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPaymentNotificationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterPaymentNotificationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterPaymentNotificationResponse clone() => RegisterPaymentNotificationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterPaymentNotificationResponse copyWith(void Function(RegisterPaymentNotificationResponse) updates) => super.copyWith((message) => updates(message as RegisterPaymentNotificationResponse)) as RegisterPaymentNotificationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPaymentNotificationResponse create() => RegisterPaymentNotificationResponse._();
  RegisterPaymentNotificationResponse createEmptyInstance() => create();
  static $pb.PbList<RegisterPaymentNotificationResponse> createRepeated() => $pb.PbList<RegisterPaymentNotificationResponse>();
  @$core.pragma('dart2js:noInline')
  static RegisterPaymentNotificationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterPaymentNotificationResponse>(create);
  static RegisterPaymentNotificationResponse? _defaultInstance;
}

class ReceiverInfoRequest extends $pb.GeneratedMessage {
  factory ReceiverInfoRequest() => create();
  ReceiverInfoRequest._() : super();
  factory ReceiverInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReceiverInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReceiverInfoRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReceiverInfoRequest clone() => ReceiverInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReceiverInfoRequest copyWith(void Function(ReceiverInfoRequest) updates) => super.copyWith((message) => updates(message as ReceiverInfoRequest)) as ReceiverInfoRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiverInfoRequest create() => ReceiverInfoRequest._();
  ReceiverInfoRequest createEmptyInstance() => create();
  static $pb.PbList<ReceiverInfoRequest> createRepeated() => $pb.PbList<ReceiverInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static ReceiverInfoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReceiverInfoRequest>(create);
  static ReceiverInfoRequest? _defaultInstance;
}

class ReceiverInfoReply extends $pb.GeneratedMessage {
  factory ReceiverInfoReply({
    $core.String? pubkey,
  }) {
    final $result = create();
    if (pubkey != null) {
      $result.pubkey = pubkey;
    }
    return $result;
  }
  ReceiverInfoReply._() : super();
  factory ReceiverInfoReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReceiverInfoReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReceiverInfoReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pubkey')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReceiverInfoReply clone() => ReceiverInfoReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReceiverInfoReply copyWith(void Function(ReceiverInfoReply) updates) => super.copyWith((message) => updates(message as ReceiverInfoReply)) as ReceiverInfoReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiverInfoReply create() => ReceiverInfoReply._();
  ReceiverInfoReply createEmptyInstance() => create();
  static $pb.PbList<ReceiverInfoReply> createRepeated() => $pb.PbList<ReceiverInfoReply>();
  @$core.pragma('dart2js:noInline')
  static ReceiverInfoReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReceiverInfoReply>(create);
  static ReceiverInfoReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pubkey => $_getSZ(0);
  @$pb.TagNumber(1)
  set pubkey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPubkey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPubkey() => clearField(1);
}

class RatesRequest extends $pb.GeneratedMessage {
  factory RatesRequest() => create();
  RatesRequest._() : super();
  factory RatesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RatesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RatesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RatesRequest clone() => RatesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RatesRequest copyWith(void Function(RatesRequest) updates) => super.copyWith((message) => updates(message as RatesRequest)) as RatesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RatesRequest create() => RatesRequest._();
  RatesRequest createEmptyInstance() => create();
  static $pb.PbList<RatesRequest> createRepeated() => $pb.PbList<RatesRequest>();
  @$core.pragma('dart2js:noInline')
  static RatesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RatesRequest>(create);
  static RatesRequest? _defaultInstance;
}

class Rate extends $pb.GeneratedMessage {
  factory Rate({
    $core.String? coin,
    $core.double? value,
  }) {
    final $result = create();
    if (coin != null) {
      $result.coin = coin;
    }
    if (value != null) {
      $result.value = value;
    }
    return $result;
  }
  Rate._() : super();
  factory Rate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Rate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Rate', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'coin')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Rate clone() => Rate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Rate copyWith(void Function(Rate) updates) => super.copyWith((message) => updates(message as Rate)) as Rate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Rate create() => Rate._();
  Rate createEmptyInstance() => create();
  static $pb.PbList<Rate> createRepeated() => $pb.PbList<Rate>();
  @$core.pragma('dart2js:noInline')
  static Rate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Rate>(create);
  static Rate? _defaultInstance;

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

class RatesReply extends $pb.GeneratedMessage {
  factory RatesReply({
    $core.Iterable<Rate>? rates,
  }) {
    final $result = create();
    if (rates != null) {
      $result.rates.addAll(rates);
    }
    return $result;
  }
  RatesReply._() : super();
  factory RatesReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RatesReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RatesReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..pc<Rate>(1, _omitFieldNames ? '' : 'rates', $pb.PbFieldType.PM, subBuilder: Rate.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RatesReply clone() => RatesReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RatesReply copyWith(void Function(RatesReply) updates) => super.copyWith((message) => updates(message as RatesReply)) as RatesReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RatesReply create() => RatesReply._();
  RatesReply createEmptyInstance() => create();
  static $pb.PbList<RatesReply> createRepeated() => $pb.PbList<RatesReply>();
  @$core.pragma('dart2js:noInline')
  static RatesReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RatesReply>(create);
  static RatesReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Rate> get rates => $_getList(0);
}

class LSPListRequest extends $pb.GeneratedMessage {
  factory LSPListRequest({
    $core.String? pubkey,
  }) {
    final $result = create();
    if (pubkey != null) {
      $result.pubkey = pubkey;
    }
    return $result;
  }
  LSPListRequest._() : super();
  factory LSPListRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LSPListRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LSPListRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(2, _omitFieldNames ? '' : 'pubkey')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LSPListRequest clone() => LSPListRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LSPListRequest copyWith(void Function(LSPListRequest) updates) => super.copyWith((message) => updates(message as LSPListRequest)) as LSPListRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LSPListRequest create() => LSPListRequest._();
  LSPListRequest createEmptyInstance() => create();
  static $pb.PbList<LSPListRequest> createRepeated() => $pb.PbList<LSPListRequest>();
  @$core.pragma('dart2js:noInline')
  static LSPListRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LSPListRequest>(create);
  static LSPListRequest? _defaultInstance;

  /// / The identity pubkey of the client
  @$pb.TagNumber(2)
  $core.String get pubkey => $_getSZ(0);
  @$pb.TagNumber(2)
  set pubkey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasPubkey() => $_has(0);
  @$pb.TagNumber(2)
  void clearPubkey() => clearField(2);
}

class LSPInformation extends $pb.GeneratedMessage {
  factory LSPInformation({
    $core.String? name,
    $core.String? widgetUrl,
    $core.String? pubkey,
    $core.String? host,
    $fixnum.Int64? channelCapacity,
    $core.int? targetConf,
    $fixnum.Int64? baseFeeMsat,
    $core.double? feeRate,
    $core.int? timeLockDelta,
    $fixnum.Int64? minHtlcMsat,
  @$core.Deprecated('This field is deprecated.')
    $fixnum.Int64? channelFeePermyriad,
    $core.List<$core.int>? lspPubkey,
  @$core.Deprecated('This field is deprecated.')
    $fixnum.Int64? maxInactiveDuration,
  @$core.Deprecated('This field is deprecated.')
    $fixnum.Int64? channelMinimumFeeMsat,
    $core.Iterable<OpeningFeeParams>? openingFeeParamsMenu,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (widgetUrl != null) {
      $result.widgetUrl = widgetUrl;
    }
    if (pubkey != null) {
      $result.pubkey = pubkey;
    }
    if (host != null) {
      $result.host = host;
    }
    if (channelCapacity != null) {
      $result.channelCapacity = channelCapacity;
    }
    if (targetConf != null) {
      $result.targetConf = targetConf;
    }
    if (baseFeeMsat != null) {
      $result.baseFeeMsat = baseFeeMsat;
    }
    if (feeRate != null) {
      $result.feeRate = feeRate;
    }
    if (timeLockDelta != null) {
      $result.timeLockDelta = timeLockDelta;
    }
    if (minHtlcMsat != null) {
      $result.minHtlcMsat = minHtlcMsat;
    }
    if (channelFeePermyriad != null) {
      // ignore: deprecated_member_use_from_same_package
      $result.channelFeePermyriad = channelFeePermyriad;
    }
    if (lspPubkey != null) {
      $result.lspPubkey = lspPubkey;
    }
    if (maxInactiveDuration != null) {
      // ignore: deprecated_member_use_from_same_package
      $result.maxInactiveDuration = maxInactiveDuration;
    }
    if (channelMinimumFeeMsat != null) {
      // ignore: deprecated_member_use_from_same_package
      $result.channelMinimumFeeMsat = channelMinimumFeeMsat;
    }
    if (openingFeeParamsMenu != null) {
      $result.openingFeeParamsMenu.addAll(openingFeeParamsMenu);
    }
    return $result;
  }
  LSPInformation._() : super();
  factory LSPInformation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LSPInformation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LSPInformation', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'widget_url')
    ..aOS(3, _omitFieldNames ? '' : 'pubkey')
    ..aOS(4, _omitFieldNames ? '' : 'host')
    ..aInt64(5, _omitFieldNames ? '' : 'channel_capacity')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'target_conf', $pb.PbFieldType.O3)
    ..aInt64(7, _omitFieldNames ? '' : 'base_fee_msat')
    ..a<$core.double>(8, _omitFieldNames ? '' : 'fee_rate', $pb.PbFieldType.OD)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'time_lock_delta', $pb.PbFieldType.OU3)
    ..aInt64(10, _omitFieldNames ? '' : 'min_htlc_msat')
    ..aInt64(11, _omitFieldNames ? '' : 'channelFeePermyriad')
    ..a<$core.List<$core.int>>(12, _omitFieldNames ? '' : 'lspPubkey', $pb.PbFieldType.OY)
    ..aInt64(13, _omitFieldNames ? '' : 'maxInactiveDuration')
    ..aInt64(14, _omitFieldNames ? '' : 'channelMinimumFeeMsat')
    ..pc<OpeningFeeParams>(15, _omitFieldNames ? '' : 'openingFeeParamsMenu', $pb.PbFieldType.PM, subBuilder: OpeningFeeParams.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LSPInformation clone() => LSPInformation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LSPInformation copyWith(void Function(LSPInformation) updates) => super.copyWith((message) => updates(message as LSPInformation)) as LSPInformation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LSPInformation create() => LSPInformation._();
  LSPInformation createEmptyInstance() => create();
  static $pb.PbList<LSPInformation> createRepeated() => $pb.PbList<LSPInformation>();
  @$core.pragma('dart2js:noInline')
  static LSPInformation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LSPInformation>(create);
  static LSPInformation? _defaultInstance;

  /// / The name of of lsp
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  /// / The name of of lsp
  @$pb.TagNumber(2)
  $core.String get widgetUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set widgetUrl($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasWidgetUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearWidgetUrl() => clearField(2);

  /// / The identity pubkey of the Lightning node
  @$pb.TagNumber(3)
  $core.String get pubkey => $_getSZ(2);
  @$pb.TagNumber(3)
  set pubkey($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPubkey() => $_has(2);
  @$pb.TagNumber(3)
  void clearPubkey() => clearField(3);

  /// / The network location of the lightning node, e.g. `12.34.56.78:9012` or `localhost:10011`
  @$pb.TagNumber(4)
  $core.String get host => $_getSZ(3);
  @$pb.TagNumber(4)
  set host($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHost() => $_has(3);
  @$pb.TagNumber(4)
  void clearHost() => clearField(4);

  /// / The channel capacity in satoshis
  @$pb.TagNumber(5)
  $fixnum.Int64 get channelCapacity => $_getI64(4);
  @$pb.TagNumber(5)
  set channelCapacity($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasChannelCapacity() => $_has(4);
  @$pb.TagNumber(5)
  void clearChannelCapacity() => clearField(5);

  /// / The target number of blocks that the funding transaction should be confirmed by.
  @$pb.TagNumber(6)
  $core.int get targetConf => $_getIZ(5);
  @$pb.TagNumber(6)
  set targetConf($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTargetConf() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetConf() => clearField(6);

  /// / The base fee charged regardless of the number of milli-satoshis sent.
  @$pb.TagNumber(7)
  $fixnum.Int64 get baseFeeMsat => $_getI64(6);
  @$pb.TagNumber(7)
  set baseFeeMsat($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasBaseFeeMsat() => $_has(6);
  @$pb.TagNumber(7)
  void clearBaseFeeMsat() => clearField(7);

  /// / The effective fee rate in milli-satoshis. The precision of this value goes up to 6 decimal places, so 1e-6.
  @$pb.TagNumber(8)
  $core.double get feeRate => $_getN(7);
  @$pb.TagNumber(8)
  set feeRate($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasFeeRate() => $_has(7);
  @$pb.TagNumber(8)
  void clearFeeRate() => clearField(8);

  /// / The required timelock delta for HTLCs forwarded over the channel.
  @$pb.TagNumber(9)
  $core.int get timeLockDelta => $_getIZ(8);
  @$pb.TagNumber(9)
  set timeLockDelta($core.int v) { $_setUnsignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTimeLockDelta() => $_has(8);
  @$pb.TagNumber(9)
  void clearTimeLockDelta() => clearField(9);

  /// / The minimum value in millisatoshi we will require for incoming HTLCs on the channel.
  @$pb.TagNumber(10)
  $fixnum.Int64 get minHtlcMsat => $_getI64(9);
  @$pb.TagNumber(10)
  set minHtlcMsat($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasMinHtlcMsat() => $_has(9);
  @$pb.TagNumber(10)
  void clearMinHtlcMsat() => clearField(10);

  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(11)
  $fixnum.Int64 get channelFeePermyriad => $_getI64(10);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(11)
  set channelFeePermyriad($fixnum.Int64 v) { $_setInt64(10, v); }
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(11)
  $core.bool hasChannelFeePermyriad() => $_has(10);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(11)
  void clearChannelFeePermyriad() => clearField(11);

  @$pb.TagNumber(12)
  $core.List<$core.int> get lspPubkey => $_getN(11);
  @$pb.TagNumber(12)
  set lspPubkey($core.List<$core.int> v) { $_setBytes(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasLspPubkey() => $_has(11);
  @$pb.TagNumber(12)
  void clearLspPubkey() => clearField(12);

  /// The channel can be closed if not used this duration in seconds.
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(13)
  $fixnum.Int64 get maxInactiveDuration => $_getI64(12);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(13)
  set maxInactiveDuration($fixnum.Int64 v) { $_setInt64(12, v); }
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(13)
  $core.bool hasMaxInactiveDuration() => $_has(12);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(13)
  void clearMaxInactiveDuration() => clearField(13);

  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(14)
  $fixnum.Int64 get channelMinimumFeeMsat => $_getI64(13);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(14)
  set channelMinimumFeeMsat($fixnum.Int64 v) { $_setInt64(13, v); }
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(14)
  $core.bool hasChannelMinimumFeeMsat() => $_has(13);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(14)
  void clearChannelMinimumFeeMsat() => clearField(14);

  @$pb.TagNumber(15)
  $core.List<OpeningFeeParams> get openingFeeParamsMenu => $_getList(14);
}

class OpeningFeeParams extends $pb.GeneratedMessage {
  factory OpeningFeeParams({
    $fixnum.Int64? minMsat,
    $core.int? proportional,
    $core.String? validUntil,
    $core.int? maxIdleTime,
    $core.int? maxClientToSelfDelay,
    $core.String? promise,
    $fixnum.Int64? minPaymentSizeMsat,
    $fixnum.Int64? maxPaymentSizeMsat,
  }) {
    final $result = create();
    if (minMsat != null) {
      $result.minMsat = minMsat;
    }
    if (proportional != null) {
      $result.proportional = proportional;
    }
    if (validUntil != null) {
      $result.validUntil = validUntil;
    }
    if (maxIdleTime != null) {
      $result.maxIdleTime = maxIdleTime;
    }
    if (maxClientToSelfDelay != null) {
      $result.maxClientToSelfDelay = maxClientToSelfDelay;
    }
    if (promise != null) {
      $result.promise = promise;
    }
    if (minPaymentSizeMsat != null) {
      $result.minPaymentSizeMsat = minPaymentSizeMsat;
    }
    if (maxPaymentSizeMsat != null) {
      $result.maxPaymentSizeMsat = maxPaymentSizeMsat;
    }
    return $result;
  }
  OpeningFeeParams._() : super();
  factory OpeningFeeParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpeningFeeParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OpeningFeeParams', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'minMsat', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'proportional', $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'validUntil')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'maxIdleTime', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'maxClientToSelfDelay', $pb.PbFieldType.OU3)
    ..aOS(6, _omitFieldNames ? '' : 'promise')
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'minPaymentSizeMsat', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(8, _omitFieldNames ? '' : 'maxPaymentSizeMsat', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpeningFeeParams clone() => OpeningFeeParams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpeningFeeParams copyWith(void Function(OpeningFeeParams) updates) => super.copyWith((message) => updates(message as OpeningFeeParams)) as OpeningFeeParams;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpeningFeeParams create() => OpeningFeeParams._();
  OpeningFeeParams createEmptyInstance() => create();
  static $pb.PbList<OpeningFeeParams> createRepeated() => $pb.PbList<OpeningFeeParams>();
  @$core.pragma('dart2js:noInline')
  static OpeningFeeParams getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpeningFeeParams>(create);
  static OpeningFeeParams? _defaultInstance;

  /// / The minimum value in millisatoshi we will require for incoming HTLCs on the channel.
  @$pb.TagNumber(1)
  $fixnum.Int64 get minMsat => $_getI64(0);
  @$pb.TagNumber(1)
  set minMsat($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMinMsat() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinMsat() => clearField(1);

  /// / The fee in ppm charged over liquidity when buying a channel.
  @$pb.TagNumber(2)
  $core.int get proportional => $_getIZ(1);
  @$pb.TagNumber(2)
  set proportional($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProportional() => $_has(1);
  @$pb.TagNumber(2)
  void clearProportional() => clearField(2);

  /// / The time this opening fee params promise expires.
  @$pb.TagNumber(3)
  $core.String get validUntil => $_getSZ(2);
  @$pb.TagNumber(3)
  set validUntil($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasValidUntil() => $_has(2);
  @$pb.TagNumber(3)
  void clearValidUntil() => clearField(3);

  /// The channel can be closed if not used this duration in blocks.
  @$pb.TagNumber(4)
  $core.int get maxIdleTime => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxIdleTime($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMaxIdleTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxIdleTime() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get maxClientToSelfDelay => $_getIZ(4);
  @$pb.TagNumber(5)
  set maxClientToSelfDelay($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMaxClientToSelfDelay() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxClientToSelfDelay() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get promise => $_getSZ(5);
  @$pb.TagNumber(6)
  set promise($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPromise() => $_has(5);
  @$pb.TagNumber(6)
  void clearPromise() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get minPaymentSizeMsat => $_getI64(6);
  @$pb.TagNumber(7)
  set minPaymentSizeMsat($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMinPaymentSizeMsat() => $_has(6);
  @$pb.TagNumber(7)
  void clearMinPaymentSizeMsat() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get maxPaymentSizeMsat => $_getI64(7);
  @$pb.TagNumber(8)
  set maxPaymentSizeMsat($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMaxPaymentSizeMsat() => $_has(7);
  @$pb.TagNumber(8)
  void clearMaxPaymentSizeMsat() => clearField(8);
}

class LSPListReply extends $pb.GeneratedMessage {
  factory LSPListReply({
    $core.Map<$core.String, LSPInformation>? lsps,
  }) {
    final $result = create();
    if (lsps != null) {
      $result.lsps.addAll(lsps);
    }
    return $result;
  }
  LSPListReply._() : super();
  factory LSPListReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LSPListReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LSPListReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..m<$core.String, LSPInformation>(1, _omitFieldNames ? '' : 'lsps', entryClassName: 'LSPListReply.LspsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: LSPInformation.create, valueDefaultOrMaker: LSPInformation.getDefault, packageName: const $pb.PackageName('breez'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LSPListReply clone() => LSPListReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LSPListReply copyWith(void Function(LSPListReply) updates) => super.copyWith((message) => updates(message as LSPListReply)) as LSPListReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LSPListReply create() => LSPListReply._();
  LSPListReply createEmptyInstance() => create();
  static $pb.PbList<LSPListReply> createRepeated() => $pb.PbList<LSPListReply>();
  @$core.pragma('dart2js:noInline')
  static LSPListReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LSPListReply>(create);
  static LSPListReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, LSPInformation> get lsps => $_getMap(0);
}

class RegisterPaymentRequest extends $pb.GeneratedMessage {
  factory RegisterPaymentRequest({
    $core.String? lspId,
    $core.List<$core.int>? blob,
  }) {
    final $result = create();
    if (lspId != null) {
      $result.lspId = lspId;
    }
    if (blob != null) {
      $result.blob = blob;
    }
    return $result;
  }
  RegisterPaymentRequest._() : super();
  factory RegisterPaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterPaymentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lspId')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'blob', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterPaymentRequest clone() => RegisterPaymentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterPaymentRequest copyWith(void Function(RegisterPaymentRequest) updates) => super.copyWith((message) => updates(message as RegisterPaymentRequest)) as RegisterPaymentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPaymentRequest create() => RegisterPaymentRequest._();
  RegisterPaymentRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterPaymentRequest> createRepeated() => $pb.PbList<RegisterPaymentRequest>();
  @$core.pragma('dart2js:noInline')
  static RegisterPaymentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterPaymentRequest>(create);
  static RegisterPaymentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lspId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lspId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLspId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLspId() => clearField(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get blob => $_getN(1);
  @$pb.TagNumber(3)
  set blob($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasBlob() => $_has(1);
  @$pb.TagNumber(3)
  void clearBlob() => clearField(3);
}

class RegisterPaymentReply extends $pb.GeneratedMessage {
  factory RegisterPaymentReply() => create();
  RegisterPaymentReply._() : super();
  factory RegisterPaymentReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPaymentReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterPaymentReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterPaymentReply clone() => RegisterPaymentReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterPaymentReply copyWith(void Function(RegisterPaymentReply) updates) => super.copyWith((message) => updates(message as RegisterPaymentReply)) as RegisterPaymentReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPaymentReply create() => RegisterPaymentReply._();
  RegisterPaymentReply createEmptyInstance() => create();
  static $pb.PbList<RegisterPaymentReply> createRepeated() => $pb.PbList<RegisterPaymentReply>();
  @$core.pragma('dart2js:noInline')
  static RegisterPaymentReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterPaymentReply>(create);
  static RegisterPaymentReply? _defaultInstance;
}

class CheckChannelsRequest extends $pb.GeneratedMessage {
  factory CheckChannelsRequest({
    $core.String? lspId,
    $core.List<$core.int>? blob,
  }) {
    final $result = create();
    if (lspId != null) {
      $result.lspId = lspId;
    }
    if (blob != null) {
      $result.blob = blob;
    }
    return $result;
  }
  CheckChannelsRequest._() : super();
  factory CheckChannelsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CheckChannelsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CheckChannelsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lspId')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'blob', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CheckChannelsRequest clone() => CheckChannelsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CheckChannelsRequest copyWith(void Function(CheckChannelsRequest) updates) => super.copyWith((message) => updates(message as CheckChannelsRequest)) as CheckChannelsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckChannelsRequest create() => CheckChannelsRequest._();
  CheckChannelsRequest createEmptyInstance() => create();
  static $pb.PbList<CheckChannelsRequest> createRepeated() => $pb.PbList<CheckChannelsRequest>();
  @$core.pragma('dart2js:noInline')
  static CheckChannelsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckChannelsRequest>(create);
  static CheckChannelsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lspId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lspId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLspId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLspId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get blob => $_getN(1);
  @$pb.TagNumber(2)
  set blob($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBlob() => $_has(1);
  @$pb.TagNumber(2)
  void clearBlob() => clearField(2);
}

class CheckChannelsReply extends $pb.GeneratedMessage {
  factory CheckChannelsReply({
    $core.List<$core.int>? blob,
  }) {
    final $result = create();
    if (blob != null) {
      $result.blob = blob;
    }
    return $result;
  }
  CheckChannelsReply._() : super();
  factory CheckChannelsReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CheckChannelsReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CheckChannelsReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'blob', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CheckChannelsReply clone() => CheckChannelsReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CheckChannelsReply copyWith(void Function(CheckChannelsReply) updates) => super.copyWith((message) => updates(message as CheckChannelsReply)) as CheckChannelsReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckChannelsReply create() => CheckChannelsReply._();
  CheckChannelsReply createEmptyInstance() => create();
  static $pb.PbList<CheckChannelsReply> createRepeated() => $pb.PbList<CheckChannelsReply>();
  @$core.pragma('dart2js:noInline')
  static CheckChannelsReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckChannelsReply>(create);
  static CheckChannelsReply? _defaultInstance;

  @$pb.TagNumber(2)
  $core.List<$core.int> get blob => $_getN(0);
  @$pb.TagNumber(2)
  set blob($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasBlob() => $_has(0);
  @$pb.TagNumber(2)
  void clearBlob() => clearField(2);
}

class Captcha extends $pb.GeneratedMessage {
  factory Captcha({
    $core.String? id,
    $core.List<$core.int>? image,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (image != null) {
      $result.image = image;
    }
    return $result;
  }
  Captcha._() : super();
  factory Captcha.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Captcha.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Captcha', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'image', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Captcha clone() => Captcha()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Captcha copyWith(void Function(Captcha) updates) => super.copyWith((message) => updates(message as Captcha)) as Captcha;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Captcha create() => Captcha._();
  Captcha createEmptyInstance() => create();
  static $pb.PbList<Captcha> createRepeated() => $pb.PbList<Captcha>();
  @$core.pragma('dart2js:noInline')
  static Captcha getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Captcha>(create);
  static Captcha? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get image => $_getN(1);
  @$pb.TagNumber(2)
  set image($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasImage() => $_has(1);
  @$pb.TagNumber(2)
  void clearImage() => clearField(2);
}

class UpdateChannelPolicyRequest extends $pb.GeneratedMessage {
  factory UpdateChannelPolicyRequest({
    $core.String? pubKey,
  }) {
    final $result = create();
    if (pubKey != null) {
      $result.pubKey = pubKey;
    }
    return $result;
  }
  UpdateChannelPolicyRequest._() : super();
  factory UpdateChannelPolicyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateChannelPolicyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateChannelPolicyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pubKey', protoName: 'pubKey')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateChannelPolicyRequest clone() => UpdateChannelPolicyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateChannelPolicyRequest copyWith(void Function(UpdateChannelPolicyRequest) updates) => super.copyWith((message) => updates(message as UpdateChannelPolicyRequest)) as UpdateChannelPolicyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateChannelPolicyRequest create() => UpdateChannelPolicyRequest._();
  UpdateChannelPolicyRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateChannelPolicyRequest> createRepeated() => $pb.PbList<UpdateChannelPolicyRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateChannelPolicyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateChannelPolicyRequest>(create);
  static UpdateChannelPolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pubKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set pubKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPubKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPubKey() => clearField(1);
}

class UpdateChannelPolicyReply extends $pb.GeneratedMessage {
  factory UpdateChannelPolicyReply() => create();
  UpdateChannelPolicyReply._() : super();
  factory UpdateChannelPolicyReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateChannelPolicyReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateChannelPolicyReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateChannelPolicyReply clone() => UpdateChannelPolicyReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateChannelPolicyReply copyWith(void Function(UpdateChannelPolicyReply) updates) => super.copyWith((message) => updates(message as UpdateChannelPolicyReply)) as UpdateChannelPolicyReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateChannelPolicyReply create() => UpdateChannelPolicyReply._();
  UpdateChannelPolicyReply createEmptyInstance() => create();
  static $pb.PbList<UpdateChannelPolicyReply> createRepeated() => $pb.PbList<UpdateChannelPolicyReply>();
  @$core.pragma('dart2js:noInline')
  static UpdateChannelPolicyReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateChannelPolicyReply>(create);
  static UpdateChannelPolicyReply? _defaultInstance;
}

class AddFundInitRequest extends $pb.GeneratedMessage {
  factory AddFundInitRequest({
    $core.String? nodeID,
    $core.String? notificationToken,
    $core.List<$core.int>? pubkey,
    $core.List<$core.int>? hash,
  }) {
    final $result = create();
    if (nodeID != null) {
      $result.nodeID = nodeID;
    }
    if (notificationToken != null) {
      $result.notificationToken = notificationToken;
    }
    if (pubkey != null) {
      $result.pubkey = pubkey;
    }
    if (hash != null) {
      $result.hash = hash;
    }
    return $result;
  }
  AddFundInitRequest._() : super();
  factory AddFundInitRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundInitRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddFundInitRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nodeID', protoName: 'nodeID')
    ..aOS(2, _omitFieldNames ? '' : 'notificationToken', protoName: 'notificationToken')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'pubkey', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'hash', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddFundInitRequest clone() => AddFundInitRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddFundInitRequest copyWith(void Function(AddFundInitRequest) updates) => super.copyWith((message) => updates(message as AddFundInitRequest)) as AddFundInitRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddFundInitRequest create() => AddFundInitRequest._();
  AddFundInitRequest createEmptyInstance() => create();
  static $pb.PbList<AddFundInitRequest> createRepeated() => $pb.PbList<AddFundInitRequest>();
  @$core.pragma('dart2js:noInline')
  static AddFundInitRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddFundInitRequest>(create);
  static AddFundInitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get notificationToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set notificationToken($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNotificationToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotificationToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get pubkey => $_getN(2);
  @$pb.TagNumber(3)
  set pubkey($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPubkey() => $_has(2);
  @$pb.TagNumber(3)
  void clearPubkey() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get hash => $_getN(3);
  @$pb.TagNumber(4)
  set hash($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHash() => $_has(3);
  @$pb.TagNumber(4)
  void clearHash() => clearField(4);
}

class AddFundInitReply extends $pb.GeneratedMessage {
  factory AddFundInitReply({
    $core.String? address,
    $core.List<$core.int>? pubkey,
    $fixnum.Int64? lockHeight,
    $fixnum.Int64? maxAllowedDeposit,
    $core.String? errorMessage,
    $fixnum.Int64? requiredReserve,
    $fixnum.Int64? minAllowedDeposit,
  }) {
    final $result = create();
    if (address != null) {
      $result.address = address;
    }
    if (pubkey != null) {
      $result.pubkey = pubkey;
    }
    if (lockHeight != null) {
      $result.lockHeight = lockHeight;
    }
    if (maxAllowedDeposit != null) {
      $result.maxAllowedDeposit = maxAllowedDeposit;
    }
    if (errorMessage != null) {
      $result.errorMessage = errorMessage;
    }
    if (requiredReserve != null) {
      $result.requiredReserve = requiredReserve;
    }
    if (minAllowedDeposit != null) {
      $result.minAllowedDeposit = minAllowedDeposit;
    }
    return $result;
  }
  AddFundInitReply._() : super();
  factory AddFundInitReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundInitReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddFundInitReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'address')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'pubkey', $pb.PbFieldType.OY)
    ..aInt64(3, _omitFieldNames ? '' : 'lockHeight', protoName: 'lockHeight')
    ..aInt64(4, _omitFieldNames ? '' : 'maxAllowedDeposit', protoName: 'maxAllowedDeposit')
    ..aOS(5, _omitFieldNames ? '' : 'errorMessage', protoName: 'errorMessage')
    ..aInt64(6, _omitFieldNames ? '' : 'requiredReserve', protoName: 'requiredReserve')
    ..aInt64(7, _omitFieldNames ? '' : 'minAllowedDeposit', protoName: 'minAllowedDeposit')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddFundInitReply clone() => AddFundInitReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddFundInitReply copyWith(void Function(AddFundInitReply) updates) => super.copyWith((message) => updates(message as AddFundInitReply)) as AddFundInitReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddFundInitReply create() => AddFundInitReply._();
  AddFundInitReply createEmptyInstance() => create();
  static $pb.PbList<AddFundInitReply> createRepeated() => $pb.PbList<AddFundInitReply>();
  @$core.pragma('dart2js:noInline')
  static AddFundInitReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddFundInitReply>(create);
  static AddFundInitReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get pubkey => $_getN(1);
  @$pb.TagNumber(2)
  set pubkey($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPubkey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPubkey() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get lockHeight => $_getI64(2);
  @$pb.TagNumber(3)
  set lockHeight($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLockHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearLockHeight() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get maxAllowedDeposit => $_getI64(3);
  @$pb.TagNumber(4)
  set maxAllowedDeposit($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMaxAllowedDeposit() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxAllowedDeposit() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get errorMessage => $_getSZ(4);
  @$pb.TagNumber(5)
  set errorMessage($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasErrorMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearErrorMessage() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get requiredReserve => $_getI64(5);
  @$pb.TagNumber(6)
  set requiredReserve($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRequiredReserve() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequiredReserve() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get minAllowedDeposit => $_getI64(6);
  @$pb.TagNumber(7)
  set minAllowedDeposit($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMinAllowedDeposit() => $_has(6);
  @$pb.TagNumber(7)
  void clearMinAllowedDeposit() => clearField(7);
}

class AddFundStatusRequest extends $pb.GeneratedMessage {
  factory AddFundStatusRequest({
    $core.Iterable<$core.String>? addresses,
    $core.String? notificationToken,
  }) {
    final $result = create();
    if (addresses != null) {
      $result.addresses.addAll(addresses);
    }
    if (notificationToken != null) {
      $result.notificationToken = notificationToken;
    }
    return $result;
  }
  AddFundStatusRequest._() : super();
  factory AddFundStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddFundStatusRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'addresses')
    ..aOS(2, _omitFieldNames ? '' : 'notificationToken', protoName: 'notificationToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddFundStatusRequest clone() => AddFundStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddFundStatusRequest copyWith(void Function(AddFundStatusRequest) updates) => super.copyWith((message) => updates(message as AddFundStatusRequest)) as AddFundStatusRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddFundStatusRequest create() => AddFundStatusRequest._();
  AddFundStatusRequest createEmptyInstance() => create();
  static $pb.PbList<AddFundStatusRequest> createRepeated() => $pb.PbList<AddFundStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static AddFundStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddFundStatusRequest>(create);
  static AddFundStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get addresses => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get notificationToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set notificationToken($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNotificationToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotificationToken() => clearField(2);
}

class AddFundStatusReply_AddressStatus extends $pb.GeneratedMessage {
  factory AddFundStatusReply_AddressStatus({
    $core.String? tx,
    $fixnum.Int64? amount,
    $core.bool? confirmed,
    $core.String? blockHash,
  }) {
    final $result = create();
    if (tx != null) {
      $result.tx = tx;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (confirmed != null) {
      $result.confirmed = confirmed;
    }
    if (blockHash != null) {
      $result.blockHash = blockHash;
    }
    return $result;
  }
  AddFundStatusReply_AddressStatus._() : super();
  factory AddFundStatusReply_AddressStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundStatusReply_AddressStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddFundStatusReply.AddressStatus', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tx')
    ..aInt64(2, _omitFieldNames ? '' : 'amount')
    ..aOB(3, _omitFieldNames ? '' : 'confirmed')
    ..aOS(4, _omitFieldNames ? '' : 'blockHash', protoName: 'blockHash')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddFundStatusReply_AddressStatus clone() => AddFundStatusReply_AddressStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddFundStatusReply_AddressStatus copyWith(void Function(AddFundStatusReply_AddressStatus) updates) => super.copyWith((message) => updates(message as AddFundStatusReply_AddressStatus)) as AddFundStatusReply_AddressStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddFundStatusReply_AddressStatus create() => AddFundStatusReply_AddressStatus._();
  AddFundStatusReply_AddressStatus createEmptyInstance() => create();
  static $pb.PbList<AddFundStatusReply_AddressStatus> createRepeated() => $pb.PbList<AddFundStatusReply_AddressStatus>();
  @$core.pragma('dart2js:noInline')
  static AddFundStatusReply_AddressStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddFundStatusReply_AddressStatus>(create);
  static AddFundStatusReply_AddressStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tx => $_getSZ(0);
  @$pb.TagNumber(1)
  set tx($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTx() => $_has(0);
  @$pb.TagNumber(1)
  void clearTx() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get amount => $_getI64(1);
  @$pb.TagNumber(2)
  set amount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get confirmed => $_getBF(2);
  @$pb.TagNumber(3)
  set confirmed($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasConfirmed() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfirmed() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get blockHash => $_getSZ(3);
  @$pb.TagNumber(4)
  set blockHash($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBlockHash() => $_has(3);
  @$pb.TagNumber(4)
  void clearBlockHash() => clearField(4);
}

class AddFundStatusReply extends $pb.GeneratedMessage {
  factory AddFundStatusReply({
    $core.Map<$core.String, AddFundStatusReply_AddressStatus>? statuses,
  }) {
    final $result = create();
    if (statuses != null) {
      $result.statuses.addAll(statuses);
    }
    return $result;
  }
  AddFundStatusReply._() : super();
  factory AddFundStatusReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundStatusReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddFundStatusReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..m<$core.String, AddFundStatusReply_AddressStatus>(1, _omitFieldNames ? '' : 'statuses', entryClassName: 'AddFundStatusReply.StatusesEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: AddFundStatusReply_AddressStatus.create, valueDefaultOrMaker: AddFundStatusReply_AddressStatus.getDefault, packageName: const $pb.PackageName('breez'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddFundStatusReply clone() => AddFundStatusReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddFundStatusReply copyWith(void Function(AddFundStatusReply) updates) => super.copyWith((message) => updates(message as AddFundStatusReply)) as AddFundStatusReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddFundStatusReply create() => AddFundStatusReply._();
  AddFundStatusReply createEmptyInstance() => create();
  static $pb.PbList<AddFundStatusReply> createRepeated() => $pb.PbList<AddFundStatusReply>();
  @$core.pragma('dart2js:noInline')
  static AddFundStatusReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddFundStatusReply>(create);
  static AddFundStatusReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, AddFundStatusReply_AddressStatus> get statuses => $_getMap(0);
}

class RemoveFundRequest extends $pb.GeneratedMessage {
  factory RemoveFundRequest({
    $core.String? address,
    $fixnum.Int64? amount,
  }) {
    final $result = create();
    if (address != null) {
      $result.address = address;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    return $result;
  }
  RemoveFundRequest._() : super();
  factory RemoveFundRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveFundRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveFundRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'address')
    ..aInt64(2, _omitFieldNames ? '' : 'amount')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveFundRequest clone() => RemoveFundRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveFundRequest copyWith(void Function(RemoveFundRequest) updates) => super.copyWith((message) => updates(message as RemoveFundRequest)) as RemoveFundRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveFundRequest create() => RemoveFundRequest._();
  RemoveFundRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveFundRequest> createRepeated() => $pb.PbList<RemoveFundRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveFundRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveFundRequest>(create);
  static RemoveFundRequest? _defaultInstance;

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
  factory RemoveFundReply({
    $core.String? paymentRequest,
    $core.String? errorMessage,
  }) {
    final $result = create();
    if (paymentRequest != null) {
      $result.paymentRequest = paymentRequest;
    }
    if (errorMessage != null) {
      $result.errorMessage = errorMessage;
    }
    return $result;
  }
  RemoveFundReply._() : super();
  factory RemoveFundReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveFundReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveFundReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'paymentRequest', protoName: 'paymentRequest')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage', protoName: 'errorMessage')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveFundReply clone() => RemoveFundReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveFundReply copyWith(void Function(RemoveFundReply) updates) => super.copyWith((message) => updates(message as RemoveFundReply)) as RemoveFundReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveFundReply create() => RemoveFundReply._();
  RemoveFundReply createEmptyInstance() => create();
  static $pb.PbList<RemoveFundReply> createRepeated() => $pb.PbList<RemoveFundReply>();
  @$core.pragma('dart2js:noInline')
  static RemoveFundReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveFundReply>(create);
  static RemoveFundReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get paymentRequest => $_getSZ(0);
  @$pb.TagNumber(1)
  set paymentRequest($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPaymentRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentRequest() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => clearField(2);
}

class RedeemRemovedFundsRequest extends $pb.GeneratedMessage {
  factory RedeemRemovedFundsRequest({
    $core.String? paymenthash,
  }) {
    final $result = create();
    if (paymenthash != null) {
      $result.paymenthash = paymenthash;
    }
    return $result;
  }
  RedeemRemovedFundsRequest._() : super();
  factory RedeemRemovedFundsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RedeemRemovedFundsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RedeemRemovedFundsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'paymenthash')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RedeemRemovedFundsRequest clone() => RedeemRemovedFundsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RedeemRemovedFundsRequest copyWith(void Function(RedeemRemovedFundsRequest) updates) => super.copyWith((message) => updates(message as RedeemRemovedFundsRequest)) as RedeemRemovedFundsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RedeemRemovedFundsRequest create() => RedeemRemovedFundsRequest._();
  RedeemRemovedFundsRequest createEmptyInstance() => create();
  static $pb.PbList<RedeemRemovedFundsRequest> createRepeated() => $pb.PbList<RedeemRemovedFundsRequest>();
  @$core.pragma('dart2js:noInline')
  static RedeemRemovedFundsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RedeemRemovedFundsRequest>(create);
  static RedeemRemovedFundsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get paymenthash => $_getSZ(0);
  @$pb.TagNumber(1)
  set paymenthash($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPaymenthash() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymenthash() => clearField(1);
}

class RedeemRemovedFundsReply extends $pb.GeneratedMessage {
  factory RedeemRemovedFundsReply({
    $core.String? txid,
  }) {
    final $result = create();
    if (txid != null) {
      $result.txid = txid;
    }
    return $result;
  }
  RedeemRemovedFundsReply._() : super();
  factory RedeemRemovedFundsReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RedeemRemovedFundsReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RedeemRemovedFundsReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'txid')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RedeemRemovedFundsReply clone() => RedeemRemovedFundsReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RedeemRemovedFundsReply copyWith(void Function(RedeemRemovedFundsReply) updates) => super.copyWith((message) => updates(message as RedeemRemovedFundsReply)) as RedeemRemovedFundsReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RedeemRemovedFundsReply create() => RedeemRemovedFundsReply._();
  RedeemRemovedFundsReply createEmptyInstance() => create();
  static $pb.PbList<RedeemRemovedFundsReply> createRepeated() => $pb.PbList<RedeemRemovedFundsReply>();
  @$core.pragma('dart2js:noInline')
  static RedeemRemovedFundsReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RedeemRemovedFundsReply>(create);
  static RedeemRemovedFundsReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);
}

class GetSwapPaymentRequest extends $pb.GeneratedMessage {
  factory GetSwapPaymentRequest({
    $core.String? paymentRequest,
  }) {
    final $result = create();
    if (paymentRequest != null) {
      $result.paymentRequest = paymentRequest;
    }
    return $result;
  }
  GetSwapPaymentRequest._() : super();
  factory GetSwapPaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSwapPaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSwapPaymentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'paymentRequest', protoName: 'paymentRequest')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSwapPaymentRequest clone() => GetSwapPaymentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSwapPaymentRequest copyWith(void Function(GetSwapPaymentRequest) updates) => super.copyWith((message) => updates(message as GetSwapPaymentRequest)) as GetSwapPaymentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSwapPaymentRequest create() => GetSwapPaymentRequest._();
  GetSwapPaymentRequest createEmptyInstance() => create();
  static $pb.PbList<GetSwapPaymentRequest> createRepeated() => $pb.PbList<GetSwapPaymentRequest>();
  @$core.pragma('dart2js:noInline')
  static GetSwapPaymentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSwapPaymentRequest>(create);
  static GetSwapPaymentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get paymentRequest => $_getSZ(0);
  @$pb.TagNumber(1)
  set paymentRequest($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPaymentRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentRequest() => clearField(1);
}

class GetSwapPaymentReply extends $pb.GeneratedMessage {
  factory GetSwapPaymentReply({
    $core.String? paymentError,
    $core.bool? fundsExceededLimit,
    GetSwapPaymentReply_SwapError? swapError,
  }) {
    final $result = create();
    if (paymentError != null) {
      $result.paymentError = paymentError;
    }
    if (fundsExceededLimit != null) {
      $result.fundsExceededLimit = fundsExceededLimit;
    }
    if (swapError != null) {
      $result.swapError = swapError;
    }
    return $result;
  }
  GetSwapPaymentReply._() : super();
  factory GetSwapPaymentReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSwapPaymentReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSwapPaymentReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'paymentError', protoName: 'paymentError')
    ..aOB(2, _omitFieldNames ? '' : 'fundsExceededLimit')
    ..e<GetSwapPaymentReply_SwapError>(3, _omitFieldNames ? '' : 'swapError', $pb.PbFieldType.OE, defaultOrMaker: GetSwapPaymentReply_SwapError.NO_ERROR, valueOf: GetSwapPaymentReply_SwapError.valueOf, enumValues: GetSwapPaymentReply_SwapError.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSwapPaymentReply clone() => GetSwapPaymentReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSwapPaymentReply copyWith(void Function(GetSwapPaymentReply) updates) => super.copyWith((message) => updates(message as GetSwapPaymentReply)) as GetSwapPaymentReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSwapPaymentReply create() => GetSwapPaymentReply._();
  GetSwapPaymentReply createEmptyInstance() => create();
  static $pb.PbList<GetSwapPaymentReply> createRepeated() => $pb.PbList<GetSwapPaymentReply>();
  @$core.pragma('dart2js:noInline')
  static GetSwapPaymentReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSwapPaymentReply>(create);
  static GetSwapPaymentReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get paymentError => $_getSZ(0);
  @$pb.TagNumber(1)
  set paymentError($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPaymentError() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentError() => clearField(1);

  /// deprecated
  @$pb.TagNumber(2)
  $core.bool get fundsExceededLimit => $_getBF(1);
  @$pb.TagNumber(2)
  set fundsExceededLimit($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFundsExceededLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearFundsExceededLimit() => clearField(2);

  @$pb.TagNumber(3)
  GetSwapPaymentReply_SwapError get swapError => $_getN(2);
  @$pb.TagNumber(3)
  set swapError(GetSwapPaymentReply_SwapError v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSwapError() => $_has(2);
  @$pb.TagNumber(3)
  void clearSwapError() => clearField(3);
}

class RedeemSwapPaymentRequest extends $pb.GeneratedMessage {
  factory RedeemSwapPaymentRequest({
    $core.List<$core.int>? preimage,
    $core.int? targetConf,
    $fixnum.Int64? satPerByte,
  }) {
    final $result = create();
    if (preimage != null) {
      $result.preimage = preimage;
    }
    if (targetConf != null) {
      $result.targetConf = targetConf;
    }
    if (satPerByte != null) {
      $result.satPerByte = satPerByte;
    }
    return $result;
  }
  RedeemSwapPaymentRequest._() : super();
  factory RedeemSwapPaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RedeemSwapPaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RedeemSwapPaymentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'preimage', $pb.PbFieldType.OY)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'targetConf', $pb.PbFieldType.O3)
    ..aInt64(3, _omitFieldNames ? '' : 'satPerByte')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RedeemSwapPaymentRequest clone() => RedeemSwapPaymentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RedeemSwapPaymentRequest copyWith(void Function(RedeemSwapPaymentRequest) updates) => super.copyWith((message) => updates(message as RedeemSwapPaymentRequest)) as RedeemSwapPaymentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RedeemSwapPaymentRequest create() => RedeemSwapPaymentRequest._();
  RedeemSwapPaymentRequest createEmptyInstance() => create();
  static $pb.PbList<RedeemSwapPaymentRequest> createRepeated() => $pb.PbList<RedeemSwapPaymentRequest>();
  @$core.pragma('dart2js:noInline')
  static RedeemSwapPaymentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RedeemSwapPaymentRequest>(create);
  static RedeemSwapPaymentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get preimage => $_getN(0);
  @$pb.TagNumber(1)
  set preimage($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPreimage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreimage() => clearField(1);

  /// / The target number of blocks that the funding transaction should be confirmed by.
  @$pb.TagNumber(2)
  $core.int get targetConf => $_getIZ(1);
  @$pb.TagNumber(2)
  set targetConf($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetConf() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetConf() => clearField(2);

  /// / A manual fee rate set in sat/byte that should be used when crafting the funding transaction.
  @$pb.TagNumber(3)
  $fixnum.Int64 get satPerByte => $_getI64(2);
  @$pb.TagNumber(3)
  set satPerByte($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSatPerByte() => $_has(2);
  @$pb.TagNumber(3)
  void clearSatPerByte() => clearField(3);
}

class RedeemSwapPaymentReply extends $pb.GeneratedMessage {
  factory RedeemSwapPaymentReply({
    $core.String? txid,
  }) {
    final $result = create();
    if (txid != null) {
      $result.txid = txid;
    }
    return $result;
  }
  RedeemSwapPaymentReply._() : super();
  factory RedeemSwapPaymentReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RedeemSwapPaymentReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RedeemSwapPaymentReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'txid')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RedeemSwapPaymentReply clone() => RedeemSwapPaymentReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RedeemSwapPaymentReply copyWith(void Function(RedeemSwapPaymentReply) updates) => super.copyWith((message) => updates(message as RedeemSwapPaymentReply)) as RedeemSwapPaymentReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RedeemSwapPaymentReply create() => RedeemSwapPaymentReply._();
  RedeemSwapPaymentReply createEmptyInstance() => create();
  static $pb.PbList<RedeemSwapPaymentReply> createRepeated() => $pb.PbList<RedeemSwapPaymentReply>();
  @$core.pragma('dart2js:noInline')
  static RedeemSwapPaymentReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RedeemSwapPaymentReply>(create);
  static RedeemSwapPaymentReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);
}

/// The request message containing the device id and lightning id
class RegisterRequest extends $pb.GeneratedMessage {
  factory RegisterRequest({
    $core.String? deviceID,
    $core.String? lightningID,
  }) {
    final $result = create();
    if (deviceID != null) {
      $result.deviceID = deviceID;
    }
    if (lightningID != null) {
      $result.lightningID = lightningID;
    }
    return $result;
  }
  RegisterRequest._() : super();
  factory RegisterRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceID', protoName: 'deviceID')
    ..aOS(2, _omitFieldNames ? '' : 'lightningID', protoName: 'lightningID')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterRequest clone() => RegisterRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterRequest copyWith(void Function(RegisterRequest) updates) => super.copyWith((message) => updates(message as RegisterRequest)) as RegisterRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterRequest create() => RegisterRequest._();
  RegisterRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterRequest> createRepeated() => $pb.PbList<RegisterRequest>();
  @$core.pragma('dart2js:noInline')
  static RegisterRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterRequest>(create);
  static RegisterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceID => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceID() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get lightningID => $_getSZ(1);
  @$pb.TagNumber(2)
  set lightningID($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLightningID() => $_has(1);
  @$pb.TagNumber(2)
  void clearLightningID() => clearField(2);
}

/// The response message containing the breez id
class RegisterReply extends $pb.GeneratedMessage {
  factory RegisterReply({
    $core.String? breezID,
  }) {
    final $result = create();
    if (breezID != null) {
      $result.breezID = breezID;
    }
    return $result;
  }
  RegisterReply._() : super();
  factory RegisterReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'breezID', protoName: 'breezID')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterReply clone() => RegisterReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterReply copyWith(void Function(RegisterReply) updates) => super.copyWith((message) => updates(message as RegisterReply)) as RegisterReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterReply create() => RegisterReply._();
  RegisterReply createEmptyInstance() => create();
  static $pb.PbList<RegisterReply> createRepeated() => $pb.PbList<RegisterReply>();
  @$core.pragma('dart2js:noInline')
  static RegisterReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterReply>(create);
  static RegisterReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get breezID => $_getSZ(0);
  @$pb.TagNumber(1)
  set breezID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBreezID() => $_has(0);
  @$pb.TagNumber(1)
  void clearBreezID() => clearField(1);
}

class PaymentRequest extends $pb.GeneratedMessage {
  factory PaymentRequest({
    $core.String? breezID,
    $core.String? invoice,
    $core.String? payee,
    $fixnum.Int64? amount,
  }) {
    final $result = create();
    if (breezID != null) {
      $result.breezID = breezID;
    }
    if (invoice != null) {
      $result.invoice = invoice;
    }
    if (payee != null) {
      $result.payee = payee;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    return $result;
  }
  PaymentRequest._() : super();
  factory PaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PaymentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'breezID', protoName: 'breezID')
    ..aOS(2, _omitFieldNames ? '' : 'invoice')
    ..aOS(3, _omitFieldNames ? '' : 'payee')
    ..aInt64(4, _omitFieldNames ? '' : 'amount')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PaymentRequest clone() => PaymentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PaymentRequest copyWith(void Function(PaymentRequest) updates) => super.copyWith((message) => updates(message as PaymentRequest)) as PaymentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PaymentRequest create() => PaymentRequest._();
  PaymentRequest createEmptyInstance() => create();
  static $pb.PbList<PaymentRequest> createRepeated() => $pb.PbList<PaymentRequest>();
  @$core.pragma('dart2js:noInline')
  static PaymentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaymentRequest>(create);
  static PaymentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get breezID => $_getSZ(0);
  @$pb.TagNumber(1)
  set breezID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBreezID() => $_has(0);
  @$pb.TagNumber(1)
  void clearBreezID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get invoice => $_getSZ(1);
  @$pb.TagNumber(2)
  set invoice($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInvoice() => $_has(1);
  @$pb.TagNumber(2)
  void clearInvoice() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get payee => $_getSZ(2);
  @$pb.TagNumber(3)
  set payee($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPayee() => $_has(2);
  @$pb.TagNumber(3)
  void clearPayee() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get amount => $_getI64(3);
  @$pb.TagNumber(4)
  set amount($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => clearField(4);
}

class InvoiceReply extends $pb.GeneratedMessage {
  factory InvoiceReply({
    $core.String? error,
  }) {
    final $result = create();
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  InvoiceReply._() : super();
  factory InvoiceReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InvoiceReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InvoiceReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'Error', protoName: 'Error')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InvoiceReply clone() => InvoiceReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InvoiceReply copyWith(void Function(InvoiceReply) updates) => super.copyWith((message) => updates(message as InvoiceReply)) as InvoiceReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvoiceReply create() => InvoiceReply._();
  InvoiceReply createEmptyInstance() => create();
  static $pb.PbList<InvoiceReply> createRepeated() => $pb.PbList<InvoiceReply>();
  @$core.pragma('dart2js:noInline')
  static InvoiceReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InvoiceReply>(create);
  static InvoiceReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get error => $_getSZ(0);
  @$pb.TagNumber(1)
  set error($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => clearField(1);
}

class UploadFileRequest extends $pb.GeneratedMessage {
  factory UploadFileRequest({
    $core.List<$core.int>? content,
  }) {
    final $result = create();
    if (content != null) {
      $result.content = content;
    }
    return $result;
  }
  UploadFileRequest._() : super();
  factory UploadFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadFileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'content', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadFileRequest clone() => UploadFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadFileRequest copyWith(void Function(UploadFileRequest) updates) => super.copyWith((message) => updates(message as UploadFileRequest)) as UploadFileRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadFileRequest create() => UploadFileRequest._();
  UploadFileRequest createEmptyInstance() => create();
  static $pb.PbList<UploadFileRequest> createRepeated() => $pb.PbList<UploadFileRequest>();
  @$core.pragma('dart2js:noInline')
  static UploadFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadFileRequest>(create);
  static UploadFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get content => $_getN(0);
  @$pb.TagNumber(1)
  set content($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => clearField(1);
}

class UploadFileReply extends $pb.GeneratedMessage {
  factory UploadFileReply({
    $core.String? url,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    return $result;
  }
  UploadFileReply._() : super();
  factory UploadFileReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadFileReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadFileReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadFileReply clone() => UploadFileReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadFileReply copyWith(void Function(UploadFileReply) updates) => super.copyWith((message) => updates(message as UploadFileReply)) as UploadFileReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadFileReply create() => UploadFileReply._();
  UploadFileReply createEmptyInstance() => create();
  static $pb.PbList<UploadFileReply> createRepeated() => $pb.PbList<UploadFileReply>();
  @$core.pragma('dart2js:noInline')
  static UploadFileReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadFileReply>(create);
  static UploadFileReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);
}

class PingRequest extends $pb.GeneratedMessage {
  factory PingRequest() => create();
  PingRequest._() : super();
  factory PingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PingRequest clone() => PingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PingRequest copyWith(void Function(PingRequest) updates) => super.copyWith((message) => updates(message as PingRequest)) as PingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingRequest create() => PingRequest._();
  PingRequest createEmptyInstance() => create();
  static $pb.PbList<PingRequest> createRepeated() => $pb.PbList<PingRequest>();
  @$core.pragma('dart2js:noInline')
  static PingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PingRequest>(create);
  static PingRequest? _defaultInstance;
}

class PingReply extends $pb.GeneratedMessage {
  factory PingReply({
    $core.String? version,
  }) {
    final $result = create();
    if (version != null) {
      $result.version = version;
    }
    return $result;
  }
  PingReply._() : super();
  factory PingReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PingReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PingReply clone() => PingReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PingReply copyWith(void Function(PingReply) updates) => super.copyWith((message) => updates(message as PingReply)) as PingReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingReply create() => PingReply._();
  PingReply createEmptyInstance() => create();
  static $pb.PbList<PingReply> createRepeated() => $pb.PbList<PingReply>();
  @$core.pragma('dart2js:noInline')
  static PingReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PingReply>(create);
  static PingReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);
}

class OrderRequest extends $pb.GeneratedMessage {
  factory OrderRequest({
    $core.String? fullName,
    $core.String? address,
    $core.String? city,
    $core.String? state,
    $core.String? zip,
    $core.String? country,
    $core.String? email,
  }) {
    final $result = create();
    if (fullName != null) {
      $result.fullName = fullName;
    }
    if (address != null) {
      $result.address = address;
    }
    if (city != null) {
      $result.city = city;
    }
    if (state != null) {
      $result.state = state;
    }
    if (zip != null) {
      $result.zip = zip;
    }
    if (country != null) {
      $result.country = country;
    }
    if (email != null) {
      $result.email = email;
    }
    return $result;
  }
  OrderRequest._() : super();
  factory OrderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OrderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OrderRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'FullName', protoName: 'FullName')
    ..aOS(2, _omitFieldNames ? '' : 'Address', protoName: 'Address')
    ..aOS(3, _omitFieldNames ? '' : 'City', protoName: 'City')
    ..aOS(4, _omitFieldNames ? '' : 'State', protoName: 'State')
    ..aOS(5, _omitFieldNames ? '' : 'Zip', protoName: 'Zip')
    ..aOS(6, _omitFieldNames ? '' : 'Country', protoName: 'Country')
    ..aOS(7, _omitFieldNames ? '' : 'Email', protoName: 'Email')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OrderRequest clone() => OrderRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OrderRequest copyWith(void Function(OrderRequest) updates) => super.copyWith((message) => updates(message as OrderRequest)) as OrderRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrderRequest create() => OrderRequest._();
  OrderRequest createEmptyInstance() => create();
  static $pb.PbList<OrderRequest> createRepeated() => $pb.PbList<OrderRequest>();
  @$core.pragma('dart2js:noInline')
  static OrderRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderRequest>(create);
  static OrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fullName => $_getSZ(0);
  @$pb.TagNumber(1)
  set fullName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFullName() => $_has(0);
  @$pb.TagNumber(1)
  void clearFullName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get address => $_getSZ(1);
  @$pb.TagNumber(2)
  set address($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddress() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get city => $_getSZ(2);
  @$pb.TagNumber(3)
  set city($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCity() => $_has(2);
  @$pb.TagNumber(3)
  void clearCity() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get state => $_getSZ(3);
  @$pb.TagNumber(4)
  set state($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get zip => $_getSZ(4);
  @$pb.TagNumber(5)
  set zip($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasZip() => $_has(4);
  @$pb.TagNumber(5)
  void clearZip() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get country => $_getSZ(5);
  @$pb.TagNumber(6)
  set country($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCountry() => $_has(5);
  @$pb.TagNumber(6)
  void clearCountry() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get email => $_getSZ(6);
  @$pb.TagNumber(7)
  set email($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasEmail() => $_has(6);
  @$pb.TagNumber(7)
  void clearEmail() => clearField(7);
}

class OrderReply extends $pb.GeneratedMessage {
  factory OrderReply() => create();
  OrderReply._() : super();
  factory OrderReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OrderReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OrderReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OrderReply clone() => OrderReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OrderReply copyWith(void Function(OrderReply) updates) => super.copyWith((message) => updates(message as OrderReply)) as OrderReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrderReply create() => OrderReply._();
  OrderReply createEmptyInstance() => create();
  static $pb.PbList<OrderReply> createRepeated() => $pb.PbList<OrderReply>();
  @$core.pragma('dart2js:noInline')
  static OrderReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderReply>(create);
  static OrderReply? _defaultInstance;
}

class SetNodeInfoRequest extends $pb.GeneratedMessage {
  factory SetNodeInfoRequest({
    $core.List<$core.int>? pubkey,
    $core.String? key,
    $core.List<$core.int>? value,
    $fixnum.Int64? timestamp,
    $core.List<$core.int>? signature,
  }) {
    final $result = create();
    if (pubkey != null) {
      $result.pubkey = pubkey;
    }
    if (key != null) {
      $result.key = key;
    }
    if (value != null) {
      $result.value = value;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (signature != null) {
      $result.signature = signature;
    }
    return $result;
  }
  SetNodeInfoRequest._() : super();
  factory SetNodeInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SetNodeInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SetNodeInfoRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'pubkey', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'key')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OY)
    ..aInt64(4, _omitFieldNames ? '' : 'timestamp')
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SetNodeInfoRequest clone() => SetNodeInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SetNodeInfoRequest copyWith(void Function(SetNodeInfoRequest) updates) => super.copyWith((message) => updates(message as SetNodeInfoRequest)) as SetNodeInfoRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetNodeInfoRequest create() => SetNodeInfoRequest._();
  SetNodeInfoRequest createEmptyInstance() => create();
  static $pb.PbList<SetNodeInfoRequest> createRepeated() => $pb.PbList<SetNodeInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static SetNodeInfoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetNodeInfoRequest>(create);
  static SetNodeInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get pubkey => $_getN(0);
  @$pb.TagNumber(1)
  set pubkey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPubkey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPubkey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get key => $_getSZ(1);
  @$pb.TagNumber(2)
  set key($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get value => $_getN(2);
  @$pb.TagNumber(3)
  set value($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get signature => $_getN(4);
  @$pb.TagNumber(5)
  set signature($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSignature() => $_has(4);
  @$pb.TagNumber(5)
  void clearSignature() => clearField(5);
}

class SetNodeInfoResponse extends $pb.GeneratedMessage {
  factory SetNodeInfoResponse() => create();
  SetNodeInfoResponse._() : super();
  factory SetNodeInfoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SetNodeInfoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SetNodeInfoResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SetNodeInfoResponse clone() => SetNodeInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SetNodeInfoResponse copyWith(void Function(SetNodeInfoResponse) updates) => super.copyWith((message) => updates(message as SetNodeInfoResponse)) as SetNodeInfoResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetNodeInfoResponse create() => SetNodeInfoResponse._();
  SetNodeInfoResponse createEmptyInstance() => create();
  static $pb.PbList<SetNodeInfoResponse> createRepeated() => $pb.PbList<SetNodeInfoResponse>();
  @$core.pragma('dart2js:noInline')
  static SetNodeInfoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetNodeInfoResponse>(create);
  static SetNodeInfoResponse? _defaultInstance;
}

class GetNodeInfoRequest extends $pb.GeneratedMessage {
  factory GetNodeInfoRequest({
    $core.List<$core.int>? pubkey,
    $core.String? key,
  }) {
    final $result = create();
    if (pubkey != null) {
      $result.pubkey = pubkey;
    }
    if (key != null) {
      $result.key = key;
    }
    return $result;
  }
  GetNodeInfoRequest._() : super();
  factory GetNodeInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetNodeInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetNodeInfoRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'pubkey', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'key')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetNodeInfoRequest clone() => GetNodeInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetNodeInfoRequest copyWith(void Function(GetNodeInfoRequest) updates) => super.copyWith((message) => updates(message as GetNodeInfoRequest)) as GetNodeInfoRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNodeInfoRequest create() => GetNodeInfoRequest._();
  GetNodeInfoRequest createEmptyInstance() => create();
  static $pb.PbList<GetNodeInfoRequest> createRepeated() => $pb.PbList<GetNodeInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static GetNodeInfoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetNodeInfoRequest>(create);
  static GetNodeInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get pubkey => $_getN(0);
  @$pb.TagNumber(1)
  set pubkey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPubkey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPubkey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get key => $_getSZ(1);
  @$pb.TagNumber(2)
  set key($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearKey() => clearField(2);
}

class GetNodeInfoResponse extends $pb.GeneratedMessage {
  factory GetNodeInfoResponse({
    $core.List<$core.int>? value,
    $fixnum.Int64? timestamp,
    $core.List<$core.int>? signature,
  }) {
    final $result = create();
    if (value != null) {
      $result.value = value;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (signature != null) {
      $result.signature = signature;
    }
    return $result;
  }
  GetNodeInfoResponse._() : super();
  factory GetNodeInfoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetNodeInfoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetNodeInfoResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OY)
    ..aInt64(2, _omitFieldNames ? '' : 'timestamp')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetNodeInfoResponse clone() => GetNodeInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetNodeInfoResponse copyWith(void Function(GetNodeInfoResponse) updates) => super.copyWith((message) => updates(message as GetNodeInfoResponse)) as GetNodeInfoResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNodeInfoResponse create() => GetNodeInfoResponse._();
  GetNodeInfoResponse createEmptyInstance() => create();
  static $pb.PbList<GetNodeInfoResponse> createRepeated() => $pb.PbList<GetNodeInfoResponse>();
  @$core.pragma('dart2js:noInline')
  static GetNodeInfoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetNodeInfoResponse>(create);
  static GetNodeInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set timestamp($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get signature => $_getN(2);
  @$pb.TagNumber(3)
  set signature($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSignature() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignature() => clearField(3);
}

class JoinCTPSessionRequest extends $pb.GeneratedMessage {
  factory JoinCTPSessionRequest({
    JoinCTPSessionRequest_PartyType? partyType,
    $core.String? partyName,
    $core.String? notificationToken,
    $core.String? sessionID,
  }) {
    final $result = create();
    if (partyType != null) {
      $result.partyType = partyType;
    }
    if (partyName != null) {
      $result.partyName = partyName;
    }
    if (notificationToken != null) {
      $result.notificationToken = notificationToken;
    }
    if (sessionID != null) {
      $result.sessionID = sessionID;
    }
    return $result;
  }
  JoinCTPSessionRequest._() : super();
  factory JoinCTPSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinCTPSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JoinCTPSessionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..e<JoinCTPSessionRequest_PartyType>(1, _omitFieldNames ? '' : 'partyType', $pb.PbFieldType.OE, protoName: 'partyType', defaultOrMaker: JoinCTPSessionRequest_PartyType.PAYER, valueOf: JoinCTPSessionRequest_PartyType.valueOf, enumValues: JoinCTPSessionRequest_PartyType.values)
    ..aOS(2, _omitFieldNames ? '' : 'partyName', protoName: 'partyName')
    ..aOS(3, _omitFieldNames ? '' : 'notificationToken', protoName: 'notificationToken')
    ..aOS(4, _omitFieldNames ? '' : 'sessionID', protoName: 'sessionID')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinCTPSessionRequest clone() => JoinCTPSessionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinCTPSessionRequest copyWith(void Function(JoinCTPSessionRequest) updates) => super.copyWith((message) => updates(message as JoinCTPSessionRequest)) as JoinCTPSessionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinCTPSessionRequest create() => JoinCTPSessionRequest._();
  JoinCTPSessionRequest createEmptyInstance() => create();
  static $pb.PbList<JoinCTPSessionRequest> createRepeated() => $pb.PbList<JoinCTPSessionRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinCTPSessionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinCTPSessionRequest>(create);
  static JoinCTPSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  JoinCTPSessionRequest_PartyType get partyType => $_getN(0);
  @$pb.TagNumber(1)
  set partyType(JoinCTPSessionRequest_PartyType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPartyType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPartyType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get partyName => $_getSZ(1);
  @$pb.TagNumber(2)
  set partyName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPartyName() => $_has(1);
  @$pb.TagNumber(2)
  void clearPartyName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get notificationToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set notificationToken($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNotificationToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotificationToken() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sessionID => $_getSZ(3);
  @$pb.TagNumber(4)
  set sessionID($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSessionID() => $_has(3);
  @$pb.TagNumber(4)
  void clearSessionID() => clearField(4);
}

class JoinCTPSessionResponse extends $pb.GeneratedMessage {
  factory JoinCTPSessionResponse({
    $core.String? sessionID,
    $fixnum.Int64? expiry,
  }) {
    final $result = create();
    if (sessionID != null) {
      $result.sessionID = sessionID;
    }
    if (expiry != null) {
      $result.expiry = expiry;
    }
    return $result;
  }
  JoinCTPSessionResponse._() : super();
  factory JoinCTPSessionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinCTPSessionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JoinCTPSessionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionID', protoName: 'sessionID')
    ..aInt64(2, _omitFieldNames ? '' : 'expiry')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinCTPSessionResponse clone() => JoinCTPSessionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinCTPSessionResponse copyWith(void Function(JoinCTPSessionResponse) updates) => super.copyWith((message) => updates(message as JoinCTPSessionResponse)) as JoinCTPSessionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinCTPSessionResponse create() => JoinCTPSessionResponse._();
  JoinCTPSessionResponse createEmptyInstance() => create();
  static $pb.PbList<JoinCTPSessionResponse> createRepeated() => $pb.PbList<JoinCTPSessionResponse>();
  @$core.pragma('dart2js:noInline')
  static JoinCTPSessionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinCTPSessionResponse>(create);
  static JoinCTPSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionID => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionID() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expiry => $_getI64(1);
  @$pb.TagNumber(2)
  set expiry($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasExpiry() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpiry() => clearField(2);
}

class TerminateCTPSessionRequest extends $pb.GeneratedMessage {
  factory TerminateCTPSessionRequest({
    $core.String? sessionID,
  }) {
    final $result = create();
    if (sessionID != null) {
      $result.sessionID = sessionID;
    }
    return $result;
  }
  TerminateCTPSessionRequest._() : super();
  factory TerminateCTPSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TerminateCTPSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TerminateCTPSessionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionID', protoName: 'sessionID')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TerminateCTPSessionRequest clone() => TerminateCTPSessionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TerminateCTPSessionRequest copyWith(void Function(TerminateCTPSessionRequest) updates) => super.copyWith((message) => updates(message as TerminateCTPSessionRequest)) as TerminateCTPSessionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TerminateCTPSessionRequest create() => TerminateCTPSessionRequest._();
  TerminateCTPSessionRequest createEmptyInstance() => create();
  static $pb.PbList<TerminateCTPSessionRequest> createRepeated() => $pb.PbList<TerminateCTPSessionRequest>();
  @$core.pragma('dart2js:noInline')
  static TerminateCTPSessionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TerminateCTPSessionRequest>(create);
  static TerminateCTPSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionID => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionID() => clearField(1);
}

class TerminateCTPSessionResponse extends $pb.GeneratedMessage {
  factory TerminateCTPSessionResponse() => create();
  TerminateCTPSessionResponse._() : super();
  factory TerminateCTPSessionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TerminateCTPSessionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TerminateCTPSessionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TerminateCTPSessionResponse clone() => TerminateCTPSessionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TerminateCTPSessionResponse copyWith(void Function(TerminateCTPSessionResponse) updates) => super.copyWith((message) => updates(message as TerminateCTPSessionResponse)) as TerminateCTPSessionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TerminateCTPSessionResponse create() => TerminateCTPSessionResponse._();
  TerminateCTPSessionResponse createEmptyInstance() => create();
  static $pb.PbList<TerminateCTPSessionResponse> createRepeated() => $pb.PbList<TerminateCTPSessionResponse>();
  @$core.pragma('dart2js:noInline')
  static TerminateCTPSessionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TerminateCTPSessionResponse>(create);
  static TerminateCTPSessionResponse? _defaultInstance;
}

class RegisterTransactionConfirmationRequest extends $pb.GeneratedMessage {
  factory RegisterTransactionConfirmationRequest({
    $core.String? txID,
    $core.String? notificationToken,
    RegisterTransactionConfirmationRequest_NotificationType? notificationType,
  }) {
    final $result = create();
    if (txID != null) {
      $result.txID = txID;
    }
    if (notificationToken != null) {
      $result.notificationToken = notificationToken;
    }
    if (notificationType != null) {
      $result.notificationType = notificationType;
    }
    return $result;
  }
  RegisterTransactionConfirmationRequest._() : super();
  factory RegisterTransactionConfirmationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterTransactionConfirmationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterTransactionConfirmationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'txID', protoName: 'txID')
    ..aOS(2, _omitFieldNames ? '' : 'notificationToken', protoName: 'notificationToken')
    ..e<RegisterTransactionConfirmationRequest_NotificationType>(3, _omitFieldNames ? '' : 'notificationType', $pb.PbFieldType.OE, protoName: 'notificationType', defaultOrMaker: RegisterTransactionConfirmationRequest_NotificationType.READY_RECEIVE_PAYMENT, valueOf: RegisterTransactionConfirmationRequest_NotificationType.valueOf, enumValues: RegisterTransactionConfirmationRequest_NotificationType.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterTransactionConfirmationRequest clone() => RegisterTransactionConfirmationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterTransactionConfirmationRequest copyWith(void Function(RegisterTransactionConfirmationRequest) updates) => super.copyWith((message) => updates(message as RegisterTransactionConfirmationRequest)) as RegisterTransactionConfirmationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterTransactionConfirmationRequest create() => RegisterTransactionConfirmationRequest._();
  RegisterTransactionConfirmationRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterTransactionConfirmationRequest> createRepeated() => $pb.PbList<RegisterTransactionConfirmationRequest>();
  @$core.pragma('dart2js:noInline')
  static RegisterTransactionConfirmationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterTransactionConfirmationRequest>(create);
  static RegisterTransactionConfirmationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txID => $_getSZ(0);
  @$pb.TagNumber(1)
  set txID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxID() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get notificationToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set notificationToken($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNotificationToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotificationToken() => clearField(2);

  @$pb.TagNumber(3)
  RegisterTransactionConfirmationRequest_NotificationType get notificationType => $_getN(2);
  @$pb.TagNumber(3)
  set notificationType(RegisterTransactionConfirmationRequest_NotificationType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasNotificationType() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotificationType() => clearField(3);
}

class RegisterTransactionConfirmationResponse extends $pb.GeneratedMessage {
  factory RegisterTransactionConfirmationResponse() => create();
  RegisterTransactionConfirmationResponse._() : super();
  factory RegisterTransactionConfirmationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterTransactionConfirmationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterTransactionConfirmationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterTransactionConfirmationResponse clone() => RegisterTransactionConfirmationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterTransactionConfirmationResponse copyWith(void Function(RegisterTransactionConfirmationResponse) updates) => super.copyWith((message) => updates(message as RegisterTransactionConfirmationResponse)) as RegisterTransactionConfirmationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterTransactionConfirmationResponse create() => RegisterTransactionConfirmationResponse._();
  RegisterTransactionConfirmationResponse createEmptyInstance() => create();
  static $pb.PbList<RegisterTransactionConfirmationResponse> createRepeated() => $pb.PbList<RegisterTransactionConfirmationResponse>();
  @$core.pragma('dart2js:noInline')
  static RegisterTransactionConfirmationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterTransactionConfirmationResponse>(create);
  static RegisterTransactionConfirmationResponse? _defaultInstance;
}

class RegisterPeriodicSyncRequest extends $pb.GeneratedMessage {
  factory RegisterPeriodicSyncRequest({
    $core.String? notificationToken,
  }) {
    final $result = create();
    if (notificationToken != null) {
      $result.notificationToken = notificationToken;
    }
    return $result;
  }
  RegisterPeriodicSyncRequest._() : super();
  factory RegisterPeriodicSyncRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPeriodicSyncRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterPeriodicSyncRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'notificationToken', protoName: 'notificationToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterPeriodicSyncRequest clone() => RegisterPeriodicSyncRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterPeriodicSyncRequest copyWith(void Function(RegisterPeriodicSyncRequest) updates) => super.copyWith((message) => updates(message as RegisterPeriodicSyncRequest)) as RegisterPeriodicSyncRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPeriodicSyncRequest create() => RegisterPeriodicSyncRequest._();
  RegisterPeriodicSyncRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterPeriodicSyncRequest> createRepeated() => $pb.PbList<RegisterPeriodicSyncRequest>();
  @$core.pragma('dart2js:noInline')
  static RegisterPeriodicSyncRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterPeriodicSyncRequest>(create);
  static RegisterPeriodicSyncRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notificationToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set notificationToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNotificationToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotificationToken() => clearField(1);
}

class RegisterPeriodicSyncResponse extends $pb.GeneratedMessage {
  factory RegisterPeriodicSyncResponse() => create();
  RegisterPeriodicSyncResponse._() : super();
  factory RegisterPeriodicSyncResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPeriodicSyncResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterPeriodicSyncResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterPeriodicSyncResponse clone() => RegisterPeriodicSyncResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterPeriodicSyncResponse copyWith(void Function(RegisterPeriodicSyncResponse) updates) => super.copyWith((message) => updates(message as RegisterPeriodicSyncResponse)) as RegisterPeriodicSyncResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPeriodicSyncResponse create() => RegisterPeriodicSyncResponse._();
  RegisterPeriodicSyncResponse createEmptyInstance() => create();
  static $pb.PbList<RegisterPeriodicSyncResponse> createRepeated() => $pb.PbList<RegisterPeriodicSyncResponse>();
  @$core.pragma('dart2js:noInline')
  static RegisterPeriodicSyncResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterPeriodicSyncResponse>(create);
  static RegisterPeriodicSyncResponse? _defaultInstance;
}

class BoltzReverseSwapLockupTx extends $pb.GeneratedMessage {
  factory BoltzReverseSwapLockupTx({
    $core.String? boltzId,
    $core.int? timeoutBlockHeight,
  }) {
    final $result = create();
    if (boltzId != null) {
      $result.boltzId = boltzId;
    }
    if (timeoutBlockHeight != null) {
      $result.timeoutBlockHeight = timeoutBlockHeight;
    }
    return $result;
  }
  BoltzReverseSwapLockupTx._() : super();
  factory BoltzReverseSwapLockupTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BoltzReverseSwapLockupTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BoltzReverseSwapLockupTx', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'boltzId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'timeoutBlockHeight', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BoltzReverseSwapLockupTx clone() => BoltzReverseSwapLockupTx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BoltzReverseSwapLockupTx copyWith(void Function(BoltzReverseSwapLockupTx) updates) => super.copyWith((message) => updates(message as BoltzReverseSwapLockupTx)) as BoltzReverseSwapLockupTx;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BoltzReverseSwapLockupTx create() => BoltzReverseSwapLockupTx._();
  BoltzReverseSwapLockupTx createEmptyInstance() => create();
  static $pb.PbList<BoltzReverseSwapLockupTx> createRepeated() => $pb.PbList<BoltzReverseSwapLockupTx>();
  @$core.pragma('dart2js:noInline')
  static BoltzReverseSwapLockupTx getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BoltzReverseSwapLockupTx>(create);
  static BoltzReverseSwapLockupTx? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get boltzId => $_getSZ(0);
  @$pb.TagNumber(1)
  set boltzId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBoltzId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBoltzId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get timeoutBlockHeight => $_getIZ(1);
  @$pb.TagNumber(2)
  set timeoutBlockHeight($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimeoutBlockHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeoutBlockHeight() => clearField(2);
}

enum PushTxNotificationRequest_Info {
  boltzReverseSwapLockupTxInfo, 
  notSet
}

class PushTxNotificationRequest extends $pb.GeneratedMessage {
  factory PushTxNotificationRequest({
    $core.String? deviceId,
    $core.String? title,
    $core.String? body,
    $core.List<$core.int>? txHash,
    $core.List<$core.int>? script,
    $core.int? blockHeightHint,
    BoltzReverseSwapLockupTx? boltzReverseSwapLockupTxInfo,
  }) {
    final $result = create();
    if (deviceId != null) {
      $result.deviceId = deviceId;
    }
    if (title != null) {
      $result.title = title;
    }
    if (body != null) {
      $result.body = body;
    }
    if (txHash != null) {
      $result.txHash = txHash;
    }
    if (script != null) {
      $result.script = script;
    }
    if (blockHeightHint != null) {
      $result.blockHeightHint = blockHeightHint;
    }
    if (boltzReverseSwapLockupTxInfo != null) {
      $result.boltzReverseSwapLockupTxInfo = boltzReverseSwapLockupTxInfo;
    }
    return $result;
  }
  PushTxNotificationRequest._() : super();
  factory PushTxNotificationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PushTxNotificationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, PushTxNotificationRequest_Info> _PushTxNotificationRequest_InfoByTag = {
    7 : PushTxNotificationRequest_Info.boltzReverseSwapLockupTxInfo,
    0 : PushTxNotificationRequest_Info.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PushTxNotificationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..oo(0, [7])
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'body')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'txHash', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'script', $pb.PbFieldType.OY)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'blockHeightHint', $pb.PbFieldType.OU3)
    ..aOM<BoltzReverseSwapLockupTx>(7, _omitFieldNames ? '' : 'boltzReverseSwapLockupTxInfo', subBuilder: BoltzReverseSwapLockupTx.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PushTxNotificationRequest clone() => PushTxNotificationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PushTxNotificationRequest copyWith(void Function(PushTxNotificationRequest) updates) => super.copyWith((message) => updates(message as PushTxNotificationRequest)) as PushTxNotificationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushTxNotificationRequest create() => PushTxNotificationRequest._();
  PushTxNotificationRequest createEmptyInstance() => create();
  static $pb.PbList<PushTxNotificationRequest> createRepeated() => $pb.PbList<PushTxNotificationRequest>();
  @$core.pragma('dart2js:noInline')
  static PushTxNotificationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PushTxNotificationRequest>(create);
  static PushTxNotificationRequest? _defaultInstance;

  PushTxNotificationRequest_Info whichInfo() => _PushTxNotificationRequest_InfoByTag[$_whichOneof(0)]!;
  void clearInfo() => clearField($_whichOneof(0));

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

  @$pb.TagNumber(4)
  $core.List<$core.int> get txHash => $_getN(3);
  @$pb.TagNumber(4)
  set txHash($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTxHash() => $_has(3);
  @$pb.TagNumber(4)
  void clearTxHash() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get script => $_getN(4);
  @$pb.TagNumber(5)
  set script($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasScript() => $_has(4);
  @$pb.TagNumber(5)
  void clearScript() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get blockHeightHint => $_getIZ(5);
  @$pb.TagNumber(6)
  set blockHeightHint($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasBlockHeightHint() => $_has(5);
  @$pb.TagNumber(6)
  void clearBlockHeightHint() => clearField(6);

  @$pb.TagNumber(7)
  BoltzReverseSwapLockupTx get boltzReverseSwapLockupTxInfo => $_getN(6);
  @$pb.TagNumber(7)
  set boltzReverseSwapLockupTxInfo(BoltzReverseSwapLockupTx v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasBoltzReverseSwapLockupTxInfo() => $_has(6);
  @$pb.TagNumber(7)
  void clearBoltzReverseSwapLockupTxInfo() => clearField(7);
  @$pb.TagNumber(7)
  BoltzReverseSwapLockupTx ensureBoltzReverseSwapLockupTxInfo() => $_ensure(6);
}

class PushTxNotificationResponse extends $pb.GeneratedMessage {
  factory PushTxNotificationResponse() => create();
  PushTxNotificationResponse._() : super();
  factory PushTxNotificationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PushTxNotificationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PushTxNotificationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PushTxNotificationResponse clone() => PushTxNotificationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PushTxNotificationResponse copyWith(void Function(PushTxNotificationResponse) updates) => super.copyWith((message) => updates(message as PushTxNotificationResponse)) as PushTxNotificationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushTxNotificationResponse create() => PushTxNotificationResponse._();
  PushTxNotificationResponse createEmptyInstance() => create();
  static $pb.PbList<PushTxNotificationResponse> createRepeated() => $pb.PbList<PushTxNotificationResponse>();
  @$core.pragma('dart2js:noInline')
  static PushTxNotificationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PushTxNotificationResponse>(create);
  static PushTxNotificationResponse? _defaultInstance;
}

class BreezAppVersionsRequest extends $pb.GeneratedMessage {
  factory BreezAppVersionsRequest() => create();
  BreezAppVersionsRequest._() : super();
  factory BreezAppVersionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BreezAppVersionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BreezAppVersionsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BreezAppVersionsRequest clone() => BreezAppVersionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BreezAppVersionsRequest copyWith(void Function(BreezAppVersionsRequest) updates) => super.copyWith((message) => updates(message as BreezAppVersionsRequest)) as BreezAppVersionsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BreezAppVersionsRequest create() => BreezAppVersionsRequest._();
  BreezAppVersionsRequest createEmptyInstance() => create();
  static $pb.PbList<BreezAppVersionsRequest> createRepeated() => $pb.PbList<BreezAppVersionsRequest>();
  @$core.pragma('dart2js:noInline')
  static BreezAppVersionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BreezAppVersionsRequest>(create);
  static BreezAppVersionsRequest? _defaultInstance;
}

class BreezAppVersionsReply extends $pb.GeneratedMessage {
  factory BreezAppVersionsReply({
    $core.Iterable<$core.String>? version,
  }) {
    final $result = create();
    if (version != null) {
      $result.version.addAll(version);
    }
    return $result;
  }
  BreezAppVersionsReply._() : super();
  factory BreezAppVersionsReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BreezAppVersionsReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BreezAppVersionsReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BreezAppVersionsReply clone() => BreezAppVersionsReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BreezAppVersionsReply copyWith(void Function(BreezAppVersionsReply) updates) => super.copyWith((message) => updates(message as BreezAppVersionsReply)) as BreezAppVersionsReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BreezAppVersionsReply create() => BreezAppVersionsReply._();
  BreezAppVersionsReply createEmptyInstance() => create();
  static $pb.PbList<BreezAppVersionsReply> createRepeated() => $pb.PbList<BreezAppVersionsReply>();
  @$core.pragma('dart2js:noInline')
  static BreezAppVersionsReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BreezAppVersionsReply>(create);
  static BreezAppVersionsReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get version => $_getList(0);
}

class GetReverseRoutingNodeRequest extends $pb.GeneratedMessage {
  factory GetReverseRoutingNodeRequest() => create();
  GetReverseRoutingNodeRequest._() : super();
  factory GetReverseRoutingNodeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetReverseRoutingNodeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetReverseRoutingNodeRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetReverseRoutingNodeRequest clone() => GetReverseRoutingNodeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetReverseRoutingNodeRequest copyWith(void Function(GetReverseRoutingNodeRequest) updates) => super.copyWith((message) => updates(message as GetReverseRoutingNodeRequest)) as GetReverseRoutingNodeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReverseRoutingNodeRequest create() => GetReverseRoutingNodeRequest._();
  GetReverseRoutingNodeRequest createEmptyInstance() => create();
  static $pb.PbList<GetReverseRoutingNodeRequest> createRepeated() => $pb.PbList<GetReverseRoutingNodeRequest>();
  @$core.pragma('dart2js:noInline')
  static GetReverseRoutingNodeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetReverseRoutingNodeRequest>(create);
  static GetReverseRoutingNodeRequest? _defaultInstance;
}

class GetReverseRoutingNodeReply extends $pb.GeneratedMessage {
  factory GetReverseRoutingNodeReply({
    $core.List<$core.int>? nodeId,
  }) {
    final $result = create();
    if (nodeId != null) {
      $result.nodeId = nodeId;
    }
    return $result;
  }
  GetReverseRoutingNodeReply._() : super();
  factory GetReverseRoutingNodeReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetReverseRoutingNodeReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetReverseRoutingNodeReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'nodeId', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetReverseRoutingNodeReply clone() => GetReverseRoutingNodeReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetReverseRoutingNodeReply copyWith(void Function(GetReverseRoutingNodeReply) updates) => super.copyWith((message) => updates(message as GetReverseRoutingNodeReply)) as GetReverseRoutingNodeReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReverseRoutingNodeReply create() => GetReverseRoutingNodeReply._();
  GetReverseRoutingNodeReply createEmptyInstance() => create();
  static $pb.PbList<GetReverseRoutingNodeReply> createRepeated() => $pb.PbList<GetReverseRoutingNodeReply>();
  @$core.pragma('dart2js:noInline')
  static GetReverseRoutingNodeReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetReverseRoutingNodeReply>(create);
  static GetReverseRoutingNodeReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nodeId => $_getN(0);
  @$pb.TagNumber(1)
  set nodeId($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);
}

class ReportPaymentFailureRequest extends $pb.GeneratedMessage {
  factory ReportPaymentFailureRequest({
    $core.String? sdkVersion,
    $core.String? sdkGitHash,
    $core.String? nodeId,
    $core.String? lspId,
    $core.String? timestamp,
    $core.String? comment,
    $core.String? report,
  }) {
    final $result = create();
    if (sdkVersion != null) {
      $result.sdkVersion = sdkVersion;
    }
    if (sdkGitHash != null) {
      $result.sdkGitHash = sdkGitHash;
    }
    if (nodeId != null) {
      $result.nodeId = nodeId;
    }
    if (lspId != null) {
      $result.lspId = lspId;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (comment != null) {
      $result.comment = comment;
    }
    if (report != null) {
      $result.report = report;
    }
    return $result;
  }
  ReportPaymentFailureRequest._() : super();
  factory ReportPaymentFailureRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReportPaymentFailureRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReportPaymentFailureRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sdkVersion')
    ..aOS(2, _omitFieldNames ? '' : 'sdkGitHash')
    ..aOS(3, _omitFieldNames ? '' : 'nodeId')
    ..aOS(4, _omitFieldNames ? '' : 'lspId')
    ..aOS(5, _omitFieldNames ? '' : 'timestamp')
    ..aOS(6, _omitFieldNames ? '' : 'comment')
    ..aOS(7, _omitFieldNames ? '' : 'report')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReportPaymentFailureRequest clone() => ReportPaymentFailureRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReportPaymentFailureRequest copyWith(void Function(ReportPaymentFailureRequest) updates) => super.copyWith((message) => updates(message as ReportPaymentFailureRequest)) as ReportPaymentFailureRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportPaymentFailureRequest create() => ReportPaymentFailureRequest._();
  ReportPaymentFailureRequest createEmptyInstance() => create();
  static $pb.PbList<ReportPaymentFailureRequest> createRepeated() => $pb.PbList<ReportPaymentFailureRequest>();
  @$core.pragma('dart2js:noInline')
  static ReportPaymentFailureRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportPaymentFailureRequest>(create);
  static ReportPaymentFailureRequest? _defaultInstance;

  /// The sdk build version
  @$pb.TagNumber(1)
  $core.String get sdkVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdkVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSdkVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdkVersion() => clearField(1);

  /// The sdk build git hash
  @$pb.TagNumber(2)
  $core.String get sdkGitHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set sdkGitHash($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSdkGitHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearSdkGitHash() => clearField(2);

  /// The node pubkey reporting the failure
  @$pb.TagNumber(3)
  $core.String get nodeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set nodeId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNodeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearNodeId() => clearField(3);

  /// The currently used lsp id
  @$pb.TagNumber(4)
  $core.String get lspId => $_getSZ(3);
  @$pb.TagNumber(4)
  set lspId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLspId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLspId() => clearField(4);

  /// The ISO 8601 timestamp
  @$pb.TagNumber(5)
  $core.String get timestamp => $_getSZ(4);
  @$pb.TagNumber(5)
  set timestamp($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTimestamp() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimestamp() => clearField(5);

  /// The optional comment/error response text
  @$pb.TagNumber(6)
  $core.String get comment => $_getSZ(5);
  @$pb.TagNumber(6)
  set comment($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasComment() => $_has(5);
  @$pb.TagNumber(6)
  void clearComment() => clearField(6);

  /// The JSON encoded report payload
  @$pb.TagNumber(7)
  $core.String get report => $_getSZ(6);
  @$pb.TagNumber(7)
  set report($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasReport() => $_has(6);
  @$pb.TagNumber(7)
  void clearReport() => clearField(7);
}

class ReportPaymentFailureReply extends $pb.GeneratedMessage {
  factory ReportPaymentFailureReply() => create();
  ReportPaymentFailureReply._() : super();
  factory ReportPaymentFailureReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReportPaymentFailureReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReportPaymentFailureReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReportPaymentFailureReply clone() => ReportPaymentFailureReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReportPaymentFailureReply copyWith(void Function(ReportPaymentFailureReply) updates) => super.copyWith((message) => updates(message as ReportPaymentFailureReply)) as ReportPaymentFailureReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportPaymentFailureReply create() => ReportPaymentFailureReply._();
  ReportPaymentFailureReply createEmptyInstance() => create();
  static $pb.PbList<ReportPaymentFailureReply> createRepeated() => $pb.PbList<ReportPaymentFailureReply>();
  @$core.pragma('dart2js:noInline')
  static ReportPaymentFailureReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportPaymentFailureReply>(create);
  static ReportPaymentFailureReply? _defaultInstance;
}

class BreezStatusRequest extends $pb.GeneratedMessage {
  factory BreezStatusRequest() => create();
  BreezStatusRequest._() : super();
  factory BreezStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BreezStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BreezStatusRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BreezStatusRequest clone() => BreezStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BreezStatusRequest copyWith(void Function(BreezStatusRequest) updates) => super.copyWith((message) => updates(message as BreezStatusRequest)) as BreezStatusRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BreezStatusRequest create() => BreezStatusRequest._();
  BreezStatusRequest createEmptyInstance() => create();
  static $pb.PbList<BreezStatusRequest> createRepeated() => $pb.PbList<BreezStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static BreezStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BreezStatusRequest>(create);
  static BreezStatusRequest? _defaultInstance;
}

class BreezStatusReply extends $pb.GeneratedMessage {
  factory BreezStatusReply({
    BreezStatusReply_BreezStatus? status,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  BreezStatusReply._() : super();
  factory BreezStatusReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BreezStatusReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BreezStatusReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'breez'), createEmptyInstance: create)
    ..e<BreezStatusReply_BreezStatus>(1, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: BreezStatusReply_BreezStatus.OPERATIONAL, valueOf: BreezStatusReply_BreezStatus.valueOf, enumValues: BreezStatusReply_BreezStatus.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BreezStatusReply clone() => BreezStatusReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BreezStatusReply copyWith(void Function(BreezStatusReply) updates) => super.copyWith((message) => updates(message as BreezStatusReply)) as BreezStatusReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BreezStatusReply create() => BreezStatusReply._();
  BreezStatusReply createEmptyInstance() => create();
  static $pb.PbList<BreezStatusReply> createRepeated() => $pb.PbList<BreezStatusReply>();
  @$core.pragma('dart2js:noInline')
  static BreezStatusReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BreezStatusReply>(create);
  static BreezStatusReply? _defaultInstance;

  @$pb.TagNumber(1)
  BreezStatusReply_BreezStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(BreezStatusReply_BreezStatus v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');

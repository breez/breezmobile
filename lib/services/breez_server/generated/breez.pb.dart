///
//  Generated code. Do not modify.
//  source: breez.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'breez.pbenum.dart';

export 'breez.pbenum.dart';

class SignUrlRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SignUrlRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'base_url', protoName: 'baseUrl')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'query_string', protoName: 'queryString')
    ..hasRequiredFields = false
  ;

  SignUrlRequest._() : super();
  factory SignUrlRequest({
    $core.String? baseUrl,
    $core.String? queryString,
  }) {
    final _result = create();
    if (baseUrl != null) {
      _result.baseUrl = baseUrl;
    }
    if (queryString != null) {
      _result.queryString = queryString;
    }
    return _result;
  }
  factory SignUrlRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignUrlRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignUrlRequest clone() => SignUrlRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignUrlRequest copyWith(void Function(SignUrlRequest) updates) => super.copyWith((message) => updates(message as SignUrlRequest)) as SignUrlRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SignUrlResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'full_url', protoName: 'fullUrl')
    ..hasRequiredFields = false
  ;

  SignUrlResponse._() : super();
  factory SignUrlResponse({
    $core.String? fullUrl,
  }) {
    final _result = create();
    if (fullUrl != null) {
      _result.fullUrl = fullUrl;
    }
    return _result;
  }
  factory SignUrlResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignUrlResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SignUrlResponse clone() => SignUrlResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SignUrlResponse copyWith(void Function(SignUrlResponse) updates) => super.copyWith((message) => updates(message as SignUrlResponse)) as SignUrlResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'InactiveNotifyRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey', $pb.PbFieldType.OY)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'days', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  InactiveNotifyRequest._() : super();
  factory InactiveNotifyRequest({
    $core.List<$core.int>? pubkey,
    $core.int? days,
  }) {
    final _result = create();
    if (pubkey != null) {
      _result.pubkey = pubkey;
    }
    if (days != null) {
      _result.days = days;
    }
    return _result;
  }
  factory InactiveNotifyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InactiveNotifyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InactiveNotifyRequest clone() => InactiveNotifyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InactiveNotifyRequest copyWith(void Function(InactiveNotifyRequest) updates) => super.copyWith((message) => updates(message as InactiveNotifyRequest)) as InactiveNotifyRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'InactiveNotifyResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  InactiveNotifyResponse._() : super();
  factory InactiveNotifyResponse() => create();
  factory InactiveNotifyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InactiveNotifyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InactiveNotifyResponse clone() => InactiveNotifyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InactiveNotifyResponse copyWith(void Function(InactiveNotifyResponse) updates) => super.copyWith((message) => updates(message as InactiveNotifyResponse)) as InactiveNotifyResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InactiveNotifyResponse create() => InactiveNotifyResponse._();
  InactiveNotifyResponse createEmptyInstance() => create();
  static $pb.PbList<InactiveNotifyResponse> createRepeated() => $pb.PbList<InactiveNotifyResponse>();
  @$core.pragma('dart2js:noInline')
  static InactiveNotifyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InactiveNotifyResponse>(create);
  static InactiveNotifyResponse? _defaultInstance;
}

class ReceiverInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReceiverInfoRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  ReceiverInfoRequest._() : super();
  factory ReceiverInfoRequest() => create();
  factory ReceiverInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReceiverInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReceiverInfoRequest clone() => ReceiverInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReceiverInfoRequest copyWith(void Function(ReceiverInfoRequest) updates) => super.copyWith((message) => updates(message as ReceiverInfoRequest)) as ReceiverInfoRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReceiverInfoReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey')
    ..hasRequiredFields = false
  ;

  ReceiverInfoReply._() : super();
  factory ReceiverInfoReply({
    $core.String? pubkey,
  }) {
    final _result = create();
    if (pubkey != null) {
      _result.pubkey = pubkey;
    }
    return _result;
  }
  factory ReceiverInfoReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReceiverInfoReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReceiverInfoReply clone() => ReceiverInfoReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReceiverInfoReply copyWith(void Function(ReceiverInfoReply) updates) => super.copyWith((message) => updates(message as ReceiverInfoReply)) as ReceiverInfoReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RatesRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  RatesRequest._() : super();
  factory RatesRequest() => create();
  factory RatesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RatesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RatesRequest clone() => RatesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RatesRequest copyWith(void Function(RatesRequest) updates) => super.copyWith((message) => updates(message as RatesRequest)) as RatesRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Rate', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coin')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  Rate._() : super();
  factory Rate({
    $core.String? coin,
    $core.double? value,
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
  factory Rate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Rate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Rate clone() => Rate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Rate copyWith(void Function(Rate) updates) => super.copyWith((message) => updates(message as Rate)) as Rate; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RatesReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..pc<Rate>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rates', $pb.PbFieldType.PM, subBuilder: Rate.create)
    ..hasRequiredFields = false
  ;

  RatesReply._() : super();
  factory RatesReply({
    $core.Iterable<Rate>? rates,
  }) {
    final _result = create();
    if (rates != null) {
      _result.rates.addAll(rates);
    }
    return _result;
  }
  factory RatesReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RatesReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RatesReply clone() => RatesReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RatesReply copyWith(void Function(RatesReply) updates) => super.copyWith((message) => updates(message as RatesReply)) as RatesReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LSPListRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey')
    ..hasRequiredFields = false
  ;

  LSPListRequest._() : super();
  factory LSPListRequest({
    $core.String? pubkey,
  }) {
    final _result = create();
    if (pubkey != null) {
      _result.pubkey = pubkey;
    }
    return _result;
  }
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
  LSPListRequest copyWith(void Function(LSPListRequest) updates) => super.copyWith((message) => updates(message as LSPListRequest)) as LSPListRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LSPListRequest create() => LSPListRequest._();
  LSPListRequest createEmptyInstance() => create();
  static $pb.PbList<LSPListRequest> createRepeated() => $pb.PbList<LSPListRequest>();
  @$core.pragma('dart2js:noInline')
  static LSPListRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LSPListRequest>(create);
  static LSPListRequest? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LSPInformation', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'widget_url')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'host')
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'channel_capacity')
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'target_conf', $pb.PbFieldType.O3)
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'base_fee_msat')
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fee_rate', $pb.PbFieldType.OD)
    ..a<$core.int>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time_lock_delta', $pb.PbFieldType.OU3)
    ..aInt64(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'min_htlc_msat')
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'channelFeePermyriad')
    ..a<$core.List<$core.int>>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lspPubkey', $pb.PbFieldType.OY)
    ..aInt64(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxInactiveDuration')
    ..aInt64(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'channelMinimumFeeMsat')
    ..hasRequiredFields = false
  ;

  LSPInformation._() : super();
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
    $fixnum.Int64? channelFeePermyriad,
    $core.List<$core.int>? lspPubkey,
    $fixnum.Int64? maxInactiveDuration,
    $fixnum.Int64? channelMinimumFeeMsat,
  }) {
    final _result = create();
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
  LSPInformation copyWith(void Function(LSPInformation) updates) => super.copyWith((message) => updates(message as LSPInformation)) as LSPInformation; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LSPInformation create() => LSPInformation._();
  LSPInformation createEmptyInstance() => create();
  static $pb.PbList<LSPInformation> createRepeated() => $pb.PbList<LSPInformation>();
  @$core.pragma('dart2js:noInline')
  static LSPInformation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LSPInformation>(create);
  static LSPInformation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get widgetUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set widgetUrl($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasWidgetUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearWidgetUrl() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get pubkey => $_getSZ(2);
  @$pb.TagNumber(3)
  set pubkey($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPubkey() => $_has(2);
  @$pb.TagNumber(3)
  void clearPubkey() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get host => $_getSZ(3);
  @$pb.TagNumber(4)
  set host($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHost() => $_has(3);
  @$pb.TagNumber(4)
  void clearHost() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get channelCapacity => $_getI64(4);
  @$pb.TagNumber(5)
  set channelCapacity($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasChannelCapacity() => $_has(4);
  @$pb.TagNumber(5)
  void clearChannelCapacity() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get targetConf => $_getIZ(5);
  @$pb.TagNumber(6)
  set targetConf($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTargetConf() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetConf() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get baseFeeMsat => $_getI64(6);
  @$pb.TagNumber(7)
  set baseFeeMsat($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasBaseFeeMsat() => $_has(6);
  @$pb.TagNumber(7)
  void clearBaseFeeMsat() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get feeRate => $_getN(7);
  @$pb.TagNumber(8)
  set feeRate($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasFeeRate() => $_has(7);
  @$pb.TagNumber(8)
  void clearFeeRate() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get timeLockDelta => $_getIZ(8);
  @$pb.TagNumber(9)
  set timeLockDelta($core.int v) { $_setUnsignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTimeLockDelta() => $_has(8);
  @$pb.TagNumber(9)
  void clearTimeLockDelta() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get minHtlcMsat => $_getI64(9);
  @$pb.TagNumber(10)
  set minHtlcMsat($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasMinHtlcMsat() => $_has(9);
  @$pb.TagNumber(10)
  void clearMinHtlcMsat() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get channelFeePermyriad => $_getI64(10);
  @$pb.TagNumber(11)
  set channelFeePermyriad($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasChannelFeePermyriad() => $_has(10);
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

  @$pb.TagNumber(13)
  $fixnum.Int64 get maxInactiveDuration => $_getI64(12);
  @$pb.TagNumber(13)
  set maxInactiveDuration($fixnum.Int64 v) { $_setInt64(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasMaxInactiveDuration() => $_has(12);
  @$pb.TagNumber(13)
  void clearMaxInactiveDuration() => clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get channelMinimumFeeMsat => $_getI64(13);
  @$pb.TagNumber(14)
  set channelMinimumFeeMsat($fixnum.Int64 v) { $_setInt64(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasChannelMinimumFeeMsat() => $_has(13);
  @$pb.TagNumber(14)
  void clearChannelMinimumFeeMsat() => clearField(14);
}

class LSPListReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LSPListReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..m<$core.String, LSPInformation>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lsps', entryClassName: 'LSPListReply.LspsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: LSPInformation.create, packageName: const $pb.PackageName('breez'))
    ..hasRequiredFields = false
  ;

  LSPListReply._() : super();
  factory LSPListReply({
    $core.Map<$core.String, LSPInformation>? lsps,
  }) {
    final _result = create();
    if (lsps != null) {
      _result.lsps.addAll(lsps);
    }
    return _result;
  }
  factory LSPListReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LSPListReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LSPListReply clone() => LSPListReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LSPListReply copyWith(void Function(LSPListReply) updates) => super.copyWith((message) => updates(message as LSPListReply)) as LSPListReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RegisterPaymentRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lspId')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blob', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  RegisterPaymentRequest._() : super();
  factory RegisterPaymentRequest({
    $core.String? lspId,
    $core.List<$core.int>? blob,
  }) {
    final _result = create();
    if (lspId != null) {
      _result.lspId = lspId;
    }
    if (blob != null) {
      _result.blob = blob;
    }
    return _result;
  }
  factory RegisterPaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterPaymentRequest clone() => RegisterPaymentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterPaymentRequest copyWith(void Function(RegisterPaymentRequest) updates) => super.copyWith((message) => updates(message as RegisterPaymentRequest)) as RegisterPaymentRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RegisterPaymentReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  RegisterPaymentReply._() : super();
  factory RegisterPaymentReply() => create();
  factory RegisterPaymentReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPaymentReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterPaymentReply clone() => RegisterPaymentReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterPaymentReply copyWith(void Function(RegisterPaymentReply) updates) => super.copyWith((message) => updates(message as RegisterPaymentReply)) as RegisterPaymentReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CheckChannelsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lspId')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blob', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CheckChannelsRequest._() : super();
  factory CheckChannelsRequest({
    $core.String? lspId,
    $core.List<$core.int>? blob,
  }) {
    final _result = create();
    if (lspId != null) {
      _result.lspId = lspId;
    }
    if (blob != null) {
      _result.blob = blob;
    }
    return _result;
  }
  factory CheckChannelsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CheckChannelsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CheckChannelsRequest clone() => CheckChannelsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CheckChannelsRequest copyWith(void Function(CheckChannelsRequest) updates) => super.copyWith((message) => updates(message as CheckChannelsRequest)) as CheckChannelsRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CheckChannelsReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blob', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CheckChannelsReply._() : super();
  factory CheckChannelsReply({
    $core.List<$core.int>? blob,
  }) {
    final _result = create();
    if (blob != null) {
      _result.blob = blob;
    }
    return _result;
  }
  factory CheckChannelsReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CheckChannelsReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CheckChannelsReply clone() => CheckChannelsReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CheckChannelsReply copyWith(void Function(CheckChannelsReply) updates) => super.copyWith((message) => updates(message as CheckChannelsReply)) as CheckChannelsReply; // ignore: deprecated_member_use
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

class OpenLSPChannelRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OpenLSPChannelRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lspId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey')
    ..hasRequiredFields = false
  ;

  OpenLSPChannelRequest._() : super();
  factory OpenLSPChannelRequest({
    $core.String? lspId,
    $core.String? pubkey,
  }) {
    final _result = create();
    if (lspId != null) {
      _result.lspId = lspId;
    }
    if (pubkey != null) {
      _result.pubkey = pubkey;
    }
    return _result;
  }
  factory OpenLSPChannelRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenLSPChannelRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpenLSPChannelRequest clone() => OpenLSPChannelRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpenLSPChannelRequest copyWith(void Function(OpenLSPChannelRequest) updates) => super.copyWith((message) => updates(message as OpenLSPChannelRequest)) as OpenLSPChannelRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpenLSPChannelRequest create() => OpenLSPChannelRequest._();
  OpenLSPChannelRequest createEmptyInstance() => create();
  static $pb.PbList<OpenLSPChannelRequest> createRepeated() => $pb.PbList<OpenLSPChannelRequest>();
  @$core.pragma('dart2js:noInline')
  static OpenLSPChannelRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenLSPChannelRequest>(create);
  static OpenLSPChannelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lspId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lspId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLspId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLspId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get pubkey => $_getSZ(1);
  @$pb.TagNumber(2)
  set pubkey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPubkey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPubkey() => clearField(2);
}

class OpenLSPChannelReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OpenLSPChannelReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  OpenLSPChannelReply._() : super();
  factory OpenLSPChannelReply() => create();
  factory OpenLSPChannelReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenLSPChannelReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpenLSPChannelReply clone() => OpenLSPChannelReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpenLSPChannelReply copyWith(void Function(OpenLSPChannelReply) updates) => super.copyWith((message) => updates(message as OpenLSPChannelReply)) as OpenLSPChannelReply; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpenLSPChannelReply create() => OpenLSPChannelReply._();
  OpenLSPChannelReply createEmptyInstance() => create();
  static $pb.PbList<OpenLSPChannelReply> createRepeated() => $pb.PbList<OpenLSPChannelReply>();
  @$core.pragma('dart2js:noInline')
  static OpenLSPChannelReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenLSPChannelReply>(create);
  static OpenLSPChannelReply? _defaultInstance;
}

class OpenChannelRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OpenChannelRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubKey', protoName: 'pubKey')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notificationToken', protoName: 'notificationToken')
    ..hasRequiredFields = false
  ;

  OpenChannelRequest._() : super();
  factory OpenChannelRequest({
    $core.String? pubKey,
    $core.String? notificationToken,
  }) {
    final _result = create();
    if (pubKey != null) {
      _result.pubKey = pubKey;
    }
    if (notificationToken != null) {
      _result.notificationToken = notificationToken;
    }
    return _result;
  }
  factory OpenChannelRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenChannelRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpenChannelRequest clone() => OpenChannelRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpenChannelRequest copyWith(void Function(OpenChannelRequest) updates) => super.copyWith((message) => updates(message as OpenChannelRequest)) as OpenChannelRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpenChannelRequest create() => OpenChannelRequest._();
  OpenChannelRequest createEmptyInstance() => create();
  static $pb.PbList<OpenChannelRequest> createRepeated() => $pb.PbList<OpenChannelRequest>();
  @$core.pragma('dart2js:noInline')
  static OpenChannelRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenChannelRequest>(create);
  static OpenChannelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pubKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set pubKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPubKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPubKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get notificationToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set notificationToken($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNotificationToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotificationToken() => clearField(2);
}

class OpenChannelReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OpenChannelReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  OpenChannelReply._() : super();
  factory OpenChannelReply() => create();
  factory OpenChannelReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenChannelReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpenChannelReply clone() => OpenChannelReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpenChannelReply copyWith(void Function(OpenChannelReply) updates) => super.copyWith((message) => updates(message as OpenChannelReply)) as OpenChannelReply; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpenChannelReply create() => OpenChannelReply._();
  OpenChannelReply createEmptyInstance() => create();
  static $pb.PbList<OpenChannelReply> createRepeated() => $pb.PbList<OpenChannelReply>();
  @$core.pragma('dart2js:noInline')
  static OpenChannelReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenChannelReply>(create);
  static OpenChannelReply? _defaultInstance;
}

class OpenPublicChannelRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OpenPublicChannelRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey')
    ..hasRequiredFields = false
  ;

  OpenPublicChannelRequest._() : super();
  factory OpenPublicChannelRequest({
    $core.String? pubkey,
  }) {
    final _result = create();
    if (pubkey != null) {
      _result.pubkey = pubkey;
    }
    return _result;
  }
  factory OpenPublicChannelRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenPublicChannelRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpenPublicChannelRequest clone() => OpenPublicChannelRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpenPublicChannelRequest copyWith(void Function(OpenPublicChannelRequest) updates) => super.copyWith((message) => updates(message as OpenPublicChannelRequest)) as OpenPublicChannelRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpenPublicChannelRequest create() => OpenPublicChannelRequest._();
  OpenPublicChannelRequest createEmptyInstance() => create();
  static $pb.PbList<OpenPublicChannelRequest> createRepeated() => $pb.PbList<OpenPublicChannelRequest>();
  @$core.pragma('dart2js:noInline')
  static OpenPublicChannelRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenPublicChannelRequest>(create);
  static OpenPublicChannelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pubkey => $_getSZ(0);
  @$pb.TagNumber(1)
  set pubkey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPubkey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPubkey() => clearField(1);
}

class OpenPublicChannelReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OpenPublicChannelReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  OpenPublicChannelReply._() : super();
  factory OpenPublicChannelReply() => create();
  factory OpenPublicChannelReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenPublicChannelReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpenPublicChannelReply clone() => OpenPublicChannelReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpenPublicChannelReply copyWith(void Function(OpenPublicChannelReply) updates) => super.copyWith((message) => updates(message as OpenPublicChannelReply)) as OpenPublicChannelReply; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpenPublicChannelReply create() => OpenPublicChannelReply._();
  OpenPublicChannelReply createEmptyInstance() => create();
  static $pb.PbList<OpenPublicChannelReply> createRepeated() => $pb.PbList<OpenPublicChannelReply>();
  @$core.pragma('dart2js:noInline')
  static OpenPublicChannelReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenPublicChannelReply>(create);
  static OpenPublicChannelReply? _defaultInstance;
}

class Captcha extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Captcha', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'image', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  Captcha._() : super();
  factory Captcha({
    $core.String? id,
    $core.List<$core.int>? image,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (image != null) {
      _result.image = image;
    }
    return _result;
  }
  factory Captcha.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Captcha.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Captcha clone() => Captcha()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Captcha copyWith(void Function(Captcha) updates) => super.copyWith((message) => updates(message as Captcha)) as Captcha; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateChannelPolicyRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubKey', protoName: 'pubKey')
    ..hasRequiredFields = false
  ;

  UpdateChannelPolicyRequest._() : super();
  factory UpdateChannelPolicyRequest({
    $core.String? pubKey,
  }) {
    final _result = create();
    if (pubKey != null) {
      _result.pubKey = pubKey;
    }
    return _result;
  }
  factory UpdateChannelPolicyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateChannelPolicyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateChannelPolicyRequest clone() => UpdateChannelPolicyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateChannelPolicyRequest copyWith(void Function(UpdateChannelPolicyRequest) updates) => super.copyWith((message) => updates(message as UpdateChannelPolicyRequest)) as UpdateChannelPolicyRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateChannelPolicyReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  UpdateChannelPolicyReply._() : super();
  factory UpdateChannelPolicyReply() => create();
  factory UpdateChannelPolicyReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateChannelPolicyReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateChannelPolicyReply clone() => UpdateChannelPolicyReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateChannelPolicyReply copyWith(void Function(UpdateChannelPolicyReply) updates) => super.copyWith((message) => updates(message as UpdateChannelPolicyReply)) as UpdateChannelPolicyReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddFundInitRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeID', protoName: 'nodeID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notificationToken', protoName: 'notificationToken')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hash', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  AddFundInitRequest._() : super();
  factory AddFundInitRequest({
    $core.String? nodeID,
    $core.String? notificationToken,
    $core.List<$core.int>? pubkey,
    $core.List<$core.int>? hash,
  }) {
    final _result = create();
    if (nodeID != null) {
      _result.nodeID = nodeID;
    }
    if (notificationToken != null) {
      _result.notificationToken = notificationToken;
    }
    if (pubkey != null) {
      _result.pubkey = pubkey;
    }
    if (hash != null) {
      _result.hash = hash;
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
  AddFundInitRequest copyWith(void Function(AddFundInitRequest) updates) => super.copyWith((message) => updates(message as AddFundInitRequest)) as AddFundInitRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddFundInitReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey', $pb.PbFieldType.OY)
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lockHeight', protoName: 'lockHeight')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxAllowedDeposit', protoName: 'maxAllowedDeposit')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMessage', protoName: 'errorMessage')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'requiredReserve', protoName: 'requiredReserve')
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minAllowedDeposit', protoName: 'minAllowedDeposit')
    ..hasRequiredFields = false
  ;

  AddFundInitReply._() : super();
  factory AddFundInitReply({
    $core.String? address,
    $core.List<$core.int>? pubkey,
    $fixnum.Int64? lockHeight,
    $fixnum.Int64? maxAllowedDeposit,
    $core.String? errorMessage,
    $fixnum.Int64? requiredReserve,
    $fixnum.Int64? minAllowedDeposit,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (pubkey != null) {
      _result.pubkey = pubkey;
    }
    if (lockHeight != null) {
      _result.lockHeight = lockHeight;
    }
    if (maxAllowedDeposit != null) {
      _result.maxAllowedDeposit = maxAllowedDeposit;
    }
    if (errorMessage != null) {
      _result.errorMessage = errorMessage;
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
  AddFundInitReply copyWith(void Function(AddFundInitReply) updates) => super.copyWith((message) => updates(message as AddFundInitReply)) as AddFundInitReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddFundStatusRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addresses')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notificationToken', protoName: 'notificationToken')
    ..hasRequiredFields = false
  ;

  AddFundStatusRequest._() : super();
  factory AddFundStatusRequest({
    $core.Iterable<$core.String>? addresses,
    $core.String? notificationToken,
  }) {
    final _result = create();
    if (addresses != null) {
      _result.addresses.addAll(addresses);
    }
    if (notificationToken != null) {
      _result.notificationToken = notificationToken;
    }
    return _result;
  }
  factory AddFundStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddFundStatusRequest clone() => AddFundStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddFundStatusRequest copyWith(void Function(AddFundStatusRequest) updates) => super.copyWith((message) => updates(message as AddFundStatusRequest)) as AddFundStatusRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddFundStatusReply.AddressStatus', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tx')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'confirmed')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockHash', protoName: 'blockHash')
    ..hasRequiredFields = false
  ;

  AddFundStatusReply_AddressStatus._() : super();
  factory AddFundStatusReply_AddressStatus({
    $core.String? tx,
    $fixnum.Int64? amount,
    $core.bool? confirmed,
    $core.String? blockHash,
  }) {
    final _result = create();
    if (tx != null) {
      _result.tx = tx;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (confirmed != null) {
      _result.confirmed = confirmed;
    }
    if (blockHash != null) {
      _result.blockHash = blockHash;
    }
    return _result;
  }
  factory AddFundStatusReply_AddressStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundStatusReply_AddressStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddFundStatusReply_AddressStatus clone() => AddFundStatusReply_AddressStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddFundStatusReply_AddressStatus copyWith(void Function(AddFundStatusReply_AddressStatus) updates) => super.copyWith((message) => updates(message as AddFundStatusReply_AddressStatus)) as AddFundStatusReply_AddressStatus; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddFundStatusReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..m<$core.String, AddFundStatusReply_AddressStatus>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'statuses', entryClassName: 'AddFundStatusReply.StatusesEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: AddFundStatusReply_AddressStatus.create, packageName: const $pb.PackageName('breez'))
    ..hasRequiredFields = false
  ;

  AddFundStatusReply._() : super();
  factory AddFundStatusReply({
    $core.Map<$core.String, AddFundStatusReply_AddressStatus>? statuses,
  }) {
    final _result = create();
    if (statuses != null) {
      _result.statuses.addAll(statuses);
    }
    return _result;
  }
  factory AddFundStatusReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundStatusReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddFundStatusReply clone() => AddFundStatusReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddFundStatusReply copyWith(void Function(AddFundStatusReply) updates) => super.copyWith((message) => updates(message as AddFundStatusReply)) as AddFundStatusReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemoveFundRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..hasRequiredFields = false
  ;

  RemoveFundRequest._() : super();
  factory RemoveFundRequest({
    $core.String? address,
    $fixnum.Int64? amount,
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
  RemoveFundRequest copyWith(void Function(RemoveFundRequest) updates) => super.copyWith((message) => updates(message as RemoveFundRequest)) as RemoveFundRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemoveFundReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentRequest', protoName: 'paymentRequest')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMessage', protoName: 'errorMessage')
    ..hasRequiredFields = false
  ;

  RemoveFundReply._() : super();
  factory RemoveFundReply({
    $core.String? paymentRequest,
    $core.String? errorMessage,
  }) {
    final _result = create();
    if (paymentRequest != null) {
      _result.paymentRequest = paymentRequest;
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
  RemoveFundReply copyWith(void Function(RemoveFundReply) updates) => super.copyWith((message) => updates(message as RemoveFundReply)) as RemoveFundReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RedeemRemovedFundsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymenthash')
    ..hasRequiredFields = false
  ;

  RedeemRemovedFundsRequest._() : super();
  factory RedeemRemovedFundsRequest({
    $core.String? paymenthash,
  }) {
    final _result = create();
    if (paymenthash != null) {
      _result.paymenthash = paymenthash;
    }
    return _result;
  }
  factory RedeemRemovedFundsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RedeemRemovedFundsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RedeemRemovedFundsRequest clone() => RedeemRemovedFundsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RedeemRemovedFundsRequest copyWith(void Function(RedeemRemovedFundsRequest) updates) => super.copyWith((message) => updates(message as RedeemRemovedFundsRequest)) as RedeemRemovedFundsRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RedeemRemovedFundsReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid')
    ..hasRequiredFields = false
  ;

  RedeemRemovedFundsReply._() : super();
  factory RedeemRemovedFundsReply({
    $core.String? txid,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    return _result;
  }
  factory RedeemRemovedFundsReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RedeemRemovedFundsReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RedeemRemovedFundsReply clone() => RedeemRemovedFundsReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RedeemRemovedFundsReply copyWith(void Function(RedeemRemovedFundsReply) updates) => super.copyWith((message) => updates(message as RedeemRemovedFundsReply)) as RedeemRemovedFundsReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetSwapPaymentRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentRequest', protoName: 'paymentRequest')
    ..hasRequiredFields = false
  ;

  GetSwapPaymentRequest._() : super();
  factory GetSwapPaymentRequest({
    $core.String? paymentRequest,
  }) {
    final _result = create();
    if (paymentRequest != null) {
      _result.paymentRequest = paymentRequest;
    }
    return _result;
  }
  factory GetSwapPaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSwapPaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSwapPaymentRequest clone() => GetSwapPaymentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSwapPaymentRequest copyWith(void Function(GetSwapPaymentRequest) updates) => super.copyWith((message) => updates(message as GetSwapPaymentRequest)) as GetSwapPaymentRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetSwapPaymentReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentError', protoName: 'paymentError')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fundsExceededLimit')
    ..e<GetSwapPaymentReply_SwapError>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapError', $pb.PbFieldType.OE, defaultOrMaker: GetSwapPaymentReply_SwapError.NO_ERROR, valueOf: GetSwapPaymentReply_SwapError.valueOf, enumValues: GetSwapPaymentReply_SwapError.values)
    ..hasRequiredFields = false
  ;

  GetSwapPaymentReply._() : super();
  factory GetSwapPaymentReply({
    $core.String? paymentError,
    $core.bool? fundsExceededLimit,
    GetSwapPaymentReply_SwapError? swapError,
  }) {
    final _result = create();
    if (paymentError != null) {
      _result.paymentError = paymentError;
    }
    if (fundsExceededLimit != null) {
      _result.fundsExceededLimit = fundsExceededLimit;
    }
    if (swapError != null) {
      _result.swapError = swapError;
    }
    return _result;
  }
  factory GetSwapPaymentReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSwapPaymentReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSwapPaymentReply clone() => GetSwapPaymentReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSwapPaymentReply copyWith(void Function(GetSwapPaymentReply) updates) => super.copyWith((message) => updates(message as GetSwapPaymentReply)) as GetSwapPaymentReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RedeemSwapPaymentRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'preimage', $pb.PbFieldType.OY)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetConf', $pb.PbFieldType.O3)
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'satPerByte')
    ..hasRequiredFields = false
  ;

  RedeemSwapPaymentRequest._() : super();
  factory RedeemSwapPaymentRequest({
    $core.List<$core.int>? preimage,
    $core.int? targetConf,
    $fixnum.Int64? satPerByte,
  }) {
    final _result = create();
    if (preimage != null) {
      _result.preimage = preimage;
    }
    if (targetConf != null) {
      _result.targetConf = targetConf;
    }
    if (satPerByte != null) {
      _result.satPerByte = satPerByte;
    }
    return _result;
  }
  factory RedeemSwapPaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RedeemSwapPaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RedeemSwapPaymentRequest clone() => RedeemSwapPaymentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RedeemSwapPaymentRequest copyWith(void Function(RedeemSwapPaymentRequest) updates) => super.copyWith((message) => updates(message as RedeemSwapPaymentRequest)) as RedeemSwapPaymentRequest; // ignore: deprecated_member_use
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

  @$pb.TagNumber(2)
  $core.int get targetConf => $_getIZ(1);
  @$pb.TagNumber(2)
  set targetConf($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetConf() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetConf() => clearField(2);

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RedeemSwapPaymentReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid')
    ..hasRequiredFields = false
  ;

  RedeemSwapPaymentReply._() : super();
  factory RedeemSwapPaymentReply({
    $core.String? txid,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    return _result;
  }
  factory RedeemSwapPaymentReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RedeemSwapPaymentReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RedeemSwapPaymentReply clone() => RedeemSwapPaymentReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RedeemSwapPaymentReply copyWith(void Function(RedeemSwapPaymentReply) updates) => super.copyWith((message) => updates(message as RedeemSwapPaymentReply)) as RedeemSwapPaymentReply; // ignore: deprecated_member_use
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

class RegisterRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RegisterRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceID', protoName: 'deviceID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lightningID', protoName: 'lightningID')
    ..hasRequiredFields = false
  ;

  RegisterRequest._() : super();
  factory RegisterRequest({
    $core.String? deviceID,
    $core.String? lightningID,
  }) {
    final _result = create();
    if (deviceID != null) {
      _result.deviceID = deviceID;
    }
    if (lightningID != null) {
      _result.lightningID = lightningID;
    }
    return _result;
  }
  factory RegisterRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterRequest clone() => RegisterRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterRequest copyWith(void Function(RegisterRequest) updates) => super.copyWith((message) => updates(message as RegisterRequest)) as RegisterRequest; // ignore: deprecated_member_use
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

class RegisterReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RegisterReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'breezID', protoName: 'breezID')
    ..hasRequiredFields = false
  ;

  RegisterReply._() : super();
  factory RegisterReply({
    $core.String? breezID,
  }) {
    final _result = create();
    if (breezID != null) {
      _result.breezID = breezID;
    }
    return _result;
  }
  factory RegisterReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterReply clone() => RegisterReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterReply copyWith(void Function(RegisterReply) updates) => super.copyWith((message) => updates(message as RegisterReply)) as RegisterReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PaymentRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'breezID', protoName: 'breezID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'invoice')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'payee')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..hasRequiredFields = false
  ;

  PaymentRequest._() : super();
  factory PaymentRequest({
    $core.String? breezID,
    $core.String? invoice,
    $core.String? payee,
    $fixnum.Int64? amount,
  }) {
    final _result = create();
    if (breezID != null) {
      _result.breezID = breezID;
    }
    if (invoice != null) {
      _result.invoice = invoice;
    }
    if (payee != null) {
      _result.payee = payee;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    return _result;
  }
  factory PaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PaymentRequest clone() => PaymentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PaymentRequest copyWith(void Function(PaymentRequest) updates) => super.copyWith((message) => updates(message as PaymentRequest)) as PaymentRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'InvoiceReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Error', protoName: 'Error')
    ..hasRequiredFields = false
  ;

  InvoiceReply._() : super();
  factory InvoiceReply({
    $core.String? error,
  }) {
    final _result = create();
    if (error != null) {
      _result.error = error;
    }
    return _result;
  }
  factory InvoiceReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InvoiceReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InvoiceReply clone() => InvoiceReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InvoiceReply copyWith(void Function(InvoiceReply) updates) => super.copyWith((message) => updates(message as InvoiceReply)) as InvoiceReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UploadFileRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'content', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  UploadFileRequest._() : super();
  factory UploadFileRequest({
    $core.List<$core.int>? content,
  }) {
    final _result = create();
    if (content != null) {
      _result.content = content;
    }
    return _result;
  }
  factory UploadFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadFileRequest clone() => UploadFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadFileRequest copyWith(void Function(UploadFileRequest) updates) => super.copyWith((message) => updates(message as UploadFileRequest)) as UploadFileRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UploadFileReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'url')
    ..hasRequiredFields = false
  ;

  UploadFileReply._() : super();
  factory UploadFileReply({
    $core.String? url,
  }) {
    final _result = create();
    if (url != null) {
      _result.url = url;
    }
    return _result;
  }
  factory UploadFileReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadFileReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadFileReply clone() => UploadFileReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadFileReply copyWith(void Function(UploadFileReply) updates) => super.copyWith((message) => updates(message as UploadFileReply)) as UploadFileReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PingRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  PingRequest._() : super();
  factory PingRequest() => create();
  factory PingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PingRequest clone() => PingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PingRequest copyWith(void Function(PingRequest) updates) => super.copyWith((message) => updates(message as PingRequest)) as PingRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PingReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..hasRequiredFields = false
  ;

  PingReply._() : super();
  factory PingReply({
    $core.String? version,
  }) {
    final _result = create();
    if (version != null) {
      _result.version = version;
    }
    return _result;
  }
  factory PingReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PingReply clone() => PingReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PingReply copyWith(void Function(PingReply) updates) => super.copyWith((message) => updates(message as PingReply)) as PingReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OrderRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'FullName', protoName: 'FullName')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Address', protoName: 'Address')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'City', protoName: 'City')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'State', protoName: 'State')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Zip', protoName: 'Zip')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Country', protoName: 'Country')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Email', protoName: 'Email')
    ..hasRequiredFields = false
  ;

  OrderRequest._() : super();
  factory OrderRequest({
    $core.String? fullName,
    $core.String? address,
    $core.String? city,
    $core.String? state,
    $core.String? zip,
    $core.String? country,
    $core.String? email,
  }) {
    final _result = create();
    if (fullName != null) {
      _result.fullName = fullName;
    }
    if (address != null) {
      _result.address = address;
    }
    if (city != null) {
      _result.city = city;
    }
    if (state != null) {
      _result.state = state;
    }
    if (zip != null) {
      _result.zip = zip;
    }
    if (country != null) {
      _result.country = country;
    }
    if (email != null) {
      _result.email = email;
    }
    return _result;
  }
  factory OrderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OrderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OrderRequest clone() => OrderRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OrderRequest copyWith(void Function(OrderRequest) updates) => super.copyWith((message) => updates(message as OrderRequest)) as OrderRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OrderReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  OrderReply._() : super();
  factory OrderReply() => create();
  factory OrderReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OrderReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OrderReply clone() => OrderReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OrderReply copyWith(void Function(OrderReply) updates) => super.copyWith((message) => updates(message as OrderReply)) as OrderReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SetNodeInfoRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey', $pb.PbFieldType.OY)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp')
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  SetNodeInfoRequest._() : super();
  factory SetNodeInfoRequest({
    $core.List<$core.int>? pubkey,
    $core.String? key,
    $core.List<$core.int>? value,
    $fixnum.Int64? timestamp,
    $core.List<$core.int>? signature,
  }) {
    final _result = create();
    if (pubkey != null) {
      _result.pubkey = pubkey;
    }
    if (key != null) {
      _result.key = key;
    }
    if (value != null) {
      _result.value = value;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (signature != null) {
      _result.signature = signature;
    }
    return _result;
  }
  factory SetNodeInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SetNodeInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SetNodeInfoRequest clone() => SetNodeInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SetNodeInfoRequest copyWith(void Function(SetNodeInfoRequest) updates) => super.copyWith((message) => updates(message as SetNodeInfoRequest)) as SetNodeInfoRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SetNodeInfoResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  SetNodeInfoResponse._() : super();
  factory SetNodeInfoResponse() => create();
  factory SetNodeInfoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SetNodeInfoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SetNodeInfoResponse clone() => SetNodeInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SetNodeInfoResponse copyWith(void Function(SetNodeInfoResponse) updates) => super.copyWith((message) => updates(message as SetNodeInfoResponse)) as SetNodeInfoResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetNodeInfoRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey', $pb.PbFieldType.OY)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..hasRequiredFields = false
  ;

  GetNodeInfoRequest._() : super();
  factory GetNodeInfoRequest({
    $core.List<$core.int>? pubkey,
    $core.String? key,
  }) {
    final _result = create();
    if (pubkey != null) {
      _result.pubkey = pubkey;
    }
    if (key != null) {
      _result.key = key;
    }
    return _result;
  }
  factory GetNodeInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetNodeInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetNodeInfoRequest clone() => GetNodeInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetNodeInfoRequest copyWith(void Function(GetNodeInfoRequest) updates) => super.copyWith((message) => updates(message as GetNodeInfoRequest)) as GetNodeInfoRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetNodeInfoResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  GetNodeInfoResponse._() : super();
  factory GetNodeInfoResponse({
    $core.List<$core.int>? value,
    $fixnum.Int64? timestamp,
    $core.List<$core.int>? signature,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (signature != null) {
      _result.signature = signature;
    }
    return _result;
  }
  factory GetNodeInfoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetNodeInfoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetNodeInfoResponse clone() => GetNodeInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetNodeInfoResponse copyWith(void Function(GetNodeInfoResponse) updates) => super.copyWith((message) => updates(message as GetNodeInfoResponse)) as GetNodeInfoResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinCTPSessionRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..e<JoinCTPSessionRequest_PartyType>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'partyType', $pb.PbFieldType.OE, protoName: 'partyType', defaultOrMaker: JoinCTPSessionRequest_PartyType.PAYER, valueOf: JoinCTPSessionRequest_PartyType.valueOf, enumValues: JoinCTPSessionRequest_PartyType.values)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'partyName', protoName: 'partyName')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notificationToken', protoName: 'notificationToken')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionID', protoName: 'sessionID')
    ..hasRequiredFields = false
  ;

  JoinCTPSessionRequest._() : super();
  factory JoinCTPSessionRequest({
    JoinCTPSessionRequest_PartyType? partyType,
    $core.String? partyName,
    $core.String? notificationToken,
    $core.String? sessionID,
  }) {
    final _result = create();
    if (partyType != null) {
      _result.partyType = partyType;
    }
    if (partyName != null) {
      _result.partyName = partyName;
    }
    if (notificationToken != null) {
      _result.notificationToken = notificationToken;
    }
    if (sessionID != null) {
      _result.sessionID = sessionID;
    }
    return _result;
  }
  factory JoinCTPSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinCTPSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinCTPSessionRequest clone() => JoinCTPSessionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinCTPSessionRequest copyWith(void Function(JoinCTPSessionRequest) updates) => super.copyWith((message) => updates(message as JoinCTPSessionRequest)) as JoinCTPSessionRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'JoinCTPSessionResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionID', protoName: 'sessionID')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expiry')
    ..hasRequiredFields = false
  ;

  JoinCTPSessionResponse._() : super();
  factory JoinCTPSessionResponse({
    $core.String? sessionID,
    $fixnum.Int64? expiry,
  }) {
    final _result = create();
    if (sessionID != null) {
      _result.sessionID = sessionID;
    }
    if (expiry != null) {
      _result.expiry = expiry;
    }
    return _result;
  }
  factory JoinCTPSessionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinCTPSessionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinCTPSessionResponse clone() => JoinCTPSessionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinCTPSessionResponse copyWith(void Function(JoinCTPSessionResponse) updates) => super.copyWith((message) => updates(message as JoinCTPSessionResponse)) as JoinCTPSessionResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TerminateCTPSessionRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionID', protoName: 'sessionID')
    ..hasRequiredFields = false
  ;

  TerminateCTPSessionRequest._() : super();
  factory TerminateCTPSessionRequest({
    $core.String? sessionID,
  }) {
    final _result = create();
    if (sessionID != null) {
      _result.sessionID = sessionID;
    }
    return _result;
  }
  factory TerminateCTPSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TerminateCTPSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TerminateCTPSessionRequest clone() => TerminateCTPSessionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TerminateCTPSessionRequest copyWith(void Function(TerminateCTPSessionRequest) updates) => super.copyWith((message) => updates(message as TerminateCTPSessionRequest)) as TerminateCTPSessionRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TerminateCTPSessionResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  TerminateCTPSessionResponse._() : super();
  factory TerminateCTPSessionResponse() => create();
  factory TerminateCTPSessionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TerminateCTPSessionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TerminateCTPSessionResponse clone() => TerminateCTPSessionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TerminateCTPSessionResponse copyWith(void Function(TerminateCTPSessionResponse) updates) => super.copyWith((message) => updates(message as TerminateCTPSessionResponse)) as TerminateCTPSessionResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RegisterTransactionConfirmationRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txID', protoName: 'txID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notificationToken', protoName: 'notificationToken')
    ..e<RegisterTransactionConfirmationRequest_NotificationType>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notificationType', $pb.PbFieldType.OE, protoName: 'notificationType', defaultOrMaker: RegisterTransactionConfirmationRequest_NotificationType.READY_RECEIVE_PAYMENT, valueOf: RegisterTransactionConfirmationRequest_NotificationType.valueOf, enumValues: RegisterTransactionConfirmationRequest_NotificationType.values)
    ..hasRequiredFields = false
  ;

  RegisterTransactionConfirmationRequest._() : super();
  factory RegisterTransactionConfirmationRequest({
    $core.String? txID,
    $core.String? notificationToken,
    RegisterTransactionConfirmationRequest_NotificationType? notificationType,
  }) {
    final _result = create();
    if (txID != null) {
      _result.txID = txID;
    }
    if (notificationToken != null) {
      _result.notificationToken = notificationToken;
    }
    if (notificationType != null) {
      _result.notificationType = notificationType;
    }
    return _result;
  }
  factory RegisterTransactionConfirmationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterTransactionConfirmationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterTransactionConfirmationRequest clone() => RegisterTransactionConfirmationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterTransactionConfirmationRequest copyWith(void Function(RegisterTransactionConfirmationRequest) updates) => super.copyWith((message) => updates(message as RegisterTransactionConfirmationRequest)) as RegisterTransactionConfirmationRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RegisterTransactionConfirmationResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  RegisterTransactionConfirmationResponse._() : super();
  factory RegisterTransactionConfirmationResponse() => create();
  factory RegisterTransactionConfirmationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterTransactionConfirmationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterTransactionConfirmationResponse clone() => RegisterTransactionConfirmationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterTransactionConfirmationResponse copyWith(void Function(RegisterTransactionConfirmationResponse) updates) => super.copyWith((message) => updates(message as RegisterTransactionConfirmationResponse)) as RegisterTransactionConfirmationResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RegisterPeriodicSyncRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notificationToken', protoName: 'notificationToken')
    ..hasRequiredFields = false
  ;

  RegisterPeriodicSyncRequest._() : super();
  factory RegisterPeriodicSyncRequest({
    $core.String? notificationToken,
  }) {
    final _result = create();
    if (notificationToken != null) {
      _result.notificationToken = notificationToken;
    }
    return _result;
  }
  factory RegisterPeriodicSyncRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPeriodicSyncRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterPeriodicSyncRequest clone() => RegisterPeriodicSyncRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterPeriodicSyncRequest copyWith(void Function(RegisterPeriodicSyncRequest) updates) => super.copyWith((message) => updates(message as RegisterPeriodicSyncRequest)) as RegisterPeriodicSyncRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RegisterPeriodicSyncResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  RegisterPeriodicSyncResponse._() : super();
  factory RegisterPeriodicSyncResponse() => create();
  factory RegisterPeriodicSyncResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPeriodicSyncResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterPeriodicSyncResponse clone() => RegisterPeriodicSyncResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterPeriodicSyncResponse copyWith(void Function(RegisterPeriodicSyncResponse) updates) => super.copyWith((message) => updates(message as RegisterPeriodicSyncResponse)) as RegisterPeriodicSyncResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BoltzReverseSwapLockupTx', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boltzId')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timeoutBlockHeight', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  BoltzReverseSwapLockupTx._() : super();
  factory BoltzReverseSwapLockupTx({
    $core.String? boltzId,
    $core.int? timeoutBlockHeight,
  }) {
    final _result = create();
    if (boltzId != null) {
      _result.boltzId = boltzId;
    }
    if (timeoutBlockHeight != null) {
      _result.timeoutBlockHeight = timeoutBlockHeight;
    }
    return _result;
  }
  factory BoltzReverseSwapLockupTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BoltzReverseSwapLockupTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BoltzReverseSwapLockupTx clone() => BoltzReverseSwapLockupTx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BoltzReverseSwapLockupTx copyWith(void Function(BoltzReverseSwapLockupTx) updates) => super.copyWith((message) => updates(message as BoltzReverseSwapLockupTx)) as BoltzReverseSwapLockupTx; // ignore: deprecated_member_use
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
  static const $core.Map<$core.int, PushTxNotificationRequest_Info> _PushTxNotificationRequest_InfoByTag = {
    7 : PushTxNotificationRequest_Info.boltzReverseSwapLockupTxInfo,
    0 : PushTxNotificationRequest_Info.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PushTxNotificationRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..oo(0, [7])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'body')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txHash', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'script', $pb.PbFieldType.OY)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockHeightHint', $pb.PbFieldType.OU3)
    ..aOM<BoltzReverseSwapLockupTx>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boltzReverseSwapLockupTxInfo', subBuilder: BoltzReverseSwapLockupTx.create)
    ..hasRequiredFields = false
  ;

  PushTxNotificationRequest._() : super();
  factory PushTxNotificationRequest({
    $core.String? deviceId,
    $core.String? title,
    $core.String? body,
    $core.List<$core.int>? txHash,
    $core.List<$core.int>? script,
    $core.int? blockHeightHint,
    BoltzReverseSwapLockupTx? boltzReverseSwapLockupTxInfo,
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
    if (txHash != null) {
      _result.txHash = txHash;
    }
    if (script != null) {
      _result.script = script;
    }
    if (blockHeightHint != null) {
      _result.blockHeightHint = blockHeightHint;
    }
    if (boltzReverseSwapLockupTxInfo != null) {
      _result.boltzReverseSwapLockupTxInfo = boltzReverseSwapLockupTxInfo;
    }
    return _result;
  }
  factory PushTxNotificationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PushTxNotificationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PushTxNotificationRequest clone() => PushTxNotificationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PushTxNotificationRequest copyWith(void Function(PushTxNotificationRequest) updates) => super.copyWith((message) => updates(message as PushTxNotificationRequest)) as PushTxNotificationRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PushTxNotificationResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  PushTxNotificationResponse._() : super();
  factory PushTxNotificationResponse() => create();
  factory PushTxNotificationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PushTxNotificationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PushTxNotificationResponse clone() => PushTxNotificationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PushTxNotificationResponse copyWith(void Function(PushTxNotificationResponse) updates) => super.copyWith((message) => updates(message as PushTxNotificationResponse)) as PushTxNotificationResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BreezAppVersionsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  BreezAppVersionsRequest._() : super();
  factory BreezAppVersionsRequest() => create();
  factory BreezAppVersionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BreezAppVersionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BreezAppVersionsRequest clone() => BreezAppVersionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BreezAppVersionsRequest copyWith(void Function(BreezAppVersionsRequest) updates) => super.copyWith((message) => updates(message as BreezAppVersionsRequest)) as BreezAppVersionsRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BreezAppVersionsReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..hasRequiredFields = false
  ;

  BreezAppVersionsReply._() : super();
  factory BreezAppVersionsReply({
    $core.Iterable<$core.String>? version,
  }) {
    final _result = create();
    if (version != null) {
      _result.version.addAll(version);
    }
    return _result;
  }
  factory BreezAppVersionsReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BreezAppVersionsReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BreezAppVersionsReply clone() => BreezAppVersionsReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BreezAppVersionsReply copyWith(void Function(BreezAppVersionsReply) updates) => super.copyWith((message) => updates(message as BreezAppVersionsReply)) as BreezAppVersionsReply; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetReverseRoutingNodeRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  GetReverseRoutingNodeRequest._() : super();
  factory GetReverseRoutingNodeRequest() => create();
  factory GetReverseRoutingNodeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetReverseRoutingNodeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetReverseRoutingNodeRequest clone() => GetReverseRoutingNodeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetReverseRoutingNodeRequest copyWith(void Function(GetReverseRoutingNodeRequest) updates) => super.copyWith((message) => updates(message as GetReverseRoutingNodeRequest)) as GetReverseRoutingNodeRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetReverseRoutingNodeReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeId', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  GetReverseRoutingNodeReply._() : super();
  factory GetReverseRoutingNodeReply({
    $core.List<$core.int>? nodeId,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    return _result;
  }
  factory GetReverseRoutingNodeReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetReverseRoutingNodeReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetReverseRoutingNodeReply clone() => GetReverseRoutingNodeReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetReverseRoutingNodeReply copyWith(void Function(GetReverseRoutingNodeReply) updates) => super.copyWith((message) => updates(message as GetReverseRoutingNodeReply)) as GetReverseRoutingNodeReply; // ignore: deprecated_member_use
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


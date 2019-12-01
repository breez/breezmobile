///
//  Generated code. Do not modify.
//  source: breez.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'breez.pbenum.dart';

export 'breez.pbenum.dart';

class RatesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RatesRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  RatesRequest._() : super();
  factory RatesRequest() => create();
  factory RatesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RatesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RatesRequest clone() => RatesRequest()..mergeFromMessage(this);
  RatesRequest copyWith(void Function(RatesRequest) updates) => super.copyWith((message) => updates(message as RatesRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RatesRequest create() => RatesRequest._();
  RatesRequest createEmptyInstance() => create();
  static $pb.PbList<RatesRequest> createRepeated() => $pb.PbList<RatesRequest>();
  @$core.pragma('dart2js:noInline')
  static RatesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RatesRequest>(create);
  static RatesRequest _defaultInstance;
}

class Rate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Rate', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'coin')
    ..a<$core.double>(2, 'value', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  Rate._() : super();
  factory Rate() => create();
  factory Rate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Rate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Rate clone() => Rate()..mergeFromMessage(this);
  Rate copyWith(void Function(Rate) updates) => super.copyWith((message) => updates(message as Rate));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Rate create() => Rate._();
  Rate createEmptyInstance() => create();
  static $pb.PbList<Rate> createRepeated() => $pb.PbList<Rate>();
  @$core.pragma('dart2js:noInline')
  static Rate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Rate>(create);
  static Rate _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RatesReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..pc<Rate>(1, 'rates', $pb.PbFieldType.PM, subBuilder: Rate.create)
    ..hasRequiredFields = false
  ;

  RatesReply._() : super();
  factory RatesReply() => create();
  factory RatesReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RatesReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RatesReply clone() => RatesReply()..mergeFromMessage(this);
  RatesReply copyWith(void Function(RatesReply) updates) => super.copyWith((message) => updates(message as RatesReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RatesReply create() => RatesReply._();
  RatesReply createEmptyInstance() => create();
  static $pb.PbList<RatesReply> createRepeated() => $pb.PbList<RatesReply>();
  @$core.pragma('dart2js:noInline')
  static RatesReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RatesReply>(create);
  static RatesReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Rate> get rates => $_getList(0);
}

class LSPListRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LSPListRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(2, 'pubkey')
    ..hasRequiredFields = false
  ;

  LSPListRequest._() : super();
  factory LSPListRequest() => create();
  factory LSPListRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LSPListRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  LSPListRequest clone() => LSPListRequest()..mergeFromMessage(this);
  LSPListRequest copyWith(void Function(LSPListRequest) updates) => super.copyWith((message) => updates(message as LSPListRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LSPListRequest create() => LSPListRequest._();
  LSPListRequest createEmptyInstance() => create();
  static $pb.PbList<LSPListRequest> createRepeated() => $pb.PbList<LSPListRequest>();
  @$core.pragma('dart2js:noInline')
  static LSPListRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LSPListRequest>(create);
  static LSPListRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LSPInformation', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'name')
    ..aOS(2, 'widget_url')
    ..aOS(3, 'pubkey')
    ..aOS(4, 'host')
    ..aInt64(5, 'channel_capacity')
    ..a<$core.int>(6, 'target_conf', $pb.PbFieldType.O3)
    ..aInt64(7, 'base_fee_msat')
    ..a<$core.double>(8, 'fee_rate', $pb.PbFieldType.OD)
    ..a<$core.int>(9, 'time_lock_delta', $pb.PbFieldType.OU3)
    ..aInt64(10, 'min_htlc_msat')
    ..hasRequiredFields = false
  ;

  LSPInformation._() : super();
  factory LSPInformation() => create();
  factory LSPInformation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LSPInformation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  LSPInformation clone() => LSPInformation()..mergeFromMessage(this);
  LSPInformation copyWith(void Function(LSPInformation) updates) => super.copyWith((message) => updates(message as LSPInformation));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LSPInformation create() => LSPInformation._();
  LSPInformation createEmptyInstance() => create();
  static $pb.PbList<LSPInformation> createRepeated() => $pb.PbList<LSPInformation>();
  @$core.pragma('dart2js:noInline')
  static LSPInformation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LSPInformation>(create);
  static LSPInformation _defaultInstance;

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
}

class LSPListReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LSPListReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..m<$core.String, LSPInformation>(1, 'lsps', entryClassName: 'LSPListReply.LspsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: LSPInformation.create, packageName: const $pb.PackageName('breez'))
    ..hasRequiredFields = false
  ;

  LSPListReply._() : super();
  factory LSPListReply() => create();
  factory LSPListReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LSPListReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  LSPListReply clone() => LSPListReply()..mergeFromMessage(this);
  LSPListReply copyWith(void Function(LSPListReply) updates) => super.copyWith((message) => updates(message as LSPListReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LSPListReply create() => LSPListReply._();
  LSPListReply createEmptyInstance() => create();
  static $pb.PbList<LSPListReply> createRepeated() => $pb.PbList<LSPListReply>();
  @$core.pragma('dart2js:noInline')
  static LSPListReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LSPListReply>(create);
  static LSPListReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, LSPInformation> get lsps => $_getMap(0);
}

class OpenLSPChannelRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OpenLSPChannelRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'lspId')
    ..aOS(2, 'pubkey')
    ..hasRequiredFields = false
  ;

  OpenLSPChannelRequest._() : super();
  factory OpenLSPChannelRequest() => create();
  factory OpenLSPChannelRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenLSPChannelRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  OpenLSPChannelRequest clone() => OpenLSPChannelRequest()..mergeFromMessage(this);
  OpenLSPChannelRequest copyWith(void Function(OpenLSPChannelRequest) updates) => super.copyWith((message) => updates(message as OpenLSPChannelRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpenLSPChannelRequest create() => OpenLSPChannelRequest._();
  OpenLSPChannelRequest createEmptyInstance() => create();
  static $pb.PbList<OpenLSPChannelRequest> createRepeated() => $pb.PbList<OpenLSPChannelRequest>();
  @$core.pragma('dart2js:noInline')
  static OpenLSPChannelRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenLSPChannelRequest>(create);
  static OpenLSPChannelRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OpenLSPChannelReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  OpenLSPChannelReply._() : super();
  factory OpenLSPChannelReply() => create();
  factory OpenLSPChannelReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenLSPChannelReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  OpenLSPChannelReply clone() => OpenLSPChannelReply()..mergeFromMessage(this);
  OpenLSPChannelReply copyWith(void Function(OpenLSPChannelReply) updates) => super.copyWith((message) => updates(message as OpenLSPChannelReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpenLSPChannelReply create() => OpenLSPChannelReply._();
  OpenLSPChannelReply createEmptyInstance() => create();
  static $pb.PbList<OpenLSPChannelReply> createRepeated() => $pb.PbList<OpenLSPChannelReply>();
  @$core.pragma('dart2js:noInline')
  static OpenLSPChannelReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenLSPChannelReply>(create);
  static OpenLSPChannelReply _defaultInstance;
}

class OpenChannelRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OpenChannelRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'pubKey', protoName: 'pubKey')
    ..aOS(2, 'notificationToken', protoName: 'notificationToken')
    ..hasRequiredFields = false
  ;

  OpenChannelRequest._() : super();
  factory OpenChannelRequest() => create();
  factory OpenChannelRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenChannelRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  OpenChannelRequest clone() => OpenChannelRequest()..mergeFromMessage(this);
  OpenChannelRequest copyWith(void Function(OpenChannelRequest) updates) => super.copyWith((message) => updates(message as OpenChannelRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpenChannelRequest create() => OpenChannelRequest._();
  OpenChannelRequest createEmptyInstance() => create();
  static $pb.PbList<OpenChannelRequest> createRepeated() => $pb.PbList<OpenChannelRequest>();
  @$core.pragma('dart2js:noInline')
  static OpenChannelRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenChannelRequest>(create);
  static OpenChannelRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OpenChannelReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  OpenChannelReply._() : super();
  factory OpenChannelReply() => create();
  factory OpenChannelReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenChannelReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  OpenChannelReply clone() => OpenChannelReply()..mergeFromMessage(this);
  OpenChannelReply copyWith(void Function(OpenChannelReply) updates) => super.copyWith((message) => updates(message as OpenChannelReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpenChannelReply create() => OpenChannelReply._();
  OpenChannelReply createEmptyInstance() => create();
  static $pb.PbList<OpenChannelReply> createRepeated() => $pb.PbList<OpenChannelReply>();
  @$core.pragma('dart2js:noInline')
  static OpenChannelReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenChannelReply>(create);
  static OpenChannelReply _defaultInstance;
}

class Captcha extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Captcha', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'id')
    ..a<$core.List<$core.int>>(2, 'image', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  Captcha._() : super();
  factory Captcha() => create();
  factory Captcha.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Captcha.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Captcha clone() => Captcha()..mergeFromMessage(this);
  Captcha copyWith(void Function(Captcha) updates) => super.copyWith((message) => updates(message as Captcha));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Captcha create() => Captcha._();
  Captcha createEmptyInstance() => create();
  static $pb.PbList<Captcha> createRepeated() => $pb.PbList<Captcha>();
  @$core.pragma('dart2js:noInline')
  static Captcha getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Captcha>(create);
  static Captcha _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UpdateChannelPolicyRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'pubKey', protoName: 'pubKey')
    ..hasRequiredFields = false
  ;

  UpdateChannelPolicyRequest._() : super();
  factory UpdateChannelPolicyRequest() => create();
  factory UpdateChannelPolicyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateChannelPolicyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  UpdateChannelPolicyRequest clone() => UpdateChannelPolicyRequest()..mergeFromMessage(this);
  UpdateChannelPolicyRequest copyWith(void Function(UpdateChannelPolicyRequest) updates) => super.copyWith((message) => updates(message as UpdateChannelPolicyRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateChannelPolicyRequest create() => UpdateChannelPolicyRequest._();
  UpdateChannelPolicyRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateChannelPolicyRequest> createRepeated() => $pb.PbList<UpdateChannelPolicyRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateChannelPolicyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateChannelPolicyRequest>(create);
  static UpdateChannelPolicyRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UpdateChannelPolicyReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  UpdateChannelPolicyReply._() : super();
  factory UpdateChannelPolicyReply() => create();
  factory UpdateChannelPolicyReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateChannelPolicyReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  UpdateChannelPolicyReply clone() => UpdateChannelPolicyReply()..mergeFromMessage(this);
  UpdateChannelPolicyReply copyWith(void Function(UpdateChannelPolicyReply) updates) => super.copyWith((message) => updates(message as UpdateChannelPolicyReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateChannelPolicyReply create() => UpdateChannelPolicyReply._();
  UpdateChannelPolicyReply createEmptyInstance() => create();
  static $pb.PbList<UpdateChannelPolicyReply> createRepeated() => $pb.PbList<UpdateChannelPolicyReply>();
  @$core.pragma('dart2js:noInline')
  static UpdateChannelPolicyReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateChannelPolicyReply>(create);
  static UpdateChannelPolicyReply _defaultInstance;
}

class AddFundInitRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AddFundInitRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'nodeID', protoName: 'nodeID')
    ..aOS(2, 'notificationToken', protoName: 'notificationToken')
    ..a<$core.List<$core.int>>(3, 'pubkey', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(4, 'hash', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  AddFundInitRequest._() : super();
  factory AddFundInitRequest() => create();
  factory AddFundInitRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundInitRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AddFundInitRequest clone() => AddFundInitRequest()..mergeFromMessage(this);
  AddFundInitRequest copyWith(void Function(AddFundInitRequest) updates) => super.copyWith((message) => updates(message as AddFundInitRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddFundInitRequest create() => AddFundInitRequest._();
  AddFundInitRequest createEmptyInstance() => create();
  static $pb.PbList<AddFundInitRequest> createRepeated() => $pb.PbList<AddFundInitRequest>();
  @$core.pragma('dart2js:noInline')
  static AddFundInitRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddFundInitRequest>(create);
  static AddFundInitRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AddFundInitReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'address')
    ..a<$core.List<$core.int>>(2, 'pubkey', $pb.PbFieldType.OY)
    ..aInt64(3, 'lockHeight', protoName: 'lockHeight')
    ..aInt64(4, 'maxAllowedDeposit', protoName: 'maxAllowedDeposit')
    ..aOS(5, 'errorMessage', protoName: 'errorMessage')
    ..aInt64(6, 'requiredReserve', protoName: 'requiredReserve')
    ..hasRequiredFields = false
  ;

  AddFundInitReply._() : super();
  factory AddFundInitReply() => create();
  factory AddFundInitReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundInitReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AddFundInitReply clone() => AddFundInitReply()..mergeFromMessage(this);
  AddFundInitReply copyWith(void Function(AddFundInitReply) updates) => super.copyWith((message) => updates(message as AddFundInitReply));
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
}

class AddFundStatusRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AddFundStatusRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..pPS(1, 'addresses')
    ..aOS(2, 'notificationToken', protoName: 'notificationToken')
    ..hasRequiredFields = false
  ;

  AddFundStatusRequest._() : super();
  factory AddFundStatusRequest() => create();
  factory AddFundStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AddFundStatusRequest clone() => AddFundStatusRequest()..mergeFromMessage(this);
  AddFundStatusRequest copyWith(void Function(AddFundStatusRequest) updates) => super.copyWith((message) => updates(message as AddFundStatusRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddFundStatusRequest create() => AddFundStatusRequest._();
  AddFundStatusRequest createEmptyInstance() => create();
  static $pb.PbList<AddFundStatusRequest> createRepeated() => $pb.PbList<AddFundStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static AddFundStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddFundStatusRequest>(create);
  static AddFundStatusRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AddFundStatusReply.AddressStatus', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'tx')
    ..aInt64(2, 'amount')
    ..aOB(3, 'confirmed')
    ..aOS(4, 'blockHash', protoName: 'blockHash')
    ..hasRequiredFields = false
  ;

  AddFundStatusReply_AddressStatus._() : super();
  factory AddFundStatusReply_AddressStatus() => create();
  factory AddFundStatusReply_AddressStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundStatusReply_AddressStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AddFundStatusReply_AddressStatus clone() => AddFundStatusReply_AddressStatus()..mergeFromMessage(this);
  AddFundStatusReply_AddressStatus copyWith(void Function(AddFundStatusReply_AddressStatus) updates) => super.copyWith((message) => updates(message as AddFundStatusReply_AddressStatus));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddFundStatusReply_AddressStatus create() => AddFundStatusReply_AddressStatus._();
  AddFundStatusReply_AddressStatus createEmptyInstance() => create();
  static $pb.PbList<AddFundStatusReply_AddressStatus> createRepeated() => $pb.PbList<AddFundStatusReply_AddressStatus>();
  @$core.pragma('dart2js:noInline')
  static AddFundStatusReply_AddressStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddFundStatusReply_AddressStatus>(create);
  static AddFundStatusReply_AddressStatus _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AddFundStatusReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..m<$core.String, AddFundStatusReply_AddressStatus>(1, 'statuses', entryClassName: 'AddFundStatusReply.StatusesEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: AddFundStatusReply_AddressStatus.create, packageName: const $pb.PackageName('breez'))
    ..hasRequiredFields = false
  ;

  AddFundStatusReply._() : super();
  factory AddFundStatusReply() => create();
  factory AddFundStatusReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddFundStatusReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AddFundStatusReply clone() => AddFundStatusReply()..mergeFromMessage(this);
  AddFundStatusReply copyWith(void Function(AddFundStatusReply) updates) => super.copyWith((message) => updates(message as AddFundStatusReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddFundStatusReply create() => AddFundStatusReply._();
  AddFundStatusReply createEmptyInstance() => create();
  static $pb.PbList<AddFundStatusReply> createRepeated() => $pb.PbList<AddFundStatusReply>();
  @$core.pragma('dart2js:noInline')
  static AddFundStatusReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddFundStatusReply>(create);
  static AddFundStatusReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, AddFundStatusReply_AddressStatus> get statuses => $_getMap(0);
}

class RemoveFundRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RemoveFundRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'address')
    ..aInt64(2, 'amount')
    ..hasRequiredFields = false
  ;

  RemoveFundRequest._() : super();
  factory RemoveFundRequest() => create();
  factory RemoveFundRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveFundRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RemoveFundRequest clone() => RemoveFundRequest()..mergeFromMessage(this);
  RemoveFundRequest copyWith(void Function(RemoveFundRequest) updates) => super.copyWith((message) => updates(message as RemoveFundRequest));
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RemoveFundReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'paymentRequest', protoName: 'paymentRequest')
    ..aOS(2, 'errorMessage', protoName: 'errorMessage')
    ..hasRequiredFields = false
  ;

  RemoveFundReply._() : super();
  factory RemoveFundReply() => create();
  factory RemoveFundReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveFundReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RemoveFundReply clone() => RemoveFundReply()..mergeFromMessage(this);
  RemoveFundReply copyWith(void Function(RemoveFundReply) updates) => super.copyWith((message) => updates(message as RemoveFundReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemoveFundReply create() => RemoveFundReply._();
  RemoveFundReply createEmptyInstance() => create();
  static $pb.PbList<RemoveFundReply> createRepeated() => $pb.PbList<RemoveFundReply>();
  @$core.pragma('dart2js:noInline')
  static RemoveFundReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveFundReply>(create);
  static RemoveFundReply _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RedeemRemovedFundsRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'paymenthash')
    ..hasRequiredFields = false
  ;

  RedeemRemovedFundsRequest._() : super();
  factory RedeemRemovedFundsRequest() => create();
  factory RedeemRemovedFundsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RedeemRemovedFundsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RedeemRemovedFundsRequest clone() => RedeemRemovedFundsRequest()..mergeFromMessage(this);
  RedeemRemovedFundsRequest copyWith(void Function(RedeemRemovedFundsRequest) updates) => super.copyWith((message) => updates(message as RedeemRemovedFundsRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RedeemRemovedFundsRequest create() => RedeemRemovedFundsRequest._();
  RedeemRemovedFundsRequest createEmptyInstance() => create();
  static $pb.PbList<RedeemRemovedFundsRequest> createRepeated() => $pb.PbList<RedeemRemovedFundsRequest>();
  @$core.pragma('dart2js:noInline')
  static RedeemRemovedFundsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RedeemRemovedFundsRequest>(create);
  static RedeemRemovedFundsRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RedeemRemovedFundsReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'txid')
    ..hasRequiredFields = false
  ;

  RedeemRemovedFundsReply._() : super();
  factory RedeemRemovedFundsReply() => create();
  factory RedeemRemovedFundsReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RedeemRemovedFundsReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RedeemRemovedFundsReply clone() => RedeemRemovedFundsReply()..mergeFromMessage(this);
  RedeemRemovedFundsReply copyWith(void Function(RedeemRemovedFundsReply) updates) => super.copyWith((message) => updates(message as RedeemRemovedFundsReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RedeemRemovedFundsReply create() => RedeemRemovedFundsReply._();
  RedeemRemovedFundsReply createEmptyInstance() => create();
  static $pb.PbList<RedeemRemovedFundsReply> createRepeated() => $pb.PbList<RedeemRemovedFundsReply>();
  @$core.pragma('dart2js:noInline')
  static RedeemRemovedFundsReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RedeemRemovedFundsReply>(create);
  static RedeemRemovedFundsReply _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetSwapPaymentRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'paymentRequest', protoName: 'paymentRequest')
    ..hasRequiredFields = false
  ;

  GetSwapPaymentRequest._() : super();
  factory GetSwapPaymentRequest() => create();
  factory GetSwapPaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSwapPaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GetSwapPaymentRequest clone() => GetSwapPaymentRequest()..mergeFromMessage(this);
  GetSwapPaymentRequest copyWith(void Function(GetSwapPaymentRequest) updates) => super.copyWith((message) => updates(message as GetSwapPaymentRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetSwapPaymentRequest create() => GetSwapPaymentRequest._();
  GetSwapPaymentRequest createEmptyInstance() => create();
  static $pb.PbList<GetSwapPaymentRequest> createRepeated() => $pb.PbList<GetSwapPaymentRequest>();
  @$core.pragma('dart2js:noInline')
  static GetSwapPaymentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSwapPaymentRequest>(create);
  static GetSwapPaymentRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetSwapPaymentReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'paymentError', protoName: 'paymentError')
    ..aOB(2, 'fundsExceededLimit')
    ..e<GetSwapPaymentReply_SwapError>(3, 'swapError', $pb.PbFieldType.OE, defaultOrMaker: GetSwapPaymentReply_SwapError.NO_ERROR, valueOf: GetSwapPaymentReply_SwapError.valueOf, enumValues: GetSwapPaymentReply_SwapError.values)
    ..hasRequiredFields = false
  ;

  GetSwapPaymentReply._() : super();
  factory GetSwapPaymentReply() => create();
  factory GetSwapPaymentReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSwapPaymentReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GetSwapPaymentReply clone() => GetSwapPaymentReply()..mergeFromMessage(this);
  GetSwapPaymentReply copyWith(void Function(GetSwapPaymentReply) updates) => super.copyWith((message) => updates(message as GetSwapPaymentReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetSwapPaymentReply create() => GetSwapPaymentReply._();
  GetSwapPaymentReply createEmptyInstance() => create();
  static $pb.PbList<GetSwapPaymentReply> createRepeated() => $pb.PbList<GetSwapPaymentReply>();
  @$core.pragma('dart2js:noInline')
  static GetSwapPaymentReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSwapPaymentReply>(create);
  static GetSwapPaymentReply _defaultInstance;

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

class RegisterRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RegisterRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'deviceID', protoName: 'deviceID')
    ..aOS(2, 'lightningID', protoName: 'lightningID')
    ..hasRequiredFields = false
  ;

  RegisterRequest._() : super();
  factory RegisterRequest() => create();
  factory RegisterRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RegisterRequest clone() => RegisterRequest()..mergeFromMessage(this);
  RegisterRequest copyWith(void Function(RegisterRequest) updates) => super.copyWith((message) => updates(message as RegisterRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RegisterRequest create() => RegisterRequest._();
  RegisterRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterRequest> createRepeated() => $pb.PbList<RegisterRequest>();
  @$core.pragma('dart2js:noInline')
  static RegisterRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterRequest>(create);
  static RegisterRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RegisterReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'breezID', protoName: 'breezID')
    ..hasRequiredFields = false
  ;

  RegisterReply._() : super();
  factory RegisterReply() => create();
  factory RegisterReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RegisterReply clone() => RegisterReply()..mergeFromMessage(this);
  RegisterReply copyWith(void Function(RegisterReply) updates) => super.copyWith((message) => updates(message as RegisterReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RegisterReply create() => RegisterReply._();
  RegisterReply createEmptyInstance() => create();
  static $pb.PbList<RegisterReply> createRepeated() => $pb.PbList<RegisterReply>();
  @$core.pragma('dart2js:noInline')
  static RegisterReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterReply>(create);
  static RegisterReply _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PaymentRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'breezID', protoName: 'breezID')
    ..aOS(2, 'invoice')
    ..aOS(3, 'payee')
    ..aInt64(4, 'amount')
    ..hasRequiredFields = false
  ;

  PaymentRequest._() : super();
  factory PaymentRequest() => create();
  factory PaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PaymentRequest clone() => PaymentRequest()..mergeFromMessage(this);
  PaymentRequest copyWith(void Function(PaymentRequest) updates) => super.copyWith((message) => updates(message as PaymentRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PaymentRequest create() => PaymentRequest._();
  PaymentRequest createEmptyInstance() => create();
  static $pb.PbList<PaymentRequest> createRepeated() => $pb.PbList<PaymentRequest>();
  @$core.pragma('dart2js:noInline')
  static PaymentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaymentRequest>(create);
  static PaymentRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('InvoiceReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'Error', protoName: 'Error')
    ..hasRequiredFields = false
  ;

  InvoiceReply._() : super();
  factory InvoiceReply() => create();
  factory InvoiceReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InvoiceReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  InvoiceReply clone() => InvoiceReply()..mergeFromMessage(this);
  InvoiceReply copyWith(void Function(InvoiceReply) updates) => super.copyWith((message) => updates(message as InvoiceReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InvoiceReply create() => InvoiceReply._();
  InvoiceReply createEmptyInstance() => create();
  static $pb.PbList<InvoiceReply> createRepeated() => $pb.PbList<InvoiceReply>();
  @$core.pragma('dart2js:noInline')
  static InvoiceReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InvoiceReply>(create);
  static InvoiceReply _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UploadFileRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'content', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  UploadFileRequest._() : super();
  factory UploadFileRequest() => create();
  factory UploadFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  UploadFileRequest clone() => UploadFileRequest()..mergeFromMessage(this);
  UploadFileRequest copyWith(void Function(UploadFileRequest) updates) => super.copyWith((message) => updates(message as UploadFileRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UploadFileRequest create() => UploadFileRequest._();
  UploadFileRequest createEmptyInstance() => create();
  static $pb.PbList<UploadFileRequest> createRepeated() => $pb.PbList<UploadFileRequest>();
  @$core.pragma('dart2js:noInline')
  static UploadFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadFileRequest>(create);
  static UploadFileRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UploadFileReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'url')
    ..hasRequiredFields = false
  ;

  UploadFileReply._() : super();
  factory UploadFileReply() => create();
  factory UploadFileReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadFileReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  UploadFileReply clone() => UploadFileReply()..mergeFromMessage(this);
  UploadFileReply copyWith(void Function(UploadFileReply) updates) => super.copyWith((message) => updates(message as UploadFileReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UploadFileReply create() => UploadFileReply._();
  UploadFileReply createEmptyInstance() => create();
  static $pb.PbList<UploadFileReply> createRepeated() => $pb.PbList<UploadFileReply>();
  @$core.pragma('dart2js:noInline')
  static UploadFileReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadFileReply>(create);
  static UploadFileReply _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PingRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  PingRequest._() : super();
  factory PingRequest() => create();
  factory PingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PingRequest clone() => PingRequest()..mergeFromMessage(this);
  PingRequest copyWith(void Function(PingRequest) updates) => super.copyWith((message) => updates(message as PingRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PingRequest create() => PingRequest._();
  PingRequest createEmptyInstance() => create();
  static $pb.PbList<PingRequest> createRepeated() => $pb.PbList<PingRequest>();
  @$core.pragma('dart2js:noInline')
  static PingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PingRequest>(create);
  static PingRequest _defaultInstance;
}

class PingReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PingReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'version')
    ..hasRequiredFields = false
  ;

  PingReply._() : super();
  factory PingReply() => create();
  factory PingReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PingReply clone() => PingReply()..mergeFromMessage(this);
  PingReply copyWith(void Function(PingReply) updates) => super.copyWith((message) => updates(message as PingReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PingReply create() => PingReply._();
  PingReply createEmptyInstance() => create();
  static $pb.PbList<PingReply> createRepeated() => $pb.PbList<PingReply>();
  @$core.pragma('dart2js:noInline')
  static PingReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PingReply>(create);
  static PingReply _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OrderRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'FullName', protoName: 'FullName')
    ..aOS(2, 'Address', protoName: 'Address')
    ..aOS(3, 'City', protoName: 'City')
    ..aOS(4, 'State', protoName: 'State')
    ..aOS(5, 'Zip', protoName: 'Zip')
    ..aOS(6, 'Country', protoName: 'Country')
    ..aOS(7, 'Email', protoName: 'Email')
    ..hasRequiredFields = false
  ;

  OrderRequest._() : super();
  factory OrderRequest() => create();
  factory OrderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OrderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  OrderRequest clone() => OrderRequest()..mergeFromMessage(this);
  OrderRequest copyWith(void Function(OrderRequest) updates) => super.copyWith((message) => updates(message as OrderRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OrderRequest create() => OrderRequest._();
  OrderRequest createEmptyInstance() => create();
  static $pb.PbList<OrderRequest> createRepeated() => $pb.PbList<OrderRequest>();
  @$core.pragma('dart2js:noInline')
  static OrderRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderRequest>(create);
  static OrderRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OrderReply', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  OrderReply._() : super();
  factory OrderReply() => create();
  factory OrderReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OrderReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  OrderReply clone() => OrderReply()..mergeFromMessage(this);
  OrderReply copyWith(void Function(OrderReply) updates) => super.copyWith((message) => updates(message as OrderReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OrderReply create() => OrderReply._();
  OrderReply createEmptyInstance() => create();
  static $pb.PbList<OrderReply> createRepeated() => $pb.PbList<OrderReply>();
  @$core.pragma('dart2js:noInline')
  static OrderReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderReply>(create);
  static OrderReply _defaultInstance;
}

class JoinCTPSessionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('JoinCTPSessionRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..e<JoinCTPSessionRequest_PartyType>(1, 'partyType', $pb.PbFieldType.OE, protoName: 'partyType', defaultOrMaker: JoinCTPSessionRequest_PartyType.PAYER, valueOf: JoinCTPSessionRequest_PartyType.valueOf, enumValues: JoinCTPSessionRequest_PartyType.values)
    ..aOS(2, 'partyName', protoName: 'partyName')
    ..aOS(3, 'notificationToken', protoName: 'notificationToken')
    ..aOS(4, 'sessionID', protoName: 'sessionID')
    ..hasRequiredFields = false
  ;

  JoinCTPSessionRequest._() : super();
  factory JoinCTPSessionRequest() => create();
  factory JoinCTPSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinCTPSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  JoinCTPSessionRequest clone() => JoinCTPSessionRequest()..mergeFromMessage(this);
  JoinCTPSessionRequest copyWith(void Function(JoinCTPSessionRequest) updates) => super.copyWith((message) => updates(message as JoinCTPSessionRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static JoinCTPSessionRequest create() => JoinCTPSessionRequest._();
  JoinCTPSessionRequest createEmptyInstance() => create();
  static $pb.PbList<JoinCTPSessionRequest> createRepeated() => $pb.PbList<JoinCTPSessionRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinCTPSessionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinCTPSessionRequest>(create);
  static JoinCTPSessionRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('JoinCTPSessionResponse', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'sessionID', protoName: 'sessionID')
    ..aInt64(2, 'expiry')
    ..hasRequiredFields = false
  ;

  JoinCTPSessionResponse._() : super();
  factory JoinCTPSessionResponse() => create();
  factory JoinCTPSessionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinCTPSessionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  JoinCTPSessionResponse clone() => JoinCTPSessionResponse()..mergeFromMessage(this);
  JoinCTPSessionResponse copyWith(void Function(JoinCTPSessionResponse) updates) => super.copyWith((message) => updates(message as JoinCTPSessionResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static JoinCTPSessionResponse create() => JoinCTPSessionResponse._();
  JoinCTPSessionResponse createEmptyInstance() => create();
  static $pb.PbList<JoinCTPSessionResponse> createRepeated() => $pb.PbList<JoinCTPSessionResponse>();
  @$core.pragma('dart2js:noInline')
  static JoinCTPSessionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinCTPSessionResponse>(create);
  static JoinCTPSessionResponse _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TerminateCTPSessionRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'sessionID', protoName: 'sessionID')
    ..hasRequiredFields = false
  ;

  TerminateCTPSessionRequest._() : super();
  factory TerminateCTPSessionRequest() => create();
  factory TerminateCTPSessionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TerminateCTPSessionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TerminateCTPSessionRequest clone() => TerminateCTPSessionRequest()..mergeFromMessage(this);
  TerminateCTPSessionRequest copyWith(void Function(TerminateCTPSessionRequest) updates) => super.copyWith((message) => updates(message as TerminateCTPSessionRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TerminateCTPSessionRequest create() => TerminateCTPSessionRequest._();
  TerminateCTPSessionRequest createEmptyInstance() => create();
  static $pb.PbList<TerminateCTPSessionRequest> createRepeated() => $pb.PbList<TerminateCTPSessionRequest>();
  @$core.pragma('dart2js:noInline')
  static TerminateCTPSessionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TerminateCTPSessionRequest>(create);
  static TerminateCTPSessionRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TerminateCTPSessionResponse', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  TerminateCTPSessionResponse._() : super();
  factory TerminateCTPSessionResponse() => create();
  factory TerminateCTPSessionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TerminateCTPSessionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TerminateCTPSessionResponse clone() => TerminateCTPSessionResponse()..mergeFromMessage(this);
  TerminateCTPSessionResponse copyWith(void Function(TerminateCTPSessionResponse) updates) => super.copyWith((message) => updates(message as TerminateCTPSessionResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TerminateCTPSessionResponse create() => TerminateCTPSessionResponse._();
  TerminateCTPSessionResponse createEmptyInstance() => create();
  static $pb.PbList<TerminateCTPSessionResponse> createRepeated() => $pb.PbList<TerminateCTPSessionResponse>();
  @$core.pragma('dart2js:noInline')
  static TerminateCTPSessionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TerminateCTPSessionResponse>(create);
  static TerminateCTPSessionResponse _defaultInstance;
}

class RegisterTransactionConfirmationRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RegisterTransactionConfirmationRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'txID', protoName: 'txID')
    ..aOS(2, 'notificationToken', protoName: 'notificationToken')
    ..e<RegisterTransactionConfirmationRequest_NotificationType>(3, 'notificationType', $pb.PbFieldType.OE, protoName: 'notificationType', defaultOrMaker: RegisterTransactionConfirmationRequest_NotificationType.READY_RECEIVE_PAYMENT, valueOf: RegisterTransactionConfirmationRequest_NotificationType.valueOf, enumValues: RegisterTransactionConfirmationRequest_NotificationType.values)
    ..hasRequiredFields = false
  ;

  RegisterTransactionConfirmationRequest._() : super();
  factory RegisterTransactionConfirmationRequest() => create();
  factory RegisterTransactionConfirmationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterTransactionConfirmationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RegisterTransactionConfirmationRequest clone() => RegisterTransactionConfirmationRequest()..mergeFromMessage(this);
  RegisterTransactionConfirmationRequest copyWith(void Function(RegisterTransactionConfirmationRequest) updates) => super.copyWith((message) => updates(message as RegisterTransactionConfirmationRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RegisterTransactionConfirmationRequest create() => RegisterTransactionConfirmationRequest._();
  RegisterTransactionConfirmationRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterTransactionConfirmationRequest> createRepeated() => $pb.PbList<RegisterTransactionConfirmationRequest>();
  @$core.pragma('dart2js:noInline')
  static RegisterTransactionConfirmationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterTransactionConfirmationRequest>(create);
  static RegisterTransactionConfirmationRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RegisterTransactionConfirmationResponse', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  RegisterTransactionConfirmationResponse._() : super();
  factory RegisterTransactionConfirmationResponse() => create();
  factory RegisterTransactionConfirmationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterTransactionConfirmationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RegisterTransactionConfirmationResponse clone() => RegisterTransactionConfirmationResponse()..mergeFromMessage(this);
  RegisterTransactionConfirmationResponse copyWith(void Function(RegisterTransactionConfirmationResponse) updates) => super.copyWith((message) => updates(message as RegisterTransactionConfirmationResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RegisterTransactionConfirmationResponse create() => RegisterTransactionConfirmationResponse._();
  RegisterTransactionConfirmationResponse createEmptyInstance() => create();
  static $pb.PbList<RegisterTransactionConfirmationResponse> createRepeated() => $pb.PbList<RegisterTransactionConfirmationResponse>();
  @$core.pragma('dart2js:noInline')
  static RegisterTransactionConfirmationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterTransactionConfirmationResponse>(create);
  static RegisterTransactionConfirmationResponse _defaultInstance;
}

class RegisterPeriodicSyncRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RegisterPeriodicSyncRequest', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..aOS(1, 'notificationToken', protoName: 'notificationToken')
    ..hasRequiredFields = false
  ;

  RegisterPeriodicSyncRequest._() : super();
  factory RegisterPeriodicSyncRequest() => create();
  factory RegisterPeriodicSyncRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPeriodicSyncRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RegisterPeriodicSyncRequest clone() => RegisterPeriodicSyncRequest()..mergeFromMessage(this);
  RegisterPeriodicSyncRequest copyWith(void Function(RegisterPeriodicSyncRequest) updates) => super.copyWith((message) => updates(message as RegisterPeriodicSyncRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RegisterPeriodicSyncRequest create() => RegisterPeriodicSyncRequest._();
  RegisterPeriodicSyncRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterPeriodicSyncRequest> createRepeated() => $pb.PbList<RegisterPeriodicSyncRequest>();
  @$core.pragma('dart2js:noInline')
  static RegisterPeriodicSyncRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterPeriodicSyncRequest>(create);
  static RegisterPeriodicSyncRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RegisterPeriodicSyncResponse', package: const $pb.PackageName('breez'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  RegisterPeriodicSyncResponse._() : super();
  factory RegisterPeriodicSyncResponse() => create();
  factory RegisterPeriodicSyncResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPeriodicSyncResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RegisterPeriodicSyncResponse clone() => RegisterPeriodicSyncResponse()..mergeFromMessage(this);
  RegisterPeriodicSyncResponse copyWith(void Function(RegisterPeriodicSyncResponse) updates) => super.copyWith((message) => updates(message as RegisterPeriodicSyncResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RegisterPeriodicSyncResponse create() => RegisterPeriodicSyncResponse._();
  RegisterPeriodicSyncResponse createEmptyInstance() => create();
  static $pb.PbList<RegisterPeriodicSyncResponse> createRepeated() => $pb.PbList<RegisterPeriodicSyncResponse>();
  @$core.pragma('dart2js:noInline')
  static RegisterPeriodicSyncResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterPeriodicSyncResponse>(create);
  static RegisterPeriodicSyncResponse _defaultInstance;
}


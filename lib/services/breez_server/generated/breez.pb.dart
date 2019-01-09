///
//  Generated code. Do not modify.
//  source: breez.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'breez.pbenum.dart';

export 'breez.pbenum.dart';

class OpenChannelRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OpenChannelRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'pubKey')
    ..aOS(2, 'notificationToken')
    ..hasRequiredFields = false
  ;

  OpenChannelRequest() : super();
  OpenChannelRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OpenChannelRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OpenChannelRequest clone() => new OpenChannelRequest()..mergeFromMessage(this);
  OpenChannelRequest copyWith(void Function(OpenChannelRequest) updates) => super.copyWith((message) => updates(message as OpenChannelRequest));
  $pb.BuilderInfo get info_ => _i;
  static OpenChannelRequest create() => new OpenChannelRequest();
  OpenChannelRequest createEmptyInstance() => create();
  static $pb.PbList<OpenChannelRequest> createRepeated() => new $pb.PbList<OpenChannelRequest>();
  static OpenChannelRequest getDefault() => _defaultInstance ??= create()..freeze();
  static OpenChannelRequest _defaultInstance;
  static void $checkItem(OpenChannelRequest v) {
    if (v is! OpenChannelRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get pubKey => $_getS(0, '');
  set pubKey(String v) { $_setString(0, v); }
  bool hasPubKey() => $_has(0);
  void clearPubKey() => clearField(1);

  String get notificationToken => $_getS(1, '');
  set notificationToken(String v) { $_setString(1, v); }
  bool hasNotificationToken() => $_has(1);
  void clearNotificationToken() => clearField(2);
}

class OpenChannelReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OpenChannelReply', package: const $pb.PackageName('breez'))
    ..hasRequiredFields = false
  ;

  OpenChannelReply() : super();
  OpenChannelReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OpenChannelReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OpenChannelReply clone() => new OpenChannelReply()..mergeFromMessage(this);
  OpenChannelReply copyWith(void Function(OpenChannelReply) updates) => super.copyWith((message) => updates(message as OpenChannelReply));
  $pb.BuilderInfo get info_ => _i;
  static OpenChannelReply create() => new OpenChannelReply();
  OpenChannelReply createEmptyInstance() => create();
  static $pb.PbList<OpenChannelReply> createRepeated() => new $pb.PbList<OpenChannelReply>();
  static OpenChannelReply getDefault() => _defaultInstance ??= create()..freeze();
  static OpenChannelReply _defaultInstance;
  static void $checkItem(OpenChannelReply v) {
    if (v is! OpenChannelReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class UpdateChannelPolicyRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateChannelPolicyRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'pubKey')
    ..hasRequiredFields = false
  ;

  UpdateChannelPolicyRequest() : super();
  UpdateChannelPolicyRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateChannelPolicyRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateChannelPolicyRequest clone() => new UpdateChannelPolicyRequest()..mergeFromMessage(this);
  UpdateChannelPolicyRequest copyWith(void Function(UpdateChannelPolicyRequest) updates) => super.copyWith((message) => updates(message as UpdateChannelPolicyRequest));
  $pb.BuilderInfo get info_ => _i;
  static UpdateChannelPolicyRequest create() => new UpdateChannelPolicyRequest();
  UpdateChannelPolicyRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateChannelPolicyRequest> createRepeated() => new $pb.PbList<UpdateChannelPolicyRequest>();
  static UpdateChannelPolicyRequest getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateChannelPolicyRequest _defaultInstance;
  static void $checkItem(UpdateChannelPolicyRequest v) {
    if (v is! UpdateChannelPolicyRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get pubKey => $_getS(0, '');
  set pubKey(String v) { $_setString(0, v); }
  bool hasPubKey() => $_has(0);
  void clearPubKey() => clearField(1);
}

class UpdateChannelPolicyReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateChannelPolicyReply', package: const $pb.PackageName('breez'))
    ..hasRequiredFields = false
  ;

  UpdateChannelPolicyReply() : super();
  UpdateChannelPolicyReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateChannelPolicyReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateChannelPolicyReply clone() => new UpdateChannelPolicyReply()..mergeFromMessage(this);
  UpdateChannelPolicyReply copyWith(void Function(UpdateChannelPolicyReply) updates) => super.copyWith((message) => updates(message as UpdateChannelPolicyReply));
  $pb.BuilderInfo get info_ => _i;
  static UpdateChannelPolicyReply create() => new UpdateChannelPolicyReply();
  UpdateChannelPolicyReply createEmptyInstance() => create();
  static $pb.PbList<UpdateChannelPolicyReply> createRepeated() => new $pb.PbList<UpdateChannelPolicyReply>();
  static UpdateChannelPolicyReply getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateChannelPolicyReply _defaultInstance;
  static void $checkItem(UpdateChannelPolicyReply v) {
    if (v is! UpdateChannelPolicyReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class AddFundInitRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AddFundInitRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'nodeID')
    ..aOS(2, 'notificationToken')
    ..a<List<int>>(3, 'pubkey', $pb.PbFieldType.OY)
    ..a<List<int>>(4, 'hash', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  AddFundInitRequest() : super();
  AddFundInitRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundInitRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundInitRequest clone() => new AddFundInitRequest()..mergeFromMessage(this);
  AddFundInitRequest copyWith(void Function(AddFundInitRequest) updates) => super.copyWith((message) => updates(message as AddFundInitRequest));
  $pb.BuilderInfo get info_ => _i;
  static AddFundInitRequest create() => new AddFundInitRequest();
  AddFundInitRequest createEmptyInstance() => create();
  static $pb.PbList<AddFundInitRequest> createRepeated() => new $pb.PbList<AddFundInitRequest>();
  static AddFundInitRequest getDefault() => _defaultInstance ??= create()..freeze();
  static AddFundInitRequest _defaultInstance;
  static void $checkItem(AddFundInitRequest v) {
    if (v is! AddFundInitRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get nodeID => $_getS(0, '');
  set nodeID(String v) { $_setString(0, v); }
  bool hasNodeID() => $_has(0);
  void clearNodeID() => clearField(1);

  String get notificationToken => $_getS(1, '');
  set notificationToken(String v) { $_setString(1, v); }
  bool hasNotificationToken() => $_has(1);
  void clearNotificationToken() => clearField(2);

  List<int> get pubkey => $_getN(2);
  set pubkey(List<int> v) { $_setBytes(2, v); }
  bool hasPubkey() => $_has(2);
  void clearPubkey() => clearField(3);

  List<int> get hash => $_getN(3);
  set hash(List<int> v) { $_setBytes(3, v); }
  bool hasHash() => $_has(3);
  void clearHash() => clearField(4);
}

class AddFundInitReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AddFundInitReply', package: const $pb.PackageName('breez'))
    ..aOS(1, 'address')
    ..a<List<int>>(2, 'pubkey', $pb.PbFieldType.OY)
    ..aInt64(3, 'lockHeight')
    ..aInt64(4, 'maxAllowedDeposit')
    ..aOS(5, 'errorMessage')
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
  static void $checkItem(AddFundInitReply v) {
    if (v is! AddFundInitReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get address => $_getS(0, '');
  set address(String v) { $_setString(0, v); }
  bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  List<int> get pubkey => $_getN(1);
  set pubkey(List<int> v) { $_setBytes(1, v); }
  bool hasPubkey() => $_has(1);
  void clearPubkey() => clearField(2);

  Int64 get lockHeight => $_getI64(2);
  set lockHeight(Int64 v) { $_setInt64(2, v); }
  bool hasLockHeight() => $_has(2);
  void clearLockHeight() => clearField(3);

  Int64 get maxAllowedDeposit => $_getI64(3);
  set maxAllowedDeposit(Int64 v) { $_setInt64(3, v); }
  bool hasMaxAllowedDeposit() => $_has(3);
  void clearMaxAllowedDeposit() => clearField(4);

  String get errorMessage => $_getS(4, '');
  set errorMessage(String v) { $_setString(4, v); }
  bool hasErrorMessage() => $_has(4);
  void clearErrorMessage() => clearField(5);
}

class AddFundStatusRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AddFundStatusRequest', package: const $pb.PackageName('breez'))
    ..pPS(1, 'addresses')
    ..aOS(2, 'notificationToken')
    ..hasRequiredFields = false
  ;

  AddFundStatusRequest() : super();
  AddFundStatusRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundStatusRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundStatusRequest clone() => new AddFundStatusRequest()..mergeFromMessage(this);
  AddFundStatusRequest copyWith(void Function(AddFundStatusRequest) updates) => super.copyWith((message) => updates(message as AddFundStatusRequest));
  $pb.BuilderInfo get info_ => _i;
  static AddFundStatusRequest create() => new AddFundStatusRequest();
  AddFundStatusRequest createEmptyInstance() => create();
  static $pb.PbList<AddFundStatusRequest> createRepeated() => new $pb.PbList<AddFundStatusRequest>();
  static AddFundStatusRequest getDefault() => _defaultInstance ??= create()..freeze();
  static AddFundStatusRequest _defaultInstance;
  static void $checkItem(AddFundStatusRequest v) {
    if (v is! AddFundStatusRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<String> get addresses => $_getList(0);

  String get notificationToken => $_getS(1, '');
  set notificationToken(String v) { $_setString(1, v); }
  bool hasNotificationToken() => $_has(1);
  void clearNotificationToken() => clearField(2);
}

class AddFundStatusReply_AddressStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AddFundStatusReply.AddressStatus', package: const $pb.PackageName('breez'))
    ..aOS(1, 'tx')
    ..aInt64(2, 'amount')
    ..aOB(3, 'confirmed')
    ..aOS(4, 'blockHash')
    ..hasRequiredFields = false
  ;

  AddFundStatusReply_AddressStatus() : super();
  AddFundStatusReply_AddressStatus.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundStatusReply_AddressStatus.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundStatusReply_AddressStatus clone() => new AddFundStatusReply_AddressStatus()..mergeFromMessage(this);
  AddFundStatusReply_AddressStatus copyWith(void Function(AddFundStatusReply_AddressStatus) updates) => super.copyWith((message) => updates(message as AddFundStatusReply_AddressStatus));
  $pb.BuilderInfo get info_ => _i;
  static AddFundStatusReply_AddressStatus create() => new AddFundStatusReply_AddressStatus();
  AddFundStatusReply_AddressStatus createEmptyInstance() => create();
  static $pb.PbList<AddFundStatusReply_AddressStatus> createRepeated() => new $pb.PbList<AddFundStatusReply_AddressStatus>();
  static AddFundStatusReply_AddressStatus getDefault() => _defaultInstance ??= create()..freeze();
  static AddFundStatusReply_AddressStatus _defaultInstance;
  static void $checkItem(AddFundStatusReply_AddressStatus v) {
    if (v is! AddFundStatusReply_AddressStatus) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get tx => $_getS(0, '');
  set tx(String v) { $_setString(0, v); }
  bool hasTx() => $_has(0);
  void clearTx() => clearField(1);

  Int64 get amount => $_getI64(1);
  set amount(Int64 v) { $_setInt64(1, v); }
  bool hasAmount() => $_has(1);
  void clearAmount() => clearField(2);

  bool get confirmed => $_get(2, false);
  set confirmed(bool v) { $_setBool(2, v); }
  bool hasConfirmed() => $_has(2);
  void clearConfirmed() => clearField(3);

  String get blockHash => $_getS(3, '');
  set blockHash(String v) { $_setString(3, v); }
  bool hasBlockHash() => $_has(3);
  void clearBlockHash() => clearField(4);
}

class AddFundStatusReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AddFundStatusReply', package: const $pb.PackageName('breez'))
    ..m<String, AddFundStatusReply_AddressStatus>(1, 'statuses', $pb.PbFieldType.OS, $pb.PbFieldType.OM, AddFundStatusReply_AddressStatus.create)
    ..hasRequiredFields = false
  ;

  AddFundStatusReply() : super();
  AddFundStatusReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundStatusReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundStatusReply clone() => new AddFundStatusReply()..mergeFromMessage(this);
  AddFundStatusReply copyWith(void Function(AddFundStatusReply) updates) => super.copyWith((message) => updates(message as AddFundStatusReply));
  $pb.BuilderInfo get info_ => _i;
  static AddFundStatusReply create() => new AddFundStatusReply();
  AddFundStatusReply createEmptyInstance() => create();
  static $pb.PbList<AddFundStatusReply> createRepeated() => new $pb.PbList<AddFundStatusReply>();
  static AddFundStatusReply getDefault() => _defaultInstance ??= create()..freeze();
  static AddFundStatusReply _defaultInstance;
  static void $checkItem(AddFundStatusReply v) {
    if (v is! AddFundStatusReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Map<String, AddFundStatusReply_AddressStatus> get statuses => $_getMap(0);
}

class RemoveFundRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RemoveFundRequest', package: const $pb.PackageName('breez'))
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
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RemoveFundReply', package: const $pb.PackageName('breez'))
    ..aOS(1, 'paymentRequest')
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
  static void $checkItem(RemoveFundReply v) {
    if (v is! RemoveFundReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get paymentRequest => $_getS(0, '');
  set paymentRequest(String v) { $_setString(0, v); }
  bool hasPaymentRequest() => $_has(0);
  void clearPaymentRequest() => clearField(1);

  String get errorMessage => $_getS(1, '');
  set errorMessage(String v) { $_setString(1, v); }
  bool hasErrorMessage() => $_has(1);
  void clearErrorMessage() => clearField(2);
}

class RedeemRemovedFundsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RedeemRemovedFundsRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'paymenthash')
    ..hasRequiredFields = false
  ;

  RedeemRemovedFundsRequest() : super();
  RedeemRemovedFundsRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RedeemRemovedFundsRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RedeemRemovedFundsRequest clone() => new RedeemRemovedFundsRequest()..mergeFromMessage(this);
  RedeemRemovedFundsRequest copyWith(void Function(RedeemRemovedFundsRequest) updates) => super.copyWith((message) => updates(message as RedeemRemovedFundsRequest));
  $pb.BuilderInfo get info_ => _i;
  static RedeemRemovedFundsRequest create() => new RedeemRemovedFundsRequest();
  RedeemRemovedFundsRequest createEmptyInstance() => create();
  static $pb.PbList<RedeemRemovedFundsRequest> createRepeated() => new $pb.PbList<RedeemRemovedFundsRequest>();
  static RedeemRemovedFundsRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RedeemRemovedFundsRequest _defaultInstance;
  static void $checkItem(RedeemRemovedFundsRequest v) {
    if (v is! RedeemRemovedFundsRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get paymenthash => $_getS(0, '');
  set paymenthash(String v) { $_setString(0, v); }
  bool hasPaymenthash() => $_has(0);
  void clearPaymenthash() => clearField(1);
}

class RedeemRemovedFundsReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RedeemRemovedFundsReply', package: const $pb.PackageName('breez'))
    ..aOS(1, 'txid')
    ..hasRequiredFields = false
  ;

  RedeemRemovedFundsReply() : super();
  RedeemRemovedFundsReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RedeemRemovedFundsReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RedeemRemovedFundsReply clone() => new RedeemRemovedFundsReply()..mergeFromMessage(this);
  RedeemRemovedFundsReply copyWith(void Function(RedeemRemovedFundsReply) updates) => super.copyWith((message) => updates(message as RedeemRemovedFundsReply));
  $pb.BuilderInfo get info_ => _i;
  static RedeemRemovedFundsReply create() => new RedeemRemovedFundsReply();
  RedeemRemovedFundsReply createEmptyInstance() => create();
  static $pb.PbList<RedeemRemovedFundsReply> createRepeated() => new $pb.PbList<RedeemRemovedFundsReply>();
  static RedeemRemovedFundsReply getDefault() => _defaultInstance ??= create()..freeze();
  static RedeemRemovedFundsReply _defaultInstance;
  static void $checkItem(RedeemRemovedFundsReply v) {
    if (v is! RedeemRemovedFundsReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get txid => $_getS(0, '');
  set txid(String v) { $_setString(0, v); }
  bool hasTxid() => $_has(0);
  void clearTxid() => clearField(1);
}

class FundRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FundRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'deviceID')
    ..aOS(2, 'lightningID')
    ..aInt64(3, 'amount')
    ..hasRequiredFields = false
  ;

  FundRequest() : super();
  FundRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FundRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FundRequest clone() => new FundRequest()..mergeFromMessage(this);
  FundRequest copyWith(void Function(FundRequest) updates) => super.copyWith((message) => updates(message as FundRequest));
  $pb.BuilderInfo get info_ => _i;
  static FundRequest create() => new FundRequest();
  FundRequest createEmptyInstance() => create();
  static $pb.PbList<FundRequest> createRepeated() => new $pb.PbList<FundRequest>();
  static FundRequest getDefault() => _defaultInstance ??= create()..freeze();
  static FundRequest _defaultInstance;
  static void $checkItem(FundRequest v) {
    if (v is! FundRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get deviceID => $_getS(0, '');
  set deviceID(String v) { $_setString(0, v); }
  bool hasDeviceID() => $_has(0);
  void clearDeviceID() => clearField(1);

  String get lightningID => $_getS(1, '');
  set lightningID(String v) { $_setString(1, v); }
  bool hasLightningID() => $_has(1);
  void clearLightningID() => clearField(2);

  Int64 get amount => $_getI64(2);
  set amount(Int64 v) { $_setInt64(2, v); }
  bool hasAmount() => $_has(2);
  void clearAmount() => clearField(3);
}

class FundReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FundReply', package: const $pb.PackageName('breez'))
    ..e<FundReply_ReturnCode>(1, 'returnCode', $pb.PbFieldType.OE, FundReply_ReturnCode.SUCCESS, FundReply_ReturnCode.valueOf, FundReply_ReturnCode.values)
    ..hasRequiredFields = false
  ;

  FundReply() : super();
  FundReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FundReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FundReply clone() => new FundReply()..mergeFromMessage(this);
  FundReply copyWith(void Function(FundReply) updates) => super.copyWith((message) => updates(message as FundReply));
  $pb.BuilderInfo get info_ => _i;
  static FundReply create() => new FundReply();
  FundReply createEmptyInstance() => create();
  static $pb.PbList<FundReply> createRepeated() => new $pb.PbList<FundReply>();
  static FundReply getDefault() => _defaultInstance ??= create()..freeze();
  static FundReply _defaultInstance;
  static void $checkItem(FundReply v) {
    if (v is! FundReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  FundReply_ReturnCode get returnCode => $_getN(0);
  set returnCode(FundReply_ReturnCode v) { setField(1, v); }
  bool hasReturnCode() => $_has(0);
  void clearReturnCode() => clearField(1);
}

class GetSwapPaymentRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetSwapPaymentRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'paymentRequest')
    ..hasRequiredFields = false
  ;

  GetSwapPaymentRequest() : super();
  GetSwapPaymentRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetSwapPaymentRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetSwapPaymentRequest clone() => new GetSwapPaymentRequest()..mergeFromMessage(this);
  GetSwapPaymentRequest copyWith(void Function(GetSwapPaymentRequest) updates) => super.copyWith((message) => updates(message as GetSwapPaymentRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetSwapPaymentRequest create() => new GetSwapPaymentRequest();
  GetSwapPaymentRequest createEmptyInstance() => create();
  static $pb.PbList<GetSwapPaymentRequest> createRepeated() => new $pb.PbList<GetSwapPaymentRequest>();
  static GetSwapPaymentRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetSwapPaymentRequest _defaultInstance;
  static void $checkItem(GetSwapPaymentRequest v) {
    if (v is! GetSwapPaymentRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get paymentRequest => $_getS(0, '');
  set paymentRequest(String v) { $_setString(0, v); }
  bool hasPaymentRequest() => $_has(0);
  void clearPaymentRequest() => clearField(1);
}

class GetSwapPaymentReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetSwapPaymentReply', package: const $pb.PackageName('breez'))
    ..aOS(1, 'paymentError')
    ..hasRequiredFields = false
  ;

  GetSwapPaymentReply() : super();
  GetSwapPaymentReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetSwapPaymentReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetSwapPaymentReply clone() => new GetSwapPaymentReply()..mergeFromMessage(this);
  GetSwapPaymentReply copyWith(void Function(GetSwapPaymentReply) updates) => super.copyWith((message) => updates(message as GetSwapPaymentReply));
  $pb.BuilderInfo get info_ => _i;
  static GetSwapPaymentReply create() => new GetSwapPaymentReply();
  GetSwapPaymentReply createEmptyInstance() => create();
  static $pb.PbList<GetSwapPaymentReply> createRepeated() => new $pb.PbList<GetSwapPaymentReply>();
  static GetSwapPaymentReply getDefault() => _defaultInstance ??= create()..freeze();
  static GetSwapPaymentReply _defaultInstance;
  static void $checkItem(GetSwapPaymentReply v) {
    if (v is! GetSwapPaymentReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get paymentError => $_getS(0, '');
  set paymentError(String v) { $_setString(0, v); }
  bool hasPaymentError() => $_has(0);
  void clearPaymentError() => clearField(1);
}

class RegisterRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RegisterRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'deviceID')
    ..aOS(2, 'lightningID')
    ..hasRequiredFields = false
  ;

  RegisterRequest() : super();
  RegisterRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RegisterRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RegisterRequest clone() => new RegisterRequest()..mergeFromMessage(this);
  RegisterRequest copyWith(void Function(RegisterRequest) updates) => super.copyWith((message) => updates(message as RegisterRequest));
  $pb.BuilderInfo get info_ => _i;
  static RegisterRequest create() => new RegisterRequest();
  RegisterRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterRequest> createRepeated() => new $pb.PbList<RegisterRequest>();
  static RegisterRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RegisterRequest _defaultInstance;
  static void $checkItem(RegisterRequest v) {
    if (v is! RegisterRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get deviceID => $_getS(0, '');
  set deviceID(String v) { $_setString(0, v); }
  bool hasDeviceID() => $_has(0);
  void clearDeviceID() => clearField(1);

  String get lightningID => $_getS(1, '');
  set lightningID(String v) { $_setString(1, v); }
  bool hasLightningID() => $_has(1);
  void clearLightningID() => clearField(2);
}

class RegisterReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RegisterReply', package: const $pb.PackageName('breez'))
    ..aOS(1, 'breezID')
    ..hasRequiredFields = false
  ;

  RegisterReply() : super();
  RegisterReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RegisterReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RegisterReply clone() => new RegisterReply()..mergeFromMessage(this);
  RegisterReply copyWith(void Function(RegisterReply) updates) => super.copyWith((message) => updates(message as RegisterReply));
  $pb.BuilderInfo get info_ => _i;
  static RegisterReply create() => new RegisterReply();
  RegisterReply createEmptyInstance() => create();
  static $pb.PbList<RegisterReply> createRepeated() => new $pb.PbList<RegisterReply>();
  static RegisterReply getDefault() => _defaultInstance ??= create()..freeze();
  static RegisterReply _defaultInstance;
  static void $checkItem(RegisterReply v) {
    if (v is! RegisterReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get breezID => $_getS(0, '');
  set breezID(String v) { $_setString(0, v); }
  bool hasBreezID() => $_has(0);
  void clearBreezID() => clearField(1);
}

class PaymentRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PaymentRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'breezID')
    ..aOS(2, 'invoice')
    ..aOS(3, 'payee')
    ..aInt64(4, 'amount')
    ..hasRequiredFields = false
  ;

  PaymentRequest() : super();
  PaymentRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PaymentRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PaymentRequest clone() => new PaymentRequest()..mergeFromMessage(this);
  PaymentRequest copyWith(void Function(PaymentRequest) updates) => super.copyWith((message) => updates(message as PaymentRequest));
  $pb.BuilderInfo get info_ => _i;
  static PaymentRequest create() => new PaymentRequest();
  PaymentRequest createEmptyInstance() => create();
  static $pb.PbList<PaymentRequest> createRepeated() => new $pb.PbList<PaymentRequest>();
  static PaymentRequest getDefault() => _defaultInstance ??= create()..freeze();
  static PaymentRequest _defaultInstance;
  static void $checkItem(PaymentRequest v) {
    if (v is! PaymentRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get breezID => $_getS(0, '');
  set breezID(String v) { $_setString(0, v); }
  bool hasBreezID() => $_has(0);
  void clearBreezID() => clearField(1);

  String get invoice => $_getS(1, '');
  set invoice(String v) { $_setString(1, v); }
  bool hasInvoice() => $_has(1);
  void clearInvoice() => clearField(2);

  String get payee => $_getS(2, '');
  set payee(String v) { $_setString(2, v); }
  bool hasPayee() => $_has(2);
  void clearPayee() => clearField(3);

  Int64 get amount => $_getI64(3);
  set amount(Int64 v) { $_setInt64(3, v); }
  bool hasAmount() => $_has(3);
  void clearAmount() => clearField(4);
}

class InvoiceReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('InvoiceReply', package: const $pb.PackageName('breez'))
    ..aOS(1, 'error')
    ..hasRequiredFields = false
  ;

  InvoiceReply() : super();
  InvoiceReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  InvoiceReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  InvoiceReply clone() => new InvoiceReply()..mergeFromMessage(this);
  InvoiceReply copyWith(void Function(InvoiceReply) updates) => super.copyWith((message) => updates(message as InvoiceReply));
  $pb.BuilderInfo get info_ => _i;
  static InvoiceReply create() => new InvoiceReply();
  InvoiceReply createEmptyInstance() => create();
  static $pb.PbList<InvoiceReply> createRepeated() => new $pb.PbList<InvoiceReply>();
  static InvoiceReply getDefault() => _defaultInstance ??= create()..freeze();
  static InvoiceReply _defaultInstance;
  static void $checkItem(InvoiceReply v) {
    if (v is! InvoiceReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get error => $_getS(0, '');
  set error(String v) { $_setString(0, v); }
  bool hasError() => $_has(0);
  void clearError() => clearField(1);
}

class UploadFileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UploadFileRequest', package: const $pb.PackageName('breez'))
    ..a<List<int>>(1, 'content', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  UploadFileRequest() : super();
  UploadFileRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UploadFileRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UploadFileRequest clone() => new UploadFileRequest()..mergeFromMessage(this);
  UploadFileRequest copyWith(void Function(UploadFileRequest) updates) => super.copyWith((message) => updates(message as UploadFileRequest));
  $pb.BuilderInfo get info_ => _i;
  static UploadFileRequest create() => new UploadFileRequest();
  UploadFileRequest createEmptyInstance() => create();
  static $pb.PbList<UploadFileRequest> createRepeated() => new $pb.PbList<UploadFileRequest>();
  static UploadFileRequest getDefault() => _defaultInstance ??= create()..freeze();
  static UploadFileRequest _defaultInstance;
  static void $checkItem(UploadFileRequest v) {
    if (v is! UploadFileRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get content => $_getN(0);
  set content(List<int> v) { $_setBytes(0, v); }
  bool hasContent() => $_has(0);
  void clearContent() => clearField(1);
}

class UploadFileReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UploadFileReply', package: const $pb.PackageName('breez'))
    ..aOS(1, 'url')
    ..hasRequiredFields = false
  ;

  UploadFileReply() : super();
  UploadFileReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UploadFileReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UploadFileReply clone() => new UploadFileReply()..mergeFromMessage(this);
  UploadFileReply copyWith(void Function(UploadFileReply) updates) => super.copyWith((message) => updates(message as UploadFileReply));
  $pb.BuilderInfo get info_ => _i;
  static UploadFileReply create() => new UploadFileReply();
  UploadFileReply createEmptyInstance() => create();
  static $pb.PbList<UploadFileReply> createRepeated() => new $pb.PbList<UploadFileReply>();
  static UploadFileReply getDefault() => _defaultInstance ??= create()..freeze();
  static UploadFileReply _defaultInstance;
  static void $checkItem(UploadFileReply v) {
    if (v is! UploadFileReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get url => $_getS(0, '');
  set url(String v) { $_setString(0, v); }
  bool hasUrl() => $_has(0);
  void clearUrl() => clearField(1);
}

class PingRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PingRequest', package: const $pb.PackageName('breez'))
    ..hasRequiredFields = false
  ;

  PingRequest() : super();
  PingRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PingRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PingRequest clone() => new PingRequest()..mergeFromMessage(this);
  PingRequest copyWith(void Function(PingRequest) updates) => super.copyWith((message) => updates(message as PingRequest));
  $pb.BuilderInfo get info_ => _i;
  static PingRequest create() => new PingRequest();
  PingRequest createEmptyInstance() => create();
  static $pb.PbList<PingRequest> createRepeated() => new $pb.PbList<PingRequest>();
  static PingRequest getDefault() => _defaultInstance ??= create()..freeze();
  static PingRequest _defaultInstance;
  static void $checkItem(PingRequest v) {
    if (v is! PingRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class PingReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PingReply', package: const $pb.PackageName('breez'))
    ..aOS(1, 'version')
    ..hasRequiredFields = false
  ;

  PingReply() : super();
  PingReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PingReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PingReply clone() => new PingReply()..mergeFromMessage(this);
  PingReply copyWith(void Function(PingReply) updates) => super.copyWith((message) => updates(message as PingReply));
  $pb.BuilderInfo get info_ => _i;
  static PingReply create() => new PingReply();
  PingReply createEmptyInstance() => create();
  static $pb.PbList<PingReply> createRepeated() => new $pb.PbList<PingReply>();
  static PingReply getDefault() => _defaultInstance ??= create()..freeze();
  static PingReply _defaultInstance;
  static void $checkItem(PingReply v) {
    if (v is! PingReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get version => $_getS(0, '');
  set version(String v) { $_setString(0, v); }
  bool hasVersion() => $_has(0);
  void clearVersion() => clearField(1);
}

class OrderRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OrderRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'fullName')
    ..aOS(2, 'address')
    ..aOS(3, 'city')
    ..aOS(4, 'state')
    ..aOS(5, 'zip')
    ..aOS(6, 'country')
    ..aOS(7, 'email')
    ..hasRequiredFields = false
  ;

  OrderRequest() : super();
  OrderRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OrderRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OrderRequest clone() => new OrderRequest()..mergeFromMessage(this);
  OrderRequest copyWith(void Function(OrderRequest) updates) => super.copyWith((message) => updates(message as OrderRequest));
  $pb.BuilderInfo get info_ => _i;
  static OrderRequest create() => new OrderRequest();
  OrderRequest createEmptyInstance() => create();
  static $pb.PbList<OrderRequest> createRepeated() => new $pb.PbList<OrderRequest>();
  static OrderRequest getDefault() => _defaultInstance ??= create()..freeze();
  static OrderRequest _defaultInstance;
  static void $checkItem(OrderRequest v) {
    if (v is! OrderRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get fullName => $_getS(0, '');
  set fullName(String v) { $_setString(0, v); }
  bool hasFullName() => $_has(0);
  void clearFullName() => clearField(1);

  String get address => $_getS(1, '');
  set address(String v) { $_setString(1, v); }
  bool hasAddress() => $_has(1);
  void clearAddress() => clearField(2);

  String get city => $_getS(2, '');
  set city(String v) { $_setString(2, v); }
  bool hasCity() => $_has(2);
  void clearCity() => clearField(3);

  String get state => $_getS(3, '');
  set state(String v) { $_setString(3, v); }
  bool hasState() => $_has(3);
  void clearState() => clearField(4);

  String get zip => $_getS(4, '');
  set zip(String v) { $_setString(4, v); }
  bool hasZip() => $_has(4);
  void clearZip() => clearField(5);

  String get country => $_getS(5, '');
  set country(String v) { $_setString(5, v); }
  bool hasCountry() => $_has(5);
  void clearCountry() => clearField(6);

  String get email => $_getS(6, '');
  set email(String v) { $_setString(6, v); }
  bool hasEmail() => $_has(6);
  void clearEmail() => clearField(7);
}

class OrderReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OrderReply', package: const $pb.PackageName('breez'))
    ..hasRequiredFields = false
  ;

  OrderReply() : super();
  OrderReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OrderReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OrderReply clone() => new OrderReply()..mergeFromMessage(this);
  OrderReply copyWith(void Function(OrderReply) updates) => super.copyWith((message) => updates(message as OrderReply));
  $pb.BuilderInfo get info_ => _i;
  static OrderReply create() => new OrderReply();
  OrderReply createEmptyInstance() => create();
  static $pb.PbList<OrderReply> createRepeated() => new $pb.PbList<OrderReply>();
  static OrderReply getDefault() => _defaultInstance ??= create()..freeze();
  static OrderReply _defaultInstance;
  static void $checkItem(OrderReply v) {
    if (v is! OrderReply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class JoinCTPSessionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('JoinCTPSessionRequest', package: const $pb.PackageName('breez'))
    ..e<JoinCTPSessionRequest_PartyType>(1, 'partyType', $pb.PbFieldType.OE, JoinCTPSessionRequest_PartyType.PAYER, JoinCTPSessionRequest_PartyType.valueOf, JoinCTPSessionRequest_PartyType.values)
    ..aOS(2, 'partyName')
    ..aOS(3, 'notificationToken')
    ..aOS(4, 'sessionID')
    ..hasRequiredFields = false
  ;

  JoinCTPSessionRequest() : super();
  JoinCTPSessionRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  JoinCTPSessionRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  JoinCTPSessionRequest clone() => new JoinCTPSessionRequest()..mergeFromMessage(this);
  JoinCTPSessionRequest copyWith(void Function(JoinCTPSessionRequest) updates) => super.copyWith((message) => updates(message as JoinCTPSessionRequest));
  $pb.BuilderInfo get info_ => _i;
  static JoinCTPSessionRequest create() => new JoinCTPSessionRequest();
  JoinCTPSessionRequest createEmptyInstance() => create();
  static $pb.PbList<JoinCTPSessionRequest> createRepeated() => new $pb.PbList<JoinCTPSessionRequest>();
  static JoinCTPSessionRequest getDefault() => _defaultInstance ??= create()..freeze();
  static JoinCTPSessionRequest _defaultInstance;
  static void $checkItem(JoinCTPSessionRequest v) {
    if (v is! JoinCTPSessionRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  JoinCTPSessionRequest_PartyType get partyType => $_getN(0);
  set partyType(JoinCTPSessionRequest_PartyType v) { setField(1, v); }
  bool hasPartyType() => $_has(0);
  void clearPartyType() => clearField(1);

  String get partyName => $_getS(1, '');
  set partyName(String v) { $_setString(1, v); }
  bool hasPartyName() => $_has(1);
  void clearPartyName() => clearField(2);

  String get notificationToken => $_getS(2, '');
  set notificationToken(String v) { $_setString(2, v); }
  bool hasNotificationToken() => $_has(2);
  void clearNotificationToken() => clearField(3);

  String get sessionID => $_getS(3, '');
  set sessionID(String v) { $_setString(3, v); }
  bool hasSessionID() => $_has(3);
  void clearSessionID() => clearField(4);
}

class JoinCTPSessionResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('JoinCTPSessionResponse', package: const $pb.PackageName('breez'))
    ..aOS(1, 'sessionID')
    ..aInt64(2, 'expiry')
    ..hasRequiredFields = false
  ;

  JoinCTPSessionResponse() : super();
  JoinCTPSessionResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  JoinCTPSessionResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  JoinCTPSessionResponse clone() => new JoinCTPSessionResponse()..mergeFromMessage(this);
  JoinCTPSessionResponse copyWith(void Function(JoinCTPSessionResponse) updates) => super.copyWith((message) => updates(message as JoinCTPSessionResponse));
  $pb.BuilderInfo get info_ => _i;
  static JoinCTPSessionResponse create() => new JoinCTPSessionResponse();
  JoinCTPSessionResponse createEmptyInstance() => create();
  static $pb.PbList<JoinCTPSessionResponse> createRepeated() => new $pb.PbList<JoinCTPSessionResponse>();
  static JoinCTPSessionResponse getDefault() => _defaultInstance ??= create()..freeze();
  static JoinCTPSessionResponse _defaultInstance;
  static void $checkItem(JoinCTPSessionResponse v) {
    if (v is! JoinCTPSessionResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get sessionID => $_getS(0, '');
  set sessionID(String v) { $_setString(0, v); }
  bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);

  Int64 get expiry => $_getI64(1);
  set expiry(Int64 v) { $_setInt64(1, v); }
  bool hasExpiry() => $_has(1);
  void clearExpiry() => clearField(2);
}

class TerminateCTPSessionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('TerminateCTPSessionRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'sessionID')
    ..hasRequiredFields = false
  ;

  TerminateCTPSessionRequest() : super();
  TerminateCTPSessionRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  TerminateCTPSessionRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  TerminateCTPSessionRequest clone() => new TerminateCTPSessionRequest()..mergeFromMessage(this);
  TerminateCTPSessionRequest copyWith(void Function(TerminateCTPSessionRequest) updates) => super.copyWith((message) => updates(message as TerminateCTPSessionRequest));
  $pb.BuilderInfo get info_ => _i;
  static TerminateCTPSessionRequest create() => new TerminateCTPSessionRequest();
  TerminateCTPSessionRequest createEmptyInstance() => create();
  static $pb.PbList<TerminateCTPSessionRequest> createRepeated() => new $pb.PbList<TerminateCTPSessionRequest>();
  static TerminateCTPSessionRequest getDefault() => _defaultInstance ??= create()..freeze();
  static TerminateCTPSessionRequest _defaultInstance;
  static void $checkItem(TerminateCTPSessionRequest v) {
    if (v is! TerminateCTPSessionRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get sessionID => $_getS(0, '');
  set sessionID(String v) { $_setString(0, v); }
  bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);
}

class TerminateCTPSessionResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('TerminateCTPSessionResponse', package: const $pb.PackageName('breez'))
    ..hasRequiredFields = false
  ;

  TerminateCTPSessionResponse() : super();
  TerminateCTPSessionResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  TerminateCTPSessionResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  TerminateCTPSessionResponse clone() => new TerminateCTPSessionResponse()..mergeFromMessage(this);
  TerminateCTPSessionResponse copyWith(void Function(TerminateCTPSessionResponse) updates) => super.copyWith((message) => updates(message as TerminateCTPSessionResponse));
  $pb.BuilderInfo get info_ => _i;
  static TerminateCTPSessionResponse create() => new TerminateCTPSessionResponse();
  TerminateCTPSessionResponse createEmptyInstance() => create();
  static $pb.PbList<TerminateCTPSessionResponse> createRepeated() => new $pb.PbList<TerminateCTPSessionResponse>();
  static TerminateCTPSessionResponse getDefault() => _defaultInstance ??= create()..freeze();
  static TerminateCTPSessionResponse _defaultInstance;
  static void $checkItem(TerminateCTPSessionResponse v) {
    if (v is! TerminateCTPSessionResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class RegisterTransactionConfirmationRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RegisterTransactionConfirmationRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'txID')
    ..aOS(2, 'notificationToken')
    ..e<RegisterTransactionConfirmationRequest_NotificationType>(3, 'notificationType', $pb.PbFieldType.OE, RegisterTransactionConfirmationRequest_NotificationType.READY_RECEIVE_PAYMENT, RegisterTransactionConfirmationRequest_NotificationType.valueOf, RegisterTransactionConfirmationRequest_NotificationType.values)
    ..hasRequiredFields = false
  ;

  RegisterTransactionConfirmationRequest() : super();
  RegisterTransactionConfirmationRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RegisterTransactionConfirmationRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RegisterTransactionConfirmationRequest clone() => new RegisterTransactionConfirmationRequest()..mergeFromMessage(this);
  RegisterTransactionConfirmationRequest copyWith(void Function(RegisterTransactionConfirmationRequest) updates) => super.copyWith((message) => updates(message as RegisterTransactionConfirmationRequest));
  $pb.BuilderInfo get info_ => _i;
  static RegisterTransactionConfirmationRequest create() => new RegisterTransactionConfirmationRequest();
  RegisterTransactionConfirmationRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterTransactionConfirmationRequest> createRepeated() => new $pb.PbList<RegisterTransactionConfirmationRequest>();
  static RegisterTransactionConfirmationRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RegisterTransactionConfirmationRequest _defaultInstance;
  static void $checkItem(RegisterTransactionConfirmationRequest v) {
    if (v is! RegisterTransactionConfirmationRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get txID => $_getS(0, '');
  set txID(String v) { $_setString(0, v); }
  bool hasTxID() => $_has(0);
  void clearTxID() => clearField(1);

  String get notificationToken => $_getS(1, '');
  set notificationToken(String v) { $_setString(1, v); }
  bool hasNotificationToken() => $_has(1);
  void clearNotificationToken() => clearField(2);

  RegisterTransactionConfirmationRequest_NotificationType get notificationType => $_getN(2);
  set notificationType(RegisterTransactionConfirmationRequest_NotificationType v) { setField(3, v); }
  bool hasNotificationType() => $_has(2);
  void clearNotificationType() => clearField(3);
}

class RegisterTransactionConfirmationResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RegisterTransactionConfirmationResponse', package: const $pb.PackageName('breez'))
    ..hasRequiredFields = false
  ;

  RegisterTransactionConfirmationResponse() : super();
  RegisterTransactionConfirmationResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RegisterTransactionConfirmationResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RegisterTransactionConfirmationResponse clone() => new RegisterTransactionConfirmationResponse()..mergeFromMessage(this);
  RegisterTransactionConfirmationResponse copyWith(void Function(RegisterTransactionConfirmationResponse) updates) => super.copyWith((message) => updates(message as RegisterTransactionConfirmationResponse));
  $pb.BuilderInfo get info_ => _i;
  static RegisterTransactionConfirmationResponse create() => new RegisterTransactionConfirmationResponse();
  RegisterTransactionConfirmationResponse createEmptyInstance() => create();
  static $pb.PbList<RegisterTransactionConfirmationResponse> createRepeated() => new $pb.PbList<RegisterTransactionConfirmationResponse>();
  static RegisterTransactionConfirmationResponse getDefault() => _defaultInstance ??= create()..freeze();
  static RegisterTransactionConfirmationResponse _defaultInstance;
  static void $checkItem(RegisterTransactionConfirmationResponse v) {
    if (v is! RegisterTransactionConfirmationResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}


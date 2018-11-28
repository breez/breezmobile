///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library breez_breez;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

import 'breez.pbenum.dart';

export 'breez.pbenum.dart';

class OpenChannelRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('OpenChannelRequest')
    ..aOS(1, 'pubKey')
    ..aOS(2, 'notificationToken')
    ..hasRequiredFields = false
  ;

  OpenChannelRequest() : super();
  OpenChannelRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OpenChannelRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OpenChannelRequest clone() => new OpenChannelRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static OpenChannelRequest create() => new OpenChannelRequest();
  static PbList<OpenChannelRequest> createRepeated() => new PbList<OpenChannelRequest>();
  static OpenChannelRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyOpenChannelRequest();
    return _defaultInstance;
  }
  static OpenChannelRequest _defaultInstance;
  static void $checkItem(OpenChannelRequest v) {
    if (v is! OpenChannelRequest) checkItemFailed(v, 'OpenChannelRequest');
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

class _ReadonlyOpenChannelRequest extends OpenChannelRequest with ReadonlyMessageMixin {}

class OpenChannelReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('OpenChannelReply')
    ..hasRequiredFields = false
  ;

  OpenChannelReply() : super();
  OpenChannelReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OpenChannelReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OpenChannelReply clone() => new OpenChannelReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static OpenChannelReply create() => new OpenChannelReply();
  static PbList<OpenChannelReply> createRepeated() => new PbList<OpenChannelReply>();
  static OpenChannelReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyOpenChannelReply();
    return _defaultInstance;
  }
  static OpenChannelReply _defaultInstance;
  static void $checkItem(OpenChannelReply v) {
    if (v is! OpenChannelReply) checkItemFailed(v, 'OpenChannelReply');
  }
}

class _ReadonlyOpenChannelReply extends OpenChannelReply with ReadonlyMessageMixin {}

class UpdateChannelPolicyRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UpdateChannelPolicyRequest')
    ..aOS(1, 'pubKey')
    ..hasRequiredFields = false
  ;

  UpdateChannelPolicyRequest() : super();
  UpdateChannelPolicyRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateChannelPolicyRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateChannelPolicyRequest clone() => new UpdateChannelPolicyRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UpdateChannelPolicyRequest create() => new UpdateChannelPolicyRequest();
  static PbList<UpdateChannelPolicyRequest> createRepeated() => new PbList<UpdateChannelPolicyRequest>();
  static UpdateChannelPolicyRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUpdateChannelPolicyRequest();
    return _defaultInstance;
  }
  static UpdateChannelPolicyRequest _defaultInstance;
  static void $checkItem(UpdateChannelPolicyRequest v) {
    if (v is! UpdateChannelPolicyRequest) checkItemFailed(v, 'UpdateChannelPolicyRequest');
  }

  String get pubKey => $_getS(0, '');
  set pubKey(String v) { $_setString(0, v); }
  bool hasPubKey() => $_has(0);
  void clearPubKey() => clearField(1);
}

class _ReadonlyUpdateChannelPolicyRequest extends UpdateChannelPolicyRequest with ReadonlyMessageMixin {}

class UpdateChannelPolicyReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UpdateChannelPolicyReply')
    ..hasRequiredFields = false
  ;

  UpdateChannelPolicyReply() : super();
  UpdateChannelPolicyReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateChannelPolicyReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateChannelPolicyReply clone() => new UpdateChannelPolicyReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UpdateChannelPolicyReply create() => new UpdateChannelPolicyReply();
  static PbList<UpdateChannelPolicyReply> createRepeated() => new PbList<UpdateChannelPolicyReply>();
  static UpdateChannelPolicyReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUpdateChannelPolicyReply();
    return _defaultInstance;
  }
  static UpdateChannelPolicyReply _defaultInstance;
  static void $checkItem(UpdateChannelPolicyReply v) {
    if (v is! UpdateChannelPolicyReply) checkItemFailed(v, 'UpdateChannelPolicyReply');
  }
}

class _ReadonlyUpdateChannelPolicyReply extends UpdateChannelPolicyReply with ReadonlyMessageMixin {}

class AddFundInitRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AddFundInitRequest')
    ..aOS(1, 'nodeID')
    ..aOS(2, 'notificationToken')
    ..a<List<int>>(3, 'pubkey', PbFieldType.OY)
    ..a<List<int>>(4, 'hash', PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  AddFundInitRequest() : super();
  AddFundInitRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundInitRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundInitRequest clone() => new AddFundInitRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static AddFundInitRequest create() => new AddFundInitRequest();
  static PbList<AddFundInitRequest> createRepeated() => new PbList<AddFundInitRequest>();
  static AddFundInitRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyAddFundInitRequest();
    return _defaultInstance;
  }
  static AddFundInitRequest _defaultInstance;
  static void $checkItem(AddFundInitRequest v) {
    if (v is! AddFundInitRequest) checkItemFailed(v, 'AddFundInitRequest');
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

class _ReadonlyAddFundInitRequest extends AddFundInitRequest with ReadonlyMessageMixin {}

class AddFundInitReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AddFundInitReply')
    ..aOS(1, 'address')
    ..a<List<int>>(2, 'pubkey', PbFieldType.OY)
    ..aInt64(3, 'lockHeight')
    ..aInt64(4, 'maxAllowedDeposit')
    ..aOS(5, 'errorMessage')
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

class _ReadonlyAddFundInitReply extends AddFundInitReply with ReadonlyMessageMixin {}

class AddFundStatusRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AddFundStatusRequest')
    ..pPS(1, 'addresses')
    ..aOS(2, 'notificationToken')
    ..hasRequiredFields = false
  ;

  AddFundStatusRequest() : super();
  AddFundStatusRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundStatusRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundStatusRequest clone() => new AddFundStatusRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static AddFundStatusRequest create() => new AddFundStatusRequest();
  static PbList<AddFundStatusRequest> createRepeated() => new PbList<AddFundStatusRequest>();
  static AddFundStatusRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyAddFundStatusRequest();
    return _defaultInstance;
  }
  static AddFundStatusRequest _defaultInstance;
  static void $checkItem(AddFundStatusRequest v) {
    if (v is! AddFundStatusRequest) checkItemFailed(v, 'AddFundStatusRequest');
  }

  List<String> get addresses => $_getList(0);

  String get notificationToken => $_getS(1, '');
  set notificationToken(String v) { $_setString(1, v); }
  bool hasNotificationToken() => $_has(1);
  void clearNotificationToken() => clearField(2);
}

class _ReadonlyAddFundStatusRequest extends AddFundStatusRequest with ReadonlyMessageMixin {}

class AddFundStatusReply_AddressStatus extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AddFundStatusReply_AddressStatus')
    ..aOS(1, 'tx')
    ..aInt64(2, 'amount')
    ..aOB(3, 'confirmed')
    ..aOS(4, 'blockHash')
    ..hasRequiredFields = false
  ;

  AddFundStatusReply_AddressStatus() : super();
  AddFundStatusReply_AddressStatus.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundStatusReply_AddressStatus.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundStatusReply_AddressStatus clone() => new AddFundStatusReply_AddressStatus()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static AddFundStatusReply_AddressStatus create() => new AddFundStatusReply_AddressStatus();
  static PbList<AddFundStatusReply_AddressStatus> createRepeated() => new PbList<AddFundStatusReply_AddressStatus>();
  static AddFundStatusReply_AddressStatus getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyAddFundStatusReply_AddressStatus();
    return _defaultInstance;
  }
  static AddFundStatusReply_AddressStatus _defaultInstance;
  static void $checkItem(AddFundStatusReply_AddressStatus v) {
    if (v is! AddFundStatusReply_AddressStatus) checkItemFailed(v, 'AddFundStatusReply_AddressStatus');
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

class _ReadonlyAddFundStatusReply_AddressStatus extends AddFundStatusReply_AddressStatus with ReadonlyMessageMixin {}

class AddFundStatusReply_StatusesEntry extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AddFundStatusReply_StatusesEntry')
    ..aOS(1, 'key')
    ..a<AddFundStatusReply_AddressStatus>(2, 'value', PbFieldType.OM, AddFundStatusReply_AddressStatus.getDefault, AddFundStatusReply_AddressStatus.create)
    ..hasRequiredFields = false
  ;

  AddFundStatusReply_StatusesEntry() : super();
  AddFundStatusReply_StatusesEntry.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundStatusReply_StatusesEntry.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundStatusReply_StatusesEntry clone() => new AddFundStatusReply_StatusesEntry()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static AddFundStatusReply_StatusesEntry create() => new AddFundStatusReply_StatusesEntry();
  static PbList<AddFundStatusReply_StatusesEntry> createRepeated() => new PbList<AddFundStatusReply_StatusesEntry>();
  static AddFundStatusReply_StatusesEntry getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyAddFundStatusReply_StatusesEntry();
    return _defaultInstance;
  }
  static AddFundStatusReply_StatusesEntry _defaultInstance;
  static void $checkItem(AddFundStatusReply_StatusesEntry v) {
    if (v is! AddFundStatusReply_StatusesEntry) checkItemFailed(v, 'AddFundStatusReply_StatusesEntry');
  }

  String get key => $_getS(0, '');
  set key(String v) { $_setString(0, v); }
  bool hasKey() => $_has(0);
  void clearKey() => clearField(1);

  AddFundStatusReply_AddressStatus get value => $_getN(1);
  set value(AddFundStatusReply_AddressStatus v) { setField(2, v); }
  bool hasValue() => $_has(1);
  void clearValue() => clearField(2);
}

class _ReadonlyAddFundStatusReply_StatusesEntry extends AddFundStatusReply_StatusesEntry with ReadonlyMessageMixin {}

class AddFundStatusReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AddFundStatusReply')
    ..pp<AddFundStatusReply_StatusesEntry>(1, 'statuses', PbFieldType.PM, AddFundStatusReply_StatusesEntry.$checkItem, AddFundStatusReply_StatusesEntry.create)
    ..hasRequiredFields = false
  ;

  AddFundStatusReply() : super();
  AddFundStatusReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundStatusReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundStatusReply clone() => new AddFundStatusReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static AddFundStatusReply create() => new AddFundStatusReply();
  static PbList<AddFundStatusReply> createRepeated() => new PbList<AddFundStatusReply>();
  static AddFundStatusReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyAddFundStatusReply();
    return _defaultInstance;
  }
  static AddFundStatusReply _defaultInstance;
  static void $checkItem(AddFundStatusReply v) {
    if (v is! AddFundStatusReply) checkItemFailed(v, 'AddFundStatusReply');
  }

  List<AddFundStatusReply_StatusesEntry> get statuses => $_getList(0);
}

class _ReadonlyAddFundStatusReply extends AddFundStatusReply with ReadonlyMessageMixin {}

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
    ..aOS(1, 'paymentRequest')
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

  String get paymentRequest => $_getS(0, '');
  set paymentRequest(String v) { $_setString(0, v); }
  bool hasPaymentRequest() => $_has(0);
  void clearPaymentRequest() => clearField(1);

  String get errorMessage => $_getS(1, '');
  set errorMessage(String v) { $_setString(1, v); }
  bool hasErrorMessage() => $_has(1);
  void clearErrorMessage() => clearField(2);
}

class _ReadonlyRemoveFundReply extends RemoveFundReply with ReadonlyMessageMixin {}

class RedeemRemovedFundsRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RedeemRemovedFundsRequest')
    ..aOS(1, 'paymenthash')
    ..hasRequiredFields = false
  ;

  RedeemRemovedFundsRequest() : super();
  RedeemRemovedFundsRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RedeemRemovedFundsRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RedeemRemovedFundsRequest clone() => new RedeemRemovedFundsRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RedeemRemovedFundsRequest create() => new RedeemRemovedFundsRequest();
  static PbList<RedeemRemovedFundsRequest> createRepeated() => new PbList<RedeemRemovedFundsRequest>();
  static RedeemRemovedFundsRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRedeemRemovedFundsRequest();
    return _defaultInstance;
  }
  static RedeemRemovedFundsRequest _defaultInstance;
  static void $checkItem(RedeemRemovedFundsRequest v) {
    if (v is! RedeemRemovedFundsRequest) checkItemFailed(v, 'RedeemRemovedFundsRequest');
  }

  String get paymenthash => $_getS(0, '');
  set paymenthash(String v) { $_setString(0, v); }
  bool hasPaymenthash() => $_has(0);
  void clearPaymenthash() => clearField(1);
}

class _ReadonlyRedeemRemovedFundsRequest extends RedeemRemovedFundsRequest with ReadonlyMessageMixin {}

class RedeemRemovedFundsReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RedeemRemovedFundsReply')
    ..aOS(1, 'txid')
    ..hasRequiredFields = false
  ;

  RedeemRemovedFundsReply() : super();
  RedeemRemovedFundsReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RedeemRemovedFundsReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RedeemRemovedFundsReply clone() => new RedeemRemovedFundsReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RedeemRemovedFundsReply create() => new RedeemRemovedFundsReply();
  static PbList<RedeemRemovedFundsReply> createRepeated() => new PbList<RedeemRemovedFundsReply>();
  static RedeemRemovedFundsReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRedeemRemovedFundsReply();
    return _defaultInstance;
  }
  static RedeemRemovedFundsReply _defaultInstance;
  static void $checkItem(RedeemRemovedFundsReply v) {
    if (v is! RedeemRemovedFundsReply) checkItemFailed(v, 'RedeemRemovedFundsReply');
  }

  String get txid => $_getS(0, '');
  set txid(String v) { $_setString(0, v); }
  bool hasTxid() => $_has(0);
  void clearTxid() => clearField(1);
}

class _ReadonlyRedeemRemovedFundsReply extends RedeemRemovedFundsReply with ReadonlyMessageMixin {}

class FundRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FundRequest')
    ..aOS(1, 'deviceID')
    ..aOS(2, 'lightningID')
    ..aInt64(3, 'amount')
    ..hasRequiredFields = false
  ;

  FundRequest() : super();
  FundRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FundRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FundRequest clone() => new FundRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FundRequest create() => new FundRequest();
  static PbList<FundRequest> createRepeated() => new PbList<FundRequest>();
  static FundRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyFundRequest();
    return _defaultInstance;
  }
  static FundRequest _defaultInstance;
  static void $checkItem(FundRequest v) {
    if (v is! FundRequest) checkItemFailed(v, 'FundRequest');
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

class _ReadonlyFundRequest extends FundRequest with ReadonlyMessageMixin {}

class FundReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FundReply')
    ..e<FundReply_ReturnCode>(1, 'returnCode', PbFieldType.OE, FundReply_ReturnCode.SUCCESS, FundReply_ReturnCode.valueOf, FundReply_ReturnCode.values)
    ..hasRequiredFields = false
  ;

  FundReply() : super();
  FundReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FundReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FundReply clone() => new FundReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FundReply create() => new FundReply();
  static PbList<FundReply> createRepeated() => new PbList<FundReply>();
  static FundReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyFundReply();
    return _defaultInstance;
  }
  static FundReply _defaultInstance;
  static void $checkItem(FundReply v) {
    if (v is! FundReply) checkItemFailed(v, 'FundReply');
  }

  FundReply_ReturnCode get returnCode => $_getN(0);
  set returnCode(FundReply_ReturnCode v) { setField(1, v); }
  bool hasReturnCode() => $_has(0);
  void clearReturnCode() => clearField(1);
}

class _ReadonlyFundReply extends FundReply with ReadonlyMessageMixin {}

class GetSwapPaymentRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('GetSwapPaymentRequest')
    ..aOS(1, 'paymentRequest')
    ..hasRequiredFields = false
  ;

  GetSwapPaymentRequest() : super();
  GetSwapPaymentRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetSwapPaymentRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetSwapPaymentRequest clone() => new GetSwapPaymentRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static GetSwapPaymentRequest create() => new GetSwapPaymentRequest();
  static PbList<GetSwapPaymentRequest> createRepeated() => new PbList<GetSwapPaymentRequest>();
  static GetSwapPaymentRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyGetSwapPaymentRequest();
    return _defaultInstance;
  }
  static GetSwapPaymentRequest _defaultInstance;
  static void $checkItem(GetSwapPaymentRequest v) {
    if (v is! GetSwapPaymentRequest) checkItemFailed(v, 'GetSwapPaymentRequest');
  }

  String get paymentRequest => $_getS(0, '');
  set paymentRequest(String v) { $_setString(0, v); }
  bool hasPaymentRequest() => $_has(0);
  void clearPaymentRequest() => clearField(1);
}

class _ReadonlyGetSwapPaymentRequest extends GetSwapPaymentRequest with ReadonlyMessageMixin {}

class GetSwapPaymentReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('GetSwapPaymentReply')
    ..aOS(1, 'paymentError')
    ..hasRequiredFields = false
  ;

  GetSwapPaymentReply() : super();
  GetSwapPaymentReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetSwapPaymentReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetSwapPaymentReply clone() => new GetSwapPaymentReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static GetSwapPaymentReply create() => new GetSwapPaymentReply();
  static PbList<GetSwapPaymentReply> createRepeated() => new PbList<GetSwapPaymentReply>();
  static GetSwapPaymentReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyGetSwapPaymentReply();
    return _defaultInstance;
  }
  static GetSwapPaymentReply _defaultInstance;
  static void $checkItem(GetSwapPaymentReply v) {
    if (v is! GetSwapPaymentReply) checkItemFailed(v, 'GetSwapPaymentReply');
  }

  String get paymentError => $_getS(0, '');
  set paymentError(String v) { $_setString(0, v); }
  bool hasPaymentError() => $_has(0);
  void clearPaymentError() => clearField(1);
}

class _ReadonlyGetSwapPaymentReply extends GetSwapPaymentReply with ReadonlyMessageMixin {}

class RegisterRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RegisterRequest')
    ..aOS(1, 'deviceID')
    ..aOS(2, 'lightningID')
    ..hasRequiredFields = false
  ;

  RegisterRequest() : super();
  RegisterRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RegisterRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RegisterRequest clone() => new RegisterRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RegisterRequest create() => new RegisterRequest();
  static PbList<RegisterRequest> createRepeated() => new PbList<RegisterRequest>();
  static RegisterRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRegisterRequest();
    return _defaultInstance;
  }
  static RegisterRequest _defaultInstance;
  static void $checkItem(RegisterRequest v) {
    if (v is! RegisterRequest) checkItemFailed(v, 'RegisterRequest');
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

class _ReadonlyRegisterRequest extends RegisterRequest with ReadonlyMessageMixin {}

class RegisterReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RegisterReply')
    ..aOS(1, 'breezID')
    ..hasRequiredFields = false
  ;

  RegisterReply() : super();
  RegisterReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RegisterReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RegisterReply clone() => new RegisterReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RegisterReply create() => new RegisterReply();
  static PbList<RegisterReply> createRepeated() => new PbList<RegisterReply>();
  static RegisterReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRegisterReply();
    return _defaultInstance;
  }
  static RegisterReply _defaultInstance;
  static void $checkItem(RegisterReply v) {
    if (v is! RegisterReply) checkItemFailed(v, 'RegisterReply');
  }

  String get breezID => $_getS(0, '');
  set breezID(String v) { $_setString(0, v); }
  bool hasBreezID() => $_has(0);
  void clearBreezID() => clearField(1);
}

class _ReadonlyRegisterReply extends RegisterReply with ReadonlyMessageMixin {}

class PaymentRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PaymentRequest')
    ..aOS(1, 'breezID')
    ..aOS(2, 'invoice')
    ..aOS(3, 'payee')
    ..aInt64(4, 'amount')
    ..hasRequiredFields = false
  ;

  PaymentRequest() : super();
  PaymentRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PaymentRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PaymentRequest clone() => new PaymentRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PaymentRequest create() => new PaymentRequest();
  static PbList<PaymentRequest> createRepeated() => new PbList<PaymentRequest>();
  static PaymentRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyPaymentRequest();
    return _defaultInstance;
  }
  static PaymentRequest _defaultInstance;
  static void $checkItem(PaymentRequest v) {
    if (v is! PaymentRequest) checkItemFailed(v, 'PaymentRequest');
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

class _ReadonlyPaymentRequest extends PaymentRequest with ReadonlyMessageMixin {}

class InvoiceReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('InvoiceReply')
    ..aOS(1, 'error')
    ..hasRequiredFields = false
  ;

  InvoiceReply() : super();
  InvoiceReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  InvoiceReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  InvoiceReply clone() => new InvoiceReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static InvoiceReply create() => new InvoiceReply();
  static PbList<InvoiceReply> createRepeated() => new PbList<InvoiceReply>();
  static InvoiceReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyInvoiceReply();
    return _defaultInstance;
  }
  static InvoiceReply _defaultInstance;
  static void $checkItem(InvoiceReply v) {
    if (v is! InvoiceReply) checkItemFailed(v, 'InvoiceReply');
  }

  String get error => $_getS(0, '');
  set error(String v) { $_setString(0, v); }
  bool hasError() => $_has(0);
  void clearError() => clearField(1);
}

class _ReadonlyInvoiceReply extends InvoiceReply with ReadonlyMessageMixin {}

class UploadFileRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UploadFileRequest')
    ..a<List<int>>(1, 'content', PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  UploadFileRequest() : super();
  UploadFileRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UploadFileRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UploadFileRequest clone() => new UploadFileRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UploadFileRequest create() => new UploadFileRequest();
  static PbList<UploadFileRequest> createRepeated() => new PbList<UploadFileRequest>();
  static UploadFileRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUploadFileRequest();
    return _defaultInstance;
  }
  static UploadFileRequest _defaultInstance;
  static void $checkItem(UploadFileRequest v) {
    if (v is! UploadFileRequest) checkItemFailed(v, 'UploadFileRequest');
  }

  List<int> get content => $_getN(0);
  set content(List<int> v) { $_setBytes(0, v); }
  bool hasContent() => $_has(0);
  void clearContent() => clearField(1);
}

class _ReadonlyUploadFileRequest extends UploadFileRequest with ReadonlyMessageMixin {}

class UploadFileReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UploadFileReply')
    ..aOS(1, 'url')
    ..hasRequiredFields = false
  ;

  UploadFileReply() : super();
  UploadFileReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UploadFileReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UploadFileReply clone() => new UploadFileReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UploadFileReply create() => new UploadFileReply();
  static PbList<UploadFileReply> createRepeated() => new PbList<UploadFileReply>();
  static UploadFileReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUploadFileReply();
    return _defaultInstance;
  }
  static UploadFileReply _defaultInstance;
  static void $checkItem(UploadFileReply v) {
    if (v is! UploadFileReply) checkItemFailed(v, 'UploadFileReply');
  }

  String get url => $_getS(0, '');
  set url(String v) { $_setString(0, v); }
  bool hasUrl() => $_has(0);
  void clearUrl() => clearField(1);
}

class _ReadonlyUploadFileReply extends UploadFileReply with ReadonlyMessageMixin {}

class PingRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PingRequest')
    ..hasRequiredFields = false
  ;

  PingRequest() : super();
  PingRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PingRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PingRequest clone() => new PingRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PingRequest create() => new PingRequest();
  static PbList<PingRequest> createRepeated() => new PbList<PingRequest>();
  static PingRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyPingRequest();
    return _defaultInstance;
  }
  static PingRequest _defaultInstance;
  static void $checkItem(PingRequest v) {
    if (v is! PingRequest) checkItemFailed(v, 'PingRequest');
  }
}

class _ReadonlyPingRequest extends PingRequest with ReadonlyMessageMixin {}

class PingReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PingReply')
    ..aOS(1, 'version')
    ..hasRequiredFields = false
  ;

  PingReply() : super();
  PingReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PingReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PingReply clone() => new PingReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PingReply create() => new PingReply();
  static PbList<PingReply> createRepeated() => new PbList<PingReply>();
  static PingReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyPingReply();
    return _defaultInstance;
  }
  static PingReply _defaultInstance;
  static void $checkItem(PingReply v) {
    if (v is! PingReply) checkItemFailed(v, 'PingReply');
  }

  String get version => $_getS(0, '');
  set version(String v) { $_setString(0, v); }
  bool hasVersion() => $_has(0);
  void clearVersion() => clearField(1);
}

class _ReadonlyPingReply extends PingReply with ReadonlyMessageMixin {}

class OrderRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('OrderRequest')
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
  OrderRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OrderRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OrderRequest clone() => new OrderRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static OrderRequest create() => new OrderRequest();
  static PbList<OrderRequest> createRepeated() => new PbList<OrderRequest>();
  static OrderRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyOrderRequest();
    return _defaultInstance;
  }
  static OrderRequest _defaultInstance;
  static void $checkItem(OrderRequest v) {
    if (v is! OrderRequest) checkItemFailed(v, 'OrderRequest');
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

class _ReadonlyOrderRequest extends OrderRequest with ReadonlyMessageMixin {}

class OrderReply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('OrderReply')
    ..hasRequiredFields = false
  ;

  OrderReply() : super();
  OrderReply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OrderReply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OrderReply clone() => new OrderReply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static OrderReply create() => new OrderReply();
  static PbList<OrderReply> createRepeated() => new PbList<OrderReply>();
  static OrderReply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyOrderReply();
    return _defaultInstance;
  }
  static OrderReply _defaultInstance;
  static void $checkItem(OrderReply v) {
    if (v is! OrderReply) checkItemFailed(v, 'OrderReply');
  }
}

class _ReadonlyOrderReply extends OrderReply with ReadonlyMessageMixin {}

class JoinCTPSessionRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('JoinCTPSessionRequest')
    ..e<JoinCTPSessionRequest_PartyType>(1, 'partyType', PbFieldType.OE, JoinCTPSessionRequest_PartyType.PAYER, JoinCTPSessionRequest_PartyType.valueOf, JoinCTPSessionRequest_PartyType.values)
    ..aOS(2, 'partyName')
    ..aOS(3, 'notificationToken')
    ..aOS(4, 'sessionID')
    ..hasRequiredFields = false
  ;

  JoinCTPSessionRequest() : super();
  JoinCTPSessionRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  JoinCTPSessionRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  JoinCTPSessionRequest clone() => new JoinCTPSessionRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static JoinCTPSessionRequest create() => new JoinCTPSessionRequest();
  static PbList<JoinCTPSessionRequest> createRepeated() => new PbList<JoinCTPSessionRequest>();
  static JoinCTPSessionRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyJoinCTPSessionRequest();
    return _defaultInstance;
  }
  static JoinCTPSessionRequest _defaultInstance;
  static void $checkItem(JoinCTPSessionRequest v) {
    if (v is! JoinCTPSessionRequest) checkItemFailed(v, 'JoinCTPSessionRequest');
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

class _ReadonlyJoinCTPSessionRequest extends JoinCTPSessionRequest with ReadonlyMessageMixin {}

class JoinCTPSessionResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('JoinCTPSessionResponse')
    ..aOS(1, 'sessionID')
    ..aInt64(2, 'expiry')
    ..hasRequiredFields = false
  ;

  JoinCTPSessionResponse() : super();
  JoinCTPSessionResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  JoinCTPSessionResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  JoinCTPSessionResponse clone() => new JoinCTPSessionResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static JoinCTPSessionResponse create() => new JoinCTPSessionResponse();
  static PbList<JoinCTPSessionResponse> createRepeated() => new PbList<JoinCTPSessionResponse>();
  static JoinCTPSessionResponse getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyJoinCTPSessionResponse();
    return _defaultInstance;
  }
  static JoinCTPSessionResponse _defaultInstance;
  static void $checkItem(JoinCTPSessionResponse v) {
    if (v is! JoinCTPSessionResponse) checkItemFailed(v, 'JoinCTPSessionResponse');
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

class _ReadonlyJoinCTPSessionResponse extends JoinCTPSessionResponse with ReadonlyMessageMixin {}

class TerminateCTPSessionRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('TerminateCTPSessionRequest')
    ..aOS(1, 'sessionID')
    ..hasRequiredFields = false
  ;

  TerminateCTPSessionRequest() : super();
  TerminateCTPSessionRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  TerminateCTPSessionRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  TerminateCTPSessionRequest clone() => new TerminateCTPSessionRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static TerminateCTPSessionRequest create() => new TerminateCTPSessionRequest();
  static PbList<TerminateCTPSessionRequest> createRepeated() => new PbList<TerminateCTPSessionRequest>();
  static TerminateCTPSessionRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyTerminateCTPSessionRequest();
    return _defaultInstance;
  }
  static TerminateCTPSessionRequest _defaultInstance;
  static void $checkItem(TerminateCTPSessionRequest v) {
    if (v is! TerminateCTPSessionRequest) checkItemFailed(v, 'TerminateCTPSessionRequest');
  }

  String get sessionID => $_getS(0, '');
  set sessionID(String v) { $_setString(0, v); }
  bool hasSessionID() => $_has(0);
  void clearSessionID() => clearField(1);
}

class _ReadonlyTerminateCTPSessionRequest extends TerminateCTPSessionRequest with ReadonlyMessageMixin {}

class TerminateCTPSessionResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('TerminateCTPSessionResponse')
    ..hasRequiredFields = false
  ;

  TerminateCTPSessionResponse() : super();
  TerminateCTPSessionResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  TerminateCTPSessionResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  TerminateCTPSessionResponse clone() => new TerminateCTPSessionResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static TerminateCTPSessionResponse create() => new TerminateCTPSessionResponse();
  static PbList<TerminateCTPSessionResponse> createRepeated() => new PbList<TerminateCTPSessionResponse>();
  static TerminateCTPSessionResponse getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyTerminateCTPSessionResponse();
    return _defaultInstance;
  }
  static TerminateCTPSessionResponse _defaultInstance;
  static void $checkItem(TerminateCTPSessionResponse v) {
    if (v is! TerminateCTPSessionResponse) checkItemFailed(v, 'TerminateCTPSessionResponse');
  }
}

class _ReadonlyTerminateCTPSessionResponse extends TerminateCTPSessionResponse with ReadonlyMessageMixin {}

class RegisterTransactionConfirmationRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RegisterTransactionConfirmationRequest')
    ..aOS(1, 'txID')
    ..aOS(2, 'notificationToken')
    ..e<RegisterTransactionConfirmationRequest_NotificationType>(3, 'notificationType', PbFieldType.OE, RegisterTransactionConfirmationRequest_NotificationType.READY_RECEIVE_PAYMENT, RegisterTransactionConfirmationRequest_NotificationType.valueOf, RegisterTransactionConfirmationRequest_NotificationType.values)
    ..hasRequiredFields = false
  ;

  RegisterTransactionConfirmationRequest() : super();
  RegisterTransactionConfirmationRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RegisterTransactionConfirmationRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RegisterTransactionConfirmationRequest clone() => new RegisterTransactionConfirmationRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RegisterTransactionConfirmationRequest create() => new RegisterTransactionConfirmationRequest();
  static PbList<RegisterTransactionConfirmationRequest> createRepeated() => new PbList<RegisterTransactionConfirmationRequest>();
  static RegisterTransactionConfirmationRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRegisterTransactionConfirmationRequest();
    return _defaultInstance;
  }
  static RegisterTransactionConfirmationRequest _defaultInstance;
  static void $checkItem(RegisterTransactionConfirmationRequest v) {
    if (v is! RegisterTransactionConfirmationRequest) checkItemFailed(v, 'RegisterTransactionConfirmationRequest');
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

class _ReadonlyRegisterTransactionConfirmationRequest extends RegisterTransactionConfirmationRequest with ReadonlyMessageMixin {}

class RegisterTransactionConfirmationResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RegisterTransactionConfirmationResponse')
    ..hasRequiredFields = false
  ;

  RegisterTransactionConfirmationResponse() : super();
  RegisterTransactionConfirmationResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RegisterTransactionConfirmationResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RegisterTransactionConfirmationResponse clone() => new RegisterTransactionConfirmationResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RegisterTransactionConfirmationResponse create() => new RegisterTransactionConfirmationResponse();
  static PbList<RegisterTransactionConfirmationResponse> createRepeated() => new PbList<RegisterTransactionConfirmationResponse>();
  static RegisterTransactionConfirmationResponse getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRegisterTransactionConfirmationResponse();
    return _defaultInstance;
  }
  static RegisterTransactionConfirmationResponse _defaultInstance;
  static void $checkItem(RegisterTransactionConfirmationResponse v) {
    if (v is! RegisterTransactionConfirmationResponse) checkItemFailed(v, 'RegisterTransactionConfirmationResponse');
  }
}

class _ReadonlyRegisterTransactionConfirmationResponse extends RegisterTransactionConfirmationResponse with ReadonlyMessageMixin {}


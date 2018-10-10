///
//  Generated code. Do not modify.
//  source: breez.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'breez.pbenum.dart';

export 'breez.pbenum.dart';

class AddFundRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AddFundRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'paymentRequest')
    ..aOS(2, 'clientID')
    ..hasRequiredFields = false
  ;

  AddFundRequest() : super();
  AddFundRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AddFundRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AddFundRequest clone() => new AddFundRequest()..mergeFromMessage(this);
  AddFundRequest copyWith(void Function(AddFundRequest) updates) => super.copyWith((message) => updates(message as AddFundRequest));
  $pb.BuilderInfo get info_ => _i;
  static AddFundRequest create() => new AddFundRequest();
  static $pb.PbList<AddFundRequest> createRepeated() => new $pb.PbList<AddFundRequest>();
  static AddFundRequest getDefault() => _defaultInstance ??= create()..freeze();
  static AddFundRequest _defaultInstance;
  static void $checkItem(AddFundRequest v) {
    if (v is! AddFundRequest) $pb.checkItemFailed(v, _i.messageName);
  }

  String get paymentRequest => $_getS(0, '');
  set paymentRequest(String v) { $_setString(0, v); }
  bool hasPaymentRequest() => $_has(0);
  void clearPaymentRequest() => clearField(1);

  String get clientID => $_getS(1, '');
  set clientID(String v) { $_setString(1, v); }
  bool hasClientID() => $_has(1);
  void clearClientID() => clearField(2);
}

class AddFundReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AddFundReply', package: const $pb.PackageName('breez'))
    ..aOS(1, 'address')
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
    if (v is! AddFundReply) $pb.checkItemFailed(v, _i.messageName);
  }

  String get address => $_getS(0, '');
  set address(String v) { $_setString(0, v); }
  bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);
}

class RemoveFundRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RemoveFundRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'address')
    ..a<double>(2, 'amount', $pb.PbFieldType.OD)
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
    if (v is! RemoveFundRequest) $pb.checkItemFailed(v, _i.messageName);
  }

  String get address => $_getS(0, '');
  set address(String v) { $_setString(0, v); }
  bool hasAddress() => $_has(0);
  void clearAddress() => clearField(1);

  double get amount => $_getN(1);
  set amount(double v) { $_setDouble(1, v); }
  bool hasAmount() => $_has(1);
  void clearAmount() => clearField(2);
}

class RemoveFundReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RemoveFundReply', package: const $pb.PackageName('breez'))
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
    if (v is! RemoveFundReply) $pb.checkItemFailed(v, _i.messageName);
  }
}

class MempoolRegisterRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('MempoolRegisterRequest', package: const $pb.PackageName('breez'))
    ..aOS(1, 'clientID')
    ..pPS(2, 'addresses')
    ..hasRequiredFields = false
  ;

  MempoolRegisterRequest() : super();
  MempoolRegisterRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MempoolRegisterRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MempoolRegisterRequest clone() => new MempoolRegisterRequest()..mergeFromMessage(this);
  MempoolRegisterRequest copyWith(void Function(MempoolRegisterRequest) updates) => super.copyWith((message) => updates(message as MempoolRegisterRequest));
  $pb.BuilderInfo get info_ => _i;
  static MempoolRegisterRequest create() => new MempoolRegisterRequest();
  static $pb.PbList<MempoolRegisterRequest> createRepeated() => new $pb.PbList<MempoolRegisterRequest>();
  static MempoolRegisterRequest getDefault() => _defaultInstance ??= create()..freeze();
  static MempoolRegisterRequest _defaultInstance;
  static void $checkItem(MempoolRegisterRequest v) {
    if (v is! MempoolRegisterRequest) $pb.checkItemFailed(v, _i.messageName);
  }

  String get clientID => $_getS(0, '');
  set clientID(String v) { $_setString(0, v); }
  bool hasClientID() => $_has(0);
  void clearClientID() => clearField(1);

  List<String> get addresses => $_getList(1);
}

class MempoolRegisterReply_Transaction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('MempoolRegisterReply.Transaction', package: const $pb.PackageName('breez'))
    ..aOS(1, 'tX')
    ..aOS(2, 'address')
    ..a<double>(3, 'value', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  MempoolRegisterReply_Transaction() : super();
  MempoolRegisterReply_Transaction.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MempoolRegisterReply_Transaction.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MempoolRegisterReply_Transaction clone() => new MempoolRegisterReply_Transaction()..mergeFromMessage(this);
  MempoolRegisterReply_Transaction copyWith(void Function(MempoolRegisterReply_Transaction) updates) => super.copyWith((message) => updates(message as MempoolRegisterReply_Transaction));
  $pb.BuilderInfo get info_ => _i;
  static MempoolRegisterReply_Transaction create() => new MempoolRegisterReply_Transaction();
  static $pb.PbList<MempoolRegisterReply_Transaction> createRepeated() => new $pb.PbList<MempoolRegisterReply_Transaction>();
  static MempoolRegisterReply_Transaction getDefault() => _defaultInstance ??= create()..freeze();
  static MempoolRegisterReply_Transaction _defaultInstance;
  static void $checkItem(MempoolRegisterReply_Transaction v) {
    if (v is! MempoolRegisterReply_Transaction) $pb.checkItemFailed(v, _i.messageName);
  }

  String get tX => $_getS(0, '');
  set tX(String v) { $_setString(0, v); }
  bool hasTX() => $_has(0);
  void clearTX() => clearField(1);

  String get address => $_getS(1, '');
  set address(String v) { $_setString(1, v); }
  bool hasAddress() => $_has(1);
  void clearAddress() => clearField(2);

  double get value => $_getN(2);
  set value(double v) { $_setDouble(2, v); }
  bool hasValue() => $_has(2);
  void clearValue() => clearField(3);
}

class MempoolRegisterReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('MempoolRegisterReply', package: const $pb.PackageName('breez'))
    ..pp<MempoolRegisterReply_Transaction>(1, 'tXS', $pb.PbFieldType.PM, MempoolRegisterReply_Transaction.$checkItem, MempoolRegisterReply_Transaction.create)
    ..hasRequiredFields = false
  ;

  MempoolRegisterReply() : super();
  MempoolRegisterReply.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MempoolRegisterReply.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MempoolRegisterReply clone() => new MempoolRegisterReply()..mergeFromMessage(this);
  MempoolRegisterReply copyWith(void Function(MempoolRegisterReply) updates) => super.copyWith((message) => updates(message as MempoolRegisterReply));
  $pb.BuilderInfo get info_ => _i;
  static MempoolRegisterReply create() => new MempoolRegisterReply();
  static $pb.PbList<MempoolRegisterReply> createRepeated() => new $pb.PbList<MempoolRegisterReply>();
  static MempoolRegisterReply getDefault() => _defaultInstance ??= create()..freeze();
  static MempoolRegisterReply _defaultInstance;
  static void $checkItem(MempoolRegisterReply v) {
    if (v is! MempoolRegisterReply) $pb.checkItemFailed(v, _i.messageName);
  }

  List<MempoolRegisterReply_Transaction> get tXS => $_getList(0);
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
  static $pb.PbList<FundRequest> createRepeated() => new $pb.PbList<FundRequest>();
  static FundRequest getDefault() => _defaultInstance ??= create()..freeze();
  static FundRequest _defaultInstance;
  static void $checkItem(FundRequest v) {
    if (v is! FundRequest) $pb.checkItemFailed(v, _i.messageName);
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
  static $pb.PbList<FundReply> createRepeated() => new $pb.PbList<FundReply>();
  static FundReply getDefault() => _defaultInstance ??= create()..freeze();
  static FundReply _defaultInstance;
  static void $checkItem(FundReply v) {
    if (v is! FundReply) $pb.checkItemFailed(v, _i.messageName);
  }

  FundReply_ReturnCode get returnCode => $_getN(0);
  set returnCode(FundReply_ReturnCode v) { setField(1, v); }
  bool hasReturnCode() => $_has(0);
  void clearReturnCode() => clearField(1);
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
  static $pb.PbList<RegisterRequest> createRepeated() => new $pb.PbList<RegisterRequest>();
  static RegisterRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RegisterRequest _defaultInstance;
  static void $checkItem(RegisterRequest v) {
    if (v is! RegisterRequest) $pb.checkItemFailed(v, _i.messageName);
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
  static $pb.PbList<RegisterReply> createRepeated() => new $pb.PbList<RegisterReply>();
  static RegisterReply getDefault() => _defaultInstance ??= create()..freeze();
  static RegisterReply _defaultInstance;
  static void $checkItem(RegisterReply v) {
    if (v is! RegisterReply) $pb.checkItemFailed(v, _i.messageName);
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
  static $pb.PbList<PaymentRequest> createRepeated() => new $pb.PbList<PaymentRequest>();
  static PaymentRequest getDefault() => _defaultInstance ??= create()..freeze();
  static PaymentRequest _defaultInstance;
  static void $checkItem(PaymentRequest v) {
    if (v is! PaymentRequest) $pb.checkItemFailed(v, _i.messageName);
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
  static $pb.PbList<InvoiceReply> createRepeated() => new $pb.PbList<InvoiceReply>();
  static InvoiceReply getDefault() => _defaultInstance ??= create()..freeze();
  static InvoiceReply _defaultInstance;
  static void $checkItem(InvoiceReply v) {
    if (v is! InvoiceReply) $pb.checkItemFailed(v, _i.messageName);
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
  static $pb.PbList<UploadFileRequest> createRepeated() => new $pb.PbList<UploadFileRequest>();
  static UploadFileRequest getDefault() => _defaultInstance ??= create()..freeze();
  static UploadFileRequest _defaultInstance;
  static void $checkItem(UploadFileRequest v) {
    if (v is! UploadFileRequest) $pb.checkItemFailed(v, _i.messageName);
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
  static $pb.PbList<UploadFileReply> createRepeated() => new $pb.PbList<UploadFileReply>();
  static UploadFileReply getDefault() => _defaultInstance ??= create()..freeze();
  static UploadFileReply _defaultInstance;
  static void $checkItem(UploadFileReply v) {
    if (v is! UploadFileReply) $pb.checkItemFailed(v, _i.messageName);
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
  static $pb.PbList<PingRequest> createRepeated() => new $pb.PbList<PingRequest>();
  static PingRequest getDefault() => _defaultInstance ??= create()..freeze();
  static PingRequest _defaultInstance;
  static void $checkItem(PingRequest v) {
    if (v is! PingRequest) $pb.checkItemFailed(v, _i.messageName);
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
  static $pb.PbList<PingReply> createRepeated() => new $pb.PbList<PingReply>();
  static PingReply getDefault() => _defaultInstance ??= create()..freeze();
  static PingReply _defaultInstance;
  static void $checkItem(PingReply v) {
    if (v is! PingReply) $pb.checkItemFailed(v, _i.messageName);
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
    ..hasRequiredFields = false
  ;

  OrderRequest() : super();
  OrderRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OrderRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OrderRequest clone() => new OrderRequest()..mergeFromMessage(this);
  OrderRequest copyWith(void Function(OrderRequest) updates) => super.copyWith((message) => updates(message as OrderRequest));
  $pb.BuilderInfo get info_ => _i;
  static OrderRequest create() => new OrderRequest();
  static $pb.PbList<OrderRequest> createRepeated() => new $pb.PbList<OrderRequest>();
  static OrderRequest getDefault() => _defaultInstance ??= create()..freeze();
  static OrderRequest _defaultInstance;
  static void $checkItem(OrderRequest v) {
    if (v is! OrderRequest) $pb.checkItemFailed(v, _i.messageName);
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
  static $pb.PbList<OrderReply> createRepeated() => new $pb.PbList<OrderReply>();
  static OrderReply getDefault() => _defaultInstance ??= create()..freeze();
  static OrderReply _defaultInstance;
  static void $checkItem(OrderReply v) {
    if (v is! OrderReply) $pb.checkItemFailed(v, _i.messageName);
  }
}


///
//  Generated code. Do not modify.
//  source: breez.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async';

import 'package:grpc/grpc.dart';

import 'breez.pb.dart';
export 'breez.pb.dart';

class InvoicerClient extends Client {
  static final _$registerDevice =
      new ClientMethod<RegisterRequest, RegisterReply>(
          '/breez.Invoicer/RegisterDevice',
          (RegisterRequest value) => value.writeToBuffer(),
          (List<int> value) => new RegisterReply.fromBuffer(value));
  static final _$sendInvoice = new ClientMethod<PaymentRequest, InvoiceReply>(
      '/breez.Invoicer/SendInvoice',
      (PaymentRequest value) => value.writeToBuffer(),
      (List<int> value) => new InvoiceReply.fromBuffer(value));

  InvoicerClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<RegisterReply> registerDevice(RegisterRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$registerDevice, new Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<InvoiceReply> sendInvoice(PaymentRequest request,
      {CallOptions options}) {
    final call = $createCall(_$sendInvoice, new Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class InvoicerServiceBase extends Service {
  String get $name => 'breez.Invoicer';

  InvoicerServiceBase() {
    $addMethod(new ServiceMethod<RegisterRequest, RegisterReply>(
        'RegisterDevice',
        registerDevice_Pre,
        false,
        false,
        (List<int> value) => new RegisterRequest.fromBuffer(value),
        (RegisterReply value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<PaymentRequest, InvoiceReply>(
        'SendInvoice',
        sendInvoice_Pre,
        false,
        false,
        (List<int> value) => new PaymentRequest.fromBuffer(value),
        (InvoiceReply value) => value.writeToBuffer()));
  }

  Future<RegisterReply> registerDevice_Pre(
      ServiceCall call, Future request) async {
    return registerDevice(call, await request);
  }

  Future<InvoiceReply> sendInvoice_Pre(ServiceCall call, Future request) async {
    return sendInvoice(call, await request);
  }

  Future<RegisterReply> registerDevice(
      ServiceCall call, RegisterRequest request);
  Future<InvoiceReply> sendInvoice(ServiceCall call, PaymentRequest request);
}

class CardOrdererClient extends Client {
  static final _$order = new ClientMethod<OrderRequest, OrderReply>(
      '/breez.CardOrderer/Order',
      (OrderRequest value) => value.writeToBuffer(),
      (List<int> value) => new OrderReply.fromBuffer(value));

  CardOrdererClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<OrderReply> order(OrderRequest request,
      {CallOptions options}) {
    final call = $createCall(_$order, new Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class CardOrdererServiceBase extends Service {
  String get $name => 'breez.CardOrderer';

  CardOrdererServiceBase() {
    $addMethod(new ServiceMethod<OrderRequest, OrderReply>(
        'Order',
        order_Pre,
        false,
        false,
        (List<int> value) => new OrderRequest.fromBuffer(value),
        (OrderReply value) => value.writeToBuffer()));
  }

  Future<OrderReply> order_Pre(ServiceCall call, Future request) async {
    return order(call, await request);
  }

  Future<OrderReply> order(ServiceCall call, OrderRequest request);
}

class PosClient extends Client {
  static final _$registerDevice =
      new ClientMethod<RegisterRequest, RegisterReply>(
          '/breez.Pos/RegisterDevice',
          (RegisterRequest value) => value.writeToBuffer(),
          (List<int> value) => new RegisterReply.fromBuffer(value));
  static final _$fundChannel = new ClientMethod<FundRequest, FundReply>(
      '/breez.Pos/FundChannel',
      (FundRequest value) => value.writeToBuffer(),
      (List<int> value) => new FundReply.fromBuffer(value));
  static final _$uploadLogo =
      new ClientMethod<UploadFileRequest, UploadFileReply>(
          '/breez.Pos/UploadLogo',
          (UploadFileRequest value) => value.writeToBuffer(),
          (List<int> value) => new UploadFileReply.fromBuffer(value));

  PosClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<RegisterReply> registerDevice(RegisterRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$registerDevice, new Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<FundReply> fundChannel(FundRequest request,
      {CallOptions options}) {
    final call = $createCall(_$fundChannel, new Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<UploadFileReply> uploadLogo(UploadFileRequest request,
      {CallOptions options}) {
    final call = $createCall(_$uploadLogo, new Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class PosServiceBase extends Service {
  String get $name => 'breez.Pos';

  PosServiceBase() {
    $addMethod(new ServiceMethod<RegisterRequest, RegisterReply>(
        'RegisterDevice',
        registerDevice_Pre,
        false,
        false,
        (List<int> value) => new RegisterRequest.fromBuffer(value),
        (RegisterReply value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<FundRequest, FundReply>(
        'FundChannel',
        fundChannel_Pre,
        false,
        false,
        (List<int> value) => new FundRequest.fromBuffer(value),
        (FundReply value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<UploadFileRequest, UploadFileReply>(
        'UploadLogo',
        uploadLogo_Pre,
        false,
        false,
        (List<int> value) => new UploadFileRequest.fromBuffer(value),
        (UploadFileReply value) => value.writeToBuffer()));
  }

  Future<RegisterReply> registerDevice_Pre(
      ServiceCall call, Future request) async {
    return registerDevice(call, await request);
  }

  Future<FundReply> fundChannel_Pre(ServiceCall call, Future request) async {
    return fundChannel(call, await request);
  }

  Future<UploadFileReply> uploadLogo_Pre(
      ServiceCall call, Future request) async {
    return uploadLogo(call, await request);
  }

  Future<RegisterReply> registerDevice(
      ServiceCall call, RegisterRequest request);
  Future<FundReply> fundChannel(ServiceCall call, FundRequest request);
  Future<UploadFileReply> uploadLogo(
      ServiceCall call, UploadFileRequest request);
}

class InformationClient extends Client {
  static final _$ping = new ClientMethod<PingRequest, PingReply>(
      '/breez.Information/Ping',
      (PingRequest value) => value.writeToBuffer(),
      (List<int> value) => new PingReply.fromBuffer(value));

  InformationClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<PingReply> ping(PingRequest request, {CallOptions options}) {
    final call = $createCall(_$ping, new Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class InformationServiceBase extends Service {
  String get $name => 'breez.Information';

  InformationServiceBase() {
    $addMethod(new ServiceMethod<PingRequest, PingReply>(
        'Ping',
        ping_Pre,
        false,
        false,
        (List<int> value) => new PingRequest.fromBuffer(value),
        (PingReply value) => value.writeToBuffer()));
  }

  Future<PingReply> ping_Pre(ServiceCall call, Future request) async {
    return ping(call, await request);
  }

  Future<PingReply> ping(ServiceCall call, PingRequest request);
}

class MempoolNotifierClient extends Client {
  static final _$mempoolRegister =
      new ClientMethod<MempoolRegisterRequest, MempoolRegisterReply>(
          '/breez.MempoolNotifier/MempoolRegister',
          (MempoolRegisterRequest value) => value.writeToBuffer(),
          (List<int> value) => new MempoolRegisterReply.fromBuffer(value));

  MempoolNotifierClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<MempoolRegisterReply> mempoolRegister(
      MempoolRegisterRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$mempoolRegister, new Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class MempoolNotifierServiceBase extends Service {
  String get $name => 'breez.MempoolNotifier';

  MempoolNotifierServiceBase() {
    $addMethod(new ServiceMethod<MempoolRegisterRequest, MempoolRegisterReply>(
        'MempoolRegister',
        mempoolRegister_Pre,
        false,
        false,
        (List<int> value) => new MempoolRegisterRequest.fromBuffer(value),
        (MempoolRegisterReply value) => value.writeToBuffer()));
  }

  Future<MempoolRegisterReply> mempoolRegister_Pre(
      ServiceCall call, Future request) async {
    return mempoolRegister(call, await request);
  }

  Future<MempoolRegisterReply> mempoolRegister(
      ServiceCall call, MempoolRegisterRequest request);
}

class FundManagerClient extends Client {
  static final _$addFund = new ClientMethod<AddFundRequest, AddFundReply>(
      '/breez.FundManager/AddFund',
      (AddFundRequest value) => value.writeToBuffer(),
      (List<int> value) => new AddFundReply.fromBuffer(value));
  static final _$removeFund =
      new ClientMethod<RemoveFundRequest, RemoveFundReply>(
          '/breez.FundManager/RemoveFund',
          (RemoveFundRequest value) => value.writeToBuffer(),
          (List<int> value) => new RemoveFundReply.fromBuffer(value));

  FundManagerClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<AddFundReply> addFund(AddFundRequest request,
      {CallOptions options}) {
    final call = $createCall(_$addFund, new Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<RemoveFundReply> removeFund(RemoveFundRequest request,
      {CallOptions options}) {
    final call = $createCall(_$removeFund, new Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class FundManagerServiceBase extends Service {
  String get $name => 'breez.FundManager';

  FundManagerServiceBase() {
    $addMethod(new ServiceMethod<AddFundRequest, AddFundReply>(
        'AddFund',
        addFund_Pre,
        false,
        false,
        (List<int> value) => new AddFundRequest.fromBuffer(value),
        (AddFundReply value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<RemoveFundRequest, RemoveFundReply>(
        'RemoveFund',
        removeFund_Pre,
        false,
        false,
        (List<int> value) => new RemoveFundRequest.fromBuffer(value),
        (RemoveFundReply value) => value.writeToBuffer()));
  }

  Future<AddFundReply> addFund_Pre(ServiceCall call, Future request) async {
    return addFund(call, await request);
  }

  Future<RemoveFundReply> removeFund_Pre(
      ServiceCall call, Future request) async {
    return removeFund(call, await request);
  }

  Future<AddFundReply> addFund(ServiceCall call, AddFundRequest request);
  Future<RemoveFundReply> removeFund(
      ServiceCall call, RemoveFundRequest request);
}

///
//  Generated code. Do not modify.
//  source: breez.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

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
        _$registerDevice, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<InvoiceReply> sendInvoice(PaymentRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$sendInvoice, new $async.Stream.fromIterable([request]),
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

  $async.Future<RegisterReply> registerDevice_Pre(
      ServiceCall call, $async.Future request) async {
    return registerDevice(call, await request);
  }

  $async.Future<InvoiceReply> sendInvoice_Pre(
      ServiceCall call, $async.Future request) async {
    return sendInvoice(call, await request);
  }

  $async.Future<RegisterReply> registerDevice(
      ServiceCall call, RegisterRequest request);
  $async.Future<InvoiceReply> sendInvoice(
      ServiceCall call, PaymentRequest request);
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
    final call = $createCall(_$order, new $async.Stream.fromIterable([request]),
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

  $async.Future<OrderReply> order_Pre(
      ServiceCall call, $async.Future request) async {
    return order(call, await request);
  }

  $async.Future<OrderReply> order(ServiceCall call, OrderRequest request);
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
        _$registerDevice, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<FundReply> fundChannel(FundRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$fundChannel, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<UploadFileReply> uploadLogo(UploadFileRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$uploadLogo, new $async.Stream.fromIterable([request]),
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

  $async.Future<RegisterReply> registerDevice_Pre(
      ServiceCall call, $async.Future request) async {
    return registerDevice(call, await request);
  }

  $async.Future<FundReply> fundChannel_Pre(
      ServiceCall call, $async.Future request) async {
    return fundChannel(call, await request);
  }

  $async.Future<UploadFileReply> uploadLogo_Pre(
      ServiceCall call, $async.Future request) async {
    return uploadLogo(call, await request);
  }

  $async.Future<RegisterReply> registerDevice(
      ServiceCall call, RegisterRequest request);
  $async.Future<FundReply> fundChannel(ServiceCall call, FundRequest request);
  $async.Future<UploadFileReply> uploadLogo(
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
    final call = $createCall(_$ping, new $async.Stream.fromIterable([request]),
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

  $async.Future<PingReply> ping_Pre(
      ServiceCall call, $async.Future request) async {
    return ping(call, await request);
  }

  $async.Future<PingReply> ping(ServiceCall call, PingRequest request);
}

class FundManagerClient extends Client {
  static final _$openChannel =
      new ClientMethod<OpenChannelRequest, OpenChannelReply>(
          '/breez.FundManager/OpenChannel',
          (OpenChannelRequest value) => value.writeToBuffer(),
          (List<int> value) => new OpenChannelReply.fromBuffer(value));
  static final _$addFund = new ClientMethod<AddFundRequest, AddFundReply>(
      '/breez.FundManager/AddFund',
      (AddFundRequest value) => value.writeToBuffer(),
      (List<int> value) => new AddFundReply.fromBuffer(value));
  static final _$addFundStatus =
      new ClientMethod<AddFundStatusRequest, AddFundStatusReply>(
          '/breez.FundManager/AddFundStatus',
          (AddFundStatusRequest value) => value.writeToBuffer(),
          (List<int> value) => new AddFundStatusReply.fromBuffer(value));
  static final _$removeFund =
      new ClientMethod<RemoveFundRequest, RemoveFundReply>(
          '/breez.FundManager/RemoveFund',
          (RemoveFundRequest value) => value.writeToBuffer(),
          (List<int> value) => new RemoveFundReply.fromBuffer(value));
  static final _$getPayment =
      new ClientMethod<GetPaymentRequest, GetPaymentReply>(
          '/breez.FundManager/GetPayment',
          (GetPaymentRequest value) => value.writeToBuffer(),
          (List<int> value) => new GetPaymentReply.fromBuffer(value));
  static final _$paySwapInvoice =
      new ClientMethod<PaySwapInvoiceRequest, PaySwapInvoiceReply>(
          '/breez.FundManager/PaySwapInvoice',
          (PaySwapInvoiceRequest value) => value.writeToBuffer(),
          (List<int> value) => new PaySwapInvoiceReply.fromBuffer(value));

  FundManagerClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<OpenChannelReply> openChannel(OpenChannelRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$openChannel, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<AddFundReply> addFund(AddFundRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$addFund, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<AddFundStatusReply> addFundStatus(AddFundStatusRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$addFundStatus, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<RemoveFundReply> removeFund(RemoveFundRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$removeFund, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<GetPaymentReply> getPayment(GetPaymentRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$getPayment, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<PaySwapInvoiceReply> paySwapInvoice(
      PaySwapInvoiceRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$paySwapInvoice, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class FundManagerServiceBase extends Service {
  String get $name => 'breez.FundManager';

  FundManagerServiceBase() {
    $addMethod(new ServiceMethod<OpenChannelRequest, OpenChannelReply>(
        'OpenChannel',
        openChannel_Pre,
        false,
        false,
        (List<int> value) => new OpenChannelRequest.fromBuffer(value),
        (OpenChannelReply value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<AddFundRequest, AddFundReply>(
        'AddFund',
        addFund_Pre,
        false,
        false,
        (List<int> value) => new AddFundRequest.fromBuffer(value),
        (AddFundReply value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<AddFundStatusRequest, AddFundStatusReply>(
        'AddFundStatus',
        addFundStatus_Pre,
        false,
        false,
        (List<int> value) => new AddFundStatusRequest.fromBuffer(value),
        (AddFundStatusReply value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<RemoveFundRequest, RemoveFundReply>(
        'RemoveFund',
        removeFund_Pre,
        false,
        false,
        (List<int> value) => new RemoveFundRequest.fromBuffer(value),
        (RemoveFundReply value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<GetPaymentRequest, GetPaymentReply>(
        'GetPayment',
        getPayment_Pre,
        false,
        false,
        (List<int> value) => new GetPaymentRequest.fromBuffer(value),
        (GetPaymentReply value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<PaySwapInvoiceRequest, PaySwapInvoiceReply>(
        'PaySwapInvoice',
        paySwapInvoice_Pre,
        false,
        false,
        (List<int> value) => new PaySwapInvoiceRequest.fromBuffer(value),
        (PaySwapInvoiceReply value) => value.writeToBuffer()));
  }

  $async.Future<OpenChannelReply> openChannel_Pre(
      ServiceCall call, $async.Future request) async {
    return openChannel(call, await request);
  }

  $async.Future<AddFundReply> addFund_Pre(
      ServiceCall call, $async.Future request) async {
    return addFund(call, await request);
  }

  $async.Future<AddFundStatusReply> addFundStatus_Pre(
      ServiceCall call, $async.Future request) async {
    return addFundStatus(call, await request);
  }

  $async.Future<RemoveFundReply> removeFund_Pre(
      ServiceCall call, $async.Future request) async {
    return removeFund(call, await request);
  }

  $async.Future<GetPaymentReply> getPayment_Pre(
      ServiceCall call, $async.Future request) async {
    return getPayment(call, await request);
  }

  $async.Future<PaySwapInvoiceReply> paySwapInvoice_Pre(
      ServiceCall call, $async.Future request) async {
    return paySwapInvoice(call, await request);
  }

  $async.Future<OpenChannelReply> openChannel(
      ServiceCall call, OpenChannelRequest request);
  $async.Future<AddFundReply> addFund(ServiceCall call, AddFundRequest request);
  $async.Future<AddFundStatusReply> addFundStatus(
      ServiceCall call, AddFundStatusRequest request);
  $async.Future<RemoveFundReply> removeFund(
      ServiceCall call, RemoveFundRequest request);
  $async.Future<GetPaymentReply> getPayment(
      ServiceCall call, GetPaymentRequest request);
  $async.Future<PaySwapInvoiceReply> paySwapInvoice(
      ServiceCall call, PaySwapInvoiceRequest request);
}

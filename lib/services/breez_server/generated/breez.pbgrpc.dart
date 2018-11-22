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
  static final _$updateChannelPolicy =
      new ClientMethod<UpdateChannelPolicyRequest, UpdateChannelPolicyReply>(
          '/breez.FundManager/UpdateChannelPolicy',
          (UpdateChannelPolicyRequest value) => value.writeToBuffer(),
          (List<int> value) => new UpdateChannelPolicyReply.fromBuffer(value));
  static final _$addFundInit =
      new ClientMethod<AddFundInitRequest, AddFundInitReply>(
          '/breez.FundManager/AddFundInit',
          (AddFundInitRequest value) => value.writeToBuffer(),
          (List<int> value) => new AddFundInitReply.fromBuffer(value));
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
  static final _$redeemRemovedFunds =
      new ClientMethod<RedeemRemovedFundsRequest, RedeemRemovedFundsReply>(
          '/breez.FundManager/RedeemRemovedFunds',
          (RedeemRemovedFundsRequest value) => value.writeToBuffer(),
          (List<int> value) => new RedeemRemovedFundsReply.fromBuffer(value));
  static final _$getSwapPayment =
      new ClientMethod<GetSwapPaymentRequest, GetSwapPaymentReply>(
          '/breez.FundManager/GetSwapPayment',
          (GetSwapPaymentRequest value) => value.writeToBuffer(),
          (List<int> value) => new GetSwapPaymentReply.fromBuffer(value));

  FundManagerClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<OpenChannelReply> openChannel(OpenChannelRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$openChannel, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<UpdateChannelPolicyReply> updateChannelPolicy(
      UpdateChannelPolicyRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$updateChannelPolicy, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<AddFundInitReply> addFundInit(AddFundInitRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$addFundInit, new $async.Stream.fromIterable([request]),
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

  ResponseFuture<RedeemRemovedFundsReply> redeemRemovedFunds(
      RedeemRemovedFundsRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$redeemRemovedFunds, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<GetSwapPaymentReply> getSwapPayment(
      GetSwapPaymentRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$getSwapPayment, new $async.Stream.fromIterable([request]),
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
    $addMethod(
        new ServiceMethod<UpdateChannelPolicyRequest, UpdateChannelPolicyReply>(
            'UpdateChannelPolicy',
            updateChannelPolicy_Pre,
            false,
            false,
            (List<int> value) =>
                new UpdateChannelPolicyRequest.fromBuffer(value),
            (UpdateChannelPolicyReply value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<AddFundInitRequest, AddFundInitReply>(
        'AddFundInit',
        addFundInit_Pre,
        false,
        false,
        (List<int> value) => new AddFundInitRequest.fromBuffer(value),
        (AddFundInitReply value) => value.writeToBuffer()));
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
    $addMethod(
        new ServiceMethod<RedeemRemovedFundsRequest, RedeemRemovedFundsReply>(
            'RedeemRemovedFunds',
            redeemRemovedFunds_Pre,
            false,
            false,
            (List<int> value) =>
                new RedeemRemovedFundsRequest.fromBuffer(value),
            (RedeemRemovedFundsReply value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<GetSwapPaymentRequest, GetSwapPaymentReply>(
        'GetSwapPayment',
        getSwapPayment_Pre,
        false,
        false,
        (List<int> value) => new GetSwapPaymentRequest.fromBuffer(value),
        (GetSwapPaymentReply value) => value.writeToBuffer()));
  }

  $async.Future<OpenChannelReply> openChannel_Pre(
      ServiceCall call, $async.Future request) async {
    return openChannel(call, await request);
  }

  $async.Future<UpdateChannelPolicyReply> updateChannelPolicy_Pre(
      ServiceCall call, $async.Future request) async {
    return updateChannelPolicy(call, await request);
  }

  $async.Future<AddFundInitReply> addFundInit_Pre(
      ServiceCall call, $async.Future request) async {
    return addFundInit(call, await request);
  }

  $async.Future<AddFundStatusReply> addFundStatus_Pre(
      ServiceCall call, $async.Future request) async {
    return addFundStatus(call, await request);
  }

  $async.Future<RemoveFundReply> removeFund_Pre(
      ServiceCall call, $async.Future request) async {
    return removeFund(call, await request);
  }

  $async.Future<RedeemRemovedFundsReply> redeemRemovedFunds_Pre(
      ServiceCall call, $async.Future request) async {
    return redeemRemovedFunds(call, await request);
  }

  $async.Future<GetSwapPaymentReply> getSwapPayment_Pre(
      ServiceCall call, $async.Future request) async {
    return getSwapPayment(call, await request);
  }

  $async.Future<OpenChannelReply> openChannel(
      ServiceCall call, OpenChannelRequest request);
  $async.Future<UpdateChannelPolicyReply> updateChannelPolicy(
      ServiceCall call, UpdateChannelPolicyRequest request);
  $async.Future<AddFundInitReply> addFundInit(
      ServiceCall call, AddFundInitRequest request);
  $async.Future<AddFundStatusReply> addFundStatus(
      ServiceCall call, AddFundStatusRequest request);
  $async.Future<RemoveFundReply> removeFund(
      ServiceCall call, RemoveFundRequest request);
  $async.Future<RedeemRemovedFundsReply> redeemRemovedFunds(
      ServiceCall call, RedeemRemovedFundsRequest request);
  $async.Future<GetSwapPaymentReply> getSwapPayment(
      ServiceCall call, GetSwapPaymentRequest request);
}

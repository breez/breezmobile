///
//  Generated code. Do not modify.
//  source: breez.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;
import 'breez.pb.dart';
export 'breez.pb.dart';

class InvoicerClient extends $grpc.Client {
  static final _$registerDevice =
      new $grpc.ClientMethod<RegisterRequest, RegisterReply>(
          '/breez.Invoicer/RegisterDevice',
          (RegisterRequest value) => value.writeToBuffer(),
          (List<int> value) => new RegisterReply.fromBuffer(value));
  static final _$sendInvoice =
      new $grpc.ClientMethod<PaymentRequest, InvoiceReply>(
          '/breez.Invoicer/SendInvoice',
          (PaymentRequest value) => value.writeToBuffer(),
          (List<int> value) => new InvoiceReply.fromBuffer(value));

  InvoicerClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<RegisterReply> registerDevice(RegisterRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$registerDevice, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<InvoiceReply> sendInvoice(PaymentRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$sendInvoice, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }
}

abstract class InvoicerServiceBase extends $grpc.Service {
  String get $name => 'breez.Invoicer';

  InvoicerServiceBase() {
    $addMethod(new $grpc.ServiceMethod<RegisterRequest, RegisterReply>(
        'RegisterDevice',
        registerDevice_Pre,
        false,
        false,
        (List<int> value) => new RegisterRequest.fromBuffer(value),
        (RegisterReply value) => value.writeToBuffer()));
    $addMethod(new $grpc.ServiceMethod<PaymentRequest, InvoiceReply>(
        'SendInvoice',
        sendInvoice_Pre,
        false,
        false,
        (List<int> value) => new PaymentRequest.fromBuffer(value),
        (InvoiceReply value) => value.writeToBuffer()));
  }

  $async.Future<RegisterReply> registerDevice_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return registerDevice(call, await request);
  }

  $async.Future<InvoiceReply> sendInvoice_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return sendInvoice(call, await request);
  }

  $async.Future<RegisterReply> registerDevice(
      $grpc.ServiceCall call, RegisterRequest request);
  $async.Future<InvoiceReply> sendInvoice(
      $grpc.ServiceCall call, PaymentRequest request);
}

class CardOrdererClient extends $grpc.Client {
  static final _$order = new $grpc.ClientMethod<OrderRequest, OrderReply>(
      '/breez.CardOrderer/Order',
      (OrderRequest value) => value.writeToBuffer(),
      (List<int> value) => new OrderReply.fromBuffer(value));

  CardOrdererClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<OrderReply> order(OrderRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$order, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }
}

abstract class CardOrdererServiceBase extends $grpc.Service {
  String get $name => 'breez.CardOrderer';

  CardOrdererServiceBase() {
    $addMethod(new $grpc.ServiceMethod<OrderRequest, OrderReply>(
        'Order',
        order_Pre,
        false,
        false,
        (List<int> value) => new OrderRequest.fromBuffer(value),
        (OrderReply value) => value.writeToBuffer()));
  }

  $async.Future<OrderReply> order_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return order(call, await request);
  }

  $async.Future<OrderReply> order($grpc.ServiceCall call, OrderRequest request);
}

class PosClient extends $grpc.Client {
  static final _$registerDevice =
      new $grpc.ClientMethod<RegisterRequest, RegisterReply>(
          '/breez.Pos/RegisterDevice',
          (RegisterRequest value) => value.writeToBuffer(),
          (List<int> value) => new RegisterReply.fromBuffer(value));
  static final _$uploadLogo =
      new $grpc.ClientMethod<UploadFileRequest, UploadFileReply>(
          '/breez.Pos/UploadLogo',
          (UploadFileRequest value) => value.writeToBuffer(),
          (List<int> value) => new UploadFileReply.fromBuffer(value));

  PosClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<RegisterReply> registerDevice(RegisterRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$registerDevice, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<UploadFileReply> uploadLogo(UploadFileRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$uploadLogo, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }
}

abstract class PosServiceBase extends $grpc.Service {
  String get $name => 'breez.Pos';

  PosServiceBase() {
    $addMethod(new $grpc.ServiceMethod<RegisterRequest, RegisterReply>(
        'RegisterDevice',
        registerDevice_Pre,
        false,
        false,
        (List<int> value) => new RegisterRequest.fromBuffer(value),
        (RegisterReply value) => value.writeToBuffer()));
    $addMethod(new $grpc.ServiceMethod<UploadFileRequest, UploadFileReply>(
        'UploadLogo',
        uploadLogo_Pre,
        false,
        false,
        (List<int> value) => new UploadFileRequest.fromBuffer(value),
        (UploadFileReply value) => value.writeToBuffer()));
  }

  $async.Future<RegisterReply> registerDevice_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return registerDevice(call, await request);
  }

  $async.Future<UploadFileReply> uploadLogo_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return uploadLogo(call, await request);
  }

  $async.Future<RegisterReply> registerDevice(
      $grpc.ServiceCall call, RegisterRequest request);
  $async.Future<UploadFileReply> uploadLogo(
      $grpc.ServiceCall call, UploadFileRequest request);
}

class InformationClient extends $grpc.Client {
  static final _$ping = new $grpc.ClientMethod<PingRequest, PingReply>(
      '/breez.Information/Ping',
      (PingRequest value) => value.writeToBuffer(),
      (List<int> value) => new PingReply.fromBuffer(value));

  InformationClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<PingReply> ping(PingRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$ping, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }
}

abstract class InformationServiceBase extends $grpc.Service {
  String get $name => 'breez.Information';

  InformationServiceBase() {
    $addMethod(new $grpc.ServiceMethod<PingRequest, PingReply>(
        'Ping',
        ping_Pre,
        false,
        false,
        (List<int> value) => new PingRequest.fromBuffer(value),
        (PingReply value) => value.writeToBuffer()));
  }

  $async.Future<PingReply> ping_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return ping(call, await request);
  }

  $async.Future<PingReply> ping($grpc.ServiceCall call, PingRequest request);
}

class FundManagerClient extends $grpc.Client {
  static final _$openChannel =
      new $grpc.ClientMethod<OpenChannelRequest, OpenChannelReply>(
          '/breez.FundManager/OpenChannel',
          (OpenChannelRequest value) => value.writeToBuffer(),
          (List<int> value) => new OpenChannelReply.fromBuffer(value));
  static final _$updateChannelPolicy = new $grpc
          .ClientMethod<UpdateChannelPolicyRequest, UpdateChannelPolicyReply>(
      '/breez.FundManager/UpdateChannelPolicy',
      (UpdateChannelPolicyRequest value) => value.writeToBuffer(),
      (List<int> value) => new UpdateChannelPolicyReply.fromBuffer(value));
  static final _$addFundInit =
      new $grpc.ClientMethod<AddFundInitRequest, AddFundInitReply>(
          '/breez.FundManager/AddFundInit',
          (AddFundInitRequest value) => value.writeToBuffer(),
          (List<int> value) => new AddFundInitReply.fromBuffer(value));
  static final _$addFundStatus =
      new $grpc.ClientMethod<AddFundStatusRequest, AddFundStatusReply>(
          '/breez.FundManager/AddFundStatus',
          (AddFundStatusRequest value) => value.writeToBuffer(),
          (List<int> value) => new AddFundStatusReply.fromBuffer(value));
  static final _$removeFund =
      new $grpc.ClientMethod<RemoveFundRequest, RemoveFundReply>(
          '/breez.FundManager/RemoveFund',
          (RemoveFundRequest value) => value.writeToBuffer(),
          (List<int> value) => new RemoveFundReply.fromBuffer(value));
  static final _$redeemRemovedFunds = new $grpc
          .ClientMethod<RedeemRemovedFundsRequest, RedeemRemovedFundsReply>(
      '/breez.FundManager/RedeemRemovedFunds',
      (RedeemRemovedFundsRequest value) => value.writeToBuffer(),
      (List<int> value) => new RedeemRemovedFundsReply.fromBuffer(value));
  static final _$getSwapPayment =
      new $grpc.ClientMethod<GetSwapPaymentRequest, GetSwapPaymentReply>(
          '/breez.FundManager/GetSwapPayment',
          (GetSwapPaymentRequest value) => value.writeToBuffer(),
          (List<int> value) => new GetSwapPaymentReply.fromBuffer(value));
  static final _$registerTransactionConfirmation = new $grpc.ClientMethod<
          RegisterTransactionConfirmationRequest,
          RegisterTransactionConfirmationResponse>(
      '/breez.FundManager/RegisterTransactionConfirmation',
      (RegisterTransactionConfirmationRequest value) => value.writeToBuffer(),
      (List<int> value) =>
          new RegisterTransactionConfirmationResponse.fromBuffer(value));

  FundManagerClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<OpenChannelReply> openChannel(OpenChannelRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$openChannel, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<UpdateChannelPolicyReply> updateChannelPolicy(
      UpdateChannelPolicyRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$updateChannelPolicy, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<AddFundInitReply> addFundInit(AddFundInitRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$addFundInit, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<AddFundStatusReply> addFundStatus(
      AddFundStatusRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$addFundStatus, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<RemoveFundReply> removeFund(RemoveFundRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$removeFund, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<RedeemRemovedFundsReply> redeemRemovedFunds(
      RedeemRemovedFundsRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$redeemRemovedFunds, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<GetSwapPaymentReply> getSwapPayment(
      GetSwapPaymentRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getSwapPayment, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<RegisterTransactionConfirmationResponse>
      registerTransactionConfirmation(
          RegisterTransactionConfirmationRequest request,
          {$grpc.CallOptions options}) {
    final call = $createCall(_$registerTransactionConfirmation,
        new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }
}

abstract class FundManagerServiceBase extends $grpc.Service {
  String get $name => 'breez.FundManager';

  FundManagerServiceBase() {
    $addMethod(new $grpc.ServiceMethod<OpenChannelRequest, OpenChannelReply>(
        'OpenChannel',
        openChannel_Pre,
        false,
        false,
        (List<int> value) => new OpenChannelRequest.fromBuffer(value),
        (OpenChannelReply value) => value.writeToBuffer()));
    $addMethod(new $grpc.ServiceMethod<UpdateChannelPolicyRequest,
            UpdateChannelPolicyReply>(
        'UpdateChannelPolicy',
        updateChannelPolicy_Pre,
        false,
        false,
        (List<int> value) => new UpdateChannelPolicyRequest.fromBuffer(value),
        (UpdateChannelPolicyReply value) => value.writeToBuffer()));
    $addMethod(new $grpc.ServiceMethod<AddFundInitRequest, AddFundInitReply>(
        'AddFundInit',
        addFundInit_Pre,
        false,
        false,
        (List<int> value) => new AddFundInitRequest.fromBuffer(value),
        (AddFundInitReply value) => value.writeToBuffer()));
    $addMethod(
        new $grpc.ServiceMethod<AddFundStatusRequest, AddFundStatusReply>(
            'AddFundStatus',
            addFundStatus_Pre,
            false,
            false,
            (List<int> value) => new AddFundStatusRequest.fromBuffer(value),
            (AddFundStatusReply value) => value.writeToBuffer()));
    $addMethod(new $grpc.ServiceMethod<RemoveFundRequest, RemoveFundReply>(
        'RemoveFund',
        removeFund_Pre,
        false,
        false,
        (List<int> value) => new RemoveFundRequest.fromBuffer(value),
        (RemoveFundReply value) => value.writeToBuffer()));
    $addMethod(new $grpc
            .ServiceMethod<RedeemRemovedFundsRequest, RedeemRemovedFundsReply>(
        'RedeemRemovedFunds',
        redeemRemovedFunds_Pre,
        false,
        false,
        (List<int> value) => new RedeemRemovedFundsRequest.fromBuffer(value),
        (RedeemRemovedFundsReply value) => value.writeToBuffer()));
    $addMethod(
        new $grpc.ServiceMethod<GetSwapPaymentRequest, GetSwapPaymentReply>(
            'GetSwapPayment',
            getSwapPayment_Pre,
            false,
            false,
            (List<int> value) => new GetSwapPaymentRequest.fromBuffer(value),
            (GetSwapPaymentReply value) => value.writeToBuffer()));
    $addMethod(new $grpc.ServiceMethod<RegisterTransactionConfirmationRequest,
            RegisterTransactionConfirmationResponse>(
        'RegisterTransactionConfirmation',
        registerTransactionConfirmation_Pre,
        false,
        false,
        (List<int> value) =>
            new RegisterTransactionConfirmationRequest.fromBuffer(value),
        (RegisterTransactionConfirmationResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<OpenChannelReply> openChannel_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return openChannel(call, await request);
  }

  $async.Future<UpdateChannelPolicyReply> updateChannelPolicy_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return updateChannelPolicy(call, await request);
  }

  $async.Future<AddFundInitReply> addFundInit_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return addFundInit(call, await request);
  }

  $async.Future<AddFundStatusReply> addFundStatus_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return addFundStatus(call, await request);
  }

  $async.Future<RemoveFundReply> removeFund_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return removeFund(call, await request);
  }

  $async.Future<RedeemRemovedFundsReply> redeemRemovedFunds_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return redeemRemovedFunds(call, await request);
  }

  $async.Future<GetSwapPaymentReply> getSwapPayment_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getSwapPayment(call, await request);
  }

  $async.Future<RegisterTransactionConfirmationResponse>
      registerTransactionConfirmation_Pre(
          $grpc.ServiceCall call, $async.Future request) async {
    return registerTransactionConfirmation(call, await request);
  }

  $async.Future<OpenChannelReply> openChannel(
      $grpc.ServiceCall call, OpenChannelRequest request);
  $async.Future<UpdateChannelPolicyReply> updateChannelPolicy(
      $grpc.ServiceCall call, UpdateChannelPolicyRequest request);
  $async.Future<AddFundInitReply> addFundInit(
      $grpc.ServiceCall call, AddFundInitRequest request);
  $async.Future<AddFundStatusReply> addFundStatus(
      $grpc.ServiceCall call, AddFundStatusRequest request);
  $async.Future<RemoveFundReply> removeFund(
      $grpc.ServiceCall call, RemoveFundRequest request);
  $async.Future<RedeemRemovedFundsReply> redeemRemovedFunds(
      $grpc.ServiceCall call, RedeemRemovedFundsRequest request);
  $async.Future<GetSwapPaymentReply> getSwapPayment(
      $grpc.ServiceCall call, GetSwapPaymentRequest request);
  $async.Future<RegisterTransactionConfirmationResponse>
      registerTransactionConfirmation($grpc.ServiceCall call,
          RegisterTransactionConfirmationRequest request);
}

class CTPClient extends $grpc.Client {
  static final _$joinCTPSession =
      new $grpc.ClientMethod<JoinCTPSessionRequest, JoinCTPSessionResponse>(
          '/breez.CTP/JoinCTPSession',
          (JoinCTPSessionRequest value) => value.writeToBuffer(),
          (List<int> value) => new JoinCTPSessionResponse.fromBuffer(value));
  static final _$terminateCTPSession = new $grpc.ClientMethod<
          TerminateCTPSessionRequest, TerminateCTPSessionResponse>(
      '/breez.CTP/TerminateCTPSession',
      (TerminateCTPSessionRequest value) => value.writeToBuffer(),
      (List<int> value) => new TerminateCTPSessionResponse.fromBuffer(value));

  CTPClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<JoinCTPSessionResponse> joinCTPSession(
      JoinCTPSessionRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$joinCTPSession, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<TerminateCTPSessionResponse> terminateCTPSession(
      TerminateCTPSessionRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$terminateCTPSession, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }
}

abstract class CTPServiceBase extends $grpc.Service {
  String get $name => 'breez.CTP';

  CTPServiceBase() {
    $addMethod(
        new $grpc.ServiceMethod<JoinCTPSessionRequest, JoinCTPSessionResponse>(
            'JoinCTPSession',
            joinCTPSession_Pre,
            false,
            false,
            (List<int> value) => new JoinCTPSessionRequest.fromBuffer(value),
            (JoinCTPSessionResponse value) => value.writeToBuffer()));
    $addMethod(new $grpc.ServiceMethod<TerminateCTPSessionRequest,
            TerminateCTPSessionResponse>(
        'TerminateCTPSession',
        terminateCTPSession_Pre,
        false,
        false,
        (List<int> value) => new TerminateCTPSessionRequest.fromBuffer(value),
        (TerminateCTPSessionResponse value) => value.writeToBuffer()));
  }

  $async.Future<JoinCTPSessionResponse> joinCTPSession_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return joinCTPSession(call, await request);
  }

  $async.Future<TerminateCTPSessionResponse> terminateCTPSession_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return terminateCTPSession(call, await request);
  }

  $async.Future<JoinCTPSessionResponse> joinCTPSession(
      $grpc.ServiceCall call, JoinCTPSessionRequest request);
  $async.Future<TerminateCTPSessionResponse> terminateCTPSession(
      $grpc.ServiceCall call, TerminateCTPSessionRequest request);
}

class SyncNotifierClient extends $grpc.Client {
  static final _$registerPeriodicSync = new $grpc.ClientMethod<
          RegisterPeriodicSyncRequest, RegisterPeriodicSyncResponse>(
      '/breez.SyncNotifier/RegisterPeriodicSync',
      (RegisterPeriodicSyncRequest value) => value.writeToBuffer(),
      (List<int> value) => new RegisterPeriodicSyncResponse.fromBuffer(value));

  SyncNotifierClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<RegisterPeriodicSyncResponse> registerPeriodicSync(
      RegisterPeriodicSyncRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$registerPeriodicSync, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }
}

abstract class SyncNotifierServiceBase extends $grpc.Service {
  String get $name => 'breez.SyncNotifier';

  SyncNotifierServiceBase() {
    $addMethod(new $grpc.ServiceMethod<RegisterPeriodicSyncRequest,
            RegisterPeriodicSyncResponse>(
        'RegisterPeriodicSync',
        registerPeriodicSync_Pre,
        false,
        false,
        (List<int> value) => new RegisterPeriodicSyncRequest.fromBuffer(value),
        (RegisterPeriodicSyncResponse value) => value.writeToBuffer()));
  }

  $async.Future<RegisterPeriodicSyncResponse> registerPeriodicSync_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return registerPeriodicSync(call, await request);
  }

  $async.Future<RegisterPeriodicSyncResponse> registerPeriodicSync(
      $grpc.ServiceCall call, RegisterPeriodicSyncRequest request);
}

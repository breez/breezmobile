///
//  Generated code. Do not modify.
//  source: breez.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'breez.pb.dart' as $0;
export 'breez.pb.dart';

class InvoicerClient extends $grpc.Client {
  static final _$registerDevice =
      $grpc.ClientMethod<$0.RegisterRequest, $0.RegisterReply>(
          '/breez.Invoicer/RegisterDevice',
          ($0.RegisterRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.RegisterReply.fromBuffer(value));
  static final _$sendInvoice =
      $grpc.ClientMethod<$0.PaymentRequest, $0.InvoiceReply>(
          '/breez.Invoicer/SendInvoice',
          ($0.PaymentRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.InvoiceReply.fromBuffer(value));

  InvoicerClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.RegisterReply> registerDevice(
      $0.RegisterRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$registerDevice, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.InvoiceReply> sendInvoice($0.PaymentRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$sendInvoice, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class InvoicerServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.Invoicer';

  InvoicerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterRequest, $0.RegisterReply>(
        'RegisterDevice',
        registerDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegisterRequest.fromBuffer(value),
        ($0.RegisterReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PaymentRequest, $0.InvoiceReply>(
        'SendInvoice',
        sendInvoice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PaymentRequest.fromBuffer(value),
        ($0.InvoiceReply value) => value.writeToBuffer()));
  }

  $async.Future<$0.RegisterReply> registerDevice_Pre(
      $grpc.ServiceCall call, $async.Future<$0.RegisterRequest> request) async {
    return registerDevice(call, await request);
  }

  $async.Future<$0.InvoiceReply> sendInvoice_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PaymentRequest> request) async {
    return sendInvoice(call, await request);
  }

  $async.Future<$0.RegisterReply> registerDevice(
      $grpc.ServiceCall call, $0.RegisterRequest request);
  $async.Future<$0.InvoiceReply> sendInvoice(
      $grpc.ServiceCall call, $0.PaymentRequest request);
}

class CardOrdererClient extends $grpc.Client {
  static final _$order = $grpc.ClientMethod<$0.OrderRequest, $0.OrderReply>(
      '/breez.CardOrderer/Order',
      ($0.OrderRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.OrderReply.fromBuffer(value));

  CardOrdererClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.OrderReply> order($0.OrderRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$order, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class CardOrdererServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.CardOrderer';

  CardOrdererServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.OrderRequest, $0.OrderReply>(
        'Order',
        order_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.OrderRequest.fromBuffer(value),
        ($0.OrderReply value) => value.writeToBuffer()));
  }

  $async.Future<$0.OrderReply> order_Pre(
      $grpc.ServiceCall call, $async.Future<$0.OrderRequest> request) async {
    return order(call, await request);
  }

  $async.Future<$0.OrderReply> order(
      $grpc.ServiceCall call, $0.OrderRequest request);
}

class PosClient extends $grpc.Client {
  static final _$registerDevice =
      $grpc.ClientMethod<$0.RegisterRequest, $0.RegisterReply>(
          '/breez.Pos/RegisterDevice',
          ($0.RegisterRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.RegisterReply.fromBuffer(value));
  static final _$uploadLogo =
      $grpc.ClientMethod<$0.UploadFileRequest, $0.UploadFileReply>(
          '/breez.Pos/UploadLogo',
          ($0.UploadFileRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.UploadFileReply.fromBuffer(value));

  PosClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.RegisterReply> registerDevice(
      $0.RegisterRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$registerDevice, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.UploadFileReply> uploadLogo(
      $0.UploadFileRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$uploadLogo, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class PosServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.Pos';

  PosServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterRequest, $0.RegisterReply>(
        'RegisterDevice',
        registerDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegisterRequest.fromBuffer(value),
        ($0.RegisterReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UploadFileRequest, $0.UploadFileReply>(
        'UploadLogo',
        uploadLogo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UploadFileRequest.fromBuffer(value),
        ($0.UploadFileReply value) => value.writeToBuffer()));
  }

  $async.Future<$0.RegisterReply> registerDevice_Pre(
      $grpc.ServiceCall call, $async.Future<$0.RegisterRequest> request) async {
    return registerDevice(call, await request);
  }

  $async.Future<$0.UploadFileReply> uploadLogo_Pre($grpc.ServiceCall call,
      $async.Future<$0.UploadFileRequest> request) async {
    return uploadLogo(call, await request);
  }

  $async.Future<$0.RegisterReply> registerDevice(
      $grpc.ServiceCall call, $0.RegisterRequest request);
  $async.Future<$0.UploadFileReply> uploadLogo(
      $grpc.ServiceCall call, $0.UploadFileRequest request);
}

class InformationClient extends $grpc.Client {
  static final _$ping = $grpc.ClientMethod<$0.PingRequest, $0.PingReply>(
      '/breez.Information/Ping',
      ($0.PingRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PingReply.fromBuffer(value));
  static final _$rates = $grpc.ClientMethod<$0.RatesRequest, $0.RatesReply>(
      '/breez.Information/Rates',
      ($0.RatesRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RatesReply.fromBuffer(value));

  InformationClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.PingReply> ping($0.PingRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$ping, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.RatesReply> rates($0.RatesRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$rates, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class InformationServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.Information';

  InformationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.PingRequest, $0.PingReply>(
        'Ping',
        ping_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PingRequest.fromBuffer(value),
        ($0.PingReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RatesRequest, $0.RatesReply>(
        'Rates',
        rates_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RatesRequest.fromBuffer(value),
        ($0.RatesReply value) => value.writeToBuffer()));
  }

  $async.Future<$0.PingReply> ping_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PingRequest> request) async {
    return ping(call, await request);
  }

  $async.Future<$0.RatesReply> rates_Pre(
      $grpc.ServiceCall call, $async.Future<$0.RatesRequest> request) async {
    return rates(call, await request);
  }

  $async.Future<$0.PingReply> ping(
      $grpc.ServiceCall call, $0.PingRequest request);
  $async.Future<$0.RatesReply> rates(
      $grpc.ServiceCall call, $0.RatesRequest request);
}

class ChannelOpenerClient extends $grpc.Client {
  static final _$lSPList =
      $grpc.ClientMethod<$0.LSPListRequest, $0.LSPListReply>(
          '/breez.ChannelOpener/LSPList',
          ($0.LSPListRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.LSPListReply.fromBuffer(value));
  static final _$openLSPChannel =
      $grpc.ClientMethod<$0.OpenLSPChannelRequest, $0.OpenLSPChannelReply>(
          '/breez.ChannelOpener/OpenLSPChannel',
          ($0.OpenLSPChannelRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.OpenLSPChannelReply.fromBuffer(value));

  ChannelOpenerClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.LSPListReply> lSPList($0.LSPListRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$lSPList, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.OpenLSPChannelReply> openLSPChannel(
      $0.OpenLSPChannelRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$openLSPChannel, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class ChannelOpenerServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.ChannelOpener';

  ChannelOpenerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LSPListRequest, $0.LSPListReply>(
        'LSPList',
        lSPList_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LSPListRequest.fromBuffer(value),
        ($0.LSPListReply value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.OpenLSPChannelRequest, $0.OpenLSPChannelReply>(
            'OpenLSPChannel',
            openLSPChannel_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.OpenLSPChannelRequest.fromBuffer(value),
            ($0.OpenLSPChannelReply value) => value.writeToBuffer()));
  }

  $async.Future<$0.LSPListReply> lSPList_Pre(
      $grpc.ServiceCall call, $async.Future<$0.LSPListRequest> request) async {
    return lSPList(call, await request);
  }

  $async.Future<$0.OpenLSPChannelReply> openLSPChannel_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.OpenLSPChannelRequest> request) async {
    return openLSPChannel(call, await request);
  }

  $async.Future<$0.LSPListReply> lSPList(
      $grpc.ServiceCall call, $0.LSPListRequest request);
  $async.Future<$0.OpenLSPChannelReply> openLSPChannel(
      $grpc.ServiceCall call, $0.OpenLSPChannelRequest request);
}

class FundManagerClient extends $grpc.Client {
  static final _$openChannel =
      $grpc.ClientMethod<$0.OpenChannelRequest, $0.OpenChannelReply>(
          '/breez.FundManager/OpenChannel',
          ($0.OpenChannelRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.OpenChannelReply.fromBuffer(value));
  static final _$updateChannelPolicy = $grpc.ClientMethod<
          $0.UpdateChannelPolicyRequest, $0.UpdateChannelPolicyReply>(
      '/breez.FundManager/UpdateChannelPolicy',
      ($0.UpdateChannelPolicyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.UpdateChannelPolicyReply.fromBuffer(value));
  static final _$addFundInit =
      $grpc.ClientMethod<$0.AddFundInitRequest, $0.AddFundInitReply>(
          '/breez.FundManager/AddFundInit',
          ($0.AddFundInitRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.AddFundInitReply.fromBuffer(value));
  static final _$addFundStatus =
      $grpc.ClientMethod<$0.AddFundStatusRequest, $0.AddFundStatusReply>(
          '/breez.FundManager/AddFundStatus',
          ($0.AddFundStatusRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.AddFundStatusReply.fromBuffer(value));
  static final _$removeFund =
      $grpc.ClientMethod<$0.RemoveFundRequest, $0.RemoveFundReply>(
          '/breez.FundManager/RemoveFund',
          ($0.RemoveFundRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.RemoveFundReply.fromBuffer(value));
  static final _$redeemRemovedFunds = $grpc.ClientMethod<
          $0.RedeemRemovedFundsRequest, $0.RedeemRemovedFundsReply>(
      '/breez.FundManager/RedeemRemovedFunds',
      ($0.RedeemRemovedFundsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.RedeemRemovedFundsReply.fromBuffer(value));
  static final _$getSwapPayment =
      $grpc.ClientMethod<$0.GetSwapPaymentRequest, $0.GetSwapPaymentReply>(
          '/breez.FundManager/GetSwapPayment',
          ($0.GetSwapPaymentRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetSwapPaymentReply.fromBuffer(value));
  static final _$registerTransactionConfirmation = $grpc.ClientMethod<
          $0.RegisterTransactionConfirmationRequest,
          $0.RegisterTransactionConfirmationResponse>(
      '/breez.FundManager/RegisterTransactionConfirmation',
      ($0.RegisterTransactionConfirmationRequest value) =>
          value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.RegisterTransactionConfirmationResponse.fromBuffer(value));

  FundManagerClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.OpenChannelReply> openChannel(
      $0.OpenChannelRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$openChannel, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.UpdateChannelPolicyReply> updateChannelPolicy(
      $0.UpdateChannelPolicyRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$updateChannelPolicy, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.AddFundInitReply> addFundInit(
      $0.AddFundInitRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$addFundInit, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.AddFundStatusReply> addFundStatus(
      $0.AddFundStatusRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$addFundStatus, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.RemoveFundReply> removeFund(
      $0.RemoveFundRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$removeFund, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.RedeemRemovedFundsReply> redeemRemovedFunds(
      $0.RedeemRemovedFundsRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$redeemRemovedFunds, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.GetSwapPaymentReply> getSwapPayment(
      $0.GetSwapPaymentRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getSwapPayment, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.RegisterTransactionConfirmationResponse>
      registerTransactionConfirmation(
          $0.RegisterTransactionConfirmationRequest request,
          {$grpc.CallOptions options}) {
    final call = $createCall(_$registerTransactionConfirmation,
        $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class FundManagerServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.FundManager';

  FundManagerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.OpenChannelRequest, $0.OpenChannelReply>(
        'OpenChannel',
        openChannel_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OpenChannelRequest.fromBuffer(value),
        ($0.OpenChannelReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateChannelPolicyRequest,
            $0.UpdateChannelPolicyReply>(
        'UpdateChannelPolicy',
        updateChannelPolicy_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateChannelPolicyRequest.fromBuffer(value),
        ($0.UpdateChannelPolicyReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddFundInitRequest, $0.AddFundInitReply>(
        'AddFundInit',
        addFundInit_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AddFundInitRequest.fromBuffer(value),
        ($0.AddFundInitReply value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.AddFundStatusRequest, $0.AddFundStatusReply>(
            'AddFundStatus',
            addFundStatus_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.AddFundStatusRequest.fromBuffer(value),
            ($0.AddFundStatusReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveFundRequest, $0.RemoveFundReply>(
        'RemoveFund',
        removeFund_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RemoveFundRequest.fromBuffer(value),
        ($0.RemoveFundReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RedeemRemovedFundsRequest,
            $0.RedeemRemovedFundsReply>(
        'RedeemRemovedFunds',
        redeemRemovedFunds_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RedeemRemovedFundsRequest.fromBuffer(value),
        ($0.RedeemRemovedFundsReply value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetSwapPaymentRequest, $0.GetSwapPaymentReply>(
            'GetSwapPayment',
            getSwapPayment_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetSwapPaymentRequest.fromBuffer(value),
            ($0.GetSwapPaymentReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RegisterTransactionConfirmationRequest,
            $0.RegisterTransactionConfirmationResponse>(
        'RegisterTransactionConfirmation',
        registerTransactionConfirmation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RegisterTransactionConfirmationRequest.fromBuffer(value),
        ($0.RegisterTransactionConfirmationResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.OpenChannelReply> openChannel_Pre($grpc.ServiceCall call,
      $async.Future<$0.OpenChannelRequest> request) async {
    return openChannel(call, await request);
  }

  $async.Future<$0.UpdateChannelPolicyReply> updateChannelPolicy_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.UpdateChannelPolicyRequest> request) async {
    return updateChannelPolicy(call, await request);
  }

  $async.Future<$0.AddFundInitReply> addFundInit_Pre($grpc.ServiceCall call,
      $async.Future<$0.AddFundInitRequest> request) async {
    return addFundInit(call, await request);
  }

  $async.Future<$0.AddFundStatusReply> addFundStatus_Pre($grpc.ServiceCall call,
      $async.Future<$0.AddFundStatusRequest> request) async {
    return addFundStatus(call, await request);
  }

  $async.Future<$0.RemoveFundReply> removeFund_Pre($grpc.ServiceCall call,
      $async.Future<$0.RemoveFundRequest> request) async {
    return removeFund(call, await request);
  }

  $async.Future<$0.RedeemRemovedFundsReply> redeemRemovedFunds_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.RedeemRemovedFundsRequest> request) async {
    return redeemRemovedFunds(call, await request);
  }

  $async.Future<$0.GetSwapPaymentReply> getSwapPayment_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.GetSwapPaymentRequest> request) async {
    return getSwapPayment(call, await request);
  }

  $async.Future<$0.RegisterTransactionConfirmationResponse>
      registerTransactionConfirmation_Pre(
          $grpc.ServiceCall call,
          $async.Future<$0.RegisterTransactionConfirmationRequest>
              request) async {
    return registerTransactionConfirmation(call, await request);
  }

  $async.Future<$0.OpenChannelReply> openChannel(
      $grpc.ServiceCall call, $0.OpenChannelRequest request);
  $async.Future<$0.UpdateChannelPolicyReply> updateChannelPolicy(
      $grpc.ServiceCall call, $0.UpdateChannelPolicyRequest request);
  $async.Future<$0.AddFundInitReply> addFundInit(
      $grpc.ServiceCall call, $0.AddFundInitRequest request);
  $async.Future<$0.AddFundStatusReply> addFundStatus(
      $grpc.ServiceCall call, $0.AddFundStatusRequest request);
  $async.Future<$0.RemoveFundReply> removeFund(
      $grpc.ServiceCall call, $0.RemoveFundRequest request);
  $async.Future<$0.RedeemRemovedFundsReply> redeemRemovedFunds(
      $grpc.ServiceCall call, $0.RedeemRemovedFundsRequest request);
  $async.Future<$0.GetSwapPaymentReply> getSwapPayment(
      $grpc.ServiceCall call, $0.GetSwapPaymentRequest request);
  $async.Future<$0.RegisterTransactionConfirmationResponse>
      registerTransactionConfirmation($grpc.ServiceCall call,
          $0.RegisterTransactionConfirmationRequest request);
}

class CTPClient extends $grpc.Client {
  static final _$joinCTPSession =
      $grpc.ClientMethod<$0.JoinCTPSessionRequest, $0.JoinCTPSessionResponse>(
          '/breez.CTP/JoinCTPSession',
          ($0.JoinCTPSessionRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.JoinCTPSessionResponse.fromBuffer(value));
  static final _$terminateCTPSession = $grpc.ClientMethod<
          $0.TerminateCTPSessionRequest, $0.TerminateCTPSessionResponse>(
      '/breez.CTP/TerminateCTPSession',
      ($0.TerminateCTPSessionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.TerminateCTPSessionResponse.fromBuffer(value));

  CTPClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.JoinCTPSessionResponse> joinCTPSession(
      $0.JoinCTPSessionRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$joinCTPSession, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.TerminateCTPSessionResponse> terminateCTPSession(
      $0.TerminateCTPSessionRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$terminateCTPSession, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class CTPServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.CTP';

  CTPServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.JoinCTPSessionRequest,
            $0.JoinCTPSessionResponse>(
        'JoinCTPSession',
        joinCTPSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.JoinCTPSessionRequest.fromBuffer(value),
        ($0.JoinCTPSessionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TerminateCTPSessionRequest,
            $0.TerminateCTPSessionResponse>(
        'TerminateCTPSession',
        terminateCTPSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TerminateCTPSessionRequest.fromBuffer(value),
        ($0.TerminateCTPSessionResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.JoinCTPSessionResponse> joinCTPSession_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.JoinCTPSessionRequest> request) async {
    return joinCTPSession(call, await request);
  }

  $async.Future<$0.TerminateCTPSessionResponse> terminateCTPSession_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.TerminateCTPSessionRequest> request) async {
    return terminateCTPSession(call, await request);
  }

  $async.Future<$0.JoinCTPSessionResponse> joinCTPSession(
      $grpc.ServiceCall call, $0.JoinCTPSessionRequest request);
  $async.Future<$0.TerminateCTPSessionResponse> terminateCTPSession(
      $grpc.ServiceCall call, $0.TerminateCTPSessionRequest request);
}

class SyncNotifierClient extends $grpc.Client {
  static final _$registerPeriodicSync = $grpc.ClientMethod<
          $0.RegisterPeriodicSyncRequest, $0.RegisterPeriodicSyncResponse>(
      '/breez.SyncNotifier/RegisterPeriodicSync',
      ($0.RegisterPeriodicSyncRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.RegisterPeriodicSyncResponse.fromBuffer(value));

  SyncNotifierClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.RegisterPeriodicSyncResponse> registerPeriodicSync(
      $0.RegisterPeriodicSyncRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$registerPeriodicSync, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class SyncNotifierServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.SyncNotifier';

  SyncNotifierServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterPeriodicSyncRequest,
            $0.RegisterPeriodicSyncResponse>(
        'RegisterPeriodicSync',
        registerPeriodicSync_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RegisterPeriodicSyncRequest.fromBuffer(value),
        ($0.RegisterPeriodicSyncResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RegisterPeriodicSyncResponse> registerPeriodicSync_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.RegisterPeriodicSyncRequest> request) async {
    return registerPeriodicSync(call, await request);
  }

  $async.Future<$0.RegisterPeriodicSyncResponse> registerPeriodicSync(
      $grpc.ServiceCall call, $0.RegisterPeriodicSyncRequest request);
}

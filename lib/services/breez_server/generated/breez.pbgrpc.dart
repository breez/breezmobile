///
//  Generated code. Do not modify.
//  source: breez.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

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

  InvoicerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.RegisterReply> registerDevice(
      $0.RegisterRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$registerDevice, request, options: options);
  }

  $grpc.ResponseFuture<$0.InvoiceReply> sendInvoice($0.PaymentRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sendInvoice, request, options: options);
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

  CardOrdererClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.OrderReply> order($0.OrderRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$order, request, options: options);
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

  PosClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.RegisterReply> registerDevice(
      $0.RegisterRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$registerDevice, request, options: options);
  }

  $grpc.ResponseFuture<$0.UploadFileReply> uploadLogo(
      $0.UploadFileRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$uploadLogo, request, options: options);
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
  static final _$breezAppVersions =
      $grpc.ClientMethod<$0.BreezAppVersionsRequest, $0.BreezAppVersionsReply>(
          '/breez.Information/BreezAppVersions',
          ($0.BreezAppVersionsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.BreezAppVersionsReply.fromBuffer(value));
  static final _$receiverInfo =
      $grpc.ClientMethod<$0.ReceiverInfoRequest, $0.ReceiverInfoReply>(
          '/breez.Information/ReceiverInfo',
          ($0.ReceiverInfoRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ReceiverInfoReply.fromBuffer(value));

  InformationClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.PingReply> ping($0.PingRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$ping, request, options: options);
  }

  $grpc.ResponseFuture<$0.RatesReply> rates($0.RatesRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$rates, request, options: options);
  }

  $grpc.ResponseFuture<$0.BreezAppVersionsReply> breezAppVersions(
      $0.BreezAppVersionsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$breezAppVersions, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReceiverInfoReply> receiverInfo(
      $0.ReceiverInfoRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$receiverInfo, request, options: options);
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
    $addMethod($grpc.ServiceMethod<$0.BreezAppVersionsRequest,
            $0.BreezAppVersionsReply>(
        'BreezAppVersions',
        breezAppVersions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.BreezAppVersionsRequest.fromBuffer(value),
        ($0.BreezAppVersionsReply value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ReceiverInfoRequest, $0.ReceiverInfoReply>(
            'ReceiverInfo',
            receiverInfo_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ReceiverInfoRequest.fromBuffer(value),
            ($0.ReceiverInfoReply value) => value.writeToBuffer()));
  }

  $async.Future<$0.PingReply> ping_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PingRequest> request) async {
    return ping(call, await request);
  }

  $async.Future<$0.RatesReply> rates_Pre(
      $grpc.ServiceCall call, $async.Future<$0.RatesRequest> request) async {
    return rates(call, await request);
  }

  $async.Future<$0.BreezAppVersionsReply> breezAppVersions_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.BreezAppVersionsRequest> request) async {
    return breezAppVersions(call, await request);
  }

  $async.Future<$0.ReceiverInfoReply> receiverInfo_Pre($grpc.ServiceCall call,
      $async.Future<$0.ReceiverInfoRequest> request) async {
    return receiverInfo(call, await request);
  }

  $async.Future<$0.PingReply> ping(
      $grpc.ServiceCall call, $0.PingRequest request);
  $async.Future<$0.RatesReply> rates(
      $grpc.ServiceCall call, $0.RatesRequest request);
  $async.Future<$0.BreezAppVersionsReply> breezAppVersions(
      $grpc.ServiceCall call, $0.BreezAppVersionsRequest request);
  $async.Future<$0.ReceiverInfoReply> receiverInfo(
      $grpc.ServiceCall call, $0.ReceiverInfoRequest request);
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
  static final _$registerPayment =
      $grpc.ClientMethod<$0.RegisterPaymentRequest, $0.RegisterPaymentReply>(
          '/breez.ChannelOpener/RegisterPayment',
          ($0.RegisterPaymentRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.RegisterPaymentReply.fromBuffer(value));
  static final _$checkChannels =
      $grpc.ClientMethod<$0.CheckChannelsRequest, $0.CheckChannelsReply>(
          '/breez.ChannelOpener/CheckChannels',
          ($0.CheckChannelsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.CheckChannelsReply.fromBuffer(value));

  ChannelOpenerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.LSPListReply> lSPList($0.LSPListRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$lSPList, request, options: options);
  }

  $grpc.ResponseFuture<$0.OpenLSPChannelReply> openLSPChannel(
      $0.OpenLSPChannelRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$openLSPChannel, request, options: options);
  }

  $grpc.ResponseFuture<$0.RegisterPaymentReply> registerPayment(
      $0.RegisterPaymentRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$registerPayment, request, options: options);
  }

  $grpc.ResponseFuture<$0.CheckChannelsReply> checkChannels(
      $0.CheckChannelsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$checkChannels, request, options: options);
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
    $addMethod(
        $grpc.ServiceMethod<$0.RegisterPaymentRequest, $0.RegisterPaymentReply>(
            'RegisterPayment',
            registerPayment_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RegisterPaymentRequest.fromBuffer(value),
            ($0.RegisterPaymentReply value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CheckChannelsRequest, $0.CheckChannelsReply>(
            'CheckChannels',
            checkChannels_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CheckChannelsRequest.fromBuffer(value),
            ($0.CheckChannelsReply value) => value.writeToBuffer()));
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

  $async.Future<$0.RegisterPaymentReply> registerPayment_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.RegisterPaymentRequest> request) async {
    return registerPayment(call, await request);
  }

  $async.Future<$0.CheckChannelsReply> checkChannels_Pre($grpc.ServiceCall call,
      $async.Future<$0.CheckChannelsRequest> request) async {
    return checkChannels(call, await request);
  }

  $async.Future<$0.LSPListReply> lSPList(
      $grpc.ServiceCall call, $0.LSPListRequest request);
  $async.Future<$0.OpenLSPChannelReply> openLSPChannel(
      $grpc.ServiceCall call, $0.OpenLSPChannelRequest request);
  $async.Future<$0.RegisterPaymentReply> registerPayment(
      $grpc.ServiceCall call, $0.RegisterPaymentRequest request);
  $async.Future<$0.CheckChannelsReply> checkChannels(
      $grpc.ServiceCall call, $0.CheckChannelsRequest request);
}

class PublicChannelOpenerClient extends $grpc.Client {
  static final _$openPublicChannel = $grpc.ClientMethod<
          $0.OpenPublicChannelRequest, $0.OpenPublicChannelReply>(
      '/breez.PublicChannelOpener/OpenPublicChannel',
      ($0.OpenPublicChannelRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.OpenPublicChannelReply.fromBuffer(value));

  PublicChannelOpenerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.OpenPublicChannelReply> openPublicChannel(
      $0.OpenPublicChannelRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$openPublicChannel, request, options: options);
  }
}

abstract class PublicChannelOpenerServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.PublicChannelOpener';

  PublicChannelOpenerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.OpenPublicChannelRequest,
            $0.OpenPublicChannelReply>(
        'OpenPublicChannel',
        openPublicChannel_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OpenPublicChannelRequest.fromBuffer(value),
        ($0.OpenPublicChannelReply value) => value.writeToBuffer()));
  }

  $async.Future<$0.OpenPublicChannelReply> openPublicChannel_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.OpenPublicChannelRequest> request) async {
    return openPublicChannel(call, await request);
  }

  $async.Future<$0.OpenPublicChannelReply> openPublicChannel(
      $grpc.ServiceCall call, $0.OpenPublicChannelRequest request);
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

  FundManagerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.OpenChannelReply> openChannel(
      $0.OpenChannelRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$openChannel, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateChannelPolicyReply> updateChannelPolicy(
      $0.UpdateChannelPolicyRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateChannelPolicy, request, options: options);
  }

  $grpc.ResponseFuture<$0.AddFundInitReply> addFundInit(
      $0.AddFundInitRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addFundInit, request, options: options);
  }

  $grpc.ResponseFuture<$0.AddFundStatusReply> addFundStatus(
      $0.AddFundStatusRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addFundStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.RemoveFundReply> removeFund(
      $0.RemoveFundRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$removeFund, request, options: options);
  }

  $grpc.ResponseFuture<$0.RedeemRemovedFundsReply> redeemRemovedFunds(
      $0.RedeemRemovedFundsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$redeemRemovedFunds, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetSwapPaymentReply> getSwapPayment(
      $0.GetSwapPaymentRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSwapPayment, request, options: options);
  }

  $grpc.ResponseFuture<$0.RegisterTransactionConfirmationResponse>
      registerTransactionConfirmation(
          $0.RegisterTransactionConfirmationRequest request,
          {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$registerTransactionConfirmation, request,
        options: options);
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

class SwapperClient extends $grpc.Client {
  static final _$addFundInit =
      $grpc.ClientMethod<$0.AddFundInitRequest, $0.AddFundInitReply>(
          '/breez.Swapper/AddFundInit',
          ($0.AddFundInitRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.AddFundInitReply.fromBuffer(value));
  static final _$addFundStatus =
      $grpc.ClientMethod<$0.AddFundStatusRequest, $0.AddFundStatusReply>(
          '/breez.Swapper/AddFundStatus',
          ($0.AddFundStatusRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.AddFundStatusReply.fromBuffer(value));
  static final _$getSwapPayment =
      $grpc.ClientMethod<$0.GetSwapPaymentRequest, $0.GetSwapPaymentReply>(
          '/breez.Swapper/GetSwapPayment',
          ($0.GetSwapPaymentRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetSwapPaymentReply.fromBuffer(value));
  static final _$redeemSwapPayment = $grpc.ClientMethod<
          $0.RedeemSwapPaymentRequest, $0.RedeemSwapPaymentReply>(
      '/breez.Swapper/RedeemSwapPayment',
      ($0.RedeemSwapPaymentRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.RedeemSwapPaymentReply.fromBuffer(value));
  static final _$getReverseRoutingNode = $grpc.ClientMethod<
          $0.GetReverseRoutingNodeRequest, $0.GetReverseRoutingNodeReply>(
      '/breez.Swapper/GetReverseRoutingNode',
      ($0.GetReverseRoutingNodeRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.GetReverseRoutingNodeReply.fromBuffer(value));

  SwapperClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.AddFundInitReply> addFundInit(
      $0.AddFundInitRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addFundInit, request, options: options);
  }

  $grpc.ResponseFuture<$0.AddFundStatusReply> addFundStatus(
      $0.AddFundStatusRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addFundStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetSwapPaymentReply> getSwapPayment(
      $0.GetSwapPaymentRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSwapPayment, request, options: options);
  }

  $grpc.ResponseFuture<$0.RedeemSwapPaymentReply> redeemSwapPayment(
      $0.RedeemSwapPaymentRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$redeemSwapPayment, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetReverseRoutingNodeReply> getReverseRoutingNode(
      $0.GetReverseRoutingNodeRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getReverseRoutingNode, request, options: options);
  }
}

abstract class SwapperServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.Swapper';

  SwapperServiceBase() {
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
    $addMethod(
        $grpc.ServiceMethod<$0.GetSwapPaymentRequest, $0.GetSwapPaymentReply>(
            'GetSwapPayment',
            getSwapPayment_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetSwapPaymentRequest.fromBuffer(value),
            ($0.GetSwapPaymentReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RedeemSwapPaymentRequest,
            $0.RedeemSwapPaymentReply>(
        'RedeemSwapPayment',
        redeemSwapPayment_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RedeemSwapPaymentRequest.fromBuffer(value),
        ($0.RedeemSwapPaymentReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetReverseRoutingNodeRequest,
            $0.GetReverseRoutingNodeReply>(
        'GetReverseRoutingNode',
        getReverseRoutingNode_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetReverseRoutingNodeRequest.fromBuffer(value),
        ($0.GetReverseRoutingNodeReply value) => value.writeToBuffer()));
  }

  $async.Future<$0.AddFundInitReply> addFundInit_Pre($grpc.ServiceCall call,
      $async.Future<$0.AddFundInitRequest> request) async {
    return addFundInit(call, await request);
  }

  $async.Future<$0.AddFundStatusReply> addFundStatus_Pre($grpc.ServiceCall call,
      $async.Future<$0.AddFundStatusRequest> request) async {
    return addFundStatus(call, await request);
  }

  $async.Future<$0.GetSwapPaymentReply> getSwapPayment_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.GetSwapPaymentRequest> request) async {
    return getSwapPayment(call, await request);
  }

  $async.Future<$0.RedeemSwapPaymentReply> redeemSwapPayment_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.RedeemSwapPaymentRequest> request) async {
    return redeemSwapPayment(call, await request);
  }

  $async.Future<$0.GetReverseRoutingNodeReply> getReverseRoutingNode_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.GetReverseRoutingNodeRequest> request) async {
    return getReverseRoutingNode(call, await request);
  }

  $async.Future<$0.AddFundInitReply> addFundInit(
      $grpc.ServiceCall call, $0.AddFundInitRequest request);
  $async.Future<$0.AddFundStatusReply> addFundStatus(
      $grpc.ServiceCall call, $0.AddFundStatusRequest request);
  $async.Future<$0.GetSwapPaymentReply> getSwapPayment(
      $grpc.ServiceCall call, $0.GetSwapPaymentRequest request);
  $async.Future<$0.RedeemSwapPaymentReply> redeemSwapPayment(
      $grpc.ServiceCall call, $0.RedeemSwapPaymentRequest request);
  $async.Future<$0.GetReverseRoutingNodeReply> getReverseRoutingNode(
      $grpc.ServiceCall call, $0.GetReverseRoutingNodeRequest request);
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

  CTPClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.JoinCTPSessionResponse> joinCTPSession(
      $0.JoinCTPSessionRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$joinCTPSession, request, options: options);
  }

  $grpc.ResponseFuture<$0.TerminateCTPSessionResponse> terminateCTPSession(
      $0.TerminateCTPSessionRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$terminateCTPSession, request, options: options);
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

class NodeInfoClient extends $grpc.Client {
  static final _$setNodeInfo =
      $grpc.ClientMethod<$0.SetNodeInfoRequest, $0.SetNodeInfoResponse>(
          '/breez.NodeInfo/SetNodeInfo',
          ($0.SetNodeInfoRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.SetNodeInfoResponse.fromBuffer(value));
  static final _$getNodeInfo =
      $grpc.ClientMethod<$0.GetNodeInfoRequest, $0.GetNodeInfoResponse>(
          '/breez.NodeInfo/GetNodeInfo',
          ($0.GetNodeInfoRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetNodeInfoResponse.fromBuffer(value));

  NodeInfoClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.SetNodeInfoResponse> setNodeInfo(
      $0.SetNodeInfoRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setNodeInfo, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetNodeInfoResponse> getNodeInfo(
      $0.GetNodeInfoRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getNodeInfo, request, options: options);
  }
}

abstract class NodeInfoServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.NodeInfo';

  NodeInfoServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.SetNodeInfoRequest, $0.SetNodeInfoResponse>(
            'SetNodeInfo',
            setNodeInfo_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SetNodeInfoRequest.fromBuffer(value),
            ($0.SetNodeInfoResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetNodeInfoRequest, $0.GetNodeInfoResponse>(
            'GetNodeInfo',
            getNodeInfo_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetNodeInfoRequest.fromBuffer(value),
            ($0.GetNodeInfoResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SetNodeInfoResponse> setNodeInfo_Pre($grpc.ServiceCall call,
      $async.Future<$0.SetNodeInfoRequest> request) async {
    return setNodeInfo(call, await request);
  }

  $async.Future<$0.GetNodeInfoResponse> getNodeInfo_Pre($grpc.ServiceCall call,
      $async.Future<$0.GetNodeInfoRequest> request) async {
    return getNodeInfo(call, await request);
  }

  $async.Future<$0.SetNodeInfoResponse> setNodeInfo(
      $grpc.ServiceCall call, $0.SetNodeInfoRequest request);
  $async.Future<$0.GetNodeInfoResponse> getNodeInfo(
      $grpc.ServiceCall call, $0.GetNodeInfoRequest request);
}

class SyncNotifierClient extends $grpc.Client {
  static final _$registerPeriodicSync = $grpc.ClientMethod<
          $0.RegisterPeriodicSyncRequest, $0.RegisterPeriodicSyncResponse>(
      '/breez.SyncNotifier/RegisterPeriodicSync',
      ($0.RegisterPeriodicSyncRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.RegisterPeriodicSyncResponse.fromBuffer(value));

  SyncNotifierClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.RegisterPeriodicSyncResponse> registerPeriodicSync(
      $0.RegisterPeriodicSyncRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$registerPeriodicSync, request, options: options);
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

class PushTxNotifierClient extends $grpc.Client {
  static final _$registerTxNotification = $grpc.ClientMethod<
          $0.PushTxNotificationRequest, $0.PushTxNotificationResponse>(
      '/breez.PushTxNotifier/RegisterTxNotification',
      ($0.PushTxNotificationRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.PushTxNotificationResponse.fromBuffer(value));

  PushTxNotifierClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.PushTxNotificationResponse> registerTxNotification(
      $0.PushTxNotificationRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$registerTxNotification, request,
        options: options);
  }
}

abstract class PushTxNotifierServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.PushTxNotifier';

  PushTxNotifierServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.PushTxNotificationRequest,
            $0.PushTxNotificationResponse>(
        'RegisterTxNotification',
        registerTxNotification_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PushTxNotificationRequest.fromBuffer(value),
        ($0.PushTxNotificationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.PushTxNotificationResponse> registerTxNotification_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.PushTxNotificationRequest> request) async {
    return registerTxNotification(call, await request);
  }

  $async.Future<$0.PushTxNotificationResponse> registerTxNotification(
      $grpc.ServiceCall call, $0.PushTxNotificationRequest request);
}

class InactiveNotifierClient extends $grpc.Client {
  static final _$inactiveNotify =
      $grpc.ClientMethod<$0.InactiveNotifyRequest, $0.InactiveNotifyResponse>(
          '/breez.InactiveNotifier/InactiveNotify',
          ($0.InactiveNotifyRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.InactiveNotifyResponse.fromBuffer(value));

  InactiveNotifierClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.InactiveNotifyResponse> inactiveNotify(
      $0.InactiveNotifyRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$inactiveNotify, request, options: options);
  }
}

abstract class InactiveNotifierServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.InactiveNotifier';

  InactiveNotifierServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.InactiveNotifyRequest,
            $0.InactiveNotifyResponse>(
        'InactiveNotify',
        inactiveNotify_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.InactiveNotifyRequest.fromBuffer(value),
        ($0.InactiveNotifyResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.InactiveNotifyResponse> inactiveNotify_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.InactiveNotifyRequest> request) async {
    return inactiveNotify(call, await request);
  }

  $async.Future<$0.InactiveNotifyResponse> inactiveNotify(
      $grpc.ServiceCall call, $0.InactiveNotifyRequest request);
}

class SignerClient extends $grpc.Client {
  static final _$signUrl =
      $grpc.ClientMethod<$0.SignUrlRequest, $0.SignUrlResponse>(
          '/breez.Signer/SignUrl',
          ($0.SignUrlRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.SignUrlResponse.fromBuffer(value));

  SignerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.SignUrlResponse> signUrl($0.SignUrlRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$signUrl, request, options: options);
  }
}

abstract class SignerServiceBase extends $grpc.Service {
  $core.String get $name => 'breez.Signer';

  SignerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SignUrlRequest, $0.SignUrlResponse>(
        'SignUrl',
        signUrl_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SignUrlRequest.fromBuffer(value),
        ($0.SignUrlResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SignUrlResponse> signUrl_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SignUrlRequest> request) async {
    return signUrl(call, await request);
  }

  $async.Future<$0.SignUrlResponse> signUrl(
      $grpc.ServiceCall call, $0.SignUrlRequest request);
}

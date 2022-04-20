///
//  Generated code. Do not modify.
//  source: rpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'rpc.pb.dart' as $0;
export 'rpc.pb.dart';

class BreezAPIClient extends $grpc.Client {
  static final _$getLSPList = $grpc.ClientMethod<$0.LSPListRequest, $0.LSPList>(
      '/data.BreezAPI/GetLSPList',
      ($0.LSPListRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LSPList.fromBuffer(value));
  static final _$connectToLSP =
      $grpc.ClientMethod<$0.ConnectLSPRequest, $0.ConnectLSPReply>(
          '/data.BreezAPI/ConnectToLSP',
          ($0.ConnectLSPRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ConnectLSPReply.fromBuffer(value));
  static final _$addFundInit =
      $grpc.ClientMethod<$0.AddFundInitRequest, $0.AddFundInitReply>(
          '/data.BreezAPI/AddFundInit',
          ($0.AddFundInitRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.AddFundInitReply.fromBuffer(value));
  static final _$getFundStatus =
      $grpc.ClientMethod<$0.FundStatusRequest, $0.FundStatusReply>(
          '/data.BreezAPI/GetFundStatus',
          ($0.FundStatusRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.FundStatusReply.fromBuffer(value));
  static final _$addInvoice =
      $grpc.ClientMethod<$0.AddInvoiceRequest, $0.AddInvoiceReply>(
          '/data.BreezAPI/AddInvoice',
          ($0.AddInvoiceRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.AddInvoiceReply.fromBuffer(value));
  static final _$payInvoice =
      $grpc.ClientMethod<$0.PayInvoiceRequest, $0.PaymentResponse>(
          '/data.BreezAPI/PayInvoice',
          ($0.PayInvoiceRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.PaymentResponse.fromBuffer(value));
  static final _$restartDaemon =
      $grpc.ClientMethod<$0.RestartDaemonRequest, $0.RestartDaemonReply>(
          '/data.BreezAPI/RestartDaemon',
          ($0.RestartDaemonRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.RestartDaemonReply.fromBuffer(value));
  static final _$listPayments =
      $grpc.ClientMethod<$0.ListPaymentsRequest, $0.PaymentsList>(
          '/data.BreezAPI/ListPayments',
          ($0.ListPaymentsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.PaymentsList.fromBuffer(value));

  BreezAPIClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.LSPList> getLSPList($0.LSPListRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getLSPList, request, options: options);
  }

  $grpc.ResponseFuture<$0.ConnectLSPReply> connectToLSP(
      $0.ConnectLSPRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$connectToLSP, request, options: options);
  }

  $grpc.ResponseFuture<$0.AddFundInitReply> addFundInit(
      $0.AddFundInitRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addFundInit, request, options: options);
  }

  $grpc.ResponseFuture<$0.FundStatusReply> getFundStatus(
      $0.FundStatusRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFundStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.AddInvoiceReply> addInvoice(
      $0.AddInvoiceRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addInvoice, request, options: options);
  }

  $grpc.ResponseFuture<$0.PaymentResponse> payInvoice(
      $0.PayInvoiceRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$payInvoice, request, options: options);
  }

  $grpc.ResponseFuture<$0.RestartDaemonReply> restartDaemon(
      $0.RestartDaemonRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$restartDaemon, request, options: options);
  }

  $grpc.ResponseFuture<$0.PaymentsList> listPayments(
      $0.ListPaymentsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listPayments, request, options: options);
  }
}

abstract class BreezAPIServiceBase extends $grpc.Service {
  $core.String get $name => 'data.BreezAPI';

  BreezAPIServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LSPListRequest, $0.LSPList>(
        'GetLSPList',
        getLSPList_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LSPListRequest.fromBuffer(value),
        ($0.LSPList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ConnectLSPRequest, $0.ConnectLSPReply>(
        'ConnectToLSP',
        connectToLSP_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ConnectLSPRequest.fromBuffer(value),
        ($0.ConnectLSPReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddFundInitRequest, $0.AddFundInitReply>(
        'AddFundInit',
        addFundInit_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AddFundInitRequest.fromBuffer(value),
        ($0.AddFundInitReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FundStatusRequest, $0.FundStatusReply>(
        'GetFundStatus',
        getFundStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FundStatusRequest.fromBuffer(value),
        ($0.FundStatusReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddInvoiceRequest, $0.AddInvoiceReply>(
        'AddInvoice',
        addInvoice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AddInvoiceRequest.fromBuffer(value),
        ($0.AddInvoiceReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PayInvoiceRequest, $0.PaymentResponse>(
        'PayInvoice',
        payInvoice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PayInvoiceRequest.fromBuffer(value),
        ($0.PaymentResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RestartDaemonRequest, $0.RestartDaemonReply>(
            'RestartDaemon',
            restartDaemon_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RestartDaemonRequest.fromBuffer(value),
            ($0.RestartDaemonReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListPaymentsRequest, $0.PaymentsList>(
        'ListPayments',
        listPayments_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListPaymentsRequest.fromBuffer(value),
        ($0.PaymentsList value) => value.writeToBuffer()));
  }

  $async.Future<$0.LSPList> getLSPList_Pre(
      $grpc.ServiceCall call, $async.Future<$0.LSPListRequest> request) async {
    return getLSPList(call, await request);
  }

  $async.Future<$0.ConnectLSPReply> connectToLSP_Pre($grpc.ServiceCall call,
      $async.Future<$0.ConnectLSPRequest> request) async {
    return connectToLSP(call, await request);
  }

  $async.Future<$0.AddFundInitReply> addFundInit_Pre($grpc.ServiceCall call,
      $async.Future<$0.AddFundInitRequest> request) async {
    return addFundInit(call, await request);
  }

  $async.Future<$0.FundStatusReply> getFundStatus_Pre($grpc.ServiceCall call,
      $async.Future<$0.FundStatusRequest> request) async {
    return getFundStatus(call, await request);
  }

  $async.Future<$0.AddInvoiceReply> addInvoice_Pre($grpc.ServiceCall call,
      $async.Future<$0.AddInvoiceRequest> request) async {
    return addInvoice(call, await request);
  }

  $async.Future<$0.PaymentResponse> payInvoice_Pre($grpc.ServiceCall call,
      $async.Future<$0.PayInvoiceRequest> request) async {
    return payInvoice(call, await request);
  }

  $async.Future<$0.RestartDaemonReply> restartDaemon_Pre($grpc.ServiceCall call,
      $async.Future<$0.RestartDaemonRequest> request) async {
    return restartDaemon(call, await request);
  }

  $async.Future<$0.PaymentsList> listPayments_Pre($grpc.ServiceCall call,
      $async.Future<$0.ListPaymentsRequest> request) async {
    return listPayments(call, await request);
  }

  $async.Future<$0.LSPList> getLSPList(
      $grpc.ServiceCall call, $0.LSPListRequest request);
  $async.Future<$0.ConnectLSPReply> connectToLSP(
      $grpc.ServiceCall call, $0.ConnectLSPRequest request);
  $async.Future<$0.AddFundInitReply> addFundInit(
      $grpc.ServiceCall call, $0.AddFundInitRequest request);
  $async.Future<$0.FundStatusReply> getFundStatus(
      $grpc.ServiceCall call, $0.FundStatusRequest request);
  $async.Future<$0.AddInvoiceReply> addInvoice(
      $grpc.ServiceCall call, $0.AddInvoiceRequest request);
  $async.Future<$0.PaymentResponse> payInvoice(
      $grpc.ServiceCall call, $0.PayInvoiceRequest request);
  $async.Future<$0.RestartDaemonReply> restartDaemon(
      $grpc.ServiceCall call, $0.RestartDaemonRequest request);
  $async.Future<$0.PaymentsList> listPayments(
      $grpc.ServiceCall call, $0.ListPaymentsRequest request);
}

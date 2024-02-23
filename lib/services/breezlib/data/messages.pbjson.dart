//
//  Generated code. Do not modify.
//  source: messages.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use swapErrorDescriptor instead')
const SwapError$json = {
  '1': 'SwapError',
  '2': [
    {'1': 'NO_ERROR', '2': 0},
    {'1': 'FUNDS_EXCEED_LIMIT', '2': 1},
    {'1': 'TX_TOO_SMALL', '2': 2},
    {'1': 'INVOICE_AMOUNT_MISMATCH', '2': 3},
    {'1': 'SWAP_EXPIRED', '2': 4},
  ],
};

/// Descriptor for `SwapError`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List swapErrorDescriptor = $convert.base64Decode(
    'CglTd2FwRXJyb3ISDAoITk9fRVJST1IQABIWChJGVU5EU19FWENFRURfTElNSVQQARIQCgxUWF'
    '9UT09fU01BTEwQAhIbChdJTlZPSUNFX0FNT1VOVF9NSVNNQVRDSBADEhAKDFNXQVBfRVhQSVJF'
    'RBAE');

@$core.Deprecated('Use listPaymentsRequestDescriptor instead')
const ListPaymentsRequest$json = {
  '1': 'ListPaymentsRequest',
};

/// Descriptor for `ListPaymentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPaymentsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UGF5bWVudHNSZXF1ZXN0');

@$core.Deprecated('Use restartDaemonRequestDescriptor instead')
const RestartDaemonRequest$json = {
  '1': 'RestartDaemonRequest',
};

/// Descriptor for `RestartDaemonRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restartDaemonRequestDescriptor = $convert.base64Decode(
    'ChRSZXN0YXJ0RGFlbW9uUmVxdWVzdA==');

@$core.Deprecated('Use restartDaemonReplyDescriptor instead')
const RestartDaemonReply$json = {
  '1': 'RestartDaemonReply',
};

/// Descriptor for `RestartDaemonReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restartDaemonReplyDescriptor = $convert.base64Decode(
    'ChJSZXN0YXJ0RGFlbW9uUmVwbHk=');

@$core.Deprecated('Use addFundInitRequestDescriptor instead')
const AddFundInitRequest$json = {
  '1': 'AddFundInitRequest',
  '2': [
    {'1': 'notificationToken', '3': 1, '4': 1, '5': 9, '10': 'notificationToken'},
    {'1': 'lspID', '3': 2, '4': 1, '5': 9, '10': 'lspID'},
    {'1': 'opening_fee_params', '3': 3, '4': 1, '5': 11, '6': '.data.OpeningFeeParams', '10': 'openingFeeParams'},
  ],
};

/// Descriptor for `AddFundInitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFundInitRequestDescriptor = $convert.base64Decode(
    'ChJBZGRGdW5kSW5pdFJlcXVlc3QSLAoRbm90aWZpY2F0aW9uVG9rZW4YASABKAlSEW5vdGlmaW'
    'NhdGlvblRva2VuEhQKBWxzcElEGAIgASgJUgVsc3BJRBJEChJvcGVuaW5nX2ZlZV9wYXJhbXMY'
    'AyABKAsyFi5kYXRhLk9wZW5pbmdGZWVQYXJhbXNSEG9wZW5pbmdGZWVQYXJhbXM=');

@$core.Deprecated('Use fundStatusRequestDescriptor instead')
const FundStatusRequest$json = {
  '1': 'FundStatusRequest',
  '2': [
    {'1': 'notificationToken', '3': 1, '4': 1, '5': 9, '10': 'notificationToken'},
  ],
};

/// Descriptor for `FundStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fundStatusRequestDescriptor = $convert.base64Decode(
    'ChFGdW5kU3RhdHVzUmVxdWVzdBIsChFub3RpZmljYXRpb25Ub2tlbhgBIAEoCVIRbm90aWZpY2'
    'F0aW9uVG9rZW4=');

@$core.Deprecated('Use addInvoiceReplyDescriptor instead')
const AddInvoiceReply$json = {
  '1': 'AddInvoiceReply',
  '2': [
    {'1': 'paymentRequest', '3': 1, '4': 1, '5': 9, '10': 'paymentRequest'},
    {'1': 'lsp_fee', '3': 2, '4': 1, '5': 3, '10': 'lspFee'},
  ],
};

/// Descriptor for `AddInvoiceReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addInvoiceReplyDescriptor = $convert.base64Decode(
    'Cg9BZGRJbnZvaWNlUmVwbHkSJgoOcGF5bWVudFJlcXVlc3QYASABKAlSDnBheW1lbnRSZXF1ZX'
    'N0EhcKB2xzcF9mZWUYAiABKANSBmxzcEZlZQ==');

@$core.Deprecated('Use chainStatusDescriptor instead')
const ChainStatus$json = {
  '1': 'ChainStatus',
  '2': [
    {'1': 'blockHeight', '3': 1, '4': 1, '5': 13, '10': 'blockHeight'},
    {'1': 'syncedToChain', '3': 2, '4': 1, '5': 8, '10': 'syncedToChain'},
  ],
};

/// Descriptor for `ChainStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chainStatusDescriptor = $convert.base64Decode(
    'CgtDaGFpblN0YXR1cxIgCgtibG9ja0hlaWdodBgBIAEoDVILYmxvY2tIZWlnaHQSJAoNc3luY2'
    'VkVG9DaGFpbhgCIAEoCFINc3luY2VkVG9DaGFpbg==');

@$core.Deprecated('Use accountDescriptor instead')
const Account$json = {
  '1': 'Account',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'balance', '3': 2, '4': 1, '5': 3, '10': 'balance'},
    {'1': 'walletBalance', '3': 3, '4': 1, '5': 3, '10': 'walletBalance'},
    {'1': 'status', '3': 4, '4': 1, '5': 14, '6': '.data.Account.AccountStatus', '10': 'status'},
    {'1': 'maxAllowedToReceive', '3': 5, '4': 1, '5': 3, '10': 'maxAllowedToReceive'},
    {'1': 'maxAllowedToPay', '3': 6, '4': 1, '5': 3, '10': 'maxAllowedToPay'},
    {'1': 'maxPaymentAmount', '3': 7, '4': 1, '5': 3, '10': 'maxPaymentAmount'},
    {'1': 'routingNodeFee', '3': 8, '4': 1, '5': 3, '10': 'routingNodeFee'},
    {'1': 'enabled', '3': 9, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'maxChanReserve', '3': 10, '4': 1, '5': 3, '10': 'maxChanReserve'},
    {'1': 'channelPoint', '3': 11, '4': 1, '5': 9, '10': 'channelPoint'},
    {'1': 'readyForPayments', '3': 12, '4': 1, '5': 8, '10': 'readyForPayments'},
    {'1': 'tipHeight', '3': 13, '4': 1, '5': 3, '10': 'tipHeight'},
    {'1': 'connectedPeers', '3': 14, '4': 3, '5': 9, '10': 'connectedPeers'},
    {'1': 'max_inbound_liquidity', '3': 15, '4': 1, '5': 3, '10': 'maxInboundLiquidity'},
    {'1': 'unconfirmed_channels', '3': 16, '4': 3, '5': 9, '10': 'unconfirmedChannels'},
  ],
  '4': [Account_AccountStatus$json],
};

@$core.Deprecated('Use accountDescriptor instead')
const Account_AccountStatus$json = {
  '1': 'AccountStatus',
  '2': [
    {'1': 'DISCONNECTED', '2': 0},
    {'1': 'PROCESSING_CONNECTION', '2': 1},
    {'1': 'CLOSING_CONNECTION', '2': 2},
    {'1': 'CONNECTED', '2': 3},
  ],
};

/// Descriptor for `Account`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDescriptor = $convert.base64Decode(
    'CgdBY2NvdW50Eg4KAmlkGAEgASgJUgJpZBIYCgdiYWxhbmNlGAIgASgDUgdiYWxhbmNlEiQKDX'
    'dhbGxldEJhbGFuY2UYAyABKANSDXdhbGxldEJhbGFuY2USMwoGc3RhdHVzGAQgASgOMhsuZGF0'
    'YS5BY2NvdW50LkFjY291bnRTdGF0dXNSBnN0YXR1cxIwChNtYXhBbGxvd2VkVG9SZWNlaXZlGA'
    'UgASgDUhNtYXhBbGxvd2VkVG9SZWNlaXZlEigKD21heEFsbG93ZWRUb1BheRgGIAEoA1IPbWF4'
    'QWxsb3dlZFRvUGF5EioKEG1heFBheW1lbnRBbW91bnQYByABKANSEG1heFBheW1lbnRBbW91bn'
    'QSJgoOcm91dGluZ05vZGVGZWUYCCABKANSDnJvdXRpbmdOb2RlRmVlEhgKB2VuYWJsZWQYCSAB'
    'KAhSB2VuYWJsZWQSJgoObWF4Q2hhblJlc2VydmUYCiABKANSDm1heENoYW5SZXNlcnZlEiIKDG'
    'NoYW5uZWxQb2ludBgLIAEoCVIMY2hhbm5lbFBvaW50EioKEHJlYWR5Rm9yUGF5bWVudHMYDCAB'
    'KAhSEHJlYWR5Rm9yUGF5bWVudHMSHAoJdGlwSGVpZ2h0GA0gASgDUgl0aXBIZWlnaHQSJgoOY2'
    '9ubmVjdGVkUGVlcnMYDiADKAlSDmNvbm5lY3RlZFBlZXJzEjIKFW1heF9pbmJvdW5kX2xpcXVp'
    'ZGl0eRgPIAEoA1ITbWF4SW5ib3VuZExpcXVpZGl0eRIxChR1bmNvbmZpcm1lZF9jaGFubmVscx'
    'gQIAMoCVITdW5jb25maXJtZWRDaGFubmVscyJjCg1BY2NvdW50U3RhdHVzEhAKDERJU0NPTk5F'
    'Q1RFRBAAEhkKFVBST0NFU1NJTkdfQ09OTkVDVElPThABEhYKEkNMT1NJTkdfQ09OTkVDVElPTh'
    'ACEg0KCUNPTk5FQ1RFRBAD');

@$core.Deprecated('Use paymentDescriptor instead')
const Payment$json = {
  '1': 'Payment',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.data.Payment.PaymentType', '10': 'type'},
    {'1': 'amount', '3': 3, '4': 1, '5': 3, '10': 'amount'},
    {'1': 'creationTimestamp', '3': 4, '4': 1, '5': 3, '10': 'creationTimestamp'},
    {'1': 'invoiceMemo', '3': 6, '4': 1, '5': 11, '6': '.data.InvoiceMemo', '10': 'invoiceMemo'},
    {'1': 'redeemTxID', '3': 7, '4': 1, '5': 9, '10': 'redeemTxID'},
    {'1': 'paymentHash', '3': 8, '4': 1, '5': 9, '10': 'paymentHash'},
    {'1': 'destination', '3': 9, '4': 1, '5': 9, '10': 'destination'},
    {'1': 'PendingExpirationHeight', '3': 10, '4': 1, '5': 13, '10': 'PendingExpirationHeight'},
    {'1': 'PendingExpirationTimestamp', '3': 11, '4': 1, '5': 3, '10': 'PendingExpirationTimestamp'},
    {'1': 'fee', '3': 12, '4': 1, '5': 3, '10': 'fee'},
    {'1': 'preimage', '3': 13, '4': 1, '5': 9, '10': 'preimage'},
    {'1': 'closedChannelPoint', '3': 14, '4': 1, '5': 9, '10': 'closedChannelPoint'},
    {'1': 'isChannelPending', '3': 15, '4': 1, '5': 8, '10': 'isChannelPending'},
    {'1': 'isChannelCloseConfimed', '3': 16, '4': 1, '5': 8, '10': 'isChannelCloseConfimed'},
    {'1': 'closedChannelTxID', '3': 17, '4': 1, '5': 9, '10': 'closedChannelTxID'},
    {'1': 'isKeySend', '3': 18, '4': 1, '5': 8, '10': 'isKeySend'},
    {'1': 'PendingFull', '3': 19, '4': 1, '5': 8, '10': 'PendingFull'},
    {'1': 'closedChannelRemoteTxID', '3': 20, '4': 1, '5': 9, '10': 'closedChannelRemoteTxID'},
    {'1': 'closedChannelSweepTxID', '3': 21, '4': 1, '5': 9, '10': 'closedChannelSweepTxID'},
    {'1': 'groupKey', '3': 22, '4': 1, '5': 9, '10': 'groupKey'},
    {'1': 'groupName', '3': 23, '4': 1, '5': 9, '10': 'groupName'},
    {'1': 'lnurlPayInfo', '3': 24, '4': 1, '5': 11, '6': '.data.LNUrlPayInfo', '10': 'lnurlPayInfo'},
  ],
  '4': [Payment_PaymentType$json],
};

@$core.Deprecated('Use paymentDescriptor instead')
const Payment_PaymentType$json = {
  '1': 'PaymentType',
  '2': [
    {'1': 'DEPOSIT', '2': 0},
    {'1': 'WITHDRAWAL', '2': 1},
    {'1': 'SENT', '2': 2},
    {'1': 'RECEIVED', '2': 3},
    {'1': 'CLOSED_CHANNEL', '2': 4},
  ],
};

/// Descriptor for `Payment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentDescriptor = $convert.base64Decode(
    'CgdQYXltZW50Ei0KBHR5cGUYASABKA4yGS5kYXRhLlBheW1lbnQuUGF5bWVudFR5cGVSBHR5cG'
    'USFgoGYW1vdW50GAMgASgDUgZhbW91bnQSLAoRY3JlYXRpb25UaW1lc3RhbXAYBCABKANSEWNy'
    'ZWF0aW9uVGltZXN0YW1wEjMKC2ludm9pY2VNZW1vGAYgASgLMhEuZGF0YS5JbnZvaWNlTWVtb1'
    'ILaW52b2ljZU1lbW8SHgoKcmVkZWVtVHhJRBgHIAEoCVIKcmVkZWVtVHhJRBIgCgtwYXltZW50'
    'SGFzaBgIIAEoCVILcGF5bWVudEhhc2gSIAoLZGVzdGluYXRpb24YCSABKAlSC2Rlc3RpbmF0aW'
    '9uEjgKF1BlbmRpbmdFeHBpcmF0aW9uSGVpZ2h0GAogASgNUhdQZW5kaW5nRXhwaXJhdGlvbkhl'
    'aWdodBI+ChpQZW5kaW5nRXhwaXJhdGlvblRpbWVzdGFtcBgLIAEoA1IaUGVuZGluZ0V4cGlyYX'
    'Rpb25UaW1lc3RhbXASEAoDZmVlGAwgASgDUgNmZWUSGgoIcHJlaW1hZ2UYDSABKAlSCHByZWlt'
    'YWdlEi4KEmNsb3NlZENoYW5uZWxQb2ludBgOIAEoCVISY2xvc2VkQ2hhbm5lbFBvaW50EioKEG'
    'lzQ2hhbm5lbFBlbmRpbmcYDyABKAhSEGlzQ2hhbm5lbFBlbmRpbmcSNgoWaXNDaGFubmVsQ2xv'
    'c2VDb25maW1lZBgQIAEoCFIWaXNDaGFubmVsQ2xvc2VDb25maW1lZBIsChFjbG9zZWRDaGFubm'
    'VsVHhJRBgRIAEoCVIRY2xvc2VkQ2hhbm5lbFR4SUQSHAoJaXNLZXlTZW5kGBIgASgIUglpc0tl'
    'eVNlbmQSIAoLUGVuZGluZ0Z1bGwYEyABKAhSC1BlbmRpbmdGdWxsEjgKF2Nsb3NlZENoYW5uZW'
    'xSZW1vdGVUeElEGBQgASgJUhdjbG9zZWRDaGFubmVsUmVtb3RlVHhJRBI2ChZjbG9zZWRDaGFu'
    'bmVsU3dlZXBUeElEGBUgASgJUhZjbG9zZWRDaGFubmVsU3dlZXBUeElEEhoKCGdyb3VwS2V5GB'
    'YgASgJUghncm91cEtleRIcCglncm91cE5hbWUYFyABKAlSCWdyb3VwTmFtZRI2CgxsbnVybFBh'
    'eUluZm8YGCABKAsyEi5kYXRhLkxOVXJsUGF5SW5mb1IMbG51cmxQYXlJbmZvIlYKC1BheW1lbn'
    'RUeXBlEgsKB0RFUE9TSVQQABIOCgpXSVRIRFJBV0FMEAESCAoEU0VOVBACEgwKCFJFQ0VJVkVE'
    'EAMSEgoOQ0xPU0VEX0NIQU5ORUwQBA==');

@$core.Deprecated('Use paymentsListDescriptor instead')
const PaymentsList$json = {
  '1': 'PaymentsList',
  '2': [
    {'1': 'paymentsList', '3': 1, '4': 3, '5': 11, '6': '.data.Payment', '10': 'paymentsList'},
  ],
};

/// Descriptor for `PaymentsList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentsListDescriptor = $convert.base64Decode(
    'CgxQYXltZW50c0xpc3QSMQoMcGF5bWVudHNMaXN0GAEgAygLMg0uZGF0YS5QYXltZW50UgxwYX'
    'ltZW50c0xpc3Q=');

@$core.Deprecated('Use paymentResponseDescriptor instead')
const PaymentResponse$json = {
  '1': 'PaymentResponse',
  '2': [
    {'1': 'paymentError', '3': 1, '4': 1, '5': 9, '10': 'paymentError'},
    {'1': 'traceReport', '3': 2, '4': 1, '5': 9, '10': 'traceReport'},
  ],
};

/// Descriptor for `PaymentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentResponseDescriptor = $convert.base64Decode(
    'Cg9QYXltZW50UmVzcG9uc2USIgoMcGF5bWVudEVycm9yGAEgASgJUgxwYXltZW50RXJyb3ISIA'
    'oLdHJhY2VSZXBvcnQYAiABKAlSC3RyYWNlUmVwb3J0');

@$core.Deprecated('Use sendWalletCoinsRequestDescriptor instead')
const SendWalletCoinsRequest$json = {
  '1': 'SendWalletCoinsRequest',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'satPerByteFee', '3': 2, '4': 1, '5': 3, '10': 'satPerByteFee'},
  ],
};

/// Descriptor for `SendWalletCoinsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendWalletCoinsRequestDescriptor = $convert.base64Decode(
    'ChZTZW5kV2FsbGV0Q29pbnNSZXF1ZXN0EhgKB2FkZHJlc3MYASABKAlSB2FkZHJlc3MSJAoNc2'
    'F0UGVyQnl0ZUZlZRgCIAEoA1INc2F0UGVyQnl0ZUZlZQ==');

@$core.Deprecated('Use payInvoiceRequestDescriptor instead')
const PayInvoiceRequest$json = {
  '1': 'PayInvoiceRequest',
  '2': [
    {'1': 'amount', '3': 1, '4': 1, '5': 3, '10': 'amount'},
    {'1': 'paymentRequest', '3': 2, '4': 1, '5': 9, '10': 'paymentRequest'},
    {'1': 'fee', '3': 3, '4': 1, '5': 3, '10': 'fee'},
  ],
};

/// Descriptor for `PayInvoiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List payInvoiceRequestDescriptor = $convert.base64Decode(
    'ChFQYXlJbnZvaWNlUmVxdWVzdBIWCgZhbW91bnQYASABKANSBmFtb3VudBImCg5wYXltZW50Um'
    'VxdWVzdBgCIAEoCVIOcGF5bWVudFJlcXVlc3QSEAoDZmVlGAMgASgDUgNmZWU=');

@$core.Deprecated('Use spontaneousPaymentRequestDescriptor instead')
const SpontaneousPaymentRequest$json = {
  '1': 'SpontaneousPaymentRequest',
  '2': [
    {'1': 'amount', '3': 1, '4': 1, '5': 3, '10': 'amount'},
    {'1': 'destNode', '3': 2, '4': 1, '5': 9, '10': 'destNode'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'groupKey', '3': 4, '4': 1, '5': 9, '10': 'groupKey'},
    {'1': 'groupName', '3': 5, '4': 1, '5': 9, '10': 'groupName'},
    {'1': 'feeLimitMsat', '3': 6, '4': 1, '5': 3, '10': 'feeLimitMsat'},
    {'1': 'tlv', '3': 7, '4': 3, '5': 11, '6': '.data.SpontaneousPaymentRequest.TlvEntry', '10': 'tlv'},
  ],
  '3': [SpontaneousPaymentRequest_TlvEntry$json],
};

@$core.Deprecated('Use spontaneousPaymentRequestDescriptor instead')
const SpontaneousPaymentRequest_TlvEntry$json = {
  '1': 'TlvEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 3, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SpontaneousPaymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List spontaneousPaymentRequestDescriptor = $convert.base64Decode(
    'ChlTcG9udGFuZW91c1BheW1lbnRSZXF1ZXN0EhYKBmFtb3VudBgBIAEoA1IGYW1vdW50EhoKCG'
    'Rlc3ROb2RlGAIgASgJUghkZXN0Tm9kZRIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRp'
    'b24SGgoIZ3JvdXBLZXkYBCABKAlSCGdyb3VwS2V5EhwKCWdyb3VwTmFtZRgFIAEoCVIJZ3JvdX'
    'BOYW1lEiIKDGZlZUxpbWl0TXNhdBgGIAEoA1IMZmVlTGltaXRNc2F0EjoKA3RsdhgHIAMoCzIo'
    'LmRhdGEuU3BvbnRhbmVvdXNQYXltZW50UmVxdWVzdC5UbHZFbnRyeVIDdGx2GjYKCFRsdkVudH'
    'J5EhAKA2tleRgBIAEoA1IDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use invoiceMemoDescriptor instead')
const InvoiceMemo$json = {
  '1': 'InvoiceMemo',
  '2': [
    {'1': 'description', '3': 1, '4': 1, '5': 9, '10': 'description'},
    {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
    {'1': 'payeeName', '3': 3, '4': 1, '5': 9, '10': 'payeeName'},
    {'1': 'payeeImageURL', '3': 4, '4': 1, '5': 9, '10': 'payeeImageURL'},
    {'1': 'payerName', '3': 5, '4': 1, '5': 9, '10': 'payerName'},
    {'1': 'payerImageURL', '3': 6, '4': 1, '5': 9, '10': 'payerImageURL'},
    {'1': 'transferRequest', '3': 7, '4': 1, '5': 8, '10': 'transferRequest'},
    {'1': 'expiry', '3': 8, '4': 1, '5': 3, '10': 'expiry'},
    {'1': 'preimage', '3': 9, '4': 1, '5': 12, '10': 'preimage'},
  ],
};

/// Descriptor for `InvoiceMemo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceMemoDescriptor = $convert.base64Decode(
    'CgtJbnZvaWNlTWVtbxIgCgtkZXNjcmlwdGlvbhgBIAEoCVILZGVzY3JpcHRpb24SFgoGYW1vdW'
    '50GAIgASgDUgZhbW91bnQSHAoJcGF5ZWVOYW1lGAMgASgJUglwYXllZU5hbWUSJAoNcGF5ZWVJ'
    'bWFnZVVSTBgEIAEoCVINcGF5ZWVJbWFnZVVSTBIcCglwYXllck5hbWUYBSABKAlSCXBheWVyTm'
    'FtZRIkCg1wYXllckltYWdlVVJMGAYgASgJUg1wYXllckltYWdlVVJMEigKD3RyYW5zZmVyUmVx'
    'dWVzdBgHIAEoCFIPdHJhbnNmZXJSZXF1ZXN0EhYKBmV4cGlyeRgIIAEoA1IGZXhwaXJ5EhoKCH'
    'ByZWltYWdlGAkgASgMUghwcmVpbWFnZQ==');

@$core.Deprecated('Use addInvoiceRequestDescriptor instead')
const AddInvoiceRequest$json = {
  '1': 'AddInvoiceRequest',
  '2': [
    {'1': 'invoiceDetails', '3': 1, '4': 1, '5': 11, '6': '.data.InvoiceMemo', '10': 'invoiceDetails'},
    {'1': 'lspInfo', '3': 2, '4': 1, '5': 11, '6': '.data.LSPInformation', '10': 'lspInfo'},
    {'1': 'opening_fee_params', '3': 3, '4': 1, '5': 11, '6': '.data.OpeningFeeParams', '10': 'openingFeeParams'},
  ],
};

/// Descriptor for `AddInvoiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addInvoiceRequestDescriptor = $convert.base64Decode(
    'ChFBZGRJbnZvaWNlUmVxdWVzdBI5Cg5pbnZvaWNlRGV0YWlscxgBIAEoCzIRLmRhdGEuSW52b2'
    'ljZU1lbW9SDmludm9pY2VEZXRhaWxzEi4KB2xzcEluZm8YAiABKAsyFC5kYXRhLkxTUEluZm9y'
    'bWF0aW9uUgdsc3BJbmZvEkQKEm9wZW5pbmdfZmVlX3BhcmFtcxgDIAEoCzIWLmRhdGEuT3Blbm'
    'luZ0ZlZVBhcmFtc1IQb3BlbmluZ0ZlZVBhcmFtcw==');

@$core.Deprecated('Use invoiceDescriptor instead')
const Invoice$json = {
  '1': 'Invoice',
  '2': [
    {'1': 'memo', '3': 1, '4': 1, '5': 11, '6': '.data.InvoiceMemo', '10': 'memo'},
    {'1': 'settled', '3': 2, '4': 1, '5': 8, '10': 'settled'},
    {'1': 'amtPaid', '3': 3, '4': 1, '5': 3, '10': 'amtPaid'},
  ],
};

/// Descriptor for `Invoice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceDescriptor = $convert.base64Decode(
    'CgdJbnZvaWNlEiUKBG1lbW8YASABKAsyES5kYXRhLkludm9pY2VNZW1vUgRtZW1vEhgKB3NldH'
    'RsZWQYAiABKAhSB3NldHRsZWQSGAoHYW10UGFpZBgDIAEoA1IHYW10UGFpZA==');

@$core.Deprecated('Use checkLSPClosedChannelMismatchRequestDescriptor instead')
const CheckLSPClosedChannelMismatchRequest$json = {
  '1': 'CheckLSPClosedChannelMismatchRequest',
  '2': [
    {'1': 'lspInfo', '3': 1, '4': 1, '5': 11, '6': '.data.LSPInformation', '10': 'lspInfo'},
    {'1': 'chanPoint', '3': 2, '4': 1, '5': 9, '10': 'chanPoint'},
  ],
};

/// Descriptor for `CheckLSPClosedChannelMismatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkLSPClosedChannelMismatchRequestDescriptor = $convert.base64Decode(
    'CiRDaGVja0xTUENsb3NlZENoYW5uZWxNaXNtYXRjaFJlcXVlc3QSLgoHbHNwSW5mbxgBIAEoCz'
    'IULmRhdGEuTFNQSW5mb3JtYXRpb25SB2xzcEluZm8SHAoJY2hhblBvaW50GAIgASgJUgljaGFu'
    'UG9pbnQ=');

@$core.Deprecated('Use checkLSPClosedChannelMismatchResponseDescriptor instead')
const CheckLSPClosedChannelMismatchResponse$json = {
  '1': 'CheckLSPClosedChannelMismatchResponse',
  '2': [
    {'1': 'mismatch', '3': 1, '4': 1, '5': 8, '10': 'mismatch'},
  ],
};

/// Descriptor for `CheckLSPClosedChannelMismatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkLSPClosedChannelMismatchResponseDescriptor = $convert.base64Decode(
    'CiVDaGVja0xTUENsb3NlZENoYW5uZWxNaXNtYXRjaFJlc3BvbnNlEhoKCG1pc21hdGNoGAEgAS'
    'gIUghtaXNtYXRjaA==');

@$core.Deprecated('Use resetClosedChannelChainInfoRequestDescriptor instead')
const ResetClosedChannelChainInfoRequest$json = {
  '1': 'ResetClosedChannelChainInfoRequest',
  '2': [
    {'1': 'chanPoint', '3': 1, '4': 1, '5': 9, '10': 'chanPoint'},
    {'1': 'blockHeight', '3': 2, '4': 1, '5': 3, '10': 'blockHeight'},
  ],
};

/// Descriptor for `ResetClosedChannelChainInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetClosedChannelChainInfoRequestDescriptor = $convert.base64Decode(
    'CiJSZXNldENsb3NlZENoYW5uZWxDaGFpbkluZm9SZXF1ZXN0EhwKCWNoYW5Qb2ludBgBIAEoCV'
    'IJY2hhblBvaW50EiAKC2Jsb2NrSGVpZ2h0GAIgASgDUgtibG9ja0hlaWdodA==');

@$core.Deprecated('Use resetClosedChannelChainInfoReplyDescriptor instead')
const ResetClosedChannelChainInfoReply$json = {
  '1': 'ResetClosedChannelChainInfoReply',
};

/// Descriptor for `ResetClosedChannelChainInfoReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetClosedChannelChainInfoReplyDescriptor = $convert.base64Decode(
    'CiBSZXNldENsb3NlZENoYW5uZWxDaGFpbkluZm9SZXBseQ==');

@$core.Deprecated('Use notificationEventDescriptor instead')
const NotificationEvent$json = {
  '1': 'NotificationEvent',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.data.NotificationEvent.NotificationType', '10': 'type'},
    {'1': 'data', '3': 2, '4': 3, '5': 9, '10': 'data'},
  ],
  '4': [NotificationEvent_NotificationType$json],
};

@$core.Deprecated('Use notificationEventDescriptor instead')
const NotificationEvent_NotificationType$json = {
  '1': 'NotificationType',
  '2': [
    {'1': 'READY', '2': 0},
    {'1': 'INITIALIZATION_FAILED', '2': 1},
    {'1': 'ACCOUNT_CHANGED', '2': 2},
    {'1': 'PAYMENT_SENT', '2': 3},
    {'1': 'INVOICE_PAID', '2': 4},
    {'1': 'LIGHTNING_SERVICE_DOWN', '2': 5},
    {'1': 'FUND_ADDRESS_CREATED', '2': 6},
    {'1': 'FUND_ADDRESS_UNSPENT_CHANGED', '2': 7},
    {'1': 'BACKUP_SUCCESS', '2': 8},
    {'1': 'BACKUP_FAILED', '2': 9},
    {'1': 'BACKUP_AUTH_FAILED', '2': 10},
    {'1': 'BACKUP_NODE_CONFLICT', '2': 11},
    {'1': 'BACKUP_REQUEST', '2': 12},
    {'1': 'PAYMENT_FAILED', '2': 13},
    {'1': 'PAYMENT_SUCCEEDED', '2': 14},
    {'1': 'REVERSE_SWAP_CLAIM_STARTED', '2': 15},
    {'1': 'REVERSE_SWAP_CLAIM_SUCCEEDED', '2': 16},
    {'1': 'REVERSE_SWAP_CLAIM_FAILED', '2': 17},
    {'1': 'REVERSE_SWAP_CLAIM_CONFIRMED', '2': 18},
    {'1': 'LSP_CHANNEL_OPENED', '2': 19},
    {'1': 'BACKUP_NOT_LATEST_CONFLICT', '2': 20},
  ],
};

/// Descriptor for `NotificationEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationEventDescriptor = $convert.base64Decode(
    'ChFOb3RpZmljYXRpb25FdmVudBI8CgR0eXBlGAEgASgOMiguZGF0YS5Ob3RpZmljYXRpb25Fdm'
    'VudC5Ob3RpZmljYXRpb25UeXBlUgR0eXBlEhIKBGRhdGEYAiADKAlSBGRhdGEinAQKEE5vdGlm'
    'aWNhdGlvblR5cGUSCQoFUkVBRFkQABIZChVJTklUSUFMSVpBVElPTl9GQUlMRUQQARITCg9BQ0'
    'NPVU5UX0NIQU5HRUQQAhIQCgxQQVlNRU5UX1NFTlQQAxIQCgxJTlZPSUNFX1BBSUQQBBIaChZM'
    'SUdIVE5JTkdfU0VSVklDRV9ET1dOEAUSGAoURlVORF9BRERSRVNTX0NSRUFURUQQBhIgChxGVU'
    '5EX0FERFJFU1NfVU5TUEVOVF9DSEFOR0VEEAcSEgoOQkFDS1VQX1NVQ0NFU1MQCBIRCg1CQUNL'
    'VVBfRkFJTEVEEAkSFgoSQkFDS1VQX0FVVEhfRkFJTEVEEAoSGAoUQkFDS1VQX05PREVfQ09ORk'
    'xJQ1QQCxISCg5CQUNLVVBfUkVRVUVTVBAMEhIKDlBBWU1FTlRfRkFJTEVEEA0SFQoRUEFZTUVO'
    'VF9TVUNDRUVERUQQDhIeChpSRVZFUlNFX1NXQVBfQ0xBSU1fU1RBUlRFRBAPEiAKHFJFVkVSU0'
    'VfU1dBUF9DTEFJTV9TVUNDRUVERUQQEBIdChlSRVZFUlNFX1NXQVBfQ0xBSU1fRkFJTEVEEBES'
    'IAocUkVWRVJTRV9TV0FQX0NMQUlNX0NPTkZJUk1FRBASEhYKEkxTUF9DSEFOTkVMX09QRU5FRB'
    'ATEh4KGkJBQ0tVUF9OT1RfTEFURVNUX0NPTkZMSUNUEBQ=');

@$core.Deprecated('Use addFundInitReplyDescriptor instead')
const AddFundInitReply$json = {
  '1': 'AddFundInitReply',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'maxAllowedDeposit', '3': 2, '4': 1, '5': 3, '10': 'maxAllowedDeposit'},
    {'1': 'errorMessage', '3': 3, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'backupJson', '3': 4, '4': 1, '5': 9, '10': 'backupJson'},
    {'1': 'requiredReserve', '3': 5, '4': 1, '5': 3, '10': 'requiredReserve'},
    {'1': 'minAllowedDeposit', '3': 6, '4': 1, '5': 3, '10': 'minAllowedDeposit'},
  ],
};

/// Descriptor for `AddFundInitReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFundInitReplyDescriptor = $convert.base64Decode(
    'ChBBZGRGdW5kSW5pdFJlcGx5EhgKB2FkZHJlc3MYASABKAlSB2FkZHJlc3MSLAoRbWF4QWxsb3'
    'dlZERlcG9zaXQYAiABKANSEW1heEFsbG93ZWREZXBvc2l0EiIKDGVycm9yTWVzc2FnZRgDIAEo'
    'CVIMZXJyb3JNZXNzYWdlEh4KCmJhY2t1cEpzb24YBCABKAlSCmJhY2t1cEpzb24SKAoPcmVxdW'
    'lyZWRSZXNlcnZlGAUgASgDUg9yZXF1aXJlZFJlc2VydmUSLAoRbWluQWxsb3dlZERlcG9zaXQY'
    'BiABKANSEW1pbkFsbG93ZWREZXBvc2l0');

@$core.Deprecated('Use addFundReplyDescriptor instead')
const AddFundReply$json = {
  '1': 'AddFundReply',
  '2': [
    {'1': 'errorMessage', '3': 1, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `AddFundReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFundReplyDescriptor = $convert.base64Decode(
    'CgxBZGRGdW5kUmVwbHkSIgoMZXJyb3JNZXNzYWdlGAEgASgJUgxlcnJvck1lc3NhZ2U=');

@$core.Deprecated('Use refundRequestDescriptor instead')
const RefundRequest$json = {
  '1': 'RefundRequest',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'refundAddress', '3': 2, '4': 1, '5': 9, '10': 'refundAddress'},
    {'1': 'target_conf', '3': 3, '4': 1, '5': 5, '10': 'targetConf'},
    {'1': 'sat_per_byte', '3': 4, '4': 1, '5': 3, '10': 'satPerByte'},
  ],
};

/// Descriptor for `RefundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundRequestDescriptor = $convert.base64Decode(
    'Cg1SZWZ1bmRSZXF1ZXN0EhgKB2FkZHJlc3MYASABKAlSB2FkZHJlc3MSJAoNcmVmdW5kQWRkcm'
    'VzcxgCIAEoCVINcmVmdW5kQWRkcmVzcxIfCgt0YXJnZXRfY29uZhgDIAEoBVIKdGFyZ2V0Q29u'
    'ZhIgCgxzYXRfcGVyX2J5dGUYBCABKANSCnNhdFBlckJ5dGU=');

@$core.Deprecated('Use addFundErrorDescriptor instead')
const AddFundError$json = {
  '1': 'AddFundError',
  '2': [
    {'1': 'swapAddressInfo', '3': 1, '4': 1, '5': 11, '6': '.data.SwapAddressInfo', '10': 'swapAddressInfo'},
    {'1': 'hoursToUnlock', '3': 2, '4': 1, '5': 2, '10': 'hoursToUnlock'},
  ],
};

/// Descriptor for `AddFundError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFundErrorDescriptor = $convert.base64Decode(
    'CgxBZGRGdW5kRXJyb3ISPwoPc3dhcEFkZHJlc3NJbmZvGAEgASgLMhUuZGF0YS5Td2FwQWRkcm'
    'Vzc0luZm9SD3N3YXBBZGRyZXNzSW5mbxIkCg1ob3Vyc1RvVW5sb2NrGAIgASgCUg1ob3Vyc1Rv'
    'VW5sb2Nr');

@$core.Deprecated('Use fundStatusReplyDescriptor instead')
const FundStatusReply$json = {
  '1': 'FundStatusReply',
  '2': [
    {'1': 'unConfirmedAddresses', '3': 1, '4': 3, '5': 11, '6': '.data.SwapAddressInfo', '10': 'unConfirmedAddresses'},
    {'1': 'confirmedAddresses', '3': 2, '4': 3, '5': 11, '6': '.data.SwapAddressInfo', '10': 'confirmedAddresses'},
    {'1': 'refundableAddresses', '3': 3, '4': 3, '5': 11, '6': '.data.SwapAddressInfo', '10': 'refundableAddresses'},
  ],
};

/// Descriptor for `FundStatusReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fundStatusReplyDescriptor = $convert.base64Decode(
    'Cg9GdW5kU3RhdHVzUmVwbHkSSQoUdW5Db25maXJtZWRBZGRyZXNzZXMYASADKAsyFS5kYXRhLl'
    'N3YXBBZGRyZXNzSW5mb1IUdW5Db25maXJtZWRBZGRyZXNzZXMSRQoSY29uZmlybWVkQWRkcmVz'
    'c2VzGAIgAygLMhUuZGF0YS5Td2FwQWRkcmVzc0luZm9SEmNvbmZpcm1lZEFkZHJlc3NlcxJHCh'
    'NyZWZ1bmRhYmxlQWRkcmVzc2VzGAMgAygLMhUuZGF0YS5Td2FwQWRkcmVzc0luZm9SE3JlZnVu'
    'ZGFibGVBZGRyZXNzZXM=');

@$core.Deprecated('Use removeFundRequestDescriptor instead')
const RemoveFundRequest$json = {
  '1': 'RemoveFundRequest',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
  ],
};

/// Descriptor for `RemoveFundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeFundRequestDescriptor = $convert.base64Decode(
    'ChFSZW1vdmVGdW5kUmVxdWVzdBIYCgdhZGRyZXNzGAEgASgJUgdhZGRyZXNzEhYKBmFtb3VudB'
    'gCIAEoA1IGYW1vdW50');

@$core.Deprecated('Use removeFundReplyDescriptor instead')
const RemoveFundReply$json = {
  '1': 'RemoveFundReply',
  '2': [
    {'1': 'txid', '3': 1, '4': 1, '5': 9, '10': 'txid'},
    {'1': 'errorMessage', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `RemoveFundReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeFundReplyDescriptor = $convert.base64Decode(
    'Cg9SZW1vdmVGdW5kUmVwbHkSEgoEdHhpZBgBIAEoCVIEdHhpZBIiCgxlcnJvck1lc3NhZ2UYAi'
    'ABKAlSDGVycm9yTWVzc2FnZQ==');

@$core.Deprecated('Use swapAddressInfoDescriptor instead')
const SwapAddressInfo$json = {
  '1': 'SwapAddressInfo',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'PaymentHash', '3': 2, '4': 1, '5': 9, '10': 'PaymentHash'},
    {'1': 'ConfirmedAmount', '3': 3, '4': 1, '5': 3, '10': 'ConfirmedAmount'},
    {'1': 'ConfirmedTransactionIds', '3': 4, '4': 3, '5': 9, '10': 'ConfirmedTransactionIds'},
    {'1': 'PaidAmount', '3': 5, '4': 1, '5': 3, '10': 'PaidAmount'},
    {'1': 'lockHeight', '3': 6, '4': 1, '5': 13, '10': 'lockHeight'},
    {'1': 'errorMessage', '3': 7, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'lastRefundTxID', '3': 8, '4': 1, '5': 9, '10': 'lastRefundTxID'},
    {'1': 'swapError', '3': 9, '4': 1, '5': 14, '6': '.data.SwapError', '10': 'swapError'},
    {'1': 'FundingTxID', '3': 10, '4': 1, '5': 9, '10': 'FundingTxID'},
    {'1': 'hoursToUnlock', '3': 11, '4': 1, '5': 2, '10': 'hoursToUnlock'},
    {'1': 'nonBlocking', '3': 12, '4': 1, '5': 8, '10': 'nonBlocking'},
  ],
};

/// Descriptor for `SwapAddressInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List swapAddressInfoDescriptor = $convert.base64Decode(
    'Cg9Td2FwQWRkcmVzc0luZm8SGAoHYWRkcmVzcxgBIAEoCVIHYWRkcmVzcxIgCgtQYXltZW50SG'
    'FzaBgCIAEoCVILUGF5bWVudEhhc2gSKAoPQ29uZmlybWVkQW1vdW50GAMgASgDUg9Db25maXJt'
    'ZWRBbW91bnQSOAoXQ29uZmlybWVkVHJhbnNhY3Rpb25JZHMYBCADKAlSF0NvbmZpcm1lZFRyYW'
    '5zYWN0aW9uSWRzEh4KClBhaWRBbW91bnQYBSABKANSClBhaWRBbW91bnQSHgoKbG9ja0hlaWdo'
    'dBgGIAEoDVIKbG9ja0hlaWdodBIiCgxlcnJvck1lc3NhZ2UYByABKAlSDGVycm9yTWVzc2FnZR'
    'ImCg5sYXN0UmVmdW5kVHhJRBgIIAEoCVIObGFzdFJlZnVuZFR4SUQSLQoJc3dhcEVycm9yGAkg'
    'ASgOMg8uZGF0YS5Td2FwRXJyb3JSCXN3YXBFcnJvchIgCgtGdW5kaW5nVHhJRBgKIAEoCVILRn'
    'VuZGluZ1R4SUQSJAoNaG91cnNUb1VubG9jaxgLIAEoAlINaG91cnNUb1VubG9jaxIgCgtub25C'
    'bG9ja2luZxgMIAEoCFILbm9uQmxvY2tpbmc=');

@$core.Deprecated('Use swapAddressListDescriptor instead')
const SwapAddressList$json = {
  '1': 'SwapAddressList',
  '2': [
    {'1': 'addresses', '3': 1, '4': 3, '5': 11, '6': '.data.SwapAddressInfo', '10': 'addresses'},
  ],
};

/// Descriptor for `SwapAddressList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List swapAddressListDescriptor = $convert.base64Decode(
    'Cg9Td2FwQWRkcmVzc0xpc3QSMwoJYWRkcmVzc2VzGAEgAygLMhUuZGF0YS5Td2FwQWRkcmVzc0'
    'luZm9SCWFkZHJlc3Nlcw==');

@$core.Deprecated('Use createRatchetSessionRequestDescriptor instead')
const CreateRatchetSessionRequest$json = {
  '1': 'CreateRatchetSessionRequest',
  '2': [
    {'1': 'secret', '3': 1, '4': 1, '5': 9, '10': 'secret'},
    {'1': 'remotePubKey', '3': 2, '4': 1, '5': 9, '10': 'remotePubKey'},
    {'1': 'sessionID', '3': 3, '4': 1, '5': 9, '10': 'sessionID'},
    {'1': 'expiry', '3': 4, '4': 1, '5': 4, '10': 'expiry'},
  ],
};

/// Descriptor for `CreateRatchetSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRatchetSessionRequestDescriptor = $convert.base64Decode(
    'ChtDcmVhdGVSYXRjaGV0U2Vzc2lvblJlcXVlc3QSFgoGc2VjcmV0GAEgASgJUgZzZWNyZXQSIg'
    'oMcmVtb3RlUHViS2V5GAIgASgJUgxyZW1vdGVQdWJLZXkSHAoJc2Vzc2lvbklEGAMgASgJUglz'
    'ZXNzaW9uSUQSFgoGZXhwaXJ5GAQgASgEUgZleHBpcnk=');

@$core.Deprecated('Use createRatchetSessionReplyDescriptor instead')
const CreateRatchetSessionReply$json = {
  '1': 'CreateRatchetSessionReply',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    {'1': 'secret', '3': 2, '4': 1, '5': 9, '10': 'secret'},
    {'1': 'pubKey', '3': 3, '4': 1, '5': 9, '10': 'pubKey'},
  ],
};

/// Descriptor for `CreateRatchetSessionReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRatchetSessionReplyDescriptor = $convert.base64Decode(
    'ChlDcmVhdGVSYXRjaGV0U2Vzc2lvblJlcGx5EhwKCXNlc3Npb25JRBgBIAEoCVIJc2Vzc2lvbk'
    'lEEhYKBnNlY3JldBgCIAEoCVIGc2VjcmV0EhYKBnB1YktleRgDIAEoCVIGcHViS2V5');

@$core.Deprecated('Use ratchetSessionInfoReplyDescriptor instead')
const RatchetSessionInfoReply$json = {
  '1': 'RatchetSessionInfoReply',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    {'1': 'initiated', '3': 2, '4': 1, '5': 8, '10': 'initiated'},
    {'1': 'userInfo', '3': 3, '4': 1, '5': 9, '10': 'userInfo'},
  ],
};

/// Descriptor for `RatchetSessionInfoReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ratchetSessionInfoReplyDescriptor = $convert.base64Decode(
    'ChdSYXRjaGV0U2Vzc2lvbkluZm9SZXBseRIcCglzZXNzaW9uSUQYASABKAlSCXNlc3Npb25JRB'
    'IcCglpbml0aWF0ZWQYAiABKAhSCWluaXRpYXRlZBIaCgh1c2VySW5mbxgDIAEoCVIIdXNlcklu'
    'Zm8=');

@$core.Deprecated('Use ratchetSessionSetInfoRequestDescriptor instead')
const RatchetSessionSetInfoRequest$json = {
  '1': 'RatchetSessionSetInfoRequest',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    {'1': 'userInfo', '3': 2, '4': 1, '5': 9, '10': 'userInfo'},
  ],
};

/// Descriptor for `RatchetSessionSetInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ratchetSessionSetInfoRequestDescriptor = $convert.base64Decode(
    'ChxSYXRjaGV0U2Vzc2lvblNldEluZm9SZXF1ZXN0EhwKCXNlc3Npb25JRBgBIAEoCVIJc2Vzc2'
    'lvbklEEhoKCHVzZXJJbmZvGAIgASgJUgh1c2VySW5mbw==');

@$core.Deprecated('Use ratchetEncryptRequestDescriptor instead')
const RatchetEncryptRequest$json = {
  '1': 'RatchetEncryptRequest',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RatchetEncryptRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ratchetEncryptRequestDescriptor = $convert.base64Decode(
    'ChVSYXRjaGV0RW5jcnlwdFJlcXVlc3QSHAoJc2Vzc2lvbklEGAEgASgJUglzZXNzaW9uSUQSGA'
    'oHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use ratchetDecryptRequestDescriptor instead')
const RatchetDecryptRequest$json = {
  '1': 'RatchetDecryptRequest',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    {'1': 'encryptedMessage', '3': 2, '4': 1, '5': 9, '10': 'encryptedMessage'},
  ],
};

/// Descriptor for `RatchetDecryptRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ratchetDecryptRequestDescriptor = $convert.base64Decode(
    'ChVSYXRjaGV0RGVjcnlwdFJlcXVlc3QSHAoJc2Vzc2lvbklEGAEgASgJUglzZXNzaW9uSUQSKg'
    'oQZW5jcnlwdGVkTWVzc2FnZRgCIAEoCVIQZW5jcnlwdGVkTWVzc2FnZQ==');

@$core.Deprecated('Use bootstrapFilesRequestDescriptor instead')
const BootstrapFilesRequest$json = {
  '1': 'BootstrapFilesRequest',
  '2': [
    {'1': 'WorkingDir', '3': 1, '4': 1, '5': 9, '10': 'WorkingDir'},
    {'1': 'FullPaths', '3': 2, '4': 3, '5': 9, '10': 'FullPaths'},
  ],
};

/// Descriptor for `BootstrapFilesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bootstrapFilesRequestDescriptor = $convert.base64Decode(
    'ChVCb290c3RyYXBGaWxlc1JlcXVlc3QSHgoKV29ya2luZ0RpchgBIAEoCVIKV29ya2luZ0Rpch'
    'IcCglGdWxsUGF0aHMYAiADKAlSCUZ1bGxQYXRocw==');

@$core.Deprecated('Use peersDescriptor instead')
const Peers$json = {
  '1': 'Peers',
  '2': [
    {'1': 'isDefault', '3': 1, '4': 1, '5': 8, '10': 'isDefault'},
    {'1': 'peer', '3': 2, '4': 3, '5': 9, '10': 'peer'},
  ],
};

/// Descriptor for `Peers`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List peersDescriptor = $convert.base64Decode(
    'CgVQZWVycxIcCglpc0RlZmF1bHQYASABKAhSCWlzRGVmYXVsdBISCgRwZWVyGAIgAygJUgRwZW'
    'Vy');

@$core.Deprecated('Use txSpentURLDescriptor instead')
const TxSpentURL$json = {
  '1': 'TxSpentURL',
  '2': [
    {'1': 'URL', '3': 1, '4': 1, '5': 9, '10': 'URL'},
    {'1': 'isDefault', '3': 2, '4': 1, '5': 8, '10': 'isDefault'},
    {'1': 'disabled', '3': 3, '4': 1, '5': 8, '10': 'disabled'},
  ],
};

/// Descriptor for `TxSpentURL`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txSpentURLDescriptor = $convert.base64Decode(
    'CgpUeFNwZW50VVJMEhAKA1VSTBgBIAEoCVIDVVJMEhwKCWlzRGVmYXVsdBgCIAEoCFIJaXNEZW'
    'ZhdWx0EhoKCGRpc2FibGVkGAMgASgIUghkaXNhYmxlZA==');

@$core.Deprecated('Use rateDescriptor instead')
const rate$json = {
  '1': 'rate',
  '2': [
    {'1': 'coin', '3': 1, '4': 1, '5': 9, '10': 'coin'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
};

/// Descriptor for `rate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateDescriptor = $convert.base64Decode(
    'CgRyYXRlEhIKBGNvaW4YASABKAlSBGNvaW4SFAoFdmFsdWUYAiABKAFSBXZhbHVl');

@$core.Deprecated('Use ratesDescriptor instead')
const Rates$json = {
  '1': 'Rates',
  '2': [
    {'1': 'rates', '3': 1, '4': 3, '5': 11, '6': '.data.rate', '10': 'rates'},
  ],
};

/// Descriptor for `Rates`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ratesDescriptor = $convert.base64Decode(
    'CgVSYXRlcxIgCgVyYXRlcxgBIAMoCzIKLmRhdGEucmF0ZVIFcmF0ZXM=');

@$core.Deprecated('Use lSPInformationDescriptor instead')
const LSPInformation$json = {
  '1': 'LSPInformation',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'widget_url', '3': 3, '4': 1, '5': 9, '10': 'widgetUrl'},
    {'1': 'pubkey', '3': 4, '4': 1, '5': 9, '10': 'pubkey'},
    {'1': 'host', '3': 5, '4': 1, '5': 9, '10': 'host'},
    {'1': 'channel_capacity', '3': 6, '4': 1, '5': 3, '10': 'channelCapacity'},
    {'1': 'target_conf', '3': 7, '4': 1, '5': 5, '10': 'targetConf'},
    {'1': 'base_fee_msat', '3': 8, '4': 1, '5': 3, '10': 'baseFeeMsat'},
    {'1': 'fee_rate', '3': 9, '4': 1, '5': 1, '10': 'feeRate'},
    {'1': 'time_lock_delta', '3': 10, '4': 1, '5': 13, '10': 'timeLockDelta'},
    {'1': 'min_htlc_msat', '3': 11, '4': 1, '5': 3, '10': 'minHtlcMsat'},
    {
      '1': 'channel_fee_permyriad',
      '3': 12,
      '4': 1,
      '5': 3,
      '8': {'3': true},
      '10': 'channelFeePermyriad',
    },
    {'1': 'lsp_pubkey', '3': 13, '4': 1, '5': 12, '10': 'lspPubkey'},
    {
      '1': 'max_inactive_duration',
      '3': 14,
      '4': 1,
      '5': 3,
      '8': {'3': true},
      '10': 'maxInactiveDuration',
    },
    {
      '1': 'channel_minimum_fee_msat',
      '3': 15,
      '4': 1,
      '5': 3,
      '8': {'3': true},
      '10': 'channelMinimumFeeMsat',
    },
    {'1': 'cheapest_opening_fee_params', '3': 16, '4': 1, '5': 11, '6': '.data.OpeningFeeParams', '10': 'cheapestOpeningFeeParams'},
    {'1': 'longest_valid_opening_fee_params', '3': 17, '4': 1, '5': 11, '6': '.data.OpeningFeeParams', '10': 'longestValidOpeningFeeParams'},
  ],
};

/// Descriptor for `LSPInformation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lSPInformationDescriptor = $convert.base64Decode(
    'Cg5MU1BJbmZvcm1hdGlvbhIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIdCg'
    'p3aWRnZXRfdXJsGAMgASgJUgl3aWRnZXRVcmwSFgoGcHVia2V5GAQgASgJUgZwdWJrZXkSEgoE'
    'aG9zdBgFIAEoCVIEaG9zdBIpChBjaGFubmVsX2NhcGFjaXR5GAYgASgDUg9jaGFubmVsQ2FwYW'
    'NpdHkSHwoLdGFyZ2V0X2NvbmYYByABKAVSCnRhcmdldENvbmYSIgoNYmFzZV9mZWVfbXNhdBgI'
    'IAEoA1ILYmFzZUZlZU1zYXQSGQoIZmVlX3JhdGUYCSABKAFSB2ZlZVJhdGUSJgoPdGltZV9sb2'
    'NrX2RlbHRhGAogASgNUg10aW1lTG9ja0RlbHRhEiIKDW1pbl9odGxjX21zYXQYCyABKANSC21p'
    'bkh0bGNNc2F0EjYKFWNoYW5uZWxfZmVlX3Blcm15cmlhZBgMIAEoA0ICGAFSE2NoYW5uZWxGZW'
    'VQZXJteXJpYWQSHQoKbHNwX3B1YmtleRgNIAEoDFIJbHNwUHVia2V5EjYKFW1heF9pbmFjdGl2'
    'ZV9kdXJhdGlvbhgOIAEoA0ICGAFSE21heEluYWN0aXZlRHVyYXRpb24SOwoYY2hhbm5lbF9taW'
    '5pbXVtX2ZlZV9tc2F0GA8gASgDQgIYAVIVY2hhbm5lbE1pbmltdW1GZWVNc2F0ElUKG2NoZWFw'
    'ZXN0X29wZW5pbmdfZmVlX3BhcmFtcxgQIAEoCzIWLmRhdGEuT3BlbmluZ0ZlZVBhcmFtc1IYY2'
    'hlYXBlc3RPcGVuaW5nRmVlUGFyYW1zEl4KIGxvbmdlc3RfdmFsaWRfb3BlbmluZ19mZWVfcGFy'
    'YW1zGBEgASgLMhYuZGF0YS5PcGVuaW5nRmVlUGFyYW1zUhxsb25nZXN0VmFsaWRPcGVuaW5nRm'
    'VlUGFyYW1z');

@$core.Deprecated('Use openingFeeParamsDescriptor instead')
const OpeningFeeParams$json = {
  '1': 'OpeningFeeParams',
  '2': [
    {'1': 'min_msat', '3': 1, '4': 1, '5': 4, '10': 'minMsat'},
    {'1': 'proportional', '3': 2, '4': 1, '5': 13, '10': 'proportional'},
    {'1': 'valid_until', '3': 3, '4': 1, '5': 9, '10': 'validUntil'},
    {'1': 'max_idle_time', '3': 4, '4': 1, '5': 13, '10': 'maxIdleTime'},
    {'1': 'max_client_to_self_delay', '3': 5, '4': 1, '5': 13, '10': 'maxClientToSelfDelay'},
    {'1': 'promise', '3': 6, '4': 1, '5': 9, '10': 'promise'},
    {'1': 'min_payment_size_msat', '3': 7, '4': 1, '5': 4, '10': 'minPaymentSizeMsat'},
    {'1': 'max_payment_size_msat', '3': 8, '4': 1, '5': 4, '10': 'maxPaymentSizeMsat'},
  ],
};

/// Descriptor for `OpeningFeeParams`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openingFeeParamsDescriptor = $convert.base64Decode(
    'ChBPcGVuaW5nRmVlUGFyYW1zEhkKCG1pbl9tc2F0GAEgASgEUgdtaW5Nc2F0EiIKDHByb3Bvcn'
    'Rpb25hbBgCIAEoDVIMcHJvcG9ydGlvbmFsEh8KC3ZhbGlkX3VudGlsGAMgASgJUgp2YWxpZFVu'
    'dGlsEiIKDW1heF9pZGxlX3RpbWUYBCABKA1SC21heElkbGVUaW1lEjYKGG1heF9jbGllbnRfdG'
    '9fc2VsZl9kZWxheRgFIAEoDVIUbWF4Q2xpZW50VG9TZWxmRGVsYXkSGAoHcHJvbWlzZRgGIAEo'
    'CVIHcHJvbWlzZRIxChVtaW5fcGF5bWVudF9zaXplX21zYXQYByABKARSEm1pblBheW1lbnRTaX'
    'plTXNhdBIxChVtYXhfcGF5bWVudF9zaXplX21zYXQYCCABKARSEm1heFBheW1lbnRTaXplTXNh'
    'dA==');

@$core.Deprecated('Use lSPListRequestDescriptor instead')
const LSPListRequest$json = {
  '1': 'LSPListRequest',
};

/// Descriptor for `LSPListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lSPListRequestDescriptor = $convert.base64Decode(
    'Cg5MU1BMaXN0UmVxdWVzdA==');

@$core.Deprecated('Use lSPListDescriptor instead')
const LSPList$json = {
  '1': 'LSPList',
  '2': [
    {'1': 'lsps', '3': 1, '4': 3, '5': 11, '6': '.data.LSPList.LspsEntry', '10': 'lsps'},
  ],
  '3': [LSPList_LspsEntry$json],
};

@$core.Deprecated('Use lSPListDescriptor instead')
const LSPList_LspsEntry$json = {
  '1': 'LspsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.data.LSPInformation', '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `LSPList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lSPListDescriptor = $convert.base64Decode(
    'CgdMU1BMaXN0EisKBGxzcHMYASADKAsyFy5kYXRhLkxTUExpc3QuTHNwc0VudHJ5UgRsc3BzGk'
    '0KCUxzcHNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIqCgV2YWx1ZRgCIAEoCzIULmRhdGEuTFNQ'
    'SW5mb3JtYXRpb25SBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use lSPActivityDescriptor instead')
const LSPActivity$json = {
  '1': 'LSPActivity',
  '2': [
    {'1': 'activity', '3': 1, '4': 3, '5': 11, '6': '.data.LSPActivity.ActivityEntry', '10': 'activity'},
  ],
  '3': [LSPActivity_ActivityEntry$json],
};

@$core.Deprecated('Use lSPActivityDescriptor instead')
const LSPActivity_ActivityEntry$json = {
  '1': 'ActivityEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `LSPActivity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lSPActivityDescriptor = $convert.base64Decode(
    'CgtMU1BBY3Rpdml0eRI7CghhY3Rpdml0eRgBIAMoCzIfLmRhdGEuTFNQQWN0aXZpdHkuQWN0aX'
    'ZpdHlFbnRyeVIIYWN0aXZpdHkaOwoNQWN0aXZpdHlFbnRyeRIQCgNrZXkYASABKAlSA2tleRIU'
    'CgV2YWx1ZRgCIAEoA1IFdmFsdWU6AjgB');

@$core.Deprecated('Use connectLSPRequestDescriptor instead')
const ConnectLSPRequest$json = {
  '1': 'ConnectLSPRequest',
  '2': [
    {'1': 'lsp_id', '3': 1, '4': 1, '5': 9, '10': 'lspId'},
  ],
};

/// Descriptor for `ConnectLSPRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectLSPRequestDescriptor = $convert.base64Decode(
    'ChFDb25uZWN0TFNQUmVxdWVzdBIVCgZsc3BfaWQYASABKAlSBWxzcElk');

@$core.Deprecated('Use connectLSPReplyDescriptor instead')
const ConnectLSPReply$json = {
  '1': 'ConnectLSPReply',
};

/// Descriptor for `ConnectLSPReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectLSPReplyDescriptor = $convert.base64Decode(
    'Cg9Db25uZWN0TFNQUmVwbHk=');

@$core.Deprecated('Use lNUrlResponseDescriptor instead')
const LNUrlResponse$json = {
  '1': 'LNUrlResponse',
  '2': [
    {'1': 'withdraw', '3': 1, '4': 1, '5': 11, '6': '.data.LNUrlWithdraw', '9': 0, '10': 'withdraw'},
    {'1': 'channel', '3': 2, '4': 1, '5': 11, '6': '.data.LNURLChannel', '9': 0, '10': 'channel'},
    {'1': 'auth', '3': 3, '4': 1, '5': 11, '6': '.data.LNURLAuth', '9': 0, '10': 'auth'},
    {'1': 'payResponse1', '3': 4, '4': 1, '5': 11, '6': '.data.LNURLPayResponse1', '9': 0, '10': 'payResponse1'},
  ],
  '8': [
    {'1': 'action'},
  ],
};

/// Descriptor for `LNUrlResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNUrlResponseDescriptor = $convert.base64Decode(
    'Cg1MTlVybFJlc3BvbnNlEjEKCHdpdGhkcmF3GAEgASgLMhMuZGF0YS5MTlVybFdpdGhkcmF3SA'
    'BSCHdpdGhkcmF3Ei4KB2NoYW5uZWwYAiABKAsyEi5kYXRhLkxOVVJMQ2hhbm5lbEgAUgdjaGFu'
    'bmVsEiUKBGF1dGgYAyABKAsyDy5kYXRhLkxOVVJMQXV0aEgAUgRhdXRoEj0KDHBheVJlc3Bvbn'
    'NlMRgEIAEoCzIXLmRhdGEuTE5VUkxQYXlSZXNwb25zZTFIAFIMcGF5UmVzcG9uc2UxQggKBmFj'
    'dGlvbg==');

@$core.Deprecated('Use lNUrlWithdrawDescriptor instead')
const LNUrlWithdraw$json = {
  '1': 'LNUrlWithdraw',
  '2': [
    {'1': 'min_amount', '3': 1, '4': 1, '5': 3, '10': 'minAmount'},
    {'1': 'max_amount', '3': 2, '4': 1, '5': 3, '10': 'maxAmount'},
    {'1': 'default_description', '3': 3, '4': 1, '5': 9, '10': 'defaultDescription'},
  ],
};

/// Descriptor for `LNUrlWithdraw`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNUrlWithdrawDescriptor = $convert.base64Decode(
    'Cg1MTlVybFdpdGhkcmF3Eh0KCm1pbl9hbW91bnQYASABKANSCW1pbkFtb3VudBIdCgptYXhfYW'
    '1vdW50GAIgASgDUgltYXhBbW91bnQSLwoTZGVmYXVsdF9kZXNjcmlwdGlvbhgDIAEoCVISZGVm'
    'YXVsdERlc2NyaXB0aW9u');

@$core.Deprecated('Use lNURLChannelDescriptor instead')
const LNURLChannel$json = {
  '1': 'LNURLChannel',
  '2': [
    {'1': 'k1', '3': 1, '4': 1, '5': 9, '10': 'k1'},
    {'1': 'callback', '3': 2, '4': 1, '5': 9, '10': 'callback'},
    {'1': 'uri', '3': 3, '4': 1, '5': 9, '10': 'uri'},
  ],
};

/// Descriptor for `LNURLChannel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNURLChannelDescriptor = $convert.base64Decode(
    'CgxMTlVSTENoYW5uZWwSDgoCazEYASABKAlSAmsxEhoKCGNhbGxiYWNrGAIgASgJUghjYWxsYm'
    'FjaxIQCgN1cmkYAyABKAlSA3VyaQ==');

@$core.Deprecated('Use lNURLAuthDescriptor instead')
const LNURLAuth$json = {
  '1': 'LNURLAuth',
  '2': [
    {'1': 'tag', '3': 1, '4': 1, '5': 9, '10': 'tag'},
    {'1': 'k1', '3': 2, '4': 1, '5': 9, '10': 'k1'},
    {'1': 'callback', '3': 3, '4': 1, '5': 9, '10': 'callback'},
    {'1': 'host', '3': 4, '4': 1, '5': 9, '10': 'host'},
    {'1': 'jwt', '3': 5, '4': 1, '5': 8, '10': 'jwt'},
  ],
};

/// Descriptor for `LNURLAuth`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNURLAuthDescriptor = $convert.base64Decode(
    'CglMTlVSTEF1dGgSEAoDdGFnGAEgASgJUgN0YWcSDgoCazEYAiABKAlSAmsxEhoKCGNhbGxiYW'
    'NrGAMgASgJUghjYWxsYmFjaxISCgRob3N0GAQgASgJUgRob3N0EhAKA2p3dBgFIAEoCFIDand0');

@$core.Deprecated('Use lNUrlPayImageDescriptor instead')
const LNUrlPayImage$json = {
  '1': 'LNUrlPayImage',
  '2': [
    {'1': 'data_uri', '3': 1, '4': 1, '5': 9, '10': 'dataUri'},
    {'1': 'ext', '3': 2, '4': 1, '5': 9, '10': 'ext'},
    {'1': 'bytes', '3': 3, '4': 1, '5': 12, '10': 'bytes'},
  ],
};

/// Descriptor for `LNUrlPayImage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNUrlPayImageDescriptor = $convert.base64Decode(
    'Cg1MTlVybFBheUltYWdlEhkKCGRhdGFfdXJpGAEgASgJUgdkYXRhVXJpEhAKA2V4dBgCIAEoCV'
    'IDZXh0EhQKBWJ5dGVzGAMgASgMUgVieXRlcw==');

@$core.Deprecated('Use lNUrlPayMetadataDescriptor instead')
const LNUrlPayMetadata$json = {
  '1': 'LNUrlPayMetadata',
  '2': [
    {'1': 'entry', '3': 1, '4': 3, '5': 9, '10': 'entry'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'long_description', '3': 3, '4': 1, '5': 9, '10': 'longDescription'},
    {'1': 'image', '3': 4, '4': 1, '5': 11, '6': '.data.LNUrlPayImage', '10': 'image'},
  ],
};

/// Descriptor for `LNUrlPayMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNUrlPayMetadataDescriptor = $convert.base64Decode(
    'ChBMTlVybFBheU1ldGFkYXRhEhQKBWVudHJ5GAEgAygJUgVlbnRyeRIgCgtkZXNjcmlwdGlvbh'
    'gCIAEoCVILZGVzY3JpcHRpb24SKQoQbG9uZ19kZXNjcmlwdGlvbhgDIAEoCVIPbG9uZ0Rlc2Ny'
    'aXB0aW9uEikKBWltYWdlGAQgASgLMhMuZGF0YS5MTlVybFBheUltYWdlUgVpbWFnZQ==');

@$core.Deprecated('Use lNURLPayResponse1Descriptor instead')
const LNURLPayResponse1$json = {
  '1': 'LNURLPayResponse1',
  '2': [
    {'1': 'callback', '3': 1, '4': 1, '5': 9, '10': 'callback'},
    {'1': 'min_amount', '3': 2, '4': 1, '5': 3, '10': 'minAmount'},
    {'1': 'max_amount', '3': 3, '4': 1, '5': 3, '10': 'maxAmount'},
    {'1': 'metadata', '3': 4, '4': 3, '5': 11, '6': '.data.LNUrlPayMetadata', '10': 'metadata'},
    {'1': 'tag', '3': 5, '4': 1, '5': 9, '10': 'tag'},
    {'1': 'amount', '3': 6, '4': 1, '5': 4, '10': 'amount'},
    {'1': 'from_nodes', '3': 7, '4': 1, '5': 9, '10': 'fromNodes'},
    {'1': 'comment', '3': 8, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'host', '3': 9, '4': 1, '5': 9, '10': 'host'},
    {'1': 'comment_allowed', '3': 10, '4': 1, '5': 3, '10': 'commentAllowed'},
    {'1': 'lightning_address', '3': 11, '4': 1, '5': 9, '10': 'lightningAddress'},
  ],
};

/// Descriptor for `LNURLPayResponse1`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNURLPayResponse1Descriptor = $convert.base64Decode(
    'ChFMTlVSTFBheVJlc3BvbnNlMRIaCghjYWxsYmFjaxgBIAEoCVIIY2FsbGJhY2sSHQoKbWluX2'
    'Ftb3VudBgCIAEoA1IJbWluQW1vdW50Eh0KCm1heF9hbW91bnQYAyABKANSCW1heEFtb3VudBIy'
    'CghtZXRhZGF0YRgEIAMoCzIWLmRhdGEuTE5VcmxQYXlNZXRhZGF0YVIIbWV0YWRhdGESEAoDdG'
    'FnGAUgASgJUgN0YWcSFgoGYW1vdW50GAYgASgEUgZhbW91bnQSHQoKZnJvbV9ub2RlcxgHIAEo'
    'CVIJZnJvbU5vZGVzEhgKB2NvbW1lbnQYCCABKAlSB2NvbW1lbnQSEgoEaG9zdBgJIAEoCVIEaG'
    '9zdBInCg9jb21tZW50X2FsbG93ZWQYCiABKANSDmNvbW1lbnRBbGxvd2VkEisKEWxpZ2h0bmlu'
    'Z19hZGRyZXNzGAsgASgJUhBsaWdodG5pbmdBZGRyZXNz');

@$core.Deprecated('Use successActionDescriptor instead')
const SuccessAction$json = {
  '1': 'SuccessAction',
  '2': [
    {'1': 'tag', '3': 1, '4': 1, '5': 9, '10': 'tag'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'url', '3': 3, '4': 1, '5': 9, '10': 'url'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
    {'1': 'ciphertext', '3': 5, '4': 1, '5': 9, '10': 'ciphertext'},
    {'1': 'iv', '3': 6, '4': 1, '5': 9, '10': 'iv'},
  ],
};

/// Descriptor for `SuccessAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List successActionDescriptor = $convert.base64Decode(
    'Cg1TdWNjZXNzQWN0aW9uEhAKA3RhZxgBIAEoCVIDdGFnEiAKC2Rlc2NyaXB0aW9uGAIgASgJUg'
    'tkZXNjcmlwdGlvbhIQCgN1cmwYAyABKAlSA3VybBIYCgdtZXNzYWdlGAQgASgJUgdtZXNzYWdl'
    'Eh4KCmNpcGhlcnRleHQYBSABKAlSCmNpcGhlcnRleHQSDgoCaXYYBiABKAlSAml2');

@$core.Deprecated('Use lNUrlPayInfoDescriptor instead')
const LNUrlPayInfo$json = {
  '1': 'LNUrlPayInfo',
  '2': [
    {'1': 'paymentHash', '3': 1, '4': 1, '5': 9, '10': 'paymentHash'},
    {'1': 'invoice', '3': 2, '4': 1, '5': 9, '10': 'invoice'},
    {'1': 'success_action', '3': 3, '4': 1, '5': 11, '6': '.data.SuccessAction', '10': 'successAction'},
    {'1': 'comment', '3': 4, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'invoice_description', '3': 5, '4': 1, '5': 9, '10': 'invoiceDescription'},
    {'1': 'metadata', '3': 6, '4': 3, '5': 11, '6': '.data.LNUrlPayMetadata', '10': 'metadata'},
    {'1': 'host', '3': 7, '4': 1, '5': 9, '10': 'host'},
    {'1': 'lightning_address', '3': 8, '4': 1, '5': 9, '10': 'lightningAddress'},
  ],
};

/// Descriptor for `LNUrlPayInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNUrlPayInfoDescriptor = $convert.base64Decode(
    'CgxMTlVybFBheUluZm8SIAoLcGF5bWVudEhhc2gYASABKAlSC3BheW1lbnRIYXNoEhgKB2ludm'
    '9pY2UYAiABKAlSB2ludm9pY2USOgoOc3VjY2Vzc19hY3Rpb24YAyABKAsyEy5kYXRhLlN1Y2Nl'
    'c3NBY3Rpb25SDXN1Y2Nlc3NBY3Rpb24SGAoHY29tbWVudBgEIAEoCVIHY29tbWVudBIvChNpbn'
    'ZvaWNlX2Rlc2NyaXB0aW9uGAUgASgJUhJpbnZvaWNlRGVzY3JpcHRpb24SMgoIbWV0YWRhdGEY'
    'BiADKAsyFi5kYXRhLkxOVXJsUGF5TWV0YWRhdGFSCG1ldGFkYXRhEhIKBGhvc3QYByABKAlSBG'
    'hvc3QSKwoRbGlnaHRuaW5nX2FkZHJlc3MYCCABKAlSEGxpZ2h0bmluZ0FkZHJlc3M=');

@$core.Deprecated('Use lNUrlPayInfoListDescriptor instead')
const LNUrlPayInfoList$json = {
  '1': 'LNUrlPayInfoList',
  '2': [
    {'1': 'infoList', '3': 1, '4': 3, '5': 11, '6': '.data.LNUrlPayInfo', '10': 'infoList'},
  ],
};

/// Descriptor for `LNUrlPayInfoList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNUrlPayInfoListDescriptor = $convert.base64Decode(
    'ChBMTlVybFBheUluZm9MaXN0Ei4KCGluZm9MaXN0GAEgAygLMhIuZGF0YS5MTlVybFBheUluZm'
    '9SCGluZm9MaXN0');

@$core.Deprecated('Use reverseSwapRequestDescriptor instead')
const ReverseSwapRequest$json = {
  '1': 'ReverseSwapRequest',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
    {'1': 'fees_hash', '3': 3, '4': 1, '5': 9, '10': 'feesHash'},
  ],
};

/// Descriptor for `ReverseSwapRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapRequestDescriptor = $convert.base64Decode(
    'ChJSZXZlcnNlU3dhcFJlcXVlc3QSGAoHYWRkcmVzcxgBIAEoCVIHYWRkcmVzcxIWCgZhbW91bn'
    'QYAiABKANSBmFtb3VudBIbCglmZWVzX2hhc2gYAyABKAlSCGZlZXNIYXNo');

@$core.Deprecated('Use reverseSwapDescriptor instead')
const ReverseSwap$json = {
  '1': 'ReverseSwap',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'invoice', '3': 2, '4': 1, '5': 9, '10': 'invoice'},
    {'1': 'script', '3': 3, '4': 1, '5': 9, '10': 'script'},
    {'1': 'lockup_address', '3': 4, '4': 1, '5': 9, '10': 'lockupAddress'},
    {'1': 'preimage', '3': 5, '4': 1, '5': 9, '10': 'preimage'},
    {'1': 'key', '3': 6, '4': 1, '5': 9, '10': 'key'},
    {'1': 'claim_address', '3': 7, '4': 1, '5': 9, '10': 'claimAddress'},
    {'1': 'ln_amount', '3': 8, '4': 1, '5': 3, '10': 'lnAmount'},
    {'1': 'onchain_amount', '3': 9, '4': 1, '5': 3, '10': 'onchainAmount'},
    {'1': 'timeout_block_height', '3': 10, '4': 1, '5': 3, '10': 'timeoutBlockHeight'},
    {'1': 'start_block_height', '3': 11, '4': 1, '5': 3, '10': 'startBlockHeight'},
    {'1': 'claim_fee', '3': 12, '4': 1, '5': 3, '10': 'claimFee'},
    {'1': 'claim_txid', '3': 13, '4': 1, '5': 9, '10': 'claimTxid'},
  ],
};

/// Descriptor for `ReverseSwap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapDescriptor = $convert.base64Decode(
    'CgtSZXZlcnNlU3dhcBIOCgJpZBgBIAEoCVICaWQSGAoHaW52b2ljZRgCIAEoCVIHaW52b2ljZR'
    'IWCgZzY3JpcHQYAyABKAlSBnNjcmlwdBIlCg5sb2NrdXBfYWRkcmVzcxgEIAEoCVINbG9ja3Vw'
    'QWRkcmVzcxIaCghwcmVpbWFnZRgFIAEoCVIIcHJlaW1hZ2USEAoDa2V5GAYgASgJUgNrZXkSIw'
    'oNY2xhaW1fYWRkcmVzcxgHIAEoCVIMY2xhaW1BZGRyZXNzEhsKCWxuX2Ftb3VudBgIIAEoA1II'
    'bG5BbW91bnQSJQoOb25jaGFpbl9hbW91bnQYCSABKANSDW9uY2hhaW5BbW91bnQSMAoUdGltZW'
    '91dF9ibG9ja19oZWlnaHQYCiABKANSEnRpbWVvdXRCbG9ja0hlaWdodBIsChJzdGFydF9ibG9j'
    'a19oZWlnaHQYCyABKANSEHN0YXJ0QmxvY2tIZWlnaHQSGwoJY2xhaW1fZmVlGAwgASgDUghjbG'
    'FpbUZlZRIdCgpjbGFpbV90eGlkGA0gASgJUgljbGFpbVR4aWQ=');

@$core.Deprecated('Use reverseSwapFeesDescriptor instead')
const ReverseSwapFees$json = {
  '1': 'ReverseSwapFees',
  '2': [
    {'1': 'percentage', '3': 1, '4': 1, '5': 1, '10': 'percentage'},
    {'1': 'lockup', '3': 2, '4': 1, '5': 3, '10': 'lockup'},
    {'1': 'claim', '3': 3, '4': 1, '5': 3, '10': 'claim'},
  ],
};

/// Descriptor for `ReverseSwapFees`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapFeesDescriptor = $convert.base64Decode(
    'Cg9SZXZlcnNlU3dhcEZlZXMSHgoKcGVyY2VudGFnZRgBIAEoAVIKcGVyY2VudGFnZRIWCgZsb2'
    'NrdXAYAiABKANSBmxvY2t1cBIUCgVjbGFpbRgDIAEoA1IFY2xhaW0=');

@$core.Deprecated('Use reverseSwapInfoDescriptor instead')
const ReverseSwapInfo$json = {
  '1': 'ReverseSwapInfo',
  '2': [
    {'1': 'min', '3': 1, '4': 1, '5': 3, '10': 'min'},
    {'1': 'max', '3': 2, '4': 1, '5': 3, '10': 'max'},
    {'1': 'fees', '3': 3, '4': 1, '5': 11, '6': '.data.ReverseSwapFees', '10': 'fees'},
    {'1': 'fees_hash', '3': 4, '4': 1, '5': 9, '10': 'feesHash'},
  ],
};

/// Descriptor for `ReverseSwapInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapInfoDescriptor = $convert.base64Decode(
    'Cg9SZXZlcnNlU3dhcEluZm8SEAoDbWluGAEgASgDUgNtaW4SEAoDbWF4GAIgASgDUgNtYXgSKQ'
    'oEZmVlcxgDIAEoCzIVLmRhdGEuUmV2ZXJzZVN3YXBGZWVzUgRmZWVzEhsKCWZlZXNfaGFzaBgE'
    'IAEoCVIIZmVlc0hhc2g=');

@$core.Deprecated('Use reverseSwapPaymentRequestDescriptor instead')
const ReverseSwapPaymentRequest$json = {
  '1': 'ReverseSwapPaymentRequest',
  '2': [
    {'1': 'hash', '3': 1, '4': 1, '5': 9, '10': 'hash'},
    {'1': 'push_notification_details', '3': 2, '4': 1, '5': 11, '6': '.data.PushNotificationDetails', '10': 'pushNotificationDetails'},
    {'1': 'fee', '3': 3, '4': 1, '5': 3, '10': 'fee'},
  ],
};

/// Descriptor for `ReverseSwapPaymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapPaymentRequestDescriptor = $convert.base64Decode(
    'ChlSZXZlcnNlU3dhcFBheW1lbnRSZXF1ZXN0EhIKBGhhc2gYASABKAlSBGhhc2gSWQoZcHVzaF'
    '9ub3RpZmljYXRpb25fZGV0YWlscxgCIAEoCzIdLmRhdGEuUHVzaE5vdGlmaWNhdGlvbkRldGFp'
    'bHNSF3B1c2hOb3RpZmljYXRpb25EZXRhaWxzEhAKA2ZlZRgDIAEoA1IDZmVl');

@$core.Deprecated('Use pushNotificationDetailsDescriptor instead')
const PushNotificationDetails$json = {
  '1': 'PushNotificationDetails',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'body', '3': 3, '4': 1, '5': 9, '10': 'body'},
  ],
};

/// Descriptor for `PushNotificationDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushNotificationDetailsDescriptor = $convert.base64Decode(
    'ChdQdXNoTm90aWZpY2F0aW9uRGV0YWlscxIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEh'
    'QKBXRpdGxlGAIgASgJUgV0aXRsZRISCgRib2R5GAMgASgJUgRib2R5');

@$core.Deprecated('Use reverseSwapPaymentStatusDescriptor instead')
const ReverseSwapPaymentStatus$json = {
  '1': 'ReverseSwapPaymentStatus',
  '2': [
    {'1': 'hash', '3': 1, '4': 1, '5': 9, '10': 'hash'},
    {'1': 'txID', '3': 2, '4': 1, '5': 9, '10': 'txID'},
    {'1': 'eta', '3': 3, '4': 1, '5': 5, '10': 'eta'},
  ],
};

/// Descriptor for `ReverseSwapPaymentStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapPaymentStatusDescriptor = $convert.base64Decode(
    'ChhSZXZlcnNlU3dhcFBheW1lbnRTdGF0dXMSEgoEaGFzaBgBIAEoCVIEaGFzaBISCgR0eElEGA'
    'IgASgJUgR0eElEEhAKA2V0YRgDIAEoBVIDZXRh');

@$core.Deprecated('Use reverseSwapPaymentStatusesDescriptor instead')
const ReverseSwapPaymentStatuses$json = {
  '1': 'ReverseSwapPaymentStatuses',
  '2': [
    {'1': 'payments_status', '3': 1, '4': 3, '5': 11, '6': '.data.ReverseSwapPaymentStatus', '10': 'paymentsStatus'},
  ],
};

/// Descriptor for `ReverseSwapPaymentStatuses`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapPaymentStatusesDescriptor = $convert.base64Decode(
    'ChpSZXZlcnNlU3dhcFBheW1lbnRTdGF0dXNlcxJHCg9wYXltZW50c19zdGF0dXMYASADKAsyHi'
    '5kYXRhLlJldmVyc2VTd2FwUGF5bWVudFN0YXR1c1IOcGF5bWVudHNTdGF0dXM=');

@$core.Deprecated('Use reverseSwapClaimFeeDescriptor instead')
const ReverseSwapClaimFee$json = {
  '1': 'ReverseSwapClaimFee',
  '2': [
    {'1': 'hash', '3': 1, '4': 1, '5': 9, '10': 'hash'},
    {'1': 'fee', '3': 2, '4': 1, '5': 3, '10': 'fee'},
  ],
};

/// Descriptor for `ReverseSwapClaimFee`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapClaimFeeDescriptor = $convert.base64Decode(
    'ChNSZXZlcnNlU3dhcENsYWltRmVlEhIKBGhhc2gYASABKAlSBGhhc2gSEAoDZmVlGAIgASgDUg'
    'NmZWU=');

@$core.Deprecated('Use claimFeeEstimatesDescriptor instead')
const ClaimFeeEstimates$json = {
  '1': 'ClaimFeeEstimates',
  '2': [
    {'1': 'fees', '3': 1, '4': 3, '5': 11, '6': '.data.ClaimFeeEstimates.FeesEntry', '10': 'fees'},
  ],
  '3': [ClaimFeeEstimates_FeesEntry$json],
};

@$core.Deprecated('Use claimFeeEstimatesDescriptor instead')
const ClaimFeeEstimates_FeesEntry$json = {
  '1': 'FeesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ClaimFeeEstimates`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List claimFeeEstimatesDescriptor = $convert.base64Decode(
    'ChFDbGFpbUZlZUVzdGltYXRlcxI1CgRmZWVzGAEgAygLMiEuZGF0YS5DbGFpbUZlZUVzdGltYX'
    'Rlcy5GZWVzRW50cnlSBGZlZXMaNwoJRmVlc0VudHJ5EhAKA2tleRgBIAEoBVIDa2V5EhQKBXZh'
    'bHVlGAIgASgDUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use unspendLockupInformationDescriptor instead')
const UnspendLockupInformation$json = {
  '1': 'UnspendLockupInformation',
  '2': [
    {'1': 'height_hint', '3': 1, '4': 1, '5': 13, '10': 'heightHint'},
    {'1': 'lockup_script', '3': 2, '4': 1, '5': 12, '10': 'lockupScript'},
    {'1': 'claim_tx_hash', '3': 3, '4': 1, '5': 12, '10': 'claimTxHash'},
  ],
};

/// Descriptor for `UnspendLockupInformation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unspendLockupInformationDescriptor = $convert.base64Decode(
    'ChhVbnNwZW5kTG9ja3VwSW5mb3JtYXRpb24SHwoLaGVpZ2h0X2hpbnQYASABKA1SCmhlaWdodE'
    'hpbnQSIwoNbG9ja3VwX3NjcmlwdBgCIAEoDFIMbG9ja3VwU2NyaXB0EiIKDWNsYWltX3R4X2hh'
    'c2gYAyABKAxSC2NsYWltVHhIYXNo');

@$core.Deprecated('Use transactionDetailsDescriptor instead')
const TransactionDetails$json = {
  '1': 'TransactionDetails',
  '2': [
    {'1': 'tx', '3': 1, '4': 1, '5': 12, '10': 'tx'},
    {'1': 'tx_hash', '3': 2, '4': 1, '5': 9, '10': 'txHash'},
    {'1': 'fees', '3': 3, '4': 1, '5': 3, '10': 'fees'},
  ],
};

/// Descriptor for `TransactionDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transactionDetailsDescriptor = $convert.base64Decode(
    'ChJUcmFuc2FjdGlvbkRldGFpbHMSDgoCdHgYASABKAxSAnR4EhcKB3R4X2hhc2gYAiABKAlSBn'
    'R4SGFzaBISCgRmZWVzGAMgASgDUgRmZWVz');

@$core.Deprecated('Use sweepAllCoinsTransactionsDescriptor instead')
const SweepAllCoinsTransactions$json = {
  '1': 'SweepAllCoinsTransactions',
  '2': [
    {'1': 'amt', '3': 1, '4': 1, '5': 3, '10': 'amt'},
    {'1': 'transactions', '3': 2, '4': 3, '5': 11, '6': '.data.SweepAllCoinsTransactions.TransactionsEntry', '10': 'transactions'},
  ],
  '3': [SweepAllCoinsTransactions_TransactionsEntry$json],
};

@$core.Deprecated('Use sweepAllCoinsTransactionsDescriptor instead')
const SweepAllCoinsTransactions_TransactionsEntry$json = {
  '1': 'TransactionsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.data.TransactionDetails', '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SweepAllCoinsTransactions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sweepAllCoinsTransactionsDescriptor = $convert.base64Decode(
    'ChlTd2VlcEFsbENvaW5zVHJhbnNhY3Rpb25zEhAKA2FtdBgBIAEoA1IDYW10ElUKDHRyYW5zYW'
    'N0aW9ucxgCIAMoCzIxLmRhdGEuU3dlZXBBbGxDb2luc1RyYW5zYWN0aW9ucy5UcmFuc2FjdGlv'
    'bnNFbnRyeVIMdHJhbnNhY3Rpb25zGlkKEVRyYW5zYWN0aW9uc0VudHJ5EhAKA2tleRgBIAEoBV'
    'IDa2V5Ei4KBXZhbHVlGAIgASgLMhguZGF0YS5UcmFuc2FjdGlvbkRldGFpbHNSBXZhbHVlOgI4'
    'AQ==');

@$core.Deprecated('Use downloadBackupResponseDescriptor instead')
const DownloadBackupResponse$json = {
  '1': 'DownloadBackupResponse',
  '2': [
    {'1': 'files', '3': 1, '4': 3, '5': 9, '10': 'files'},
  ],
};

/// Descriptor for `DownloadBackupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadBackupResponseDescriptor = $convert.base64Decode(
    'ChZEb3dubG9hZEJhY2t1cFJlc3BvbnNlEhQKBWZpbGVzGAEgAygJUgVmaWxlcw==');

@$core.Deprecated('Use torConfigDescriptor instead')
const TorConfig$json = {
  '1': 'TorConfig',
  '2': [
    {'1': 'control', '3': 1, '4': 1, '5': 9, '10': 'control'},
    {'1': 'http', '3': 2, '4': 1, '5': 9, '10': 'http'},
    {'1': 'socks', '3': 3, '4': 1, '5': 9, '10': 'socks'},
  ],
};

/// Descriptor for `TorConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List torConfigDescriptor = $convert.base64Decode(
    'CglUb3JDb25maWcSGAoHY29udHJvbBgBIAEoCVIHY29udHJvbBISCgRodHRwGAIgASgJUgRodH'
    'RwEhQKBXNvY2tzGAMgASgJUgVzb2Nrcw==');


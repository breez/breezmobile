///
//  Generated code. Do not modify.
//  source: messages.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use swapErrorDescriptor instead')
const SwapError$json = const {
  '1': 'SwapError',
  '2': const [
    const {'1': 'NO_ERROR', '2': 0},
    const {'1': 'FUNDS_EXCEED_LIMIT', '2': 1},
    const {'1': 'TX_TOO_SMALL', '2': 2},
    const {'1': 'INVOICE_AMOUNT_MISMATCH', '2': 3},
    const {'1': 'SWAP_EXPIRED', '2': 4},
  ],
};

/// Descriptor for `SwapError`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List swapErrorDescriptor = $convert.base64Decode('CglTd2FwRXJyb3ISDAoITk9fRVJST1IQABIWChJGVU5EU19FWENFRURfTElNSVQQARIQCgxUWF9UT09fU01BTEwQAhIbChdJTlZPSUNFX0FNT1VOVF9NSVNNQVRDSBADEhAKDFNXQVBfRVhQSVJFRBAE');
@$core.Deprecated('Use listPaymentsRequestDescriptor instead')
const ListPaymentsRequest$json = const {
  '1': 'ListPaymentsRequest',
};

/// Descriptor for `ListPaymentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPaymentsRequestDescriptor = $convert.base64Decode('ChNMaXN0UGF5bWVudHNSZXF1ZXN0');
@$core.Deprecated('Use restartDaemonRequestDescriptor instead')
const RestartDaemonRequest$json = const {
  '1': 'RestartDaemonRequest',
};

/// Descriptor for `RestartDaemonRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restartDaemonRequestDescriptor = $convert.base64Decode('ChRSZXN0YXJ0RGFlbW9uUmVxdWVzdA==');
@$core.Deprecated('Use restartDaemonReplyDescriptor instead')
const RestartDaemonReply$json = const {
  '1': 'RestartDaemonReply',
};

/// Descriptor for `RestartDaemonReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restartDaemonReplyDescriptor = $convert.base64Decode('ChJSZXN0YXJ0RGFlbW9uUmVwbHk=');
@$core.Deprecated('Use addFundInitRequestDescriptor instead')
const AddFundInitRequest$json = const {
  '1': 'AddFundInitRequest',
  '2': const [
    const {'1': 'notificationToken', '3': 1, '4': 1, '5': 9, '10': 'notificationToken'},
    const {'1': 'lspID', '3': 2, '4': 1, '5': 9, '10': 'lspID'},
  ],
};

/// Descriptor for `AddFundInitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFundInitRequestDescriptor = $convert.base64Decode('ChJBZGRGdW5kSW5pdFJlcXVlc3QSLAoRbm90aWZpY2F0aW9uVG9rZW4YASABKAlSEW5vdGlmaWNhdGlvblRva2VuEhQKBWxzcElEGAIgASgJUgVsc3BJRA==');
@$core.Deprecated('Use fundStatusRequestDescriptor instead')
const FundStatusRequest$json = const {
  '1': 'FundStatusRequest',
  '2': const [
    const {'1': 'notificationToken', '3': 1, '4': 1, '5': 9, '10': 'notificationToken'},
  ],
};

/// Descriptor for `FundStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fundStatusRequestDescriptor = $convert.base64Decode('ChFGdW5kU3RhdHVzUmVxdWVzdBIsChFub3RpZmljYXRpb25Ub2tlbhgBIAEoCVIRbm90aWZpY2F0aW9uVG9rZW4=');
@$core.Deprecated('Use addInvoiceReplyDescriptor instead')
const AddInvoiceReply$json = const {
  '1': 'AddInvoiceReply',
  '2': const [
    const {'1': 'paymentRequest', '3': 1, '4': 1, '5': 9, '10': 'paymentRequest'},
    const {'1': 'lsp_fee', '3': 2, '4': 1, '5': 3, '10': 'lspFee'},
  ],
};

/// Descriptor for `AddInvoiceReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addInvoiceReplyDescriptor = $convert.base64Decode('Cg9BZGRJbnZvaWNlUmVwbHkSJgoOcGF5bWVudFJlcXVlc3QYASABKAlSDnBheW1lbnRSZXF1ZXN0EhcKB2xzcF9mZWUYAiABKANSBmxzcEZlZQ==');
@$core.Deprecated('Use chainStatusDescriptor instead')
const ChainStatus$json = const {
  '1': 'ChainStatus',
  '2': const [
    const {'1': 'blockHeight', '3': 1, '4': 1, '5': 13, '10': 'blockHeight'},
    const {'1': 'syncedToChain', '3': 2, '4': 1, '5': 8, '10': 'syncedToChain'},
  ],
};

/// Descriptor for `ChainStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chainStatusDescriptor = $convert.base64Decode('CgtDaGFpblN0YXR1cxIgCgtibG9ja0hlaWdodBgBIAEoDVILYmxvY2tIZWlnaHQSJAoNc3luY2VkVG9DaGFpbhgCIAEoCFINc3luY2VkVG9DaGFpbg==');
@$core.Deprecated('Use accountDescriptor instead')
const Account$json = const {
  '1': 'Account',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'balance', '3': 2, '4': 1, '5': 3, '10': 'balance'},
    const {'1': 'walletBalance', '3': 3, '4': 1, '5': 3, '10': 'walletBalance'},
    const {'1': 'status', '3': 4, '4': 1, '5': 14, '6': '.data.Account.AccountStatus', '10': 'status'},
    const {'1': 'maxAllowedToReceive', '3': 5, '4': 1, '5': 3, '10': 'maxAllowedToReceive'},
    const {'1': 'maxAllowedToPay', '3': 6, '4': 1, '5': 3, '10': 'maxAllowedToPay'},
    const {'1': 'maxPaymentAmount', '3': 7, '4': 1, '5': 3, '10': 'maxPaymentAmount'},
    const {'1': 'routingNodeFee', '3': 8, '4': 1, '5': 3, '10': 'routingNodeFee'},
    const {'1': 'enabled', '3': 9, '4': 1, '5': 8, '10': 'enabled'},
    const {'1': 'maxChanReserve', '3': 10, '4': 1, '5': 3, '10': 'maxChanReserve'},
    const {'1': 'channelPoint', '3': 11, '4': 1, '5': 9, '10': 'channelPoint'},
    const {'1': 'readyForPayments', '3': 12, '4': 1, '5': 8, '10': 'readyForPayments'},
    const {'1': 'tipHeight', '3': 13, '4': 1, '5': 3, '10': 'tipHeight'},
    const {'1': 'connectedPeers', '3': 14, '4': 3, '5': 9, '10': 'connectedPeers'},
    const {'1': 'max_inbound_liquidity', '3': 15, '4': 1, '5': 3, '10': 'maxInboundLiquidity'},
    const {'1': 'unconfirmed_channels', '3': 16, '4': 3, '5': 9, '10': 'unconfirmedChannels'},
  ],
  '4': const [Account_AccountStatus$json],
};

@$core.Deprecated('Use accountDescriptor instead')
const Account_AccountStatus$json = const {
  '1': 'AccountStatus',
  '2': const [
    const {'1': 'DISCONNECTED', '2': 0},
    const {'1': 'PROCESSING_CONNECTION', '2': 1},
    const {'1': 'CLOSING_CONNECTION', '2': 2},
    const {'1': 'CONNECTED', '2': 3},
  ],
};

/// Descriptor for `Account`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDescriptor = $convert.base64Decode('CgdBY2NvdW50Eg4KAmlkGAEgASgJUgJpZBIYCgdiYWxhbmNlGAIgASgDUgdiYWxhbmNlEiQKDXdhbGxldEJhbGFuY2UYAyABKANSDXdhbGxldEJhbGFuY2USMwoGc3RhdHVzGAQgASgOMhsuZGF0YS5BY2NvdW50LkFjY291bnRTdGF0dXNSBnN0YXR1cxIwChNtYXhBbGxvd2VkVG9SZWNlaXZlGAUgASgDUhNtYXhBbGxvd2VkVG9SZWNlaXZlEigKD21heEFsbG93ZWRUb1BheRgGIAEoA1IPbWF4QWxsb3dlZFRvUGF5EioKEG1heFBheW1lbnRBbW91bnQYByABKANSEG1heFBheW1lbnRBbW91bnQSJgoOcm91dGluZ05vZGVGZWUYCCABKANSDnJvdXRpbmdOb2RlRmVlEhgKB2VuYWJsZWQYCSABKAhSB2VuYWJsZWQSJgoObWF4Q2hhblJlc2VydmUYCiABKANSDm1heENoYW5SZXNlcnZlEiIKDGNoYW5uZWxQb2ludBgLIAEoCVIMY2hhbm5lbFBvaW50EioKEHJlYWR5Rm9yUGF5bWVudHMYDCABKAhSEHJlYWR5Rm9yUGF5bWVudHMSHAoJdGlwSGVpZ2h0GA0gASgDUgl0aXBIZWlnaHQSJgoOY29ubmVjdGVkUGVlcnMYDiADKAlSDmNvbm5lY3RlZFBlZXJzEjIKFW1heF9pbmJvdW5kX2xpcXVpZGl0eRgPIAEoA1ITbWF4SW5ib3VuZExpcXVpZGl0eRIxChR1bmNvbmZpcm1lZF9jaGFubmVscxgQIAMoCVITdW5jb25maXJtZWRDaGFubmVscyJjCg1BY2NvdW50U3RhdHVzEhAKDERJU0NPTk5FQ1RFRBAAEhkKFVBST0NFU1NJTkdfQ09OTkVDVElPThABEhYKEkNMT1NJTkdfQ09OTkVDVElPThACEg0KCUNPTk5FQ1RFRBAD');
@$core.Deprecated('Use paymentDescriptor instead')
const Payment$json = const {
  '1': 'Payment',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.data.Payment.PaymentType', '10': 'type'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 3, '10': 'amount'},
    const {'1': 'creationTimestamp', '3': 4, '4': 1, '5': 3, '10': 'creationTimestamp'},
    const {'1': 'invoiceMemo', '3': 6, '4': 1, '5': 11, '6': '.data.InvoiceMemo', '10': 'invoiceMemo'},
    const {'1': 'redeemTxID', '3': 7, '4': 1, '5': 9, '10': 'redeemTxID'},
    const {'1': 'paymentHash', '3': 8, '4': 1, '5': 9, '10': 'paymentHash'},
    const {'1': 'destination', '3': 9, '4': 1, '5': 9, '10': 'destination'},
    const {'1': 'PendingExpirationHeight', '3': 10, '4': 1, '5': 13, '10': 'PendingExpirationHeight'},
    const {'1': 'PendingExpirationTimestamp', '3': 11, '4': 1, '5': 3, '10': 'PendingExpirationTimestamp'},
    const {'1': 'fee', '3': 12, '4': 1, '5': 3, '10': 'fee'},
    const {'1': 'preimage', '3': 13, '4': 1, '5': 9, '10': 'preimage'},
    const {'1': 'closedChannelPoint', '3': 14, '4': 1, '5': 9, '10': 'closedChannelPoint'},
    const {'1': 'isChannelPending', '3': 15, '4': 1, '5': 8, '10': 'isChannelPending'},
    const {'1': 'isChannelCloseConfimed', '3': 16, '4': 1, '5': 8, '10': 'isChannelCloseConfimed'},
    const {'1': 'closedChannelTxID', '3': 17, '4': 1, '5': 9, '10': 'closedChannelTxID'},
    const {'1': 'isKeySend', '3': 18, '4': 1, '5': 8, '10': 'isKeySend'},
    const {'1': 'PendingFull', '3': 19, '4': 1, '5': 8, '10': 'PendingFull'},
    const {'1': 'closedChannelRemoteTxID', '3': 20, '4': 1, '5': 9, '10': 'closedChannelRemoteTxID'},
    const {'1': 'closedChannelSweepTxID', '3': 21, '4': 1, '5': 9, '10': 'closedChannelSweepTxID'},
    const {'1': 'groupKey', '3': 22, '4': 1, '5': 9, '10': 'groupKey'},
    const {'1': 'groupName', '3': 23, '4': 1, '5': 9, '10': 'groupName'},
    const {'1': 'lnurlPayInfo', '3': 24, '4': 1, '5': 11, '6': '.data.LNUrlPayInfo', '10': 'lnurlPayInfo'},
  ],
  '4': const [Payment_PaymentType$json],
};

@$core.Deprecated('Use paymentDescriptor instead')
const Payment_PaymentType$json = const {
  '1': 'PaymentType',
  '2': const [
    const {'1': 'DEPOSIT', '2': 0},
    const {'1': 'WITHDRAWAL', '2': 1},
    const {'1': 'SENT', '2': 2},
    const {'1': 'RECEIVED', '2': 3},
    const {'1': 'CLOSED_CHANNEL', '2': 4},
  ],
};

/// Descriptor for `Payment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentDescriptor = $convert.base64Decode('CgdQYXltZW50Ei0KBHR5cGUYASABKA4yGS5kYXRhLlBheW1lbnQuUGF5bWVudFR5cGVSBHR5cGUSFgoGYW1vdW50GAMgASgDUgZhbW91bnQSLAoRY3JlYXRpb25UaW1lc3RhbXAYBCABKANSEWNyZWF0aW9uVGltZXN0YW1wEjMKC2ludm9pY2VNZW1vGAYgASgLMhEuZGF0YS5JbnZvaWNlTWVtb1ILaW52b2ljZU1lbW8SHgoKcmVkZWVtVHhJRBgHIAEoCVIKcmVkZWVtVHhJRBIgCgtwYXltZW50SGFzaBgIIAEoCVILcGF5bWVudEhhc2gSIAoLZGVzdGluYXRpb24YCSABKAlSC2Rlc3RpbmF0aW9uEjgKF1BlbmRpbmdFeHBpcmF0aW9uSGVpZ2h0GAogASgNUhdQZW5kaW5nRXhwaXJhdGlvbkhlaWdodBI+ChpQZW5kaW5nRXhwaXJhdGlvblRpbWVzdGFtcBgLIAEoA1IaUGVuZGluZ0V4cGlyYXRpb25UaW1lc3RhbXASEAoDZmVlGAwgASgDUgNmZWUSGgoIcHJlaW1hZ2UYDSABKAlSCHByZWltYWdlEi4KEmNsb3NlZENoYW5uZWxQb2ludBgOIAEoCVISY2xvc2VkQ2hhbm5lbFBvaW50EioKEGlzQ2hhbm5lbFBlbmRpbmcYDyABKAhSEGlzQ2hhbm5lbFBlbmRpbmcSNgoWaXNDaGFubmVsQ2xvc2VDb25maW1lZBgQIAEoCFIWaXNDaGFubmVsQ2xvc2VDb25maW1lZBIsChFjbG9zZWRDaGFubmVsVHhJRBgRIAEoCVIRY2xvc2VkQ2hhbm5lbFR4SUQSHAoJaXNLZXlTZW5kGBIgASgIUglpc0tleVNlbmQSIAoLUGVuZGluZ0Z1bGwYEyABKAhSC1BlbmRpbmdGdWxsEjgKF2Nsb3NlZENoYW5uZWxSZW1vdGVUeElEGBQgASgJUhdjbG9zZWRDaGFubmVsUmVtb3RlVHhJRBI2ChZjbG9zZWRDaGFubmVsU3dlZXBUeElEGBUgASgJUhZjbG9zZWRDaGFubmVsU3dlZXBUeElEEhoKCGdyb3VwS2V5GBYgASgJUghncm91cEtleRIcCglncm91cE5hbWUYFyABKAlSCWdyb3VwTmFtZRI2CgxsbnVybFBheUluZm8YGCABKAsyEi5kYXRhLkxOVXJsUGF5SW5mb1IMbG51cmxQYXlJbmZvIlYKC1BheW1lbnRUeXBlEgsKB0RFUE9TSVQQABIOCgpXSVRIRFJBV0FMEAESCAoEU0VOVBACEgwKCFJFQ0VJVkVEEAMSEgoOQ0xPU0VEX0NIQU5ORUwQBA==');
@$core.Deprecated('Use paymentsListDescriptor instead')
const PaymentsList$json = const {
  '1': 'PaymentsList',
  '2': const [
    const {'1': 'paymentsList', '3': 1, '4': 3, '5': 11, '6': '.data.Payment', '10': 'paymentsList'},
  ],
};

/// Descriptor for `PaymentsList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentsListDescriptor = $convert.base64Decode('CgxQYXltZW50c0xpc3QSMQoMcGF5bWVudHNMaXN0GAEgAygLMg0uZGF0YS5QYXltZW50UgxwYXltZW50c0xpc3Q=');
@$core.Deprecated('Use paymentResponseDescriptor instead')
const PaymentResponse$json = const {
  '1': 'PaymentResponse',
  '2': const [
    const {'1': 'paymentError', '3': 1, '4': 1, '5': 9, '10': 'paymentError'},
    const {'1': 'traceReport', '3': 2, '4': 1, '5': 9, '10': 'traceReport'},
  ],
};

/// Descriptor for `PaymentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentResponseDescriptor = $convert.base64Decode('Cg9QYXltZW50UmVzcG9uc2USIgoMcGF5bWVudEVycm9yGAEgASgJUgxwYXltZW50RXJyb3ISIAoLdHJhY2VSZXBvcnQYAiABKAlSC3RyYWNlUmVwb3J0');
@$core.Deprecated('Use sendWalletCoinsRequestDescriptor instead')
const SendWalletCoinsRequest$json = const {
  '1': 'SendWalletCoinsRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'satPerByteFee', '3': 2, '4': 1, '5': 3, '10': 'satPerByteFee'},
  ],
};

/// Descriptor for `SendWalletCoinsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendWalletCoinsRequestDescriptor = $convert.base64Decode('ChZTZW5kV2FsbGV0Q29pbnNSZXF1ZXN0EhgKB2FkZHJlc3MYASABKAlSB2FkZHJlc3MSJAoNc2F0UGVyQnl0ZUZlZRgCIAEoA1INc2F0UGVyQnl0ZUZlZQ==');
@$core.Deprecated('Use payInvoiceRequestDescriptor instead')
const PayInvoiceRequest$json = const {
  '1': 'PayInvoiceRequest',
  '2': const [
    const {'1': 'amount', '3': 1, '4': 1, '5': 3, '10': 'amount'},
    const {'1': 'paymentRequest', '3': 2, '4': 1, '5': 9, '10': 'paymentRequest'},
  ],
};

/// Descriptor for `PayInvoiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List payInvoiceRequestDescriptor = $convert.base64Decode('ChFQYXlJbnZvaWNlUmVxdWVzdBIWCgZhbW91bnQYASABKANSBmFtb3VudBImCg5wYXltZW50UmVxdWVzdBgCIAEoCVIOcGF5bWVudFJlcXVlc3Q=');
@$core.Deprecated('Use spontaneousPaymentRequestDescriptor instead')
const SpontaneousPaymentRequest$json = const {
  '1': 'SpontaneousPaymentRequest',
  '2': const [
    const {'1': 'amount', '3': 1, '4': 1, '5': 3, '10': 'amount'},
    const {'1': 'destNode', '3': 2, '4': 1, '5': 9, '10': 'destNode'},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'groupKey', '3': 4, '4': 1, '5': 9, '10': 'groupKey'},
    const {'1': 'groupName', '3': 5, '4': 1, '5': 9, '10': 'groupName'},
    const {'1': 'feeLimitMsat', '3': 6, '4': 1, '5': 3, '10': 'feeLimitMsat'},
    const {'1': 'tlv', '3': 7, '4': 3, '5': 11, '6': '.data.SpontaneousPaymentRequest.TlvEntry', '10': 'tlv'},
  ],
  '3': const [SpontaneousPaymentRequest_TlvEntry$json],
};

@$core.Deprecated('Use spontaneousPaymentRequestDescriptor instead')
const SpontaneousPaymentRequest_TlvEntry$json = const {
  '1': 'TlvEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 3, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `SpontaneousPaymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List spontaneousPaymentRequestDescriptor = $convert.base64Decode('ChlTcG9udGFuZW91c1BheW1lbnRSZXF1ZXN0EhYKBmFtb3VudBgBIAEoA1IGYW1vdW50EhoKCGRlc3ROb2RlGAIgASgJUghkZXN0Tm9kZRIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24SGgoIZ3JvdXBLZXkYBCABKAlSCGdyb3VwS2V5EhwKCWdyb3VwTmFtZRgFIAEoCVIJZ3JvdXBOYW1lEiIKDGZlZUxpbWl0TXNhdBgGIAEoA1IMZmVlTGltaXRNc2F0EjoKA3RsdhgHIAMoCzIoLmRhdGEuU3BvbnRhbmVvdXNQYXltZW50UmVxdWVzdC5UbHZFbnRyeVIDdGx2GjYKCFRsdkVudHJ5EhAKA2tleRgBIAEoA1IDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use invoiceMemoDescriptor instead')
const InvoiceMemo$json = const {
  '1': 'InvoiceMemo',
  '2': const [
    const {'1': 'description', '3': 1, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
    const {'1': 'payeeName', '3': 3, '4': 1, '5': 9, '10': 'payeeName'},
    const {'1': 'payeeImageURL', '3': 4, '4': 1, '5': 9, '10': 'payeeImageURL'},
    const {'1': 'payerName', '3': 5, '4': 1, '5': 9, '10': 'payerName'},
    const {'1': 'payerImageURL', '3': 6, '4': 1, '5': 9, '10': 'payerImageURL'},
    const {'1': 'transferRequest', '3': 7, '4': 1, '5': 8, '10': 'transferRequest'},
    const {'1': 'expiry', '3': 8, '4': 1, '5': 3, '10': 'expiry'},
    const {'1': 'preimage', '3': 9, '4': 1, '5': 12, '10': 'preimage'},
  ],
};

/// Descriptor for `InvoiceMemo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceMemoDescriptor = $convert.base64Decode('CgtJbnZvaWNlTWVtbxIgCgtkZXNjcmlwdGlvbhgBIAEoCVILZGVzY3JpcHRpb24SFgoGYW1vdW50GAIgASgDUgZhbW91bnQSHAoJcGF5ZWVOYW1lGAMgASgJUglwYXllZU5hbWUSJAoNcGF5ZWVJbWFnZVVSTBgEIAEoCVINcGF5ZWVJbWFnZVVSTBIcCglwYXllck5hbWUYBSABKAlSCXBheWVyTmFtZRIkCg1wYXllckltYWdlVVJMGAYgASgJUg1wYXllckltYWdlVVJMEigKD3RyYW5zZmVyUmVxdWVzdBgHIAEoCFIPdHJhbnNmZXJSZXF1ZXN0EhYKBmV4cGlyeRgIIAEoA1IGZXhwaXJ5EhoKCHByZWltYWdlGAkgASgMUghwcmVpbWFnZQ==');
@$core.Deprecated('Use addInvoiceRequestDescriptor instead')
const AddInvoiceRequest$json = const {
  '1': 'AddInvoiceRequest',
  '2': const [
    const {'1': 'invoiceDetails', '3': 1, '4': 1, '5': 11, '6': '.data.InvoiceMemo', '10': 'invoiceDetails'},
    const {'1': 'lspInfo', '3': 2, '4': 1, '5': 11, '6': '.data.LSPInformation', '10': 'lspInfo'},
  ],
};

/// Descriptor for `AddInvoiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addInvoiceRequestDescriptor = $convert.base64Decode('ChFBZGRJbnZvaWNlUmVxdWVzdBI5Cg5pbnZvaWNlRGV0YWlscxgBIAEoCzIRLmRhdGEuSW52b2ljZU1lbW9SDmludm9pY2VEZXRhaWxzEi4KB2xzcEluZm8YAiABKAsyFC5kYXRhLkxTUEluZm9ybWF0aW9uUgdsc3BJbmZv');
@$core.Deprecated('Use invoiceDescriptor instead')
const Invoice$json = const {
  '1': 'Invoice',
  '2': const [
    const {'1': 'memo', '3': 1, '4': 1, '5': 11, '6': '.data.InvoiceMemo', '10': 'memo'},
    const {'1': 'settled', '3': 2, '4': 1, '5': 8, '10': 'settled'},
    const {'1': 'amtPaid', '3': 3, '4': 1, '5': 3, '10': 'amtPaid'},
  ],
};

/// Descriptor for `Invoice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceDescriptor = $convert.base64Decode('CgdJbnZvaWNlEiUKBG1lbW8YASABKAsyES5kYXRhLkludm9pY2VNZW1vUgRtZW1vEhgKB3NldHRsZWQYAiABKAhSB3NldHRsZWQSGAoHYW10UGFpZBgDIAEoA1IHYW10UGFpZA==');
@$core.Deprecated('Use syncLSPChannelsRequestDescriptor instead')
const SyncLSPChannelsRequest$json = const {
  '1': 'SyncLSPChannelsRequest',
  '2': const [
    const {'1': 'lspInfo', '3': 1, '4': 1, '5': 11, '6': '.data.LSPInformation', '10': 'lspInfo'},
  ],
};

/// Descriptor for `SyncLSPChannelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncLSPChannelsRequestDescriptor = $convert.base64Decode('ChZTeW5jTFNQQ2hhbm5lbHNSZXF1ZXN0Ei4KB2xzcEluZm8YASABKAsyFC5kYXRhLkxTUEluZm9ybWF0aW9uUgdsc3BJbmZv');
@$core.Deprecated('Use syncLSPChannelsResponseDescriptor instead')
const SyncLSPChannelsResponse$json = const {
  '1': 'SyncLSPChannelsResponse',
  '2': const [
    const {'1': 'hasMismatch', '3': 1, '4': 1, '5': 8, '10': 'hasMismatch'},
  ],
};

/// Descriptor for `SyncLSPChannelsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncLSPChannelsResponseDescriptor = $convert.base64Decode('ChdTeW5jTFNQQ2hhbm5lbHNSZXNwb25zZRIgCgtoYXNNaXNtYXRjaBgBIAEoCFILaGFzTWlzbWF0Y2g=');
@$core.Deprecated('Use unconfirmedChannelsStatusDescriptor instead')
const UnconfirmedChannelsStatus$json = const {
  '1': 'UnconfirmedChannelsStatus',
  '2': const [
    const {'1': 'statuses', '3': 1, '4': 3, '5': 11, '6': '.data.UnconfirmedChannelStatus', '10': 'statuses'},
  ],
};

/// Descriptor for `UnconfirmedChannelsStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unconfirmedChannelsStatusDescriptor = $convert.base64Decode('ChlVbmNvbmZpcm1lZENoYW5uZWxzU3RhdHVzEjoKCHN0YXR1c2VzGAEgAygLMh4uZGF0YS5VbmNvbmZpcm1lZENoYW5uZWxTdGF0dXNSCHN0YXR1c2Vz');
@$core.Deprecated('Use unconfirmedChannelStatusDescriptor instead')
const UnconfirmedChannelStatus$json = const {
  '1': 'UnconfirmedChannelStatus',
  '2': const [
    const {'1': 'channelPoint', '3': 1, '4': 1, '5': 9, '10': 'channelPoint'},
    const {'1': 'heightHint', '3': 2, '4': 1, '5': 3, '10': 'heightHint'},
    const {'1': 'lspConfirmedHeight', '3': 3, '4': 1, '5': 3, '10': 'lspConfirmedHeight'},
  ],
};

/// Descriptor for `UnconfirmedChannelStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unconfirmedChannelStatusDescriptor = $convert.base64Decode('ChhVbmNvbmZpcm1lZENoYW5uZWxTdGF0dXMSIgoMY2hhbm5lbFBvaW50GAEgASgJUgxjaGFubmVsUG9pbnQSHgoKaGVpZ2h0SGludBgCIAEoA1IKaGVpZ2h0SGludBIuChJsc3BDb25maXJtZWRIZWlnaHQYAyABKANSEmxzcENvbmZpcm1lZEhlaWdodA==');
@$core.Deprecated('Use checkLSPClosedChannelMismatchRequestDescriptor instead')
const CheckLSPClosedChannelMismatchRequest$json = const {
  '1': 'CheckLSPClosedChannelMismatchRequest',
  '2': const [
    const {'1': 'lspInfo', '3': 1, '4': 1, '5': 11, '6': '.data.LSPInformation', '10': 'lspInfo'},
    const {'1': 'chanPoint', '3': 2, '4': 1, '5': 9, '10': 'chanPoint'},
  ],
};

/// Descriptor for `CheckLSPClosedChannelMismatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkLSPClosedChannelMismatchRequestDescriptor = $convert.base64Decode('CiRDaGVja0xTUENsb3NlZENoYW5uZWxNaXNtYXRjaFJlcXVlc3QSLgoHbHNwSW5mbxgBIAEoCzIULmRhdGEuTFNQSW5mb3JtYXRpb25SB2xzcEluZm8SHAoJY2hhblBvaW50GAIgASgJUgljaGFuUG9pbnQ=');
@$core.Deprecated('Use checkLSPClosedChannelMismatchResponseDescriptor instead')
const CheckLSPClosedChannelMismatchResponse$json = const {
  '1': 'CheckLSPClosedChannelMismatchResponse',
  '2': const [
    const {'1': 'mismatch', '3': 1, '4': 1, '5': 8, '10': 'mismatch'},
  ],
};

/// Descriptor for `CheckLSPClosedChannelMismatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkLSPClosedChannelMismatchResponseDescriptor = $convert.base64Decode('CiVDaGVja0xTUENsb3NlZENoYW5uZWxNaXNtYXRjaFJlc3BvbnNlEhoKCG1pc21hdGNoGAEgASgIUghtaXNtYXRjaA==');
@$core.Deprecated('Use resetClosedChannelChainInfoRequestDescriptor instead')
const ResetClosedChannelChainInfoRequest$json = const {
  '1': 'ResetClosedChannelChainInfoRequest',
  '2': const [
    const {'1': 'chanPoint', '3': 1, '4': 1, '5': 9, '10': 'chanPoint'},
    const {'1': 'blockHeight', '3': 2, '4': 1, '5': 3, '10': 'blockHeight'},
  ],
};

/// Descriptor for `ResetClosedChannelChainInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetClosedChannelChainInfoRequestDescriptor = $convert.base64Decode('CiJSZXNldENsb3NlZENoYW5uZWxDaGFpbkluZm9SZXF1ZXN0EhwKCWNoYW5Qb2ludBgBIAEoCVIJY2hhblBvaW50EiAKC2Jsb2NrSGVpZ2h0GAIgASgDUgtibG9ja0hlaWdodA==');
@$core.Deprecated('Use resetClosedChannelChainInfoReplyDescriptor instead')
const ResetClosedChannelChainInfoReply$json = const {
  '1': 'ResetClosedChannelChainInfoReply',
};

/// Descriptor for `ResetClosedChannelChainInfoReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetClosedChannelChainInfoReplyDescriptor = $convert.base64Decode('CiBSZXNldENsb3NlZENoYW5uZWxDaGFpbkluZm9SZXBseQ==');
@$core.Deprecated('Use notificationEventDescriptor instead')
const NotificationEvent$json = const {
  '1': 'NotificationEvent',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.data.NotificationEvent.NotificationType', '10': 'type'},
    const {'1': 'data', '3': 2, '4': 3, '5': 9, '10': 'data'},
  ],
  '4': const [NotificationEvent_NotificationType$json],
};

@$core.Deprecated('Use notificationEventDescriptor instead')
const NotificationEvent_NotificationType$json = const {
  '1': 'NotificationType',
  '2': const [
    const {'1': 'READY', '2': 0},
    const {'1': 'INITIALIZATION_FAILED', '2': 1},
    const {'1': 'ACCOUNT_CHANGED', '2': 2},
    const {'1': 'PAYMENT_SENT', '2': 3},
    const {'1': 'INVOICE_PAID', '2': 4},
    const {'1': 'LIGHTNING_SERVICE_DOWN', '2': 5},
    const {'1': 'FUND_ADDRESS_CREATED', '2': 6},
    const {'1': 'FUND_ADDRESS_UNSPENT_CHANGED', '2': 7},
    const {'1': 'BACKUP_SUCCESS', '2': 8},
    const {'1': 'BACKUP_FAILED', '2': 9},
    const {'1': 'BACKUP_AUTH_FAILED', '2': 10},
    const {'1': 'BACKUP_NODE_CONFLICT', '2': 11},
    const {'1': 'BACKUP_REQUEST', '2': 12},
    const {'1': 'PAYMENT_FAILED', '2': 13},
    const {'1': 'PAYMENT_SUCCEEDED', '2': 14},
    const {'1': 'REVERSE_SWAP_CLAIM_STARTED', '2': 15},
    const {'1': 'REVERSE_SWAP_CLAIM_SUCCEEDED', '2': 16},
    const {'1': 'REVERSE_SWAP_CLAIM_FAILED', '2': 17},
    const {'1': 'REVERSE_SWAP_CLAIM_CONFIRMED', '2': 18},
    const {'1': 'LSP_CHANNEL_OPENED', '2': 19},
  ],
};

/// Descriptor for `NotificationEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationEventDescriptor = $convert.base64Decode('ChFOb3RpZmljYXRpb25FdmVudBI8CgR0eXBlGAEgASgOMiguZGF0YS5Ob3RpZmljYXRpb25FdmVudC5Ob3RpZmljYXRpb25UeXBlUgR0eXBlEhIKBGRhdGEYAiADKAlSBGRhdGEi/AMKEE5vdGlmaWNhdGlvblR5cGUSCQoFUkVBRFkQABIZChVJTklUSUFMSVpBVElPTl9GQUlMRUQQARITCg9BQ0NPVU5UX0NIQU5HRUQQAhIQCgxQQVlNRU5UX1NFTlQQAxIQCgxJTlZPSUNFX1BBSUQQBBIaChZMSUdIVE5JTkdfU0VSVklDRV9ET1dOEAUSGAoURlVORF9BRERSRVNTX0NSRUFURUQQBhIgChxGVU5EX0FERFJFU1NfVU5TUEVOVF9DSEFOR0VEEAcSEgoOQkFDS1VQX1NVQ0NFU1MQCBIRCg1CQUNLVVBfRkFJTEVEEAkSFgoSQkFDS1VQX0FVVEhfRkFJTEVEEAoSGAoUQkFDS1VQX05PREVfQ09ORkxJQ1QQCxISCg5CQUNLVVBfUkVRVUVTVBAMEhIKDlBBWU1FTlRfRkFJTEVEEA0SFQoRUEFZTUVOVF9TVUNDRUVERUQQDhIeChpSRVZFUlNFX1NXQVBfQ0xBSU1fU1RBUlRFRBAPEiAKHFJFVkVSU0VfU1dBUF9DTEFJTV9TVUNDRUVERUQQEBIdChlSRVZFUlNFX1NXQVBfQ0xBSU1fRkFJTEVEEBESIAocUkVWRVJTRV9TV0FQX0NMQUlNX0NPTkZJUk1FRBASEhYKEkxTUF9DSEFOTkVMX09QRU5FRBAT');
@$core.Deprecated('Use addFundInitReplyDescriptor instead')
const AddFundInitReply$json = const {
  '1': 'AddFundInitReply',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'maxAllowedDeposit', '3': 2, '4': 1, '5': 3, '10': 'maxAllowedDeposit'},
    const {'1': 'errorMessage', '3': 3, '4': 1, '5': 9, '10': 'errorMessage'},
    const {'1': 'backupJson', '3': 4, '4': 1, '5': 9, '10': 'backupJson'},
    const {'1': 'requiredReserve', '3': 5, '4': 1, '5': 3, '10': 'requiredReserve'},
    const {'1': 'minAllowedDeposit', '3': 6, '4': 1, '5': 3, '10': 'minAllowedDeposit'},
  ],
};

/// Descriptor for `AddFundInitReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFundInitReplyDescriptor = $convert.base64Decode('ChBBZGRGdW5kSW5pdFJlcGx5EhgKB2FkZHJlc3MYASABKAlSB2FkZHJlc3MSLAoRbWF4QWxsb3dlZERlcG9zaXQYAiABKANSEW1heEFsbG93ZWREZXBvc2l0EiIKDGVycm9yTWVzc2FnZRgDIAEoCVIMZXJyb3JNZXNzYWdlEh4KCmJhY2t1cEpzb24YBCABKAlSCmJhY2t1cEpzb24SKAoPcmVxdWlyZWRSZXNlcnZlGAUgASgDUg9yZXF1aXJlZFJlc2VydmUSLAoRbWluQWxsb3dlZERlcG9zaXQYBiABKANSEW1pbkFsbG93ZWREZXBvc2l0');
@$core.Deprecated('Use addFundReplyDescriptor instead')
const AddFundReply$json = const {
  '1': 'AddFundReply',
  '2': const [
    const {'1': 'errorMessage', '3': 1, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `AddFundReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFundReplyDescriptor = $convert.base64Decode('CgxBZGRGdW5kUmVwbHkSIgoMZXJyb3JNZXNzYWdlGAEgASgJUgxlcnJvck1lc3NhZ2U=');
@$core.Deprecated('Use refundRequestDescriptor instead')
const RefundRequest$json = const {
  '1': 'RefundRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'refundAddress', '3': 2, '4': 1, '5': 9, '10': 'refundAddress'},
    const {'1': 'target_conf', '3': 3, '4': 1, '5': 5, '10': 'targetConf'},
    const {'1': 'sat_per_byte', '3': 4, '4': 1, '5': 3, '10': 'satPerByte'},
  ],
};

/// Descriptor for `RefundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundRequestDescriptor = $convert.base64Decode('Cg1SZWZ1bmRSZXF1ZXN0EhgKB2FkZHJlc3MYASABKAlSB2FkZHJlc3MSJAoNcmVmdW5kQWRkcmVzcxgCIAEoCVINcmVmdW5kQWRkcmVzcxIfCgt0YXJnZXRfY29uZhgDIAEoBVIKdGFyZ2V0Q29uZhIgCgxzYXRfcGVyX2J5dGUYBCABKANSCnNhdFBlckJ5dGU=');
@$core.Deprecated('Use addFundErrorDescriptor instead')
const AddFundError$json = const {
  '1': 'AddFundError',
  '2': const [
    const {'1': 'swapAddressInfo', '3': 1, '4': 1, '5': 11, '6': '.data.SwapAddressInfo', '10': 'swapAddressInfo'},
    const {'1': 'hoursToUnlock', '3': 2, '4': 1, '5': 2, '10': 'hoursToUnlock'},
  ],
};

/// Descriptor for `AddFundError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFundErrorDescriptor = $convert.base64Decode('CgxBZGRGdW5kRXJyb3ISPwoPc3dhcEFkZHJlc3NJbmZvGAEgASgLMhUuZGF0YS5Td2FwQWRkcmVzc0luZm9SD3N3YXBBZGRyZXNzSW5mbxIkCg1ob3Vyc1RvVW5sb2NrGAIgASgCUg1ob3Vyc1RvVW5sb2Nr');
@$core.Deprecated('Use fundStatusReplyDescriptor instead')
const FundStatusReply$json = const {
  '1': 'FundStatusReply',
  '2': const [
    const {'1': 'unConfirmedAddresses', '3': 1, '4': 3, '5': 11, '6': '.data.SwapAddressInfo', '10': 'unConfirmedAddresses'},
    const {'1': 'confirmedAddresses', '3': 2, '4': 3, '5': 11, '6': '.data.SwapAddressInfo', '10': 'confirmedAddresses'},
    const {'1': 'refundableAddresses', '3': 3, '4': 3, '5': 11, '6': '.data.SwapAddressInfo', '10': 'refundableAddresses'},
  ],
};

/// Descriptor for `FundStatusReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fundStatusReplyDescriptor = $convert.base64Decode('Cg9GdW5kU3RhdHVzUmVwbHkSSQoUdW5Db25maXJtZWRBZGRyZXNzZXMYASADKAsyFS5kYXRhLlN3YXBBZGRyZXNzSW5mb1IUdW5Db25maXJtZWRBZGRyZXNzZXMSRQoSY29uZmlybWVkQWRkcmVzc2VzGAIgAygLMhUuZGF0YS5Td2FwQWRkcmVzc0luZm9SEmNvbmZpcm1lZEFkZHJlc3NlcxJHChNyZWZ1bmRhYmxlQWRkcmVzc2VzGAMgAygLMhUuZGF0YS5Td2FwQWRkcmVzc0luZm9SE3JlZnVuZGFibGVBZGRyZXNzZXM=');
@$core.Deprecated('Use removeFundRequestDescriptor instead')
const RemoveFundRequest$json = const {
  '1': 'RemoveFundRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
  ],
};

/// Descriptor for `RemoveFundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeFundRequestDescriptor = $convert.base64Decode('ChFSZW1vdmVGdW5kUmVxdWVzdBIYCgdhZGRyZXNzGAEgASgJUgdhZGRyZXNzEhYKBmFtb3VudBgCIAEoA1IGYW1vdW50');
@$core.Deprecated('Use removeFundReplyDescriptor instead')
const RemoveFundReply$json = const {
  '1': 'RemoveFundReply',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 1, '5': 9, '10': 'txid'},
    const {'1': 'errorMessage', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `RemoveFundReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeFundReplyDescriptor = $convert.base64Decode('Cg9SZW1vdmVGdW5kUmVwbHkSEgoEdHhpZBgBIAEoCVIEdHhpZBIiCgxlcnJvck1lc3NhZ2UYAiABKAlSDGVycm9yTWVzc2FnZQ==');
@$core.Deprecated('Use swapAddressInfoDescriptor instead')
const SwapAddressInfo$json = const {
  '1': 'SwapAddressInfo',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'PaymentHash', '3': 2, '4': 1, '5': 9, '10': 'PaymentHash'},
    const {'1': 'ConfirmedAmount', '3': 3, '4': 1, '5': 3, '10': 'ConfirmedAmount'},
    const {'1': 'ConfirmedTransactionIds', '3': 4, '4': 3, '5': 9, '10': 'ConfirmedTransactionIds'},
    const {'1': 'PaidAmount', '3': 5, '4': 1, '5': 3, '10': 'PaidAmount'},
    const {'1': 'lockHeight', '3': 6, '4': 1, '5': 13, '10': 'lockHeight'},
    const {'1': 'errorMessage', '3': 7, '4': 1, '5': 9, '10': 'errorMessage'},
    const {'1': 'lastRefundTxID', '3': 8, '4': 1, '5': 9, '10': 'lastRefundTxID'},
    const {'1': 'swapError', '3': 9, '4': 1, '5': 14, '6': '.data.SwapError', '10': 'swapError'},
    const {'1': 'FundingTxID', '3': 10, '4': 1, '5': 9, '10': 'FundingTxID'},
    const {'1': 'hoursToUnlock', '3': 11, '4': 1, '5': 2, '10': 'hoursToUnlock'},
    const {'1': 'nonBlocking', '3': 12, '4': 1, '5': 8, '10': 'nonBlocking'},
  ],
};

/// Descriptor for `SwapAddressInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List swapAddressInfoDescriptor = $convert.base64Decode('Cg9Td2FwQWRkcmVzc0luZm8SGAoHYWRkcmVzcxgBIAEoCVIHYWRkcmVzcxIgCgtQYXltZW50SGFzaBgCIAEoCVILUGF5bWVudEhhc2gSKAoPQ29uZmlybWVkQW1vdW50GAMgASgDUg9Db25maXJtZWRBbW91bnQSOAoXQ29uZmlybWVkVHJhbnNhY3Rpb25JZHMYBCADKAlSF0NvbmZpcm1lZFRyYW5zYWN0aW9uSWRzEh4KClBhaWRBbW91bnQYBSABKANSClBhaWRBbW91bnQSHgoKbG9ja0hlaWdodBgGIAEoDVIKbG9ja0hlaWdodBIiCgxlcnJvck1lc3NhZ2UYByABKAlSDGVycm9yTWVzc2FnZRImCg5sYXN0UmVmdW5kVHhJRBgIIAEoCVIObGFzdFJlZnVuZFR4SUQSLQoJc3dhcEVycm9yGAkgASgOMg8uZGF0YS5Td2FwRXJyb3JSCXN3YXBFcnJvchIgCgtGdW5kaW5nVHhJRBgKIAEoCVILRnVuZGluZ1R4SUQSJAoNaG91cnNUb1VubG9jaxgLIAEoAlINaG91cnNUb1VubG9jaxIgCgtub25CbG9ja2luZxgMIAEoCFILbm9uQmxvY2tpbmc=');
@$core.Deprecated('Use swapAddressListDescriptor instead')
const SwapAddressList$json = const {
  '1': 'SwapAddressList',
  '2': const [
    const {'1': 'addresses', '3': 1, '4': 3, '5': 11, '6': '.data.SwapAddressInfo', '10': 'addresses'},
  ],
};

/// Descriptor for `SwapAddressList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List swapAddressListDescriptor = $convert.base64Decode('Cg9Td2FwQWRkcmVzc0xpc3QSMwoJYWRkcmVzc2VzGAEgAygLMhUuZGF0YS5Td2FwQWRkcmVzc0luZm9SCWFkZHJlc3Nlcw==');
@$core.Deprecated('Use createRatchetSessionRequestDescriptor instead')
const CreateRatchetSessionRequest$json = const {
  '1': 'CreateRatchetSessionRequest',
  '2': const [
    const {'1': 'secret', '3': 1, '4': 1, '5': 9, '10': 'secret'},
    const {'1': 'remotePubKey', '3': 2, '4': 1, '5': 9, '10': 'remotePubKey'},
    const {'1': 'sessionID', '3': 3, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'expiry', '3': 4, '4': 1, '5': 4, '10': 'expiry'},
  ],
};

/// Descriptor for `CreateRatchetSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRatchetSessionRequestDescriptor = $convert.base64Decode('ChtDcmVhdGVSYXRjaGV0U2Vzc2lvblJlcXVlc3QSFgoGc2VjcmV0GAEgASgJUgZzZWNyZXQSIgoMcmVtb3RlUHViS2V5GAIgASgJUgxyZW1vdGVQdWJLZXkSHAoJc2Vzc2lvbklEGAMgASgJUglzZXNzaW9uSUQSFgoGZXhwaXJ5GAQgASgEUgZleHBpcnk=');
@$core.Deprecated('Use createRatchetSessionReplyDescriptor instead')
const CreateRatchetSessionReply$json = const {
  '1': 'CreateRatchetSessionReply',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'secret', '3': 2, '4': 1, '5': 9, '10': 'secret'},
    const {'1': 'pubKey', '3': 3, '4': 1, '5': 9, '10': 'pubKey'},
  ],
};

/// Descriptor for `CreateRatchetSessionReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRatchetSessionReplyDescriptor = $convert.base64Decode('ChlDcmVhdGVSYXRjaGV0U2Vzc2lvblJlcGx5EhwKCXNlc3Npb25JRBgBIAEoCVIJc2Vzc2lvbklEEhYKBnNlY3JldBgCIAEoCVIGc2VjcmV0EhYKBnB1YktleRgDIAEoCVIGcHViS2V5');
@$core.Deprecated('Use ratchetSessionInfoReplyDescriptor instead')
const RatchetSessionInfoReply$json = const {
  '1': 'RatchetSessionInfoReply',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'initiated', '3': 2, '4': 1, '5': 8, '10': 'initiated'},
    const {'1': 'userInfo', '3': 3, '4': 1, '5': 9, '10': 'userInfo'},
  ],
};

/// Descriptor for `RatchetSessionInfoReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ratchetSessionInfoReplyDescriptor = $convert.base64Decode('ChdSYXRjaGV0U2Vzc2lvbkluZm9SZXBseRIcCglzZXNzaW9uSUQYASABKAlSCXNlc3Npb25JRBIcCglpbml0aWF0ZWQYAiABKAhSCWluaXRpYXRlZBIaCgh1c2VySW5mbxgDIAEoCVIIdXNlckluZm8=');
@$core.Deprecated('Use ratchetSessionSetInfoRequestDescriptor instead')
const RatchetSessionSetInfoRequest$json = const {
  '1': 'RatchetSessionSetInfoRequest',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'userInfo', '3': 2, '4': 1, '5': 9, '10': 'userInfo'},
  ],
};

/// Descriptor for `RatchetSessionSetInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ratchetSessionSetInfoRequestDescriptor = $convert.base64Decode('ChxSYXRjaGV0U2Vzc2lvblNldEluZm9SZXF1ZXN0EhwKCXNlc3Npb25JRBgBIAEoCVIJc2Vzc2lvbklEEhoKCHVzZXJJbmZvGAIgASgJUgh1c2VySW5mbw==');
@$core.Deprecated('Use ratchetEncryptRequestDescriptor instead')
const RatchetEncryptRequest$json = const {
  '1': 'RatchetEncryptRequest',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RatchetEncryptRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ratchetEncryptRequestDescriptor = $convert.base64Decode('ChVSYXRjaGV0RW5jcnlwdFJlcXVlc3QSHAoJc2Vzc2lvbklEGAEgASgJUglzZXNzaW9uSUQSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use ratchetDecryptRequestDescriptor instead')
const RatchetDecryptRequest$json = const {
  '1': 'RatchetDecryptRequest',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'encryptedMessage', '3': 2, '4': 1, '5': 9, '10': 'encryptedMessage'},
  ],
};

/// Descriptor for `RatchetDecryptRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ratchetDecryptRequestDescriptor = $convert.base64Decode('ChVSYXRjaGV0RGVjcnlwdFJlcXVlc3QSHAoJc2Vzc2lvbklEGAEgASgJUglzZXNzaW9uSUQSKgoQZW5jcnlwdGVkTWVzc2FnZRgCIAEoCVIQZW5jcnlwdGVkTWVzc2FnZQ==');
@$core.Deprecated('Use bootstrapFilesRequestDescriptor instead')
const BootstrapFilesRequest$json = const {
  '1': 'BootstrapFilesRequest',
  '2': const [
    const {'1': 'WorkingDir', '3': 1, '4': 1, '5': 9, '10': 'WorkingDir'},
    const {'1': 'FullPaths', '3': 2, '4': 3, '5': 9, '10': 'FullPaths'},
  ],
};

/// Descriptor for `BootstrapFilesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bootstrapFilesRequestDescriptor = $convert.base64Decode('ChVCb290c3RyYXBGaWxlc1JlcXVlc3QSHgoKV29ya2luZ0RpchgBIAEoCVIKV29ya2luZ0RpchIcCglGdWxsUGF0aHMYAiADKAlSCUZ1bGxQYXRocw==');
@$core.Deprecated('Use peersDescriptor instead')
const Peers$json = const {
  '1': 'Peers',
  '2': const [
    const {'1': 'isDefault', '3': 1, '4': 1, '5': 8, '10': 'isDefault'},
    const {'1': 'peer', '3': 2, '4': 3, '5': 9, '10': 'peer'},
  ],
};

/// Descriptor for `Peers`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List peersDescriptor = $convert.base64Decode('CgVQZWVycxIcCglpc0RlZmF1bHQYASABKAhSCWlzRGVmYXVsdBISCgRwZWVyGAIgAygJUgRwZWVy');
@$core.Deprecated('Use txSpentURLDescriptor instead')
const TxSpentURL$json = const {
  '1': 'TxSpentURL',
  '2': const [
    const {'1': 'URL', '3': 1, '4': 1, '5': 9, '10': 'URL'},
    const {'1': 'isDefault', '3': 2, '4': 1, '5': 8, '10': 'isDefault'},
    const {'1': 'disabled', '3': 3, '4': 1, '5': 8, '10': 'disabled'},
  ],
};

/// Descriptor for `TxSpentURL`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txSpentURLDescriptor = $convert.base64Decode('CgpUeFNwZW50VVJMEhAKA1VSTBgBIAEoCVIDVVJMEhwKCWlzRGVmYXVsdBgCIAEoCFIJaXNEZWZhdWx0EhoKCGRpc2FibGVkGAMgASgIUghkaXNhYmxlZA==');
@$core.Deprecated('Use rateDescriptor instead')
const rate$json = const {
  '1': 'rate',
  '2': const [
    const {'1': 'coin', '3': 1, '4': 1, '5': 9, '10': 'coin'},
    const {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
};

/// Descriptor for `rate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateDescriptor = $convert.base64Decode('CgRyYXRlEhIKBGNvaW4YASABKAlSBGNvaW4SFAoFdmFsdWUYAiABKAFSBXZhbHVl');
@$core.Deprecated('Use ratesDescriptor instead')
const Rates$json = const {
  '1': 'Rates',
  '2': const [
    const {'1': 'rates', '3': 1, '4': 3, '5': 11, '6': '.data.rate', '10': 'rates'},
  ],
};

/// Descriptor for `Rates`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ratesDescriptor = $convert.base64Decode('CgVSYXRlcxIgCgVyYXRlcxgBIAMoCzIKLmRhdGEucmF0ZVIFcmF0ZXM=');
@$core.Deprecated('Use lSPInformationDescriptor instead')
const LSPInformation$json = const {
  '1': 'LSPInformation',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'widget_url', '3': 3, '4': 1, '5': 9, '10': 'widgetUrl'},
    const {'1': 'pubkey', '3': 4, '4': 1, '5': 9, '10': 'pubkey'},
    const {'1': 'host', '3': 5, '4': 1, '5': 9, '10': 'host'},
    const {'1': 'channel_capacity', '3': 6, '4': 1, '5': 3, '10': 'channelCapacity'},
    const {'1': 'target_conf', '3': 7, '4': 1, '5': 5, '10': 'targetConf'},
    const {'1': 'base_fee_msat', '3': 8, '4': 1, '5': 3, '10': 'baseFeeMsat'},
    const {'1': 'fee_rate', '3': 9, '4': 1, '5': 1, '10': 'feeRate'},
    const {'1': 'time_lock_delta', '3': 10, '4': 1, '5': 13, '10': 'timeLockDelta'},
    const {'1': 'min_htlc_msat', '3': 11, '4': 1, '5': 3, '10': 'minHtlcMsat'},
    const {'1': 'channel_fee_permyriad', '3': 12, '4': 1, '5': 3, '10': 'channelFeePermyriad'},
    const {'1': 'lsp_pubkey', '3': 13, '4': 1, '5': 12, '10': 'lspPubkey'},
    const {'1': 'max_inactive_duration', '3': 14, '4': 1, '5': 3, '10': 'maxInactiveDuration'},
    const {'1': 'channel_minimum_fee_msat', '3': 15, '4': 1, '5': 3, '10': 'channelMinimumFeeMsat'},
  ],
};

/// Descriptor for `LSPInformation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lSPInformationDescriptor = $convert.base64Decode('Cg5MU1BJbmZvcm1hdGlvbhIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIdCgp3aWRnZXRfdXJsGAMgASgJUgl3aWRnZXRVcmwSFgoGcHVia2V5GAQgASgJUgZwdWJrZXkSEgoEaG9zdBgFIAEoCVIEaG9zdBIpChBjaGFubmVsX2NhcGFjaXR5GAYgASgDUg9jaGFubmVsQ2FwYWNpdHkSHwoLdGFyZ2V0X2NvbmYYByABKAVSCnRhcmdldENvbmYSIgoNYmFzZV9mZWVfbXNhdBgIIAEoA1ILYmFzZUZlZU1zYXQSGQoIZmVlX3JhdGUYCSABKAFSB2ZlZVJhdGUSJgoPdGltZV9sb2NrX2RlbHRhGAogASgNUg10aW1lTG9ja0RlbHRhEiIKDW1pbl9odGxjX21zYXQYCyABKANSC21pbkh0bGNNc2F0EjIKFWNoYW5uZWxfZmVlX3Blcm15cmlhZBgMIAEoA1ITY2hhbm5lbEZlZVBlcm15cmlhZBIdCgpsc3BfcHVia2V5GA0gASgMUglsc3BQdWJrZXkSMgoVbWF4X2luYWN0aXZlX2R1cmF0aW9uGA4gASgDUhNtYXhJbmFjdGl2ZUR1cmF0aW9uEjcKGGNoYW5uZWxfbWluaW11bV9mZWVfbXNhdBgPIAEoA1IVY2hhbm5lbE1pbmltdW1GZWVNc2F0');
@$core.Deprecated('Use lSPListRequestDescriptor instead')
const LSPListRequest$json = const {
  '1': 'LSPListRequest',
};

/// Descriptor for `LSPListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lSPListRequestDescriptor = $convert.base64Decode('Cg5MU1BMaXN0UmVxdWVzdA==');
@$core.Deprecated('Use lSPListDescriptor instead')
const LSPList$json = const {
  '1': 'LSPList',
  '2': const [
    const {'1': 'lsps', '3': 1, '4': 3, '5': 11, '6': '.data.LSPList.LspsEntry', '10': 'lsps'},
  ],
  '3': const [LSPList_LspsEntry$json],
};

@$core.Deprecated('Use lSPListDescriptor instead')
const LSPList_LspsEntry$json = const {
  '1': 'LspsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.data.LSPInformation', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `LSPList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lSPListDescriptor = $convert.base64Decode('CgdMU1BMaXN0EisKBGxzcHMYASADKAsyFy5kYXRhLkxTUExpc3QuTHNwc0VudHJ5UgRsc3BzGk0KCUxzcHNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIqCgV2YWx1ZRgCIAEoCzIULmRhdGEuTFNQSW5mb3JtYXRpb25SBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use lSPActivityDescriptor instead')
const LSPActivity$json = const {
  '1': 'LSPActivity',
  '2': const [
    const {'1': 'activity', '3': 1, '4': 3, '5': 11, '6': '.data.LSPActivity.ActivityEntry', '10': 'activity'},
  ],
  '3': const [LSPActivity_ActivityEntry$json],
};

@$core.Deprecated('Use lSPActivityDescriptor instead')
const LSPActivity_ActivityEntry$json = const {
  '1': 'ActivityEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `LSPActivity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lSPActivityDescriptor = $convert.base64Decode('CgtMU1BBY3Rpdml0eRI7CghhY3Rpdml0eRgBIAMoCzIfLmRhdGEuTFNQQWN0aXZpdHkuQWN0aXZpdHlFbnRyeVIIYWN0aXZpdHkaOwoNQWN0aXZpdHlFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoA1IFdmFsdWU6AjgB');
@$core.Deprecated('Use connectLSPRequestDescriptor instead')
const ConnectLSPRequest$json = const {
  '1': 'ConnectLSPRequest',
  '2': const [
    const {'1': 'lsp_id', '3': 1, '4': 1, '5': 9, '10': 'lspId'},
  ],
};

/// Descriptor for `ConnectLSPRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectLSPRequestDescriptor = $convert.base64Decode('ChFDb25uZWN0TFNQUmVxdWVzdBIVCgZsc3BfaWQYASABKAlSBWxzcElk');
@$core.Deprecated('Use connectLSPReplyDescriptor instead')
const ConnectLSPReply$json = const {
  '1': 'ConnectLSPReply',
};

/// Descriptor for `ConnectLSPReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectLSPReplyDescriptor = $convert.base64Decode('Cg9Db25uZWN0TFNQUmVwbHk=');
@$core.Deprecated('Use lNUrlResponseDescriptor instead')
const LNUrlResponse$json = const {
  '1': 'LNUrlResponse',
  '2': const [
    const {'1': 'withdraw', '3': 1, '4': 1, '5': 11, '6': '.data.LNUrlWithdraw', '9': 0, '10': 'withdraw'},
    const {'1': 'channel', '3': 2, '4': 1, '5': 11, '6': '.data.LNURLChannel', '9': 0, '10': 'channel'},
    const {'1': 'auth', '3': 3, '4': 1, '5': 11, '6': '.data.LNURLAuth', '9': 0, '10': 'auth'},
    const {'1': 'payResponse1', '3': 4, '4': 1, '5': 11, '6': '.data.LNURLPayResponse1', '9': 0, '10': 'payResponse1'},
  ],
  '8': const [
    const {'1': 'action'},
  ],
};

/// Descriptor for `LNUrlResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNUrlResponseDescriptor = $convert.base64Decode('Cg1MTlVybFJlc3BvbnNlEjEKCHdpdGhkcmF3GAEgASgLMhMuZGF0YS5MTlVybFdpdGhkcmF3SABSCHdpdGhkcmF3Ei4KB2NoYW5uZWwYAiABKAsyEi5kYXRhLkxOVVJMQ2hhbm5lbEgAUgdjaGFubmVsEiUKBGF1dGgYAyABKAsyDy5kYXRhLkxOVVJMQXV0aEgAUgRhdXRoEj0KDHBheVJlc3BvbnNlMRgEIAEoCzIXLmRhdGEuTE5VUkxQYXlSZXNwb25zZTFIAFIMcGF5UmVzcG9uc2UxQggKBmFjdGlvbg==');
@$core.Deprecated('Use lNUrlWithdrawDescriptor instead')
const LNUrlWithdraw$json = const {
  '1': 'LNUrlWithdraw',
  '2': const [
    const {'1': 'min_amount', '3': 1, '4': 1, '5': 3, '10': 'minAmount'},
    const {'1': 'max_amount', '3': 2, '4': 1, '5': 3, '10': 'maxAmount'},
    const {'1': 'default_description', '3': 3, '4': 1, '5': 9, '10': 'defaultDescription'},
  ],
};

/// Descriptor for `LNUrlWithdraw`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNUrlWithdrawDescriptor = $convert.base64Decode('Cg1MTlVybFdpdGhkcmF3Eh0KCm1pbl9hbW91bnQYASABKANSCW1pbkFtb3VudBIdCgptYXhfYW1vdW50GAIgASgDUgltYXhBbW91bnQSLwoTZGVmYXVsdF9kZXNjcmlwdGlvbhgDIAEoCVISZGVmYXVsdERlc2NyaXB0aW9u');
@$core.Deprecated('Use lNURLChannelDescriptor instead')
const LNURLChannel$json = const {
  '1': 'LNURLChannel',
  '2': const [
    const {'1': 'k1', '3': 1, '4': 1, '5': 9, '10': 'k1'},
    const {'1': 'callback', '3': 2, '4': 1, '5': 9, '10': 'callback'},
    const {'1': 'uri', '3': 3, '4': 1, '5': 9, '10': 'uri'},
  ],
};

/// Descriptor for `LNURLChannel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNURLChannelDescriptor = $convert.base64Decode('CgxMTlVSTENoYW5uZWwSDgoCazEYASABKAlSAmsxEhoKCGNhbGxiYWNrGAIgASgJUghjYWxsYmFjaxIQCgN1cmkYAyABKAlSA3VyaQ==');
@$core.Deprecated('Use lNURLAuthDescriptor instead')
const LNURLAuth$json = const {
  '1': 'LNURLAuth',
  '2': const [
    const {'1': 'tag', '3': 1, '4': 1, '5': 9, '10': 'tag'},
    const {'1': 'k1', '3': 2, '4': 1, '5': 9, '10': 'k1'},
    const {'1': 'callback', '3': 3, '4': 1, '5': 9, '10': 'callback'},
    const {'1': 'host', '3': 4, '4': 1, '5': 9, '10': 'host'},
    const {'1': 'jwt', '3': 5, '4': 1, '5': 8, '10': 'jwt'},
  ],
};

/// Descriptor for `LNURLAuth`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNURLAuthDescriptor = $convert.base64Decode('CglMTlVSTEF1dGgSEAoDdGFnGAEgASgJUgN0YWcSDgoCazEYAiABKAlSAmsxEhoKCGNhbGxiYWNrGAMgASgJUghjYWxsYmFjaxISCgRob3N0GAQgASgJUgRob3N0EhAKA2p3dBgFIAEoCFIDand0');
@$core.Deprecated('Use lNUrlPayMetadataDescriptor instead')
const LNUrlPayMetadata$json = const {
  '1': 'LNUrlPayMetadata',
  '2': const [
    const {'1': 'entry', '3': 1, '4': 3, '5': 9, '10': 'entry'},
  ],
};

/// Descriptor for `LNUrlPayMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNUrlPayMetadataDescriptor = $convert.base64Decode('ChBMTlVybFBheU1ldGFkYXRhEhQKBWVudHJ5GAEgAygJUgVlbnRyeQ==');
@$core.Deprecated('Use lNURLPayResponse1Descriptor instead')
const LNURLPayResponse1$json = const {
  '1': 'LNURLPayResponse1',
  '2': const [
    const {'1': 'callback', '3': 1, '4': 1, '5': 9, '10': 'callback'},
    const {'1': 'min_amount', '3': 2, '4': 1, '5': 3, '10': 'minAmount'},
    const {'1': 'max_amount', '3': 3, '4': 1, '5': 3, '10': 'maxAmount'},
    const {'1': 'metadata', '3': 4, '4': 3, '5': 11, '6': '.data.LNUrlPayMetadata', '10': 'metadata'},
    const {'1': 'tag', '3': 5, '4': 1, '5': 9, '10': 'tag'},
    const {'1': 'amount', '3': 6, '4': 1, '5': 4, '10': 'amount'},
    const {'1': 'from_nodes', '3': 7, '4': 1, '5': 9, '10': 'fromNodes'},
    const {'1': 'comment', '3': 8, '4': 1, '5': 9, '10': 'comment'},
    const {'1': 'host', '3': 9, '4': 1, '5': 9, '10': 'host'},
  ],
};

/// Descriptor for `LNURLPayResponse1`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNURLPayResponse1Descriptor = $convert.base64Decode('ChFMTlVSTFBheVJlc3BvbnNlMRIaCghjYWxsYmFjaxgBIAEoCVIIY2FsbGJhY2sSHQoKbWluX2Ftb3VudBgCIAEoA1IJbWluQW1vdW50Eh0KCm1heF9hbW91bnQYAyABKANSCW1heEFtb3VudBIyCghtZXRhZGF0YRgEIAMoCzIWLmRhdGEuTE5VcmxQYXlNZXRhZGF0YVIIbWV0YWRhdGESEAoDdGFnGAUgASgJUgN0YWcSFgoGYW1vdW50GAYgASgEUgZhbW91bnQSHQoKZnJvbV9ub2RlcxgHIAEoCVIJZnJvbU5vZGVzEhgKB2NvbW1lbnQYCCABKAlSB2NvbW1lbnQSEgoEaG9zdBgJIAEoCVIEaG9zdA==');
@$core.Deprecated('Use successActionDescriptor instead')
const SuccessAction$json = const {
  '1': 'SuccessAction',
  '2': const [
    const {'1': 'tag', '3': 1, '4': 1, '5': 9, '10': 'tag'},
    const {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'url', '3': 3, '4': 1, '5': 9, '10': 'url'},
    const {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'ciphertext', '3': 5, '4': 1, '5': 9, '10': 'ciphertext'},
    const {'1': 'iv', '3': 6, '4': 1, '5': 9, '10': 'iv'},
  ],
};

/// Descriptor for `SuccessAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List successActionDescriptor = $convert.base64Decode('Cg1TdWNjZXNzQWN0aW9uEhAKA3RhZxgBIAEoCVIDdGFnEiAKC2Rlc2NyaXB0aW9uGAIgASgJUgtkZXNjcmlwdGlvbhIQCgN1cmwYAyABKAlSA3VybBIYCgdtZXNzYWdlGAQgASgJUgdtZXNzYWdlEh4KCmNpcGhlcnRleHQYBSABKAlSCmNpcGhlcnRleHQSDgoCaXYYBiABKAlSAml2');
@$core.Deprecated('Use lNUrlPayInfoDescriptor instead')
const LNUrlPayInfo$json = const {
  '1': 'LNUrlPayInfo',
  '2': const [
    const {'1': 'paymentHash', '3': 1, '4': 1, '5': 9, '10': 'paymentHash'},
    const {'1': 'invoice', '3': 2, '4': 1, '5': 9, '10': 'invoice'},
    const {'1': 'success_action', '3': 3, '4': 1, '5': 11, '6': '.data.SuccessAction', '10': 'successAction'},
    const {'1': 'comment', '3': 4, '4': 1, '5': 9, '10': 'comment'},
    const {'1': 'invoice_description', '3': 5, '4': 1, '5': 9, '10': 'invoiceDescription'},
    const {'1': 'metadata', '3': 6, '4': 3, '5': 11, '6': '.data.LNUrlPayMetadata', '10': 'metadata'},
    const {'1': 'host', '3': 7, '4': 1, '5': 9, '10': 'host'},
  ],
};

/// Descriptor for `LNUrlPayInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNUrlPayInfoDescriptor = $convert.base64Decode('CgxMTlVybFBheUluZm8SIAoLcGF5bWVudEhhc2gYASABKAlSC3BheW1lbnRIYXNoEhgKB2ludm9pY2UYAiABKAlSB2ludm9pY2USOgoOc3VjY2Vzc19hY3Rpb24YAyABKAsyEy5kYXRhLlN1Y2Nlc3NBY3Rpb25SDXN1Y2Nlc3NBY3Rpb24SGAoHY29tbWVudBgEIAEoCVIHY29tbWVudBIvChNpbnZvaWNlX2Rlc2NyaXB0aW9uGAUgASgJUhJpbnZvaWNlRGVzY3JpcHRpb24SMgoIbWV0YWRhdGEYBiADKAsyFi5kYXRhLkxOVXJsUGF5TWV0YWRhdGFSCG1ldGFkYXRhEhIKBGhvc3QYByABKAlSBGhvc3Q=');
@$core.Deprecated('Use lNUrlPayInfoListDescriptor instead')
const LNUrlPayInfoList$json = const {
  '1': 'LNUrlPayInfoList',
  '2': const [
    const {'1': 'infoList', '3': 1, '4': 3, '5': 11, '6': '.data.LNUrlPayInfo', '10': 'infoList'},
  ],
};

/// Descriptor for `LNUrlPayInfoList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lNUrlPayInfoListDescriptor = $convert.base64Decode('ChBMTlVybFBheUluZm9MaXN0Ei4KCGluZm9MaXN0GAEgAygLMhIuZGF0YS5MTlVybFBheUluZm9SCGluZm9MaXN0');
@$core.Deprecated('Use reverseSwapRequestDescriptor instead')
const ReverseSwapRequest$json = const {
  '1': 'ReverseSwapRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
    const {'1': 'fees_hash', '3': 3, '4': 1, '5': 9, '10': 'feesHash'},
  ],
};

/// Descriptor for `ReverseSwapRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapRequestDescriptor = $convert.base64Decode('ChJSZXZlcnNlU3dhcFJlcXVlc3QSGAoHYWRkcmVzcxgBIAEoCVIHYWRkcmVzcxIWCgZhbW91bnQYAiABKANSBmFtb3VudBIbCglmZWVzX2hhc2gYAyABKAlSCGZlZXNIYXNo');
@$core.Deprecated('Use reverseSwapDescriptor instead')
const ReverseSwap$json = const {
  '1': 'ReverseSwap',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'invoice', '3': 2, '4': 1, '5': 9, '10': 'invoice'},
    const {'1': 'script', '3': 3, '4': 1, '5': 9, '10': 'script'},
    const {'1': 'lockup_address', '3': 4, '4': 1, '5': 9, '10': 'lockupAddress'},
    const {'1': 'preimage', '3': 5, '4': 1, '5': 9, '10': 'preimage'},
    const {'1': 'key', '3': 6, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'claim_address', '3': 7, '4': 1, '5': 9, '10': 'claimAddress'},
    const {'1': 'ln_amount', '3': 8, '4': 1, '5': 3, '10': 'lnAmount'},
    const {'1': 'onchain_amount', '3': 9, '4': 1, '5': 3, '10': 'onchainAmount'},
    const {'1': 'timeout_block_height', '3': 10, '4': 1, '5': 3, '10': 'timeoutBlockHeight'},
    const {'1': 'start_block_height', '3': 11, '4': 1, '5': 3, '10': 'startBlockHeight'},
    const {'1': 'claim_fee', '3': 12, '4': 1, '5': 3, '10': 'claimFee'},
    const {'1': 'claim_txid', '3': 13, '4': 1, '5': 9, '10': 'claimTxid'},
  ],
};

/// Descriptor for `ReverseSwap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapDescriptor = $convert.base64Decode('CgtSZXZlcnNlU3dhcBIOCgJpZBgBIAEoCVICaWQSGAoHaW52b2ljZRgCIAEoCVIHaW52b2ljZRIWCgZzY3JpcHQYAyABKAlSBnNjcmlwdBIlCg5sb2NrdXBfYWRkcmVzcxgEIAEoCVINbG9ja3VwQWRkcmVzcxIaCghwcmVpbWFnZRgFIAEoCVIIcHJlaW1hZ2USEAoDa2V5GAYgASgJUgNrZXkSIwoNY2xhaW1fYWRkcmVzcxgHIAEoCVIMY2xhaW1BZGRyZXNzEhsKCWxuX2Ftb3VudBgIIAEoA1IIbG5BbW91bnQSJQoOb25jaGFpbl9hbW91bnQYCSABKANSDW9uY2hhaW5BbW91bnQSMAoUdGltZW91dF9ibG9ja19oZWlnaHQYCiABKANSEnRpbWVvdXRCbG9ja0hlaWdodBIsChJzdGFydF9ibG9ja19oZWlnaHQYCyABKANSEHN0YXJ0QmxvY2tIZWlnaHQSGwoJY2xhaW1fZmVlGAwgASgDUghjbGFpbUZlZRIdCgpjbGFpbV90eGlkGA0gASgJUgljbGFpbVR4aWQ=');
@$core.Deprecated('Use reverseSwapFeesDescriptor instead')
const ReverseSwapFees$json = const {
  '1': 'ReverseSwapFees',
  '2': const [
    const {'1': 'percentage', '3': 1, '4': 1, '5': 1, '10': 'percentage'},
    const {'1': 'lockup', '3': 2, '4': 1, '5': 3, '10': 'lockup'},
    const {'1': 'claim', '3': 3, '4': 1, '5': 3, '10': 'claim'},
  ],
};

/// Descriptor for `ReverseSwapFees`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapFeesDescriptor = $convert.base64Decode('Cg9SZXZlcnNlU3dhcEZlZXMSHgoKcGVyY2VudGFnZRgBIAEoAVIKcGVyY2VudGFnZRIWCgZsb2NrdXAYAiABKANSBmxvY2t1cBIUCgVjbGFpbRgDIAEoA1IFY2xhaW0=');
@$core.Deprecated('Use reverseSwapInfoDescriptor instead')
const ReverseSwapInfo$json = const {
  '1': 'ReverseSwapInfo',
  '2': const [
    const {'1': 'min', '3': 1, '4': 1, '5': 3, '10': 'min'},
    const {'1': 'max', '3': 2, '4': 1, '5': 3, '10': 'max'},
    const {'1': 'fees', '3': 3, '4': 1, '5': 11, '6': '.data.ReverseSwapFees', '10': 'fees'},
    const {'1': 'fees_hash', '3': 4, '4': 1, '5': 9, '10': 'feesHash'},
  ],
};

/// Descriptor for `ReverseSwapInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapInfoDescriptor = $convert.base64Decode('Cg9SZXZlcnNlU3dhcEluZm8SEAoDbWluGAEgASgDUgNtaW4SEAoDbWF4GAIgASgDUgNtYXgSKQoEZmVlcxgDIAEoCzIVLmRhdGEuUmV2ZXJzZVN3YXBGZWVzUgRmZWVzEhsKCWZlZXNfaGFzaBgEIAEoCVIIZmVlc0hhc2g=');
@$core.Deprecated('Use reverseSwapPaymentRequestDescriptor instead')
const ReverseSwapPaymentRequest$json = const {
  '1': 'ReverseSwapPaymentRequest',
  '2': const [
    const {'1': 'hash', '3': 1, '4': 1, '5': 9, '10': 'hash'},
    const {'1': 'push_notification_details', '3': 2, '4': 1, '5': 11, '6': '.data.PushNotificationDetails', '10': 'pushNotificationDetails'},
  ],
};

/// Descriptor for `ReverseSwapPaymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapPaymentRequestDescriptor = $convert.base64Decode('ChlSZXZlcnNlU3dhcFBheW1lbnRSZXF1ZXN0EhIKBGhhc2gYASABKAlSBGhhc2gSWQoZcHVzaF9ub3RpZmljYXRpb25fZGV0YWlscxgCIAEoCzIdLmRhdGEuUHVzaE5vdGlmaWNhdGlvbkRldGFpbHNSF3B1c2hOb3RpZmljYXRpb25EZXRhaWxz');
@$core.Deprecated('Use pushNotificationDetailsDescriptor instead')
const PushNotificationDetails$json = const {
  '1': 'PushNotificationDetails',
  '2': const [
    const {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'body', '3': 3, '4': 1, '5': 9, '10': 'body'},
  ],
};

/// Descriptor for `PushNotificationDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushNotificationDetailsDescriptor = $convert.base64Decode('ChdQdXNoTm90aWZpY2F0aW9uRGV0YWlscxIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRISCgRib2R5GAMgASgJUgRib2R5');
@$core.Deprecated('Use reverseSwapPaymentStatusDescriptor instead')
const ReverseSwapPaymentStatus$json = const {
  '1': 'ReverseSwapPaymentStatus',
  '2': const [
    const {'1': 'hash', '3': 1, '4': 1, '5': 9, '10': 'hash'},
    const {'1': 'eta', '3': 3, '4': 1, '5': 5, '10': 'eta'},
  ],
};

/// Descriptor for `ReverseSwapPaymentStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapPaymentStatusDescriptor = $convert.base64Decode('ChhSZXZlcnNlU3dhcFBheW1lbnRTdGF0dXMSEgoEaGFzaBgBIAEoCVIEaGFzaBIQCgNldGEYAyABKAVSA2V0YQ==');
@$core.Deprecated('Use reverseSwapPaymentStatusesDescriptor instead')
const ReverseSwapPaymentStatuses$json = const {
  '1': 'ReverseSwapPaymentStatuses',
  '2': const [
    const {'1': 'payments_status', '3': 1, '4': 3, '5': 11, '6': '.data.ReverseSwapPaymentStatus', '10': 'paymentsStatus'},
  ],
};

/// Descriptor for `ReverseSwapPaymentStatuses`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapPaymentStatusesDescriptor = $convert.base64Decode('ChpSZXZlcnNlU3dhcFBheW1lbnRTdGF0dXNlcxJHCg9wYXltZW50c19zdGF0dXMYASADKAsyHi5kYXRhLlJldmVyc2VTd2FwUGF5bWVudFN0YXR1c1IOcGF5bWVudHNTdGF0dXM=');
@$core.Deprecated('Use reverseSwapClaimFeeDescriptor instead')
const ReverseSwapClaimFee$json = const {
  '1': 'ReverseSwapClaimFee',
  '2': const [
    const {'1': 'hash', '3': 1, '4': 1, '5': 9, '10': 'hash'},
    const {'1': 'fee', '3': 2, '4': 1, '5': 3, '10': 'fee'},
  ],
};

/// Descriptor for `ReverseSwapClaimFee`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseSwapClaimFeeDescriptor = $convert.base64Decode('ChNSZXZlcnNlU3dhcENsYWltRmVlEhIKBGhhc2gYASABKAlSBGhhc2gSEAoDZmVlGAIgASgDUgNmZWU=');
@$core.Deprecated('Use claimFeeEstimatesDescriptor instead')
const ClaimFeeEstimates$json = const {
  '1': 'ClaimFeeEstimates',
  '2': const [
    const {'1': 'fees', '3': 1, '4': 3, '5': 11, '6': '.data.ClaimFeeEstimates.FeesEntry', '10': 'fees'},
  ],
  '3': const [ClaimFeeEstimates_FeesEntry$json],
};

@$core.Deprecated('Use claimFeeEstimatesDescriptor instead')
const ClaimFeeEstimates_FeesEntry$json = const {
  '1': 'FeesEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `ClaimFeeEstimates`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List claimFeeEstimatesDescriptor = $convert.base64Decode('ChFDbGFpbUZlZUVzdGltYXRlcxI1CgRmZWVzGAEgAygLMiEuZGF0YS5DbGFpbUZlZUVzdGltYXRlcy5GZWVzRW50cnlSBGZlZXMaNwoJRmVlc0VudHJ5EhAKA2tleRgBIAEoBVIDa2V5EhQKBXZhbHVlGAIgASgDUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use unspendLockupInformationDescriptor instead')
const UnspendLockupInformation$json = const {
  '1': 'UnspendLockupInformation',
  '2': const [
    const {'1': 'height_hint', '3': 1, '4': 1, '5': 13, '10': 'heightHint'},
    const {'1': 'lockup_script', '3': 2, '4': 1, '5': 12, '10': 'lockupScript'},
    const {'1': 'claim_tx_hash', '3': 3, '4': 1, '5': 12, '10': 'claimTxHash'},
  ],
};

/// Descriptor for `UnspendLockupInformation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unspendLockupInformationDescriptor = $convert.base64Decode('ChhVbnNwZW5kTG9ja3VwSW5mb3JtYXRpb24SHwoLaGVpZ2h0X2hpbnQYASABKA1SCmhlaWdodEhpbnQSIwoNbG9ja3VwX3NjcmlwdBgCIAEoDFIMbG9ja3VwU2NyaXB0EiIKDWNsYWltX3R4X2hhc2gYAyABKAxSC2NsYWltVHhIYXNo');
@$core.Deprecated('Use transactionDetailsDescriptor instead')
const TransactionDetails$json = const {
  '1': 'TransactionDetails',
  '2': const [
    const {'1': 'tx', '3': 1, '4': 1, '5': 12, '10': 'tx'},
    const {'1': 'tx_hash', '3': 2, '4': 1, '5': 9, '10': 'txHash'},
    const {'1': 'fees', '3': 3, '4': 1, '5': 3, '10': 'fees'},
  ],
};

/// Descriptor for `TransactionDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transactionDetailsDescriptor = $convert.base64Decode('ChJUcmFuc2FjdGlvbkRldGFpbHMSDgoCdHgYASABKAxSAnR4EhcKB3R4X2hhc2gYAiABKAlSBnR4SGFzaBISCgRmZWVzGAMgASgDUgRmZWVz');
@$core.Deprecated('Use sweepAllCoinsTransactionsDescriptor instead')
const SweepAllCoinsTransactions$json = const {
  '1': 'SweepAllCoinsTransactions',
  '2': const [
    const {'1': 'amt', '3': 1, '4': 1, '5': 3, '10': 'amt'},
    const {'1': 'transactions', '3': 2, '4': 3, '5': 11, '6': '.data.SweepAllCoinsTransactions.TransactionsEntry', '10': 'transactions'},
  ],
  '3': const [SweepAllCoinsTransactions_TransactionsEntry$json],
};

@$core.Deprecated('Use sweepAllCoinsTransactionsDescriptor instead')
const SweepAllCoinsTransactions_TransactionsEntry$json = const {
  '1': 'TransactionsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.data.TransactionDetails', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `SweepAllCoinsTransactions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sweepAllCoinsTransactionsDescriptor = $convert.base64Decode('ChlTd2VlcEFsbENvaW5zVHJhbnNhY3Rpb25zEhAKA2FtdBgBIAEoA1IDYW10ElUKDHRyYW5zYWN0aW9ucxgCIAMoCzIxLmRhdGEuU3dlZXBBbGxDb2luc1RyYW5zYWN0aW9ucy5UcmFuc2FjdGlvbnNFbnRyeVIMdHJhbnNhY3Rpb25zGlkKEVRyYW5zYWN0aW9uc0VudHJ5EhAKA2tleRgBIAEoBVIDa2V5Ei4KBXZhbHVlGAIgASgLMhguZGF0YS5UcmFuc2FjdGlvbkRldGFpbHNSBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use downloadBackupResponseDescriptor instead')
const DownloadBackupResponse$json = const {
  '1': 'DownloadBackupResponse',
  '2': const [
    const {'1': 'files', '3': 1, '4': 3, '5': 9, '10': 'files'},
  ],
};

/// Descriptor for `DownloadBackupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadBackupResponseDescriptor = $convert.base64Decode('ChZEb3dubG9hZEJhY2t1cFJlc3BvbnNlEhQKBWZpbGVzGAEgAygJUgVmaWxlcw==');

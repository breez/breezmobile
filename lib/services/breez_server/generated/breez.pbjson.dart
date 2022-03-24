///
//  Generated code. Do not modify.
//  source: breez.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use signUrlRequestDescriptor instead')
const SignUrlRequest$json = const {
  '1': 'SignUrlRequest',
  '2': const [
    const {'1': 'baseUrl', '3': 1, '4': 1, '5': 9, '10': 'base_url'},
    const {'1': 'queryString', '3': 2, '4': 1, '5': 9, '10': 'query_string'},
  ],
};

/// Descriptor for `SignUrlRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signUrlRequestDescriptor = $convert.base64Decode('Cg5TaWduVXJsUmVxdWVzdBIZCgdiYXNlVXJsGAEgASgJUghiYXNlX3VybBIhCgtxdWVyeVN0cmluZxgCIAEoCVIMcXVlcnlfc3RyaW5n');
@$core.Deprecated('Use signUrlResponseDescriptor instead')
const SignUrlResponse$json = const {
  '1': 'SignUrlResponse',
  '2': const [
    const {'1': 'fullUrl', '3': 1, '4': 1, '5': 9, '10': 'full_url'},
  ],
};

/// Descriptor for `SignUrlResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signUrlResponseDescriptor = $convert.base64Decode('Cg9TaWduVXJsUmVzcG9uc2USGQoHZnVsbFVybBgBIAEoCVIIZnVsbF91cmw=');
@$core.Deprecated('Use inactiveNotifyRequestDescriptor instead')
const InactiveNotifyRequest$json = const {
  '1': 'InactiveNotifyRequest',
  '2': const [
    const {'1': 'pubkey', '3': 1, '4': 1, '5': 12, '10': 'pubkey'},
    const {'1': 'days', '3': 2, '4': 1, '5': 5, '10': 'days'},
  ],
};

/// Descriptor for `InactiveNotifyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inactiveNotifyRequestDescriptor = $convert.base64Decode('ChVJbmFjdGl2ZU5vdGlmeVJlcXVlc3QSFgoGcHVia2V5GAEgASgMUgZwdWJrZXkSEgoEZGF5cxgCIAEoBVIEZGF5cw==');
@$core.Deprecated('Use inactiveNotifyResponseDescriptor instead')
const InactiveNotifyResponse$json = const {
  '1': 'InactiveNotifyResponse',
};

/// Descriptor for `InactiveNotifyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inactiveNotifyResponseDescriptor = $convert.base64Decode('ChZJbmFjdGl2ZU5vdGlmeVJlc3BvbnNl');
@$core.Deprecated('Use receiverInfoRequestDescriptor instead')
const ReceiverInfoRequest$json = const {
  '1': 'ReceiverInfoRequest',
};

/// Descriptor for `ReceiverInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiverInfoRequestDescriptor = $convert.base64Decode('ChNSZWNlaXZlckluZm9SZXF1ZXN0');
@$core.Deprecated('Use receiverInfoReplyDescriptor instead')
const ReceiverInfoReply$json = const {
  '1': 'ReceiverInfoReply',
  '2': const [
    const {'1': 'pubkey', '3': 1, '4': 1, '5': 9, '10': 'pubkey'},
  ],
};

/// Descriptor for `ReceiverInfoReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiverInfoReplyDescriptor = $convert.base64Decode('ChFSZWNlaXZlckluZm9SZXBseRIWCgZwdWJrZXkYASABKAlSBnB1YmtleQ==');
@$core.Deprecated('Use ratesRequestDescriptor instead')
const RatesRequest$json = const {
  '1': 'RatesRequest',
};

/// Descriptor for `RatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ratesRequestDescriptor = $convert.base64Decode('CgxSYXRlc1JlcXVlc3Q=');
@$core.Deprecated('Use rateDescriptor instead')
const Rate$json = const {
  '1': 'Rate',
  '2': const [
    const {'1': 'coin', '3': 1, '4': 1, '5': 9, '10': 'coin'},
    const {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
};

/// Descriptor for `Rate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateDescriptor = $convert.base64Decode('CgRSYXRlEhIKBGNvaW4YASABKAlSBGNvaW4SFAoFdmFsdWUYAiABKAFSBXZhbHVl');
@$core.Deprecated('Use ratesReplyDescriptor instead')
const RatesReply$json = const {
  '1': 'RatesReply',
  '2': const [
    const {'1': 'rates', '3': 1, '4': 3, '5': 11, '6': '.breez.Rate', '10': 'rates'},
  ],
};

/// Descriptor for `RatesReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ratesReplyDescriptor = $convert.base64Decode('CgpSYXRlc1JlcGx5EiEKBXJhdGVzGAEgAygLMgsuYnJlZXouUmF0ZVIFcmF0ZXM=');
@$core.Deprecated('Use lSPListRequestDescriptor instead')
const LSPListRequest$json = const {
  '1': 'LSPListRequest',
  '2': const [
    const {'1': 'pubkey', '3': 2, '4': 1, '5': 9, '10': 'pubkey'},
  ],
};

/// Descriptor for `LSPListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lSPListRequestDescriptor = $convert.base64Decode('Cg5MU1BMaXN0UmVxdWVzdBIWCgZwdWJrZXkYAiABKAlSBnB1YmtleQ==');
@$core.Deprecated('Use lSPInformationDescriptor instead')
const LSPInformation$json = const {
  '1': 'LSPInformation',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'widget_url', '3': 2, '4': 1, '5': 9, '10': 'widget_url'},
    const {'1': 'pubkey', '3': 3, '4': 1, '5': 9, '10': 'pubkey'},
    const {'1': 'host', '3': 4, '4': 1, '5': 9, '10': 'host'},
    const {'1': 'channel_capacity', '3': 5, '4': 1, '5': 3, '10': 'channel_capacity'},
    const {'1': 'target_conf', '3': 6, '4': 1, '5': 5, '10': 'target_conf'},
    const {'1': 'base_fee_msat', '3': 7, '4': 1, '5': 3, '10': 'base_fee_msat'},
    const {'1': 'fee_rate', '3': 8, '4': 1, '5': 1, '10': 'fee_rate'},
    const {'1': 'time_lock_delta', '3': 9, '4': 1, '5': 13, '10': 'time_lock_delta'},
    const {'1': 'min_htlc_msat', '3': 10, '4': 1, '5': 3, '10': 'min_htlc_msat'},
    const {'1': 'channel_fee_permyriad', '3': 11, '4': 1, '5': 3, '10': 'channelFeePermyriad'},
    const {'1': 'lsp_pubkey', '3': 12, '4': 1, '5': 12, '10': 'lspPubkey'},
    const {'1': 'max_inactive_duration', '3': 13, '4': 1, '5': 3, '10': 'maxInactiveDuration'},
    const {'1': 'channel_minimum_fee_msat', '3': 14, '4': 1, '5': 3, '10': 'channelMinimumFeeMsat'},
  ],
};

/// Descriptor for `LSPInformation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lSPInformationDescriptor = $convert.base64Decode('Cg5MU1BJbmZvcm1hdGlvbhISCgRuYW1lGAEgASgJUgRuYW1lEh4KCndpZGdldF91cmwYAiABKAlSCndpZGdldF91cmwSFgoGcHVia2V5GAMgASgJUgZwdWJrZXkSEgoEaG9zdBgEIAEoCVIEaG9zdBIqChBjaGFubmVsX2NhcGFjaXR5GAUgASgDUhBjaGFubmVsX2NhcGFjaXR5EiAKC3RhcmdldF9jb25mGAYgASgFUgt0YXJnZXRfY29uZhIkCg1iYXNlX2ZlZV9tc2F0GAcgASgDUg1iYXNlX2ZlZV9tc2F0EhoKCGZlZV9yYXRlGAggASgBUghmZWVfcmF0ZRIoCg90aW1lX2xvY2tfZGVsdGEYCSABKA1SD3RpbWVfbG9ja19kZWx0YRIkCg1taW5faHRsY19tc2F0GAogASgDUg1taW5faHRsY19tc2F0EjIKFWNoYW5uZWxfZmVlX3Blcm15cmlhZBgLIAEoA1ITY2hhbm5lbEZlZVBlcm15cmlhZBIdCgpsc3BfcHVia2V5GAwgASgMUglsc3BQdWJrZXkSMgoVbWF4X2luYWN0aXZlX2R1cmF0aW9uGA0gASgDUhNtYXhJbmFjdGl2ZUR1cmF0aW9uEjcKGGNoYW5uZWxfbWluaW11bV9mZWVfbXNhdBgOIAEoA1IVY2hhbm5lbE1pbmltdW1GZWVNc2F0');
@$core.Deprecated('Use lSPListReplyDescriptor instead')
const LSPListReply$json = const {
  '1': 'LSPListReply',
  '2': const [
    const {'1': 'lsps', '3': 1, '4': 3, '5': 11, '6': '.breez.LSPListReply.LspsEntry', '10': 'lsps'},
  ],
  '3': const [LSPListReply_LspsEntry$json],
};

@$core.Deprecated('Use lSPListReplyDescriptor instead')
const LSPListReply_LspsEntry$json = const {
  '1': 'LspsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.breez.LSPInformation', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `LSPListReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lSPListReplyDescriptor = $convert.base64Decode('CgxMU1BMaXN0UmVwbHkSMQoEbHNwcxgBIAMoCzIdLmJyZWV6LkxTUExpc3RSZXBseS5Mc3BzRW50cnlSBGxzcHMaTgoJTHNwc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EisKBXZhbHVlGAIgASgLMhUuYnJlZXouTFNQSW5mb3JtYXRpb25SBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use registerPaymentRequestDescriptor instead')
const RegisterPaymentRequest$json = const {
  '1': 'RegisterPaymentRequest',
  '2': const [
    const {'1': 'lsp_id', '3': 1, '4': 1, '5': 9, '10': 'lspId'},
    const {'1': 'blob', '3': 3, '4': 1, '5': 12, '10': 'blob'},
  ],
};

/// Descriptor for `RegisterPaymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerPaymentRequestDescriptor = $convert.base64Decode('ChZSZWdpc3RlclBheW1lbnRSZXF1ZXN0EhUKBmxzcF9pZBgBIAEoCVIFbHNwSWQSEgoEYmxvYhgDIAEoDFIEYmxvYg==');
@$core.Deprecated('Use registerPaymentReplyDescriptor instead')
const RegisterPaymentReply$json = const {
  '1': 'RegisterPaymentReply',
};

/// Descriptor for `RegisterPaymentReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerPaymentReplyDescriptor = $convert.base64Decode('ChRSZWdpc3RlclBheW1lbnRSZXBseQ==');
@$core.Deprecated('Use checkChannelsRequestDescriptor instead')
const CheckChannelsRequest$json = const {
  '1': 'CheckChannelsRequest',
  '2': const [
    const {'1': 'lsp_id', '3': 1, '4': 1, '5': 9, '10': 'lspId'},
    const {'1': 'blob', '3': 2, '4': 1, '5': 12, '10': 'blob'},
  ],
};

/// Descriptor for `CheckChannelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkChannelsRequestDescriptor = $convert.base64Decode('ChRDaGVja0NoYW5uZWxzUmVxdWVzdBIVCgZsc3BfaWQYASABKAlSBWxzcElkEhIKBGJsb2IYAiABKAxSBGJsb2I=');
@$core.Deprecated('Use checkChannelsReplyDescriptor instead')
const CheckChannelsReply$json = const {
  '1': 'CheckChannelsReply',
  '2': const [
    const {'1': 'blob', '3': 2, '4': 1, '5': 12, '10': 'blob'},
  ],
};

/// Descriptor for `CheckChannelsReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkChannelsReplyDescriptor = $convert.base64Decode('ChJDaGVja0NoYW5uZWxzUmVwbHkSEgoEYmxvYhgCIAEoDFIEYmxvYg==');
@$core.Deprecated('Use openLSPChannelRequestDescriptor instead')
const OpenLSPChannelRequest$json = const {
  '1': 'OpenLSPChannelRequest',
  '2': const [
    const {'1': 'lsp_id', '3': 1, '4': 1, '5': 9, '10': 'lspId'},
    const {'1': 'pubkey', '3': 2, '4': 1, '5': 9, '10': 'pubkey'},
  ],
};

/// Descriptor for `OpenLSPChannelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openLSPChannelRequestDescriptor = $convert.base64Decode('ChVPcGVuTFNQQ2hhbm5lbFJlcXVlc3QSFQoGbHNwX2lkGAEgASgJUgVsc3BJZBIWCgZwdWJrZXkYAiABKAlSBnB1YmtleQ==');
@$core.Deprecated('Use openLSPChannelReplyDescriptor instead')
const OpenLSPChannelReply$json = const {
  '1': 'OpenLSPChannelReply',
};

/// Descriptor for `OpenLSPChannelReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openLSPChannelReplyDescriptor = $convert.base64Decode('ChNPcGVuTFNQQ2hhbm5lbFJlcGx5');
@$core.Deprecated('Use openChannelRequestDescriptor instead')
const OpenChannelRequest$json = const {
  '1': 'OpenChannelRequest',
  '2': const [
    const {'1': 'pubKey', '3': 1, '4': 1, '5': 9, '10': 'pubKey'},
    const {'1': 'notificationToken', '3': 2, '4': 1, '5': 9, '10': 'notificationToken'},
  ],
};

/// Descriptor for `OpenChannelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openChannelRequestDescriptor = $convert.base64Decode('ChJPcGVuQ2hhbm5lbFJlcXVlc3QSFgoGcHViS2V5GAEgASgJUgZwdWJLZXkSLAoRbm90aWZpY2F0aW9uVG9rZW4YAiABKAlSEW5vdGlmaWNhdGlvblRva2Vu');
@$core.Deprecated('Use openChannelReplyDescriptor instead')
const OpenChannelReply$json = const {
  '1': 'OpenChannelReply',
};

/// Descriptor for `OpenChannelReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openChannelReplyDescriptor = $convert.base64Decode('ChBPcGVuQ2hhbm5lbFJlcGx5');
@$core.Deprecated('Use openPublicChannelRequestDescriptor instead')
const OpenPublicChannelRequest$json = const {
  '1': 'OpenPublicChannelRequest',
  '2': const [
    const {'1': 'pubkey', '3': 1, '4': 1, '5': 9, '10': 'pubkey'},
  ],
};

/// Descriptor for `OpenPublicChannelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openPublicChannelRequestDescriptor = $convert.base64Decode('ChhPcGVuUHVibGljQ2hhbm5lbFJlcXVlc3QSFgoGcHVia2V5GAEgASgJUgZwdWJrZXk=');
@$core.Deprecated('Use openPublicChannelReplyDescriptor instead')
const OpenPublicChannelReply$json = const {
  '1': 'OpenPublicChannelReply',
};

/// Descriptor for `OpenPublicChannelReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openPublicChannelReplyDescriptor = $convert.base64Decode('ChZPcGVuUHVibGljQ2hhbm5lbFJlcGx5');
@$core.Deprecated('Use captchaDescriptor instead')
const Captcha$json = const {
  '1': 'Captcha',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'image', '3': 2, '4': 1, '5': 12, '10': 'image'},
  ],
};

/// Descriptor for `Captcha`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List captchaDescriptor = $convert.base64Decode('CgdDYXB0Y2hhEg4KAmlkGAEgASgJUgJpZBIUCgVpbWFnZRgCIAEoDFIFaW1hZ2U=');
@$core.Deprecated('Use updateChannelPolicyRequestDescriptor instead')
const UpdateChannelPolicyRequest$json = const {
  '1': 'UpdateChannelPolicyRequest',
  '2': const [
    const {'1': 'pubKey', '3': 1, '4': 1, '5': 9, '10': 'pubKey'},
  ],
};

/// Descriptor for `UpdateChannelPolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateChannelPolicyRequestDescriptor = $convert.base64Decode('ChpVcGRhdGVDaGFubmVsUG9saWN5UmVxdWVzdBIWCgZwdWJLZXkYASABKAlSBnB1YktleQ==');
@$core.Deprecated('Use updateChannelPolicyReplyDescriptor instead')
const UpdateChannelPolicyReply$json = const {
  '1': 'UpdateChannelPolicyReply',
};

/// Descriptor for `UpdateChannelPolicyReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateChannelPolicyReplyDescriptor = $convert.base64Decode('ChhVcGRhdGVDaGFubmVsUG9saWN5UmVwbHk=');
@$core.Deprecated('Use addFundInitRequestDescriptor instead')
const AddFundInitRequest$json = const {
  '1': 'AddFundInitRequest',
  '2': const [
    const {'1': 'nodeID', '3': 1, '4': 1, '5': 9, '10': 'nodeID'},
    const {'1': 'notificationToken', '3': 2, '4': 1, '5': 9, '10': 'notificationToken'},
    const {'1': 'pubkey', '3': 3, '4': 1, '5': 12, '10': 'pubkey'},
    const {'1': 'hash', '3': 4, '4': 1, '5': 12, '10': 'hash'},
  ],
};

/// Descriptor for `AddFundInitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFundInitRequestDescriptor = $convert.base64Decode('ChJBZGRGdW5kSW5pdFJlcXVlc3QSFgoGbm9kZUlEGAEgASgJUgZub2RlSUQSLAoRbm90aWZpY2F0aW9uVG9rZW4YAiABKAlSEW5vdGlmaWNhdGlvblRva2VuEhYKBnB1YmtleRgDIAEoDFIGcHVia2V5EhIKBGhhc2gYBCABKAxSBGhhc2g=');
@$core.Deprecated('Use addFundInitReplyDescriptor instead')
const AddFundInitReply$json = const {
  '1': 'AddFundInitReply',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'pubkey', '3': 2, '4': 1, '5': 12, '10': 'pubkey'},
    const {'1': 'lockHeight', '3': 3, '4': 1, '5': 3, '10': 'lockHeight'},
    const {'1': 'maxAllowedDeposit', '3': 4, '4': 1, '5': 3, '10': 'maxAllowedDeposit'},
    const {'1': 'errorMessage', '3': 5, '4': 1, '5': 9, '10': 'errorMessage'},
    const {'1': 'requiredReserve', '3': 6, '4': 1, '5': 3, '10': 'requiredReserve'},
    const {'1': 'minAllowedDeposit', '3': 7, '4': 1, '5': 3, '10': 'minAllowedDeposit'},
  ],
};

/// Descriptor for `AddFundInitReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFundInitReplyDescriptor = $convert.base64Decode('ChBBZGRGdW5kSW5pdFJlcGx5EhgKB2FkZHJlc3MYASABKAlSB2FkZHJlc3MSFgoGcHVia2V5GAIgASgMUgZwdWJrZXkSHgoKbG9ja0hlaWdodBgDIAEoA1IKbG9ja0hlaWdodBIsChFtYXhBbGxvd2VkRGVwb3NpdBgEIAEoA1IRbWF4QWxsb3dlZERlcG9zaXQSIgoMZXJyb3JNZXNzYWdlGAUgASgJUgxlcnJvck1lc3NhZ2USKAoPcmVxdWlyZWRSZXNlcnZlGAYgASgDUg9yZXF1aXJlZFJlc2VydmUSLAoRbWluQWxsb3dlZERlcG9zaXQYByABKANSEW1pbkFsbG93ZWREZXBvc2l0');
@$core.Deprecated('Use addFundStatusRequestDescriptor instead')
const AddFundStatusRequest$json = const {
  '1': 'AddFundStatusRequest',
  '2': const [
    const {'1': 'addresses', '3': 1, '4': 3, '5': 9, '10': 'addresses'},
    const {'1': 'notificationToken', '3': 2, '4': 1, '5': 9, '10': 'notificationToken'},
  ],
};

/// Descriptor for `AddFundStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFundStatusRequestDescriptor = $convert.base64Decode('ChRBZGRGdW5kU3RhdHVzUmVxdWVzdBIcCglhZGRyZXNzZXMYASADKAlSCWFkZHJlc3NlcxIsChFub3RpZmljYXRpb25Ub2tlbhgCIAEoCVIRbm90aWZpY2F0aW9uVG9rZW4=');
@$core.Deprecated('Use addFundStatusReplyDescriptor instead')
const AddFundStatusReply$json = const {
  '1': 'AddFundStatusReply',
  '2': const [
    const {'1': 'statuses', '3': 1, '4': 3, '5': 11, '6': '.breez.AddFundStatusReply.StatusesEntry', '10': 'statuses'},
  ],
  '3': const [AddFundStatusReply_AddressStatus$json, AddFundStatusReply_StatusesEntry$json],
};

@$core.Deprecated('Use addFundStatusReplyDescriptor instead')
const AddFundStatusReply_AddressStatus$json = const {
  '1': 'AddressStatus',
  '2': const [
    const {'1': 'tx', '3': 1, '4': 1, '5': 9, '10': 'tx'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
    const {'1': 'confirmed', '3': 3, '4': 1, '5': 8, '10': 'confirmed'},
    const {'1': 'blockHash', '3': 4, '4': 1, '5': 9, '10': 'blockHash'},
  ],
};

@$core.Deprecated('Use addFundStatusReplyDescriptor instead')
const AddFundStatusReply_StatusesEntry$json = const {
  '1': 'StatusesEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.breez.AddFundStatusReply.AddressStatus', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `AddFundStatusReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFundStatusReplyDescriptor = $convert.base64Decode('ChJBZGRGdW5kU3RhdHVzUmVwbHkSQwoIc3RhdHVzZXMYASADKAsyJy5icmVlei5BZGRGdW5kU3RhdHVzUmVwbHkuU3RhdHVzZXNFbnRyeVIIc3RhdHVzZXMacwoNQWRkcmVzc1N0YXR1cxIOCgJ0eBgBIAEoCVICdHgSFgoGYW1vdW50GAIgASgDUgZhbW91bnQSHAoJY29uZmlybWVkGAMgASgIUgljb25maXJtZWQSHAoJYmxvY2tIYXNoGAQgASgJUglibG9ja0hhc2gaZAoNU3RhdHVzZXNFbnRyeRIQCgNrZXkYASABKAlSA2tleRI9CgV2YWx1ZRgCIAEoCzInLmJyZWV6LkFkZEZ1bmRTdGF0dXNSZXBseS5BZGRyZXNzU3RhdHVzUgV2YWx1ZToCOAE=');
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
    const {'1': 'paymentRequest', '3': 1, '4': 1, '5': 9, '10': 'paymentRequest'},
    const {'1': 'errorMessage', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `RemoveFundReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeFundReplyDescriptor = $convert.base64Decode('Cg9SZW1vdmVGdW5kUmVwbHkSJgoOcGF5bWVudFJlcXVlc3QYASABKAlSDnBheW1lbnRSZXF1ZXN0EiIKDGVycm9yTWVzc2FnZRgCIAEoCVIMZXJyb3JNZXNzYWdl');
@$core.Deprecated('Use redeemRemovedFundsRequestDescriptor instead')
const RedeemRemovedFundsRequest$json = const {
  '1': 'RedeemRemovedFundsRequest',
  '2': const [
    const {'1': 'paymenthash', '3': 1, '4': 1, '5': 9, '10': 'paymenthash'},
  ],
};

/// Descriptor for `RedeemRemovedFundsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List redeemRemovedFundsRequestDescriptor = $convert.base64Decode('ChlSZWRlZW1SZW1vdmVkRnVuZHNSZXF1ZXN0EiAKC3BheW1lbnRoYXNoGAEgASgJUgtwYXltZW50aGFzaA==');
@$core.Deprecated('Use redeemRemovedFundsReplyDescriptor instead')
const RedeemRemovedFundsReply$json = const {
  '1': 'RedeemRemovedFundsReply',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 1, '5': 9, '10': 'txid'},
  ],
};

/// Descriptor for `RedeemRemovedFundsReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List redeemRemovedFundsReplyDescriptor = $convert.base64Decode('ChdSZWRlZW1SZW1vdmVkRnVuZHNSZXBseRISCgR0eGlkGAEgASgJUgR0eGlk');
@$core.Deprecated('Use getSwapPaymentRequestDescriptor instead')
const GetSwapPaymentRequest$json = const {
  '1': 'GetSwapPaymentRequest',
  '2': const [
    const {'1': 'paymentRequest', '3': 1, '4': 1, '5': 9, '10': 'paymentRequest'},
  ],
};

/// Descriptor for `GetSwapPaymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSwapPaymentRequestDescriptor = $convert.base64Decode('ChVHZXRTd2FwUGF5bWVudFJlcXVlc3QSJgoOcGF5bWVudFJlcXVlc3QYASABKAlSDnBheW1lbnRSZXF1ZXN0');
@$core.Deprecated('Use getSwapPaymentReplyDescriptor instead')
const GetSwapPaymentReply$json = const {
  '1': 'GetSwapPaymentReply',
  '2': const [
    const {'1': 'paymentError', '3': 1, '4': 1, '5': 9, '10': 'paymentError'},
    const {'1': 'funds_exceeded_limit', '3': 2, '4': 1, '5': 8, '10': 'fundsExceededLimit'},
    const {'1': 'swap_error', '3': 3, '4': 1, '5': 14, '6': '.breez.GetSwapPaymentReply.SwapError', '10': 'swapError'},
  ],
  '4': const [GetSwapPaymentReply_SwapError$json],
};

@$core.Deprecated('Use getSwapPaymentReplyDescriptor instead')
const GetSwapPaymentReply_SwapError$json = const {
  '1': 'SwapError',
  '2': const [
    const {'1': 'NO_ERROR', '2': 0},
    const {'1': 'FUNDS_EXCEED_LIMIT', '2': 1},
    const {'1': 'TX_TOO_SMALL', '2': 2},
    const {'1': 'INVOICE_AMOUNT_MISMATCH', '2': 3},
    const {'1': 'SWAP_EXPIRED', '2': 4},
  ],
};

/// Descriptor for `GetSwapPaymentReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSwapPaymentReplyDescriptor = $convert.base64Decode('ChNHZXRTd2FwUGF5bWVudFJlcGx5EiIKDHBheW1lbnRFcnJvchgBIAEoCVIMcGF5bWVudEVycm9yEjAKFGZ1bmRzX2V4Y2VlZGVkX2xpbWl0GAIgASgIUhJmdW5kc0V4Y2VlZGVkTGltaXQSQwoKc3dhcF9lcnJvchgDIAEoDjIkLmJyZWV6LkdldFN3YXBQYXltZW50UmVwbHkuU3dhcEVycm9yUglzd2FwRXJyb3IicgoJU3dhcEVycm9yEgwKCE5PX0VSUk9SEAASFgoSRlVORFNfRVhDRUVEX0xJTUlUEAESEAoMVFhfVE9PX1NNQUxMEAISGwoXSU5WT0lDRV9BTU9VTlRfTUlTTUFUQ0gQAxIQCgxTV0FQX0VYUElSRUQQBA==');
@$core.Deprecated('Use redeemSwapPaymentRequestDescriptor instead')
const RedeemSwapPaymentRequest$json = const {
  '1': 'RedeemSwapPaymentRequest',
  '2': const [
    const {'1': 'preimage', '3': 1, '4': 1, '5': 12, '10': 'preimage'},
    const {'1': 'target_conf', '3': 2, '4': 1, '5': 5, '10': 'targetConf'},
    const {'1': 'sat_per_byte', '3': 3, '4': 1, '5': 3, '10': 'satPerByte'},
  ],
};

/// Descriptor for `RedeemSwapPaymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List redeemSwapPaymentRequestDescriptor = $convert.base64Decode('ChhSZWRlZW1Td2FwUGF5bWVudFJlcXVlc3QSGgoIcHJlaW1hZ2UYASABKAxSCHByZWltYWdlEh8KC3RhcmdldF9jb25mGAIgASgFUgp0YXJnZXRDb25mEiAKDHNhdF9wZXJfYnl0ZRgDIAEoA1IKc2F0UGVyQnl0ZQ==');
@$core.Deprecated('Use redeemSwapPaymentReplyDescriptor instead')
const RedeemSwapPaymentReply$json = const {
  '1': 'RedeemSwapPaymentReply',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 1, '5': 9, '10': 'txid'},
  ],
};

/// Descriptor for `RedeemSwapPaymentReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List redeemSwapPaymentReplyDescriptor = $convert.base64Decode('ChZSZWRlZW1Td2FwUGF5bWVudFJlcGx5EhIKBHR4aWQYASABKAlSBHR4aWQ=');
@$core.Deprecated('Use registerRequestDescriptor instead')
const RegisterRequest$json = const {
  '1': 'RegisterRequest',
  '2': const [
    const {'1': 'deviceID', '3': 1, '4': 1, '5': 9, '10': 'deviceID'},
    const {'1': 'lightningID', '3': 2, '4': 1, '5': 9, '10': 'lightningID'},
  ],
};

/// Descriptor for `RegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRequestDescriptor = $convert.base64Decode('Cg9SZWdpc3RlclJlcXVlc3QSGgoIZGV2aWNlSUQYASABKAlSCGRldmljZUlEEiAKC2xpZ2h0bmluZ0lEGAIgASgJUgtsaWdodG5pbmdJRA==');
@$core.Deprecated('Use registerReplyDescriptor instead')
const RegisterReply$json = const {
  '1': 'RegisterReply',
  '2': const [
    const {'1': 'breezID', '3': 1, '4': 1, '5': 9, '10': 'breezID'},
  ],
};

/// Descriptor for `RegisterReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerReplyDescriptor = $convert.base64Decode('Cg1SZWdpc3RlclJlcGx5EhgKB2JyZWV6SUQYASABKAlSB2JyZWV6SUQ=');
@$core.Deprecated('Use paymentRequestDescriptor instead')
const PaymentRequest$json = const {
  '1': 'PaymentRequest',
  '2': const [
    const {'1': 'breezID', '3': 1, '4': 1, '5': 9, '10': 'breezID'},
    const {'1': 'invoice', '3': 2, '4': 1, '5': 9, '10': 'invoice'},
    const {'1': 'payee', '3': 3, '4': 1, '5': 9, '10': 'payee'},
    const {'1': 'amount', '3': 4, '4': 1, '5': 3, '10': 'amount'},
  ],
};

/// Descriptor for `PaymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentRequestDescriptor = $convert.base64Decode('Cg5QYXltZW50UmVxdWVzdBIYCgdicmVleklEGAEgASgJUgdicmVleklEEhgKB2ludm9pY2UYAiABKAlSB2ludm9pY2USFAoFcGF5ZWUYAyABKAlSBXBheWVlEhYKBmFtb3VudBgEIAEoA1IGYW1vdW50');
@$core.Deprecated('Use invoiceReplyDescriptor instead')
const InvoiceReply$json = const {
  '1': 'InvoiceReply',
  '2': const [
    const {'1': 'Error', '3': 1, '4': 1, '5': 9, '10': 'Error'},
  ],
};

/// Descriptor for `InvoiceReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceReplyDescriptor = $convert.base64Decode('CgxJbnZvaWNlUmVwbHkSFAoFRXJyb3IYASABKAlSBUVycm9y');
@$core.Deprecated('Use uploadFileRequestDescriptor instead')
const UploadFileRequest$json = const {
  '1': 'UploadFileRequest',
  '2': const [
    const {'1': 'content', '3': 1, '4': 1, '5': 12, '10': 'content'},
  ],
};

/// Descriptor for `UploadFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadFileRequestDescriptor = $convert.base64Decode('ChFVcGxvYWRGaWxlUmVxdWVzdBIYCgdjb250ZW50GAEgASgMUgdjb250ZW50');
@$core.Deprecated('Use uploadFileReplyDescriptor instead')
const UploadFileReply$json = const {
  '1': 'UploadFileReply',
  '2': const [
    const {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `UploadFileReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadFileReplyDescriptor = $convert.base64Decode('Cg9VcGxvYWRGaWxlUmVwbHkSEAoDdXJsGAEgASgJUgN1cmw=');
@$core.Deprecated('Use pingRequestDescriptor instead')
const PingRequest$json = const {
  '1': 'PingRequest',
};

/// Descriptor for `PingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingRequestDescriptor = $convert.base64Decode('CgtQaW5nUmVxdWVzdA==');
@$core.Deprecated('Use pingReplyDescriptor instead')
const PingReply$json = const {
  '1': 'PingReply',
  '2': const [
    const {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `PingReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingReplyDescriptor = $convert.base64Decode('CglQaW5nUmVwbHkSGAoHdmVyc2lvbhgBIAEoCVIHdmVyc2lvbg==');
@$core.Deprecated('Use orderRequestDescriptor instead')
const OrderRequest$json = const {
  '1': 'OrderRequest',
  '2': const [
    const {'1': 'FullName', '3': 1, '4': 1, '5': 9, '10': 'FullName'},
    const {'1': 'Address', '3': 2, '4': 1, '5': 9, '10': 'Address'},
    const {'1': 'City', '3': 3, '4': 1, '5': 9, '10': 'City'},
    const {'1': 'State', '3': 4, '4': 1, '5': 9, '10': 'State'},
    const {'1': 'Zip', '3': 5, '4': 1, '5': 9, '10': 'Zip'},
    const {'1': 'Country', '3': 6, '4': 1, '5': 9, '10': 'Country'},
    const {'1': 'Email', '3': 7, '4': 1, '5': 9, '10': 'Email'},
  ],
};

/// Descriptor for `OrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderRequestDescriptor = $convert.base64Decode('CgxPcmRlclJlcXVlc3QSGgoIRnVsbE5hbWUYASABKAlSCEZ1bGxOYW1lEhgKB0FkZHJlc3MYAiABKAlSB0FkZHJlc3MSEgoEQ2l0eRgDIAEoCVIEQ2l0eRIUCgVTdGF0ZRgEIAEoCVIFU3RhdGUSEAoDWmlwGAUgASgJUgNaaXASGAoHQ291bnRyeRgGIAEoCVIHQ291bnRyeRIUCgVFbWFpbBgHIAEoCVIFRW1haWw=');
@$core.Deprecated('Use orderReplyDescriptor instead')
const OrderReply$json = const {
  '1': 'OrderReply',
};

/// Descriptor for `OrderReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderReplyDescriptor = $convert.base64Decode('CgpPcmRlclJlcGx5');
@$core.Deprecated('Use setNodeInfoRequestDescriptor instead')
const SetNodeInfoRequest$json = const {
  '1': 'SetNodeInfoRequest',
  '2': const [
    const {'1': 'pubkey', '3': 1, '4': 1, '5': 12, '10': 'pubkey'},
    const {'1': 'key', '3': 2, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 3, '4': 1, '5': 12, '10': 'value'},
    const {'1': 'timestamp', '3': 4, '4': 1, '5': 3, '10': 'timestamp'},
    const {'1': 'signature', '3': 5, '4': 1, '5': 12, '10': 'signature'},
  ],
};

/// Descriptor for `SetNodeInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setNodeInfoRequestDescriptor = $convert.base64Decode('ChJTZXROb2RlSW5mb1JlcXVlc3QSFgoGcHVia2V5GAEgASgMUgZwdWJrZXkSEAoDa2V5GAIgASgJUgNrZXkSFAoFdmFsdWUYAyABKAxSBXZhbHVlEhwKCXRpbWVzdGFtcBgEIAEoA1IJdGltZXN0YW1wEhwKCXNpZ25hdHVyZRgFIAEoDFIJc2lnbmF0dXJl');
@$core.Deprecated('Use setNodeInfoResponseDescriptor instead')
const SetNodeInfoResponse$json = const {
  '1': 'SetNodeInfoResponse',
};

/// Descriptor for `SetNodeInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setNodeInfoResponseDescriptor = $convert.base64Decode('ChNTZXROb2RlSW5mb1Jlc3BvbnNl');
@$core.Deprecated('Use getNodeInfoRequestDescriptor instead')
const GetNodeInfoRequest$json = const {
  '1': 'GetNodeInfoRequest',
  '2': const [
    const {'1': 'pubkey', '3': 1, '4': 1, '5': 12, '10': 'pubkey'},
    const {'1': 'key', '3': 2, '4': 1, '5': 9, '10': 'key'},
  ],
};

/// Descriptor for `GetNodeInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNodeInfoRequestDescriptor = $convert.base64Decode('ChJHZXROb2RlSW5mb1JlcXVlc3QSFgoGcHVia2V5GAEgASgMUgZwdWJrZXkSEAoDa2V5GAIgASgJUgNrZXk=');
@$core.Deprecated('Use getNodeInfoResponseDescriptor instead')
const GetNodeInfoResponse$json = const {
  '1': 'GetNodeInfoResponse',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 12, '10': 'value'},
    const {'1': 'timestamp', '3': 2, '4': 1, '5': 3, '10': 'timestamp'},
    const {'1': 'signature', '3': 3, '4': 1, '5': 12, '10': 'signature'},
  ],
};

/// Descriptor for `GetNodeInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNodeInfoResponseDescriptor = $convert.base64Decode('ChNHZXROb2RlSW5mb1Jlc3BvbnNlEhQKBXZhbHVlGAEgASgMUgV2YWx1ZRIcCgl0aW1lc3RhbXAYAiABKANSCXRpbWVzdGFtcBIcCglzaWduYXR1cmUYAyABKAxSCXNpZ25hdHVyZQ==');
@$core.Deprecated('Use joinCTPSessionRequestDescriptor instead')
const JoinCTPSessionRequest$json = const {
  '1': 'JoinCTPSessionRequest',
  '2': const [
    const {'1': 'partyType', '3': 1, '4': 1, '5': 14, '6': '.breez.JoinCTPSessionRequest.PartyType', '10': 'partyType'},
    const {'1': 'partyName', '3': 2, '4': 1, '5': 9, '10': 'partyName'},
    const {'1': 'notificationToken', '3': 3, '4': 1, '5': 9, '10': 'notificationToken'},
    const {'1': 'sessionID', '3': 4, '4': 1, '5': 9, '10': 'sessionID'},
  ],
  '4': const [JoinCTPSessionRequest_PartyType$json],
};

@$core.Deprecated('Use joinCTPSessionRequestDescriptor instead')
const JoinCTPSessionRequest_PartyType$json = const {
  '1': 'PartyType',
  '2': const [
    const {'1': 'PAYER', '2': 0},
    const {'1': 'PAYEE', '2': 1},
  ],
};

/// Descriptor for `JoinCTPSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinCTPSessionRequestDescriptor = $convert.base64Decode('ChVKb2luQ1RQU2Vzc2lvblJlcXVlc3QSRAoJcGFydHlUeXBlGAEgASgOMiYuYnJlZXouSm9pbkNUUFNlc3Npb25SZXF1ZXN0LlBhcnR5VHlwZVIJcGFydHlUeXBlEhwKCXBhcnR5TmFtZRgCIAEoCVIJcGFydHlOYW1lEiwKEW5vdGlmaWNhdGlvblRva2VuGAMgASgJUhFub3RpZmljYXRpb25Ub2tlbhIcCglzZXNzaW9uSUQYBCABKAlSCXNlc3Npb25JRCIhCglQYXJ0eVR5cGUSCQoFUEFZRVIQABIJCgVQQVlFRRAB');
@$core.Deprecated('Use joinCTPSessionResponseDescriptor instead')
const JoinCTPSessionResponse$json = const {
  '1': 'JoinCTPSessionResponse',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'expiry', '3': 2, '4': 1, '5': 3, '10': 'expiry'},
  ],
};

/// Descriptor for `JoinCTPSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinCTPSessionResponseDescriptor = $convert.base64Decode('ChZKb2luQ1RQU2Vzc2lvblJlc3BvbnNlEhwKCXNlc3Npb25JRBgBIAEoCVIJc2Vzc2lvbklEEhYKBmV4cGlyeRgCIAEoA1IGZXhwaXJ5');
@$core.Deprecated('Use terminateCTPSessionRequestDescriptor instead')
const TerminateCTPSessionRequest$json = const {
  '1': 'TerminateCTPSessionRequest',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
  ],
};

/// Descriptor for `TerminateCTPSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List terminateCTPSessionRequestDescriptor = $convert.base64Decode('ChpUZXJtaW5hdGVDVFBTZXNzaW9uUmVxdWVzdBIcCglzZXNzaW9uSUQYASABKAlSCXNlc3Npb25JRA==');
@$core.Deprecated('Use terminateCTPSessionResponseDescriptor instead')
const TerminateCTPSessionResponse$json = const {
  '1': 'TerminateCTPSessionResponse',
};

/// Descriptor for `TerminateCTPSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List terminateCTPSessionResponseDescriptor = $convert.base64Decode('ChtUZXJtaW5hdGVDVFBTZXNzaW9uUmVzcG9uc2U=');
@$core.Deprecated('Use registerTransactionConfirmationRequestDescriptor instead')
const RegisterTransactionConfirmationRequest$json = const {
  '1': 'RegisterTransactionConfirmationRequest',
  '2': const [
    const {'1': 'txID', '3': 1, '4': 1, '5': 9, '10': 'txID'},
    const {'1': 'notificationToken', '3': 2, '4': 1, '5': 9, '10': 'notificationToken'},
    const {'1': 'notificationType', '3': 3, '4': 1, '5': 14, '6': '.breez.RegisterTransactionConfirmationRequest.NotificationType', '10': 'notificationType'},
  ],
  '4': const [RegisterTransactionConfirmationRequest_NotificationType$json],
};

@$core.Deprecated('Use registerTransactionConfirmationRequestDescriptor instead')
const RegisterTransactionConfirmationRequest_NotificationType$json = const {
  '1': 'NotificationType',
  '2': const [
    const {'1': 'READY_RECEIVE_PAYMENT', '2': 0},
    const {'1': 'CHANNEL_OPENED', '2': 1},
  ],
};

/// Descriptor for `RegisterTransactionConfirmationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerTransactionConfirmationRequestDescriptor = $convert.base64Decode('CiZSZWdpc3RlclRyYW5zYWN0aW9uQ29uZmlybWF0aW9uUmVxdWVzdBISCgR0eElEGAEgASgJUgR0eElEEiwKEW5vdGlmaWNhdGlvblRva2VuGAIgASgJUhFub3RpZmljYXRpb25Ub2tlbhJqChBub3RpZmljYXRpb25UeXBlGAMgASgOMj4uYnJlZXouUmVnaXN0ZXJUcmFuc2FjdGlvbkNvbmZpcm1hdGlvblJlcXVlc3QuTm90aWZpY2F0aW9uVHlwZVIQbm90aWZpY2F0aW9uVHlwZSJBChBOb3RpZmljYXRpb25UeXBlEhkKFVJFQURZX1JFQ0VJVkVfUEFZTUVOVBAAEhIKDkNIQU5ORUxfT1BFTkVEEAE=');
@$core.Deprecated('Use registerTransactionConfirmationResponseDescriptor instead')
const RegisterTransactionConfirmationResponse$json = const {
  '1': 'RegisterTransactionConfirmationResponse',
};

/// Descriptor for `RegisterTransactionConfirmationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerTransactionConfirmationResponseDescriptor = $convert.base64Decode('CidSZWdpc3RlclRyYW5zYWN0aW9uQ29uZmlybWF0aW9uUmVzcG9uc2U=');
@$core.Deprecated('Use registerPeriodicSyncRequestDescriptor instead')
const RegisterPeriodicSyncRequest$json = const {
  '1': 'RegisterPeriodicSyncRequest',
  '2': const [
    const {'1': 'notificationToken', '3': 1, '4': 1, '5': 9, '10': 'notificationToken'},
  ],
};

/// Descriptor for `RegisterPeriodicSyncRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerPeriodicSyncRequestDescriptor = $convert.base64Decode('ChtSZWdpc3RlclBlcmlvZGljU3luY1JlcXVlc3QSLAoRbm90aWZpY2F0aW9uVG9rZW4YASABKAlSEW5vdGlmaWNhdGlvblRva2Vu');
@$core.Deprecated('Use registerPeriodicSyncResponseDescriptor instead')
const RegisterPeriodicSyncResponse$json = const {
  '1': 'RegisterPeriodicSyncResponse',
};

/// Descriptor for `RegisterPeriodicSyncResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerPeriodicSyncResponseDescriptor = $convert.base64Decode('ChxSZWdpc3RlclBlcmlvZGljU3luY1Jlc3BvbnNl');
@$core.Deprecated('Use boltzReverseSwapLockupTxDescriptor instead')
const BoltzReverseSwapLockupTx$json = const {
  '1': 'BoltzReverseSwapLockupTx',
  '2': const [
    const {'1': 'boltz_id', '3': 1, '4': 1, '5': 9, '10': 'boltzId'},
    const {'1': 'timeout_block_height', '3': 2, '4': 1, '5': 13, '10': 'timeoutBlockHeight'},
  ],
};

/// Descriptor for `BoltzReverseSwapLockupTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List boltzReverseSwapLockupTxDescriptor = $convert.base64Decode('ChhCb2x0elJldmVyc2VTd2FwTG9ja3VwVHgSGQoIYm9sdHpfaWQYASABKAlSB2JvbHR6SWQSMAoUdGltZW91dF9ibG9ja19oZWlnaHQYAiABKA1SEnRpbWVvdXRCbG9ja0hlaWdodA==');
@$core.Deprecated('Use pushTxNotificationRequestDescriptor instead')
const PushTxNotificationRequest$json = const {
  '1': 'PushTxNotificationRequest',
  '2': const [
    const {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'body', '3': 3, '4': 1, '5': 9, '10': 'body'},
    const {'1': 'tx_hash', '3': 4, '4': 1, '5': 12, '10': 'txHash'},
    const {'1': 'script', '3': 5, '4': 1, '5': 12, '10': 'script'},
    const {'1': 'block_height_hint', '3': 6, '4': 1, '5': 13, '10': 'blockHeightHint'},
    const {'1': 'boltz_reverse_swap_lockup_tx_info', '3': 7, '4': 1, '5': 11, '6': '.breez.BoltzReverseSwapLockupTx', '9': 0, '10': 'boltzReverseSwapLockupTxInfo'},
  ],
  '8': const [
    const {'1': 'info'},
  ],
};

/// Descriptor for `PushTxNotificationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushTxNotificationRequestDescriptor = $convert.base64Decode('ChlQdXNoVHhOb3RpZmljYXRpb25SZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEhIKBGJvZHkYAyABKAlSBGJvZHkSFwoHdHhfaGFzaBgEIAEoDFIGdHhIYXNoEhYKBnNjcmlwdBgFIAEoDFIGc2NyaXB0EioKEWJsb2NrX2hlaWdodF9oaW50GAYgASgNUg9ibG9ja0hlaWdodEhpbnQSagohYm9sdHpfcmV2ZXJzZV9zd2FwX2xvY2t1cF90eF9pbmZvGAcgASgLMh8uYnJlZXouQm9sdHpSZXZlcnNlU3dhcExvY2t1cFR4SABSHGJvbHR6UmV2ZXJzZVN3YXBMb2NrdXBUeEluZm9CBgoEaW5mbw==');
@$core.Deprecated('Use pushTxNotificationResponseDescriptor instead')
const PushTxNotificationResponse$json = const {
  '1': 'PushTxNotificationResponse',
};

/// Descriptor for `PushTxNotificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushTxNotificationResponseDescriptor = $convert.base64Decode('ChpQdXNoVHhOb3RpZmljYXRpb25SZXNwb25zZQ==');
@$core.Deprecated('Use breezAppVersionsRequestDescriptor instead')
const BreezAppVersionsRequest$json = const {
  '1': 'BreezAppVersionsRequest',
};

/// Descriptor for `BreezAppVersionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List breezAppVersionsRequestDescriptor = $convert.base64Decode('ChdCcmVlekFwcFZlcnNpb25zUmVxdWVzdA==');
@$core.Deprecated('Use breezAppVersionsReplyDescriptor instead')
const BreezAppVersionsReply$json = const {
  '1': 'BreezAppVersionsReply',
  '2': const [
    const {'1': 'version', '3': 1, '4': 3, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `BreezAppVersionsReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List breezAppVersionsReplyDescriptor = $convert.base64Decode('ChVCcmVlekFwcFZlcnNpb25zUmVwbHkSGAoHdmVyc2lvbhgBIAMoCVIHdmVyc2lvbg==');
@$core.Deprecated('Use getReverseRoutingNodeRequestDescriptor instead')
const GetReverseRoutingNodeRequest$json = const {
  '1': 'GetReverseRoutingNodeRequest',
};

/// Descriptor for `GetReverseRoutingNodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReverseRoutingNodeRequestDescriptor = $convert.base64Decode('ChxHZXRSZXZlcnNlUm91dGluZ05vZGVSZXF1ZXN0');
@$core.Deprecated('Use getReverseRoutingNodeReplyDescriptor instead')
const GetReverseRoutingNodeReply$json = const {
  '1': 'GetReverseRoutingNodeReply',
  '2': const [
    const {'1': 'node_id', '3': 1, '4': 1, '5': 12, '10': 'nodeId'},
  ],
};

/// Descriptor for `GetReverseRoutingNodeReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReverseRoutingNodeReplyDescriptor = $convert.base64Decode('ChpHZXRSZXZlcnNlUm91dGluZ05vZGVSZXBseRIXCgdub2RlX2lkGAEgASgMUgZub2RlSWQ=');

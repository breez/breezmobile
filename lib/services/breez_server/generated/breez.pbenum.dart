///
//  Generated code. Do not modify.
//  source: breez.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class GetSwapPaymentReply_SwapError extends $pb.ProtobufEnum {
  static const GetSwapPaymentReply_SwapError NO_ERROR = GetSwapPaymentReply_SwapError._(0, 'NO_ERROR');
  static const GetSwapPaymentReply_SwapError FUNDS_EXCEED_LIMIT = GetSwapPaymentReply_SwapError._(1, 'FUNDS_EXCEED_LIMIT');
  static const GetSwapPaymentReply_SwapError TX_TOO_SMALL = GetSwapPaymentReply_SwapError._(2, 'TX_TOO_SMALL');
  static const GetSwapPaymentReply_SwapError INVOICE_AMOUNT_MISMATCH = GetSwapPaymentReply_SwapError._(3, 'INVOICE_AMOUNT_MISMATCH');
  static const GetSwapPaymentReply_SwapError SWAP_EXPIRED = GetSwapPaymentReply_SwapError._(4, 'SWAP_EXPIRED');

  static const $core.List<GetSwapPaymentReply_SwapError> values = <GetSwapPaymentReply_SwapError> [
    NO_ERROR,
    FUNDS_EXCEED_LIMIT,
    TX_TOO_SMALL,
    INVOICE_AMOUNT_MISMATCH,
    SWAP_EXPIRED,
  ];

  static final $core.Map<$core.int, GetSwapPaymentReply_SwapError> _byValue = $pb.ProtobufEnum.initByValue(values);
  static GetSwapPaymentReply_SwapError valueOf($core.int value) => _byValue[value];

  const GetSwapPaymentReply_SwapError._($core.int v, $core.String n) : super(v, n);
}

class JoinCTPSessionRequest_PartyType extends $pb.ProtobufEnum {
  static const JoinCTPSessionRequest_PartyType PAYER = JoinCTPSessionRequest_PartyType._(0, 'PAYER');
  static const JoinCTPSessionRequest_PartyType PAYEE = JoinCTPSessionRequest_PartyType._(1, 'PAYEE');

  static const $core.List<JoinCTPSessionRequest_PartyType> values = <JoinCTPSessionRequest_PartyType> [
    PAYER,
    PAYEE,
  ];

  static final $core.Map<$core.int, JoinCTPSessionRequest_PartyType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static JoinCTPSessionRequest_PartyType valueOf($core.int value) => _byValue[value];

  const JoinCTPSessionRequest_PartyType._($core.int v, $core.String n) : super(v, n);
}

class RegisterTransactionConfirmationRequest_NotificationType extends $pb.ProtobufEnum {
  static const RegisterTransactionConfirmationRequest_NotificationType READY_RECEIVE_PAYMENT = RegisterTransactionConfirmationRequest_NotificationType._(0, 'READY_RECEIVE_PAYMENT');
  static const RegisterTransactionConfirmationRequest_NotificationType CHANNEL_OPENED = RegisterTransactionConfirmationRequest_NotificationType._(1, 'CHANNEL_OPENED');

  static const $core.List<RegisterTransactionConfirmationRequest_NotificationType> values = <RegisterTransactionConfirmationRequest_NotificationType> [
    READY_RECEIVE_PAYMENT,
    CHANNEL_OPENED,
  ];

  static final $core.Map<$core.int, RegisterTransactionConfirmationRequest_NotificationType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RegisterTransactionConfirmationRequest_NotificationType valueOf($core.int value) => _byValue[value];

  const RegisterTransactionConfirmationRequest_NotificationType._($core.int v, $core.String n) : super(v, n);
}


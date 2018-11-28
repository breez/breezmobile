///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library breez_breez_pbenum;

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart';

class FundReply_ReturnCode extends ProtobufEnum {
  static const FundReply_ReturnCode SUCCESS = const FundReply_ReturnCode._(0, 'SUCCESS');
  static const FundReply_ReturnCode UNKNOWN_ERROR = const FundReply_ReturnCode._(-1, 'UNKNOWN_ERROR');
  static const FundReply_ReturnCode NODE_BUSY = const FundReply_ReturnCode._(-2, 'NODE_BUSY');
  static const FundReply_ReturnCode CLIENT_NOT_REGISTERED = const FundReply_ReturnCode._(-3, 'CLIENT_NOT_REGISTERED');
  static const FundReply_ReturnCode WRONG_NODE_ID = const FundReply_ReturnCode._(-4, 'WRONG_NODE_ID');
  static const FundReply_ReturnCode WRONG_AMOUNT = const FundReply_ReturnCode._(-5, 'WRONG_AMOUNT');

  static const List<FundReply_ReturnCode> values = const <FundReply_ReturnCode> [
    SUCCESS,
    UNKNOWN_ERROR,
    NODE_BUSY,
    CLIENT_NOT_REGISTERED,
    WRONG_NODE_ID,
    WRONG_AMOUNT,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static FundReply_ReturnCode valueOf(int value) => _byValue[value] as FundReply_ReturnCode;
  static void $checkItem(FundReply_ReturnCode v) {
    if (v is! FundReply_ReturnCode) checkItemFailed(v, 'FundReply_ReturnCode');
  }

  const FundReply_ReturnCode._(int v, String n) : super(v, n);
}

class JoinCTPSessionRequest_PartyType extends ProtobufEnum {
  static const JoinCTPSessionRequest_PartyType PAYER = const JoinCTPSessionRequest_PartyType._(0, 'PAYER');
  static const JoinCTPSessionRequest_PartyType PAYEE = const JoinCTPSessionRequest_PartyType._(1, 'PAYEE');

  static const List<JoinCTPSessionRequest_PartyType> values = const <JoinCTPSessionRequest_PartyType> [
    PAYER,
    PAYEE,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static JoinCTPSessionRequest_PartyType valueOf(int value) => _byValue[value] as JoinCTPSessionRequest_PartyType;
  static void $checkItem(JoinCTPSessionRequest_PartyType v) {
    if (v is! JoinCTPSessionRequest_PartyType) checkItemFailed(v, 'JoinCTPSessionRequest_PartyType');
  }

  const JoinCTPSessionRequest_PartyType._(int v, String n) : super(v, n);
}

class RegisterTransactionConfirmationRequest_NotificationType extends ProtobufEnum {
  static const RegisterTransactionConfirmationRequest_NotificationType READY_RECEIVE_PAYMENT = const RegisterTransactionConfirmationRequest_NotificationType._(0, 'READY_RECEIVE_PAYMENT');

  static const List<RegisterTransactionConfirmationRequest_NotificationType> values = const <RegisterTransactionConfirmationRequest_NotificationType> [
    READY_RECEIVE_PAYMENT,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static RegisterTransactionConfirmationRequest_NotificationType valueOf(int value) => _byValue[value] as RegisterTransactionConfirmationRequest_NotificationType;
  static void $checkItem(RegisterTransactionConfirmationRequest_NotificationType v) {
    if (v is! RegisterTransactionConfirmationRequest_NotificationType) checkItemFailed(v, 'RegisterTransactionConfirmationRequest_NotificationType');
  }

  const RegisterTransactionConfirmationRequest_NotificationType._(int v, String n) : super(v, n);
}


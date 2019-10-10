///
//  Generated code. Do not modify.
//  source: breez.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;

import 'package:protobuf/protobuf.dart' as $pb;

class JoinCTPSessionRequest_PartyType extends $pb.ProtobufEnum {
  static const JoinCTPSessionRequest_PartyType PAYER = const JoinCTPSessionRequest_PartyType._(0, 'PAYER');
  static const JoinCTPSessionRequest_PartyType PAYEE = const JoinCTPSessionRequest_PartyType._(1, 'PAYEE');

  static const List<JoinCTPSessionRequest_PartyType> values = const <JoinCTPSessionRequest_PartyType> [
    PAYER,
    PAYEE,
  ];

  static final Map<int, JoinCTPSessionRequest_PartyType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static JoinCTPSessionRequest_PartyType valueOf(int value) => _byValue[value];

  const JoinCTPSessionRequest_PartyType._(int v, String n) : super(v, n);
}

class RegisterTransactionConfirmationRequest_NotificationType extends $pb.ProtobufEnum {
  static const RegisterTransactionConfirmationRequest_NotificationType READY_RECEIVE_PAYMENT = const RegisterTransactionConfirmationRequest_NotificationType._(0, 'READY_RECEIVE_PAYMENT');
  static const RegisterTransactionConfirmationRequest_NotificationType CHANNEL_OPENED = const RegisterTransactionConfirmationRequest_NotificationType._(1, 'CHANNEL_OPENED');

  static const List<RegisterTransactionConfirmationRequest_NotificationType> values = const <RegisterTransactionConfirmationRequest_NotificationType> [
    READY_RECEIVE_PAYMENT,
    CHANNEL_OPENED,
  ];

  static final Map<int, RegisterTransactionConfirmationRequest_NotificationType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RegisterTransactionConfirmationRequest_NotificationType valueOf(int value) => _byValue[value];

  const RegisterTransactionConfirmationRequest_NotificationType._(int v, String n) : super(v, n);
}


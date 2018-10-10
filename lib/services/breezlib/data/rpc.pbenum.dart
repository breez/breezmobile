///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library data_rpc_pbenum;

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart';

class Account_AccountStatus extends ProtobufEnum {
  static const Account_AccountStatus WAITING_DEPOSIT = const Account_AccountStatus._(0, 'WAITING_DEPOSIT');
  static const Account_AccountStatus WAITING_DEPOSIT_CONFIRMATION = const Account_AccountStatus._(1, 'WAITING_DEPOSIT_CONFIRMATION');
  static const Account_AccountStatus PROCESSING_BREEZ_CONNECTION = const Account_AccountStatus._(2, 'PROCESSING_BREEZ_CONNECTION');
  static const Account_AccountStatus PROCESSING_WITHDRAWAL = const Account_AccountStatus._(3, 'PROCESSING_WITHDRAWAL');
  static const Account_AccountStatus ACTIVE = const Account_AccountStatus._(4, 'ACTIVE');

  static const List<Account_AccountStatus> values = const <Account_AccountStatus> [
    WAITING_DEPOSIT,
    WAITING_DEPOSIT_CONFIRMATION,
    PROCESSING_BREEZ_CONNECTION,
    PROCESSING_WITHDRAWAL,
    ACTIVE,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static Account_AccountStatus valueOf(int value) => _byValue[value] as Account_AccountStatus;
  static void $checkItem(Account_AccountStatus v) {
    if (v is! Account_AccountStatus) checkItemFailed(v, 'Account_AccountStatus');
  }

  const Account_AccountStatus._(int v, String n) : super(v, n);
}

class Payment_PaymentType extends ProtobufEnum {
  static const Payment_PaymentType DEPOSIT = const Payment_PaymentType._(0, 'DEPOSIT');
  static const Payment_PaymentType WITHDRAWAL = const Payment_PaymentType._(1, 'WITHDRAWAL');
  static const Payment_PaymentType SENT = const Payment_PaymentType._(2, 'SENT');
  static const Payment_PaymentType RECEIVED = const Payment_PaymentType._(3, 'RECEIVED');

  static const List<Payment_PaymentType> values = const <Payment_PaymentType> [
    DEPOSIT,
    WITHDRAWAL,
    SENT,
    RECEIVED,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static Payment_PaymentType valueOf(int value) => _byValue[value] as Payment_PaymentType;
  static void $checkItem(Payment_PaymentType v) {
    if (v is! Payment_PaymentType) checkItemFailed(v, 'Payment_PaymentType');
  }

  const Payment_PaymentType._(int v, String n) : super(v, n);
}

class NotificationEvent_NotificationType extends ProtobufEnum {
  static const NotificationEvent_NotificationType READY = const NotificationEvent_NotificationType._(0, 'READY');
  static const NotificationEvent_NotificationType INITIALIZATION_FAILED = const NotificationEvent_NotificationType._(1, 'INITIALIZATION_FAILED');
  static const NotificationEvent_NotificationType ACCOUNT_CHANGED = const NotificationEvent_NotificationType._(2, 'ACCOUNT_CHANGED');
  static const NotificationEvent_NotificationType INVOICE_PAID = const NotificationEvent_NotificationType._(3, 'INVOICE_PAID');
  static const NotificationEvent_NotificationType ROUTING_NODE_CONNECTION_CHANGED = const NotificationEvent_NotificationType._(4, 'ROUTING_NODE_CONNECTION_CHANGED');

  static const List<NotificationEvent_NotificationType> values = const <NotificationEvent_NotificationType> [
    READY,
    INITIALIZATION_FAILED,
    ACCOUNT_CHANGED,
    INVOICE_PAID,
    ROUTING_NODE_CONNECTION_CHANGED,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static NotificationEvent_NotificationType valueOf(int value) => _byValue[value] as NotificationEvent_NotificationType;
  static void $checkItem(NotificationEvent_NotificationType v) {
    if (v is! NotificationEvent_NotificationType) checkItemFailed(v, 'NotificationEvent_NotificationType');
  }

  const NotificationEvent_NotificationType._(int v, String n) : super(v, n);
}

class FundStatusReply_FundStatus extends ProtobufEnum {
  static const FundStatusReply_FundStatus NO_FUND = const FundStatusReply_FundStatus._(0, 'NO_FUND');
  static const FundStatusReply_FundStatus WAITING_CONFIRMATION = const FundStatusReply_FundStatus._(1, 'WAITING_CONFIRMATION');
  static const FundStatusReply_FundStatus CONFIRMED = const FundStatusReply_FundStatus._(2, 'CONFIRMED');

  static const List<FundStatusReply_FundStatus> values = const <FundStatusReply_FundStatus> [
    NO_FUND,
    WAITING_CONFIRMATION,
    CONFIRMED,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static FundStatusReply_FundStatus valueOf(int value) => _byValue[value] as FundStatusReply_FundStatus;
  static void $checkItem(FundStatusReply_FundStatus v) {
    if (v is! FundStatusReply_FundStatus) checkItemFailed(v, 'FundStatusReply_FundStatus');
  }

  const FundStatusReply_FundStatus._(int v, String n) : super(v, n);
}


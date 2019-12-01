///
//  Generated code. Do not modify.
//  source: rpc.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class SwapError extends $pb.ProtobufEnum {
  static const SwapError NO_ERROR = SwapError._(0, 'NO_ERROR');
  static const SwapError FUNDS_EXCEED_LIMIT = SwapError._(1, 'FUNDS_EXCEED_LIMIT');
  static const SwapError TX_TOO_SMALL = SwapError._(2, 'TX_TOO_SMALL');
  static const SwapError INVOICE_AMOUNT_MISMATCH = SwapError._(3, 'INVOICE_AMOUNT_MISMATCH');
  static const SwapError SWAP_EXPIRED = SwapError._(4, 'SWAP_EXPIRED');

  static const $core.List<SwapError> values = <SwapError> [
    NO_ERROR,
    FUNDS_EXCEED_LIMIT,
    TX_TOO_SMALL,
    INVOICE_AMOUNT_MISMATCH,
    SWAP_EXPIRED,
  ];

  static final $core.Map<$core.int, SwapError> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SwapError valueOf($core.int value) => _byValue[value];

  const SwapError._($core.int v, $core.String n) : super(v, n);
}

class Account_AccountStatus extends $pb.ProtobufEnum {
  static const Account_AccountStatus DISCONNECTED = Account_AccountStatus._(0, 'DISCONNECTED');
  static const Account_AccountStatus PROCESSING_CONNECTION = Account_AccountStatus._(1, 'PROCESSING_CONNECTION');
  static const Account_AccountStatus CLOSING_CONNECTION = Account_AccountStatus._(2, 'CLOSING_CONNECTION');
  static const Account_AccountStatus CONNECTED = Account_AccountStatus._(3, 'CONNECTED');

  static const $core.List<Account_AccountStatus> values = <Account_AccountStatus> [
    DISCONNECTED,
    PROCESSING_CONNECTION,
    CLOSING_CONNECTION,
    CONNECTED,
  ];

  static final $core.Map<$core.int, Account_AccountStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Account_AccountStatus valueOf($core.int value) => _byValue[value];

  const Account_AccountStatus._($core.int v, $core.String n) : super(v, n);
}

class Payment_PaymentType extends $pb.ProtobufEnum {
  static const Payment_PaymentType DEPOSIT = Payment_PaymentType._(0, 'DEPOSIT');
  static const Payment_PaymentType WITHDRAWAL = Payment_PaymentType._(1, 'WITHDRAWAL');
  static const Payment_PaymentType SENT = Payment_PaymentType._(2, 'SENT');
  static const Payment_PaymentType RECEIVED = Payment_PaymentType._(3, 'RECEIVED');

  static const $core.List<Payment_PaymentType> values = <Payment_PaymentType> [
    DEPOSIT,
    WITHDRAWAL,
    SENT,
    RECEIVED,
  ];

  static final $core.Map<$core.int, Payment_PaymentType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Payment_PaymentType valueOf($core.int value) => _byValue[value];

  const Payment_PaymentType._($core.int v, $core.String n) : super(v, n);
}

class NotificationEvent_NotificationType extends $pb.ProtobufEnum {
  static const NotificationEvent_NotificationType READY = NotificationEvent_NotificationType._(0, 'READY');
  static const NotificationEvent_NotificationType INITIALIZATION_FAILED = NotificationEvent_NotificationType._(1, 'INITIALIZATION_FAILED');
  static const NotificationEvent_NotificationType ACCOUNT_CHANGED = NotificationEvent_NotificationType._(2, 'ACCOUNT_CHANGED');
  static const NotificationEvent_NotificationType PAYMENT_SENT = NotificationEvent_NotificationType._(3, 'PAYMENT_SENT');
  static const NotificationEvent_NotificationType INVOICE_PAID = NotificationEvent_NotificationType._(4, 'INVOICE_PAID');
  static const NotificationEvent_NotificationType LIGHTNING_SERVICE_DOWN = NotificationEvent_NotificationType._(5, 'LIGHTNING_SERVICE_DOWN');
  static const NotificationEvent_NotificationType FUND_ADDRESS_CREATED = NotificationEvent_NotificationType._(6, 'FUND_ADDRESS_CREATED');
  static const NotificationEvent_NotificationType FUND_ADDRESS_UNSPENT_CHANGED = NotificationEvent_NotificationType._(7, 'FUND_ADDRESS_UNSPENT_CHANGED');
  static const NotificationEvent_NotificationType BACKUP_SUCCESS = NotificationEvent_NotificationType._(8, 'BACKUP_SUCCESS');
  static const NotificationEvent_NotificationType BACKUP_FAILED = NotificationEvent_NotificationType._(9, 'BACKUP_FAILED');
  static const NotificationEvent_NotificationType BACKUP_AUTH_FAILED = NotificationEvent_NotificationType._(10, 'BACKUP_AUTH_FAILED');
  static const NotificationEvent_NotificationType BACKUP_NODE_CONFLICT = NotificationEvent_NotificationType._(11, 'BACKUP_NODE_CONFLICT');
  static const NotificationEvent_NotificationType BACKUP_REQUEST = NotificationEvent_NotificationType._(12, 'BACKUP_REQUEST');

  static const $core.List<NotificationEvent_NotificationType> values = <NotificationEvent_NotificationType> [
    READY,
    INITIALIZATION_FAILED,
    ACCOUNT_CHANGED,
    PAYMENT_SENT,
    INVOICE_PAID,
    LIGHTNING_SERVICE_DOWN,
    FUND_ADDRESS_CREATED,
    FUND_ADDRESS_UNSPENT_CHANGED,
    BACKUP_SUCCESS,
    BACKUP_FAILED,
    BACKUP_AUTH_FAILED,
    BACKUP_NODE_CONFLICT,
    BACKUP_REQUEST,
  ];

  static final $core.Map<$core.int, NotificationEvent_NotificationType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static NotificationEvent_NotificationType valueOf($core.int value) => _byValue[value];

  const NotificationEvent_NotificationType._($core.int v, $core.String n) : super(v, n);
}


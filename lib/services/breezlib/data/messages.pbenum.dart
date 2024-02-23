//
//  Generated code. Do not modify.
//  source: messages.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SwapError extends $pb.ProtobufEnum {
  static const SwapError NO_ERROR = SwapError._(0, _omitEnumNames ? '' : 'NO_ERROR');
  static const SwapError FUNDS_EXCEED_LIMIT = SwapError._(1, _omitEnumNames ? '' : 'FUNDS_EXCEED_LIMIT');
  static const SwapError TX_TOO_SMALL = SwapError._(2, _omitEnumNames ? '' : 'TX_TOO_SMALL');
  static const SwapError INVOICE_AMOUNT_MISMATCH = SwapError._(3, _omitEnumNames ? '' : 'INVOICE_AMOUNT_MISMATCH');
  static const SwapError SWAP_EXPIRED = SwapError._(4, _omitEnumNames ? '' : 'SWAP_EXPIRED');

  static const $core.List<SwapError> values = <SwapError> [
    NO_ERROR,
    FUNDS_EXCEED_LIMIT,
    TX_TOO_SMALL,
    INVOICE_AMOUNT_MISMATCH,
    SWAP_EXPIRED,
  ];

  static final $core.Map<$core.int, SwapError> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SwapError? valueOf($core.int value) => _byValue[value];

  const SwapError._($core.int v, $core.String n) : super(v, n);
}

class Account_AccountStatus extends $pb.ProtobufEnum {
  static const Account_AccountStatus DISCONNECTED = Account_AccountStatus._(0, _omitEnumNames ? '' : 'DISCONNECTED');
  static const Account_AccountStatus PROCESSING_CONNECTION = Account_AccountStatus._(1, _omitEnumNames ? '' : 'PROCESSING_CONNECTION');
  static const Account_AccountStatus CLOSING_CONNECTION = Account_AccountStatus._(2, _omitEnumNames ? '' : 'CLOSING_CONNECTION');
  static const Account_AccountStatus CONNECTED = Account_AccountStatus._(3, _omitEnumNames ? '' : 'CONNECTED');

  static const $core.List<Account_AccountStatus> values = <Account_AccountStatus> [
    DISCONNECTED,
    PROCESSING_CONNECTION,
    CLOSING_CONNECTION,
    CONNECTED,
  ];

  static final $core.Map<$core.int, Account_AccountStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Account_AccountStatus? valueOf($core.int value) => _byValue[value];

  const Account_AccountStatus._($core.int v, $core.String n) : super(v, n);
}

class Payment_PaymentType extends $pb.ProtobufEnum {
  static const Payment_PaymentType DEPOSIT = Payment_PaymentType._(0, _omitEnumNames ? '' : 'DEPOSIT');
  static const Payment_PaymentType WITHDRAWAL = Payment_PaymentType._(1, _omitEnumNames ? '' : 'WITHDRAWAL');
  static const Payment_PaymentType SENT = Payment_PaymentType._(2, _omitEnumNames ? '' : 'SENT');
  static const Payment_PaymentType RECEIVED = Payment_PaymentType._(3, _omitEnumNames ? '' : 'RECEIVED');
  static const Payment_PaymentType CLOSED_CHANNEL = Payment_PaymentType._(4, _omitEnumNames ? '' : 'CLOSED_CHANNEL');

  static const $core.List<Payment_PaymentType> values = <Payment_PaymentType> [
    DEPOSIT,
    WITHDRAWAL,
    SENT,
    RECEIVED,
    CLOSED_CHANNEL,
  ];

  static final $core.Map<$core.int, Payment_PaymentType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Payment_PaymentType? valueOf($core.int value) => _byValue[value];

  const Payment_PaymentType._($core.int v, $core.String n) : super(v, n);
}

class NotificationEvent_NotificationType extends $pb.ProtobufEnum {
  static const NotificationEvent_NotificationType READY = NotificationEvent_NotificationType._(0, _omitEnumNames ? '' : 'READY');
  static const NotificationEvent_NotificationType INITIALIZATION_FAILED = NotificationEvent_NotificationType._(1, _omitEnumNames ? '' : 'INITIALIZATION_FAILED');
  static const NotificationEvent_NotificationType ACCOUNT_CHANGED = NotificationEvent_NotificationType._(2, _omitEnumNames ? '' : 'ACCOUNT_CHANGED');
  static const NotificationEvent_NotificationType PAYMENT_SENT = NotificationEvent_NotificationType._(3, _omitEnumNames ? '' : 'PAYMENT_SENT');
  static const NotificationEvent_NotificationType INVOICE_PAID = NotificationEvent_NotificationType._(4, _omitEnumNames ? '' : 'INVOICE_PAID');
  static const NotificationEvent_NotificationType LIGHTNING_SERVICE_DOWN = NotificationEvent_NotificationType._(5, _omitEnumNames ? '' : 'LIGHTNING_SERVICE_DOWN');
  static const NotificationEvent_NotificationType FUND_ADDRESS_CREATED = NotificationEvent_NotificationType._(6, _omitEnumNames ? '' : 'FUND_ADDRESS_CREATED');
  static const NotificationEvent_NotificationType FUND_ADDRESS_UNSPENT_CHANGED = NotificationEvent_NotificationType._(7, _omitEnumNames ? '' : 'FUND_ADDRESS_UNSPENT_CHANGED');
  static const NotificationEvent_NotificationType BACKUP_SUCCESS = NotificationEvent_NotificationType._(8, _omitEnumNames ? '' : 'BACKUP_SUCCESS');
  static const NotificationEvent_NotificationType BACKUP_FAILED = NotificationEvent_NotificationType._(9, _omitEnumNames ? '' : 'BACKUP_FAILED');
  static const NotificationEvent_NotificationType BACKUP_AUTH_FAILED = NotificationEvent_NotificationType._(10, _omitEnumNames ? '' : 'BACKUP_AUTH_FAILED');
  static const NotificationEvent_NotificationType BACKUP_NODE_CONFLICT = NotificationEvent_NotificationType._(11, _omitEnumNames ? '' : 'BACKUP_NODE_CONFLICT');
  static const NotificationEvent_NotificationType BACKUP_REQUEST = NotificationEvent_NotificationType._(12, _omitEnumNames ? '' : 'BACKUP_REQUEST');
  static const NotificationEvent_NotificationType PAYMENT_FAILED = NotificationEvent_NotificationType._(13, _omitEnumNames ? '' : 'PAYMENT_FAILED');
  static const NotificationEvent_NotificationType PAYMENT_SUCCEEDED = NotificationEvent_NotificationType._(14, _omitEnumNames ? '' : 'PAYMENT_SUCCEEDED');
  static const NotificationEvent_NotificationType REVERSE_SWAP_CLAIM_STARTED = NotificationEvent_NotificationType._(15, _omitEnumNames ? '' : 'REVERSE_SWAP_CLAIM_STARTED');
  static const NotificationEvent_NotificationType REVERSE_SWAP_CLAIM_SUCCEEDED = NotificationEvent_NotificationType._(16, _omitEnumNames ? '' : 'REVERSE_SWAP_CLAIM_SUCCEEDED');
  static const NotificationEvent_NotificationType REVERSE_SWAP_CLAIM_FAILED = NotificationEvent_NotificationType._(17, _omitEnumNames ? '' : 'REVERSE_SWAP_CLAIM_FAILED');
  static const NotificationEvent_NotificationType REVERSE_SWAP_CLAIM_CONFIRMED = NotificationEvent_NotificationType._(18, _omitEnumNames ? '' : 'REVERSE_SWAP_CLAIM_CONFIRMED');
  static const NotificationEvent_NotificationType LSP_CHANNEL_OPENED = NotificationEvent_NotificationType._(19, _omitEnumNames ? '' : 'LSP_CHANNEL_OPENED');
  static const NotificationEvent_NotificationType BACKUP_NOT_LATEST_CONFLICT = NotificationEvent_NotificationType._(20, _omitEnumNames ? '' : 'BACKUP_NOT_LATEST_CONFLICT');

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
    PAYMENT_FAILED,
    PAYMENT_SUCCEEDED,
    REVERSE_SWAP_CLAIM_STARTED,
    REVERSE_SWAP_CLAIM_SUCCEEDED,
    REVERSE_SWAP_CLAIM_FAILED,
    REVERSE_SWAP_CLAIM_CONFIRMED,
    LSP_CHANNEL_OPENED,
    BACKUP_NOT_LATEST_CONFLICT,
  ];

  static final $core.Map<$core.int, NotificationEvent_NotificationType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static NotificationEvent_NotificationType? valueOf($core.int value) => _byValue[value];

  const NotificationEvent_NotificationType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');

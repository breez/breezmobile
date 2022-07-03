import 'package:fixnum/fixnum.dart';

abstract class NfcWithdrawInvoiceStatus {
  const NfcWithdrawInvoiceStatus();

  factory NfcWithdrawInvoiceStatus.started() =>
      const NfcWithdrawInvoiceStatusStarted();

  factory NfcWithdrawInvoiceStatus.completed() =>
      const NfcWithdrawInvoiceStatusCompleted();

  factory NfcWithdrawInvoiceStatus.rangeError(Int64 min, Int64 max) =>
      NfcWithdrawInvoiceStatusRangeError(min, max);

  factory NfcWithdrawInvoiceStatus.error(String message) =>
      NfcWithdrawInvoiceStatusError(message);
}

class NfcWithdrawInvoiceStatusStarted extends NfcWithdrawInvoiceStatus {
  const NfcWithdrawInvoiceStatusStarted();
}

class NfcWithdrawInvoiceStatusCompleted extends NfcWithdrawInvoiceStatus {
  const NfcWithdrawInvoiceStatusCompleted();
}

class NfcWithdrawInvoiceStatusRangeError extends NfcWithdrawInvoiceStatus {
  final Int64 minAmount;
  final Int64 maxAmount;

  const NfcWithdrawInvoiceStatusRangeError(
    this.minAmount,
    this.maxAmount,
  );
}

class NfcWithdrawInvoiceStatusTimeoutError extends NfcWithdrawInvoiceStatus {
  const NfcWithdrawInvoiceStatusTimeoutError();
}

class NfcWithdrawInvoiceStatusError extends NfcWithdrawInvoiceStatus {
  final String message;

  const NfcWithdrawInvoiceStatusError(
    this.message,
  );
}

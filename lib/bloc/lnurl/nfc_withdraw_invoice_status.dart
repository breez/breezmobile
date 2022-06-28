import 'package:fixnum/fixnum.dart';

abstract class NfcWithdrawInvoiceStatus {
  const NfcWithdrawInvoiceStatus();

  factory NfcWithdrawInvoiceStatus.started() =>
      const NfcWithdrawInvoiceStatusStarted();

  factory NfcWithdrawInvoiceStatus.completed(String paymentHash) =>
      NfcWithdrawInvoiceStatusCompleted(paymentHash);

  factory NfcWithdrawInvoiceStatus.rangeError(Int64 min, Int64 max) =>
      NfcWithdrawInvoiceStatusRangeError(min, max);

  factory NfcWithdrawInvoiceStatus.timeoutError() =>
      const NfcWithdrawInvoiceStatusTimeoutError();

  factory NfcWithdrawInvoiceStatus.error(String message) =>
      NfcWithdrawInvoiceStatusError(message);
}

class NfcWithdrawInvoiceStatusStarted extends NfcWithdrawInvoiceStatus {
  const NfcWithdrawInvoiceStatusStarted();
}

class NfcWithdrawInvoiceStatusCompleted extends NfcWithdrawInvoiceStatus {
  final String paymentHash;

  const NfcWithdrawInvoiceStatusCompleted(
    this.paymentHash,
  );
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

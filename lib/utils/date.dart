import 'dart:io' show Platform;
import "package:intl/intl.dart";
import 'package:fixnum/fixnum.dart';

class DateUtils {
  static final DateFormat _monthDateFormat = new DateFormat.Md(Platform.localeName);
  static final DateFormat _yearMonthDayFormat = new DateFormat.yMd(Platform.localeName);
  static final DateFormat _transactionDateFormat = new DateFormat.yMd(Platform.localeName).add_jm();

  static String formatMonthDate(DateTime d) => _monthDateFormat.format(d);
  static String formatYearMonthDay(DateTime d) => _yearMonthDayFormat.format(d);
  static String formatPosTransactionDate(Int64 t) =>
      _transactionDateFormat.format(new DateTime.fromMillisecondsSinceEpoch(t.toInt() * 1000));
  static String formatTransactionDate(Int64 t) =>
      _monthDateFormat.format(DateTime.fromMillisecondsSinceEpoch(t.toInt() * 1000));
  static String formatFilterDateRange(DateTime startDate, DateTime endDate) {
    var formatter = (startDate.year != endDate.year) ? _monthDateFormat : _yearMonthDayFormat;
    return formatter.format(startDate) + "-" + formatter.format(endDate);
  }
}

import 'dart:io' show Platform;
import "package:intl/intl.dart";

class DateUtils {
  static final DateFormat _monthDateFormat = new DateFormat.Md(Platform.localeName);
  static final DateFormat _yearMonthDayFormat = new DateFormat.yMd(Platform.localeName);
  static final DateFormat _yearMonthDayHourMinuteFormat = new DateFormat.yMd(Platform.localeName).add_jm();

  static String formatMonthDate(DateTime d) => _monthDateFormat.format(d);
  static String formatYearMonthDay(DateTime d) => _yearMonthDayFormat.format(d);
  static String formatYearMonthDayHourMinute(DateTime d) => _yearMonthDayHourMinuteFormat.format(d);
  static String formatFilterDateRange(DateTime startDate, DateTime endDate) {
    var formatter = (startDate.year != endDate.year) ? _monthDateFormat : _yearMonthDayFormat;
    return formatter.format(startDate) + "-" + formatter.format(endDate);
  }
}

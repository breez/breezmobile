import 'dart:io' show Platform;
import "package:intl/intl.dart";

class DateUtils {
  static final DateFormat _monthDateFormat = new DateFormat.MMMd(Platform.localeName);
  static final DateFormat _yearMonthDayFormat = new DateFormat.yMd(Platform.localeName);

  static String formatMonthDate(DateTime d) => _monthDateFormat.format(d);
  static String formatYearMonthDay(DateTime d) => _yearMonthDayFormat.format(d);
}

import 'dart:io' show Platform;

import 'package:breez/l10n/fi_messages.dart';
import 'package:breez/utils/locale.dart';
import "package:intl/intl.dart";
import 'package:timeago/timeago.dart' as timeago;

class BreezDateUtils {
  static final DateFormat _monthDateFormat = DateFormat.Md(Platform.localeName);
  static final DateFormat _yearMonthDayFormat =
      DateFormat.yMd(Platform.localeName);
  static final DateFormat _yearMonthDayHourMinuteFormat =
      DateFormat.yMd(Platform.localeName).add_jm();
  static final DateFormat _yearMonthDayHourMinuteSecondFormat =
      DateFormat.yMd(Platform.localeName).add_Hms();
  static final DateFormat _hourMinuteDayFormat =
      DateFormat.jm(Platform.localeName);

  static String formatMonthDate(DateTime d) => _monthDateFormat.format(d);
  static String formatYearMonthDay(DateTime d) => _yearMonthDayFormat.format(d);
  static String formatYearMonthDayHourMinute(DateTime d) =>
      _yearMonthDayHourMinuteFormat.format(d);
  static String formatYearMonthDayHourMinuteSecond(DateTime d) =>
      _yearMonthDayHourMinuteSecondFormat.format(d);

  static String formatTimelineRelative(DateTime d) {
    if (DateTime.now().subtract(Duration(days: 4)).isBefore(d)) {
      return timeago.format(d, locale: getSystemLocale().languageCode);
    } else {
      return formatYearMonthDay(d);
    }
  }

  static String formatHourMinute(DateTime d) => _hourMinuteDayFormat.format(d);

  static String formatFilterDateRange(DateTime startDate, DateTime endDate) {
    var formatter = (startDate.year == endDate.year)
        ? _monthDateFormat
        : _yearMonthDayFormat;
    return formatter.format(startDate) + "-" + formatter.format(endDate);
  }

  static void setupLocales() {
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('es', timeago.EsMessages());
    timeago.setLocaleMessages('fi', FiMessages());
    timeago.setLocaleMessages('pt', timeago.PtBrMessages());
  }
}

import 'package:breez/utils/date.dart';
import 'package:flutter_test/flutter_test.dart';

DateTime firstDay() => DateTime(2021, 1, 1, 0, 0, 0);

DateTime lastDay() => DateTime(2021, 12, 31, 23, 59, 59);

void main() {
  group('formatMonthDate', () {
    test('31 of december of 2021', () {
      expect(
        BreezDateUtils.formatMonthDate(lastDay()),
        '12/31',
      );
    });

    test('1 of january of 2021', () {
      expect(
        BreezDateUtils.formatMonthDate(firstDay()),
        '1/1',
      );
    });
  });

  group('formatYearMonthDay', () {
    test('31 of december of 2021', () {
      expect(
        BreezDateUtils.formatYearMonthDay(lastDay()),
        '12/31/2021',
      );
    });

    test('1 of january of 2021', () {
      expect(
        BreezDateUtils.formatYearMonthDay(firstDay()),
        '1/1/2021',
      );
    });
  });

  group('formatYearMonthDayHourMinute', () {
    test('31 of december of 2021', () {
      expect(
        BreezDateUtils.formatYearMonthDayHourMinute(lastDay()),
        '12/31/2021 11:59 PM',
      );
    });

    test('1 of january of 2021', () {
      expect(
        BreezDateUtils.formatYearMonthDayHourMinute(firstDay()),
        '1/1/2021 12:00 AM',
      );
    });
  });

  group('formatYearMonthDayHourMinuteSecond', () {
    test('31 of december of 2021', () {
      expect(
        BreezDateUtils.formatYearMonthDayHourMinuteSecond(lastDay()),
        '12/31/2021 23:59:59',
      );
    });

    test('1 of january of 2021', () {
      expect(
        BreezDateUtils.formatYearMonthDayHourMinuteSecond(firstDay()),
        '1/1/2021 00:00:00',
      );
    });
  });

  group('formatTimelineRelative', () {
    test('right now should return a moment ago', () {
      expect(
        BreezDateUtils.formatTimelineRelative(DateTime.now()),
        'a moment ago',
      );
    });

    test('one second ago should return a moment ago', () {
      expect(
        BreezDateUtils.formatTimelineRelative(
          DateTime.now().subtract(Duration(seconds: 1)),
        ),
        'a moment ago',
      );
    });

    test('one second ago should return a moment ago', () {
      expect(
        BreezDateUtils.formatTimelineRelative(
          DateTime.now().subtract(Duration(seconds: 1)),
        ),
        'a moment ago',
      );
    });

    test('one minute ago should return a minute ago', () {
      expect(
        BreezDateUtils.formatTimelineRelative(
          DateTime.now().subtract(Duration(minutes: 1)),
        ),
        'a minute ago',
      );
    });

    test('one hour ago should return about an hour ago', () {
      expect(
        BreezDateUtils.formatTimelineRelative(
          DateTime.now().subtract(Duration(hours: 1)),
        ),
        'about an hour ago',
      );
    });

    test('one day ago should return a day ago', () {
      expect(
        BreezDateUtils.formatTimelineRelative(
          DateTime.now().subtract(Duration(days: 1)),
        ),
        'a day ago',
      );
    });

    test('three days ago should return 3 days ago', () {
      expect(
        BreezDateUtils.formatTimelineRelative(
          DateTime.now().subtract(Duration(days: 3)),
        ),
        '3 days ago',
      );
    });

    test('more than 3 days ago should return full date', () {
      expect(
        BreezDateUtils.formatTimelineRelative(
          firstDay(),
        ),
        '1/1/2021',
      );
    });
  });
}

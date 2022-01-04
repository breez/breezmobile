import 'package:duration/locale.dart';

// TODO update duration lib when it adds finnish, current there is no "fi" finnish locale on the lib
class FinnishDurationLocale implements DurationLocale {
  const FinnishDurationLocale();

  @override
  String year(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'y';
    } else {
      return 'year' + (amount.abs() != 1 ? 's' : '');
    }
  }

  @override
  String month(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'mon';
    } else {
      return 'month' + (amount.abs() != 1 ? 's' : '');
    }
  }

  @override
  String week(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'w';
    } else {
      return 'week' + (amount.abs() != 1 ? 's' : '');
    }
  }

  @override
  String day(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'd';
    } else {
      return 'day' + (amount.abs() != 1 ? 's' : '');
    }
  }

  @override
  String hour(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'h';
    } else {
      return 'hour' + (amount.abs() != 1 ? 's' : '');
    }
  }

  @override
  String minute(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'min';
    } else {
      return 'minute' + (amount.abs() != 1 ? 's' : '');
    }
  }

  @override
  String second(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 's';
    } else {
      return 'second' + (amount.abs() != 1 ? 's' : '');
    }
  }

  @override
  String millisecond(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'ms';
    } else {
      return 'millisecond' + (amount.abs() != 1 ? 's' : '');
    }
  }

  @override
  String microseconds(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'us';
    } else {
      return 'microsecond' + (amount.abs() != 1 ? 's' : '');
    }
  }
}

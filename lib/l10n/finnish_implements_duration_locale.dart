import 'package:duration/locale.dart';

// TODO update duration lib when it adds finnish, current there is no "fi" finnish locale on the lib
class FinnishDurationLocale implements DurationLocale {
  const FinnishDurationLocale();

  @override
  String year(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'v';
    } else {
      return 'vuosi' + (amount.abs() != 1 ? 'a' : '');
    }
  }

  @override
  String month(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'kk';
    } else {
      return 'kuukausi' + (amount.abs() != 1 ? 'a' : '');
    }
  }

  @override
  String week(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'vko';
    } else {
      return 'viikko' + (amount.abs() != 1 ? 'a' : '');
    }
  }

  @override
  String day(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'pvä';
    } else {
      return 'päivä' + (amount.abs() != 1 ? 'ä' : '');
    }
  }

  @override
  String hour(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 't';
    } else {
      return 'tunti' + (amount.abs() != 1 ? 'a' : '');
    }
  }

  @override
  String minute(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'min';
    } else {
      return 'minuutti' + (amount.abs() != 1 ? 'a' : '');
    }
  }

  @override
  String second(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 's';
    } else {
      return 'sekunti' + (amount.abs() != 1 ? 'a' : '');
    }
  }

  @override
  String millisecond(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'ms';
    } else {
      return 'millisekunti' + (amount.abs() != 1 ? 'a' : '');
    }
  }

  @override
  String microseconds(int amount, [bool abbreviated = true]) {
    if (abbreviated) {
      return 'us';
    } else {
      return 'mikrosekunti' + (amount.abs() != 1 ? 'a' : '');
    }
  }
}

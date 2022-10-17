import 'dart:io';
import 'dart:ui';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';

Locale getSystemLocale() {
  final localeName = Platform.localeName;
  if (localeName.contains("_")) {
    final pieces = localeName.split("_");
    return Locale(pieces[0], pieces[1]);
  } else {
    return Locale(localeName);
  }
}

AppLocalizations getSystemAppLocalizations() {
  return AppLocalizationsEn();
}

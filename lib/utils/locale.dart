import 'dart:io';
import 'dart:ui';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_es.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fr.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_pt.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_sv.dart';

Locale getSystemLocale() {
  final localeName = Platform.localeName;
  if (localeName.contains("_")) {
    final pieces = localeName.split("_");
    return Locale(pieces[0], pieces[1]);
  } else {
    return Locale(localeName);
  }
}

/// prefer the traditional AppLocalizations.of(context) instead of this method.
/// The only reason to add this method is the lack of official method to access
/// an AppLocalizations object without a BuildContext object
AppLocalizations getSystemAppLocalizations() {
  switch (getSystemLocale().languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
    case 'sv':
      return AppLocalizationsSv();
    default:
      return AppLocalizationsEn();
  }
}

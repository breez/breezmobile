import 'package:anytime/l10n/L.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates() {
  return [
    AppLocalizations.delegate,
    const LocalisationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}

Iterable<Locale> supportedLocales() {
  return [
    const Locale('en', ''),
    const Locale('es', ''),
    const Locale('fi', ''),
    const Locale('pt', ''),
  ];
}

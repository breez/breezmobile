import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates() {
  return [
    AppLocalizations.delegate,
    const ClovrLabsLocalizationDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}

class ClovrLabsLocalizationDelegate extends LocalizationsDelegate<Locale> {
  const ClovrLabsLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
      .any((l) => l.languageCode == locale.languageCode);

  @override
  Future<Locale> load(Locale locale) =>
      SynchronousFuture(const Locale('en', ''));

  @override
  bool shouldReload(_) => false;
}

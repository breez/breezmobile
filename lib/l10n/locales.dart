import 'package:anytime/l10n/L.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates() {
  return [
    AppLocalizations.delegate,
    const LocalisationsDelegate(),
    const AnytimeFallbackLocalizationDelegate(),
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
    const Locale('fr', ''),
    const Locale('it', ''),
    const Locale('pt', ''),
  ];
}

class AnytimeFallbackLocalizationDelegate extends LocalizationsDelegate<L> {
  const AnytimeFallbackLocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      !['en', 'de', 'pt'].contains(locale.languageCode);

  // Fallback to English if Breez's supported locale is not supported by Anytime
  @override
  Future<L> load(Locale locale) => L.load(const Locale('en', ''), null);

  @override
  bool shouldReload(_) => false;
}

import 'package:anytime/l10n/L.dart';
import 'package:anytime/l10n/generated/anytime_texts.dart' as anytime_texts;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

class AnytimeFallbackLocalizationDelegate extends LocalizationsDelegate<L> {
  const AnytimeFallbackLocalizationDelegate();

  // Only support if the locale is supported by the app and by anytime.
  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode) &&
      anytime_texts.AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  // Fallback to English if Breez's supported locale is not supported by Anytime
  @override
  Future<L> load(Locale locale) => SynchronousFuture(L.load(const Locale('en', ''), null));

  @override
  bool shouldReload(_) => false;
}

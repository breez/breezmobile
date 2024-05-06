import 'package:anytime/l10n/L.dart';
import 'package:anytime/l10n/generated/anytime_texts.dart' as anytime_texts;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AnytimeFallbackLocalizationDelegate extends LocalizationsDelegate<L> {
  const AnytimeFallbackLocalizationDelegate();

  // Only support if the locale is supported by the app and by anytime.
  @override
  bool isSupported(Locale locale) =>
      supportedLocales().any((l) => l.languageCode == locale.languageCode) &&
      anytime_texts.AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  // Fallback to English if Breez's supported locale is not supported by Anytime
  @override
  Future<L> load(Locale locale) => SynchronousFuture(L.load(const Locale('en', ''), null));

  @override
  bool shouldReload(old) => false;
}

import 'package:anytime/l10n/L.dart';
import 'package:flutter/widgets.dart';

class AnytimeFallbackLocalizationsDelegate extends LocalizationsDelegate<L> {
  const AnytimeFallbackLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      !['en', 'de', 'pt'].contains(locale.languageCode);

  // Fallback to English if Breez's supported locale is not supported by Anytime
  @override
  Future<L> load(Locale locale) => L.load(const Locale('en', ''), null);

  @override
  bool shouldReload(_) => false;
}

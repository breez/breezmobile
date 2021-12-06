import 'dart:io';
import 'dart:ui';

Locale getSystemLocale() {
  final localeName = Platform.localeName;
  if (localeName.contains("_")) {
    final pieces = localeName.split("_");
    return Locale(pieces[0], pieces[1]);
  } else {
    return Locale(localeName);
  }
}

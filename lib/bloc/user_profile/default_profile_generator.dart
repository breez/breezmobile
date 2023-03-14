import "dart:math";
import 'dart:ui';

import 'package:breez/bloc/user_profile/profile_animal.dart';
import 'package:breez/bloc/user_profile/profile_color.dart';
import 'package:breez_translations/generated/breez_translations.dart';

class DefaultProfile {
  final String color;
  final String animal;

  const DefaultProfile(
    this.color,
    this.animal,
  );

  String buildName(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
      case 'fr':
      case 'it':
      case 'pt':
        return "$animal $color";

      case 'de':
      case 'en':
      case 'fi':
      case 'sv':
      default:
        return "$color $animal";
    }
  }
}

DefaultProfile generateDefaultProfile(BreezTranslations texts) {
  final random = Random();

  const colors = ProfileColor.values;
  const animals = ProfileAnimal.values;

  final randomColor = colors.elementAt(random.nextInt(colors.length));
  final randomAnimal = animals.elementAt(random.nextInt(animals.length));

  return DefaultProfile(
    randomColor.name(texts),
    randomAnimal.name(texts),
  );
}

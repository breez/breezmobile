import "dart:math";
import 'dart:ui';

import 'package:breez/bloc/user_profile/profile_animal.dart';
import 'package:breez/bloc/user_profile/profile_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      case 'pt':
        return "$animal $color";

      case 'en':
      case 'fi':
      default:
        return "$color $animal";
    }
  }
}

DefaultProfile generateDefaultProfile(AppLocalizations l10n) {
  final random = Random();

  final colors = ProfileColor.values;
  final animals = ProfileAnimal.values;

  final randomColor = colors.elementAt(random.nextInt(colors.length));
  final randomAnimal = animals.elementAt(random.nextInt(animals.length));

  return DefaultProfile(
    randomColor.name(l10n),
    randomAnimal.name(l10n),
  );
}

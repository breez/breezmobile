import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_es.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fr.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_pt.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_sv.dart';

enum ProfileAnimal {
  BAT,
  BEAR,
  BOAR,
  CAT,
  CHICK,
  COW,
  DEER,
  DOG,
  EAGLE,
  ELEPHANT,
  FOX,
  FROG,
  HIPPO,
  HUMMINGBIRD,
  KOALA,
  LION,
  MONKEY,
  MOUSE,
  OWL,
  OX,
  PANDA,
  PIG,
  RABBIT,
  SEAGULL,
  SHEEP,
  SNAKE,
}

ProfileAnimal profileAnimalFromName(String name, AppLocalizations texts) {
  final key = name.toLowerCase();
  final localizedNames = _animalsFromName[texts.locale];

  if (localizedNames.containsKey(key)) {
    return localizedNames[key];
  }

  for (var map in _animalsFromName.values) {
    if (map.containsKey(key)) {
      return map[key];
    }
  }

  // Not a known animal name
  return null;
}

extension ProfileAnimalExtension on ProfileAnimal {
  String name(AppLocalizations texts) {
    switch (this) {
      case ProfileAnimal.BAT:
        return texts.app_animal_bat;
      case ProfileAnimal.BEAR:
        return texts.app_animal_bear;
      case ProfileAnimal.BOAR:
        return texts.app_animal_boar;
      case ProfileAnimal.CAT:
        return texts.app_animal_cat;
      case ProfileAnimal.CHICK:
        return texts.app_animal_chick;
      case ProfileAnimal.COW:
        return texts.app_animal_cow;
      case ProfileAnimal.DEER:
        return texts.app_animal_deer;
      case ProfileAnimal.DOG:
        return texts.app_animal_dog;
      case ProfileAnimal.EAGLE:
        return texts.app_animal_eagle;
      case ProfileAnimal.ELEPHANT:
        return texts.app_animal_elephant;
      case ProfileAnimal.FOX:
        return texts.app_animal_fox;
      case ProfileAnimal.FROG:
        return texts.app_animal_frog;
      case ProfileAnimal.HIPPO:
        return texts.app_animal_hippo;
      case ProfileAnimal.HUMMINGBIRD:
        return texts.app_animal_hummingbird;
      case ProfileAnimal.KOALA:
        return texts.app_animal_koala;
      case ProfileAnimal.LION:
        return texts.app_animal_lion;
      case ProfileAnimal.MONKEY:
        return texts.app_animal_monkey;
      case ProfileAnimal.MOUSE:
        return texts.app_animal_mouse;
      case ProfileAnimal.OWL:
        return texts.app_animal_owl;
      case ProfileAnimal.OX:
        return texts.app_animal_ox;
      case ProfileAnimal.PANDA:
        return texts.app_animal_panda;
      case ProfileAnimal.PIG:
        return texts.app_animal_pig;
      case ProfileAnimal.RABBIT:
        return texts.app_animal_rabbit;
      case ProfileAnimal.SEAGULL:
        return texts.app_animal_seagull;
      case ProfileAnimal.SHEEP:
        return texts.app_animal_sheep;
      case ProfileAnimal.SNAKE:
        return texts.app_animal_snake;
      default:
        return "";
    }
  }

  IconData get iconData {
    switch (this) {
      case ProfileAnimal.BAT:
        return IconData(0xe900, fontFamily: 'animals');
      case ProfileAnimal.BEAR:
        return IconData(0xe901, fontFamily: 'animals');
      case ProfileAnimal.BOAR:
        return IconData(0xe902, fontFamily: 'animals');
      case ProfileAnimal.CAT:
        return IconData(0xe903, fontFamily: 'animals');
      case ProfileAnimal.CHICK:
        return IconData(0xe904, fontFamily: 'animals');
      case ProfileAnimal.COW:
        return IconData(0xe905, fontFamily: 'animals');
      case ProfileAnimal.DEER:
        return IconData(0xe906, fontFamily: 'animals');
      case ProfileAnimal.DOG:
        return IconData(0xe907, fontFamily: 'animals');
      case ProfileAnimal.EAGLE:
        return IconData(0xe908, fontFamily: 'animals');
      case ProfileAnimal.ELEPHANT:
        return IconData(0xe909, fontFamily: 'animals');
      case ProfileAnimal.FOX:
        return IconData(0xe90a, fontFamily: 'animals');
      case ProfileAnimal.FROG:
        return IconData(0xe90b, fontFamily: 'animals');
      case ProfileAnimal.HIPPO:
        return IconData(0xe90c, fontFamily: 'animals');
      case ProfileAnimal.HUMMINGBIRD:
        return IconData(0xe90d, fontFamily: 'animals');
      case ProfileAnimal.KOALA:
        return IconData(0xe90e, fontFamily: 'animals');
      case ProfileAnimal.LION:
        return IconData(0xe90f, fontFamily: 'animals');
      case ProfileAnimal.MONKEY:
        return IconData(0xe910, fontFamily: 'animals');
      case ProfileAnimal.MOUSE:
        return IconData(0xe911, fontFamily: 'animals');
      case ProfileAnimal.OWL:
        return IconData(0xe912, fontFamily: 'animals');
      case ProfileAnimal.OX:
        return IconData(0xe913, fontFamily: 'animals');
      case ProfileAnimal.PANDA:
        return IconData(0xe914, fontFamily: 'animals');
      case ProfileAnimal.PIG:
        return IconData(0xe915, fontFamily: 'animals');
      case ProfileAnimal.RABBIT:
        return IconData(0xe916, fontFamily: 'animals');
      case ProfileAnimal.SEAGULL:
        return IconData(0xe917, fontFamily: 'animals');
      case ProfileAnimal.SHEEP:
        return IconData(0xe918, fontFamily: 'animals');
      case ProfileAnimal.SNAKE:
        return IconData(0xe919, fontFamily: 'animals');
      default:
        return Icons.bug_report;
    }
  }
}

Map<String, Map<String, ProfileAnimal>> _animalsFromName = {
  "en": _buildAnimalsFromName(AppLocalizationsEn()),
  "es": _buildAnimalsFromName(AppLocalizationsEs()),
  "fi": _buildAnimalsFromName(AppLocalizationsFi()),
  "fr": _buildAnimalsFromName(AppLocalizationsFr()),
  "it": _buildAnimalsFromName(AppLocalizationsIt()),
  "pt": _buildAnimalsFromName(AppLocalizationsPt()),
  "sv": _buildAnimalsFromName(AppLocalizationsSv()),
};

Map<String, ProfileAnimal> _buildAnimalsFromName(AppLocalizations local) => {
      local.app_animal_bat.toLowerCase(): ProfileAnimal.BAT,
      local.app_animal_bear.toLowerCase(): ProfileAnimal.BEAR,
      local.app_animal_boar.toLowerCase(): ProfileAnimal.BOAR,
      local.app_animal_cat.toLowerCase(): ProfileAnimal.CAT,
      local.app_animal_chick.toLowerCase(): ProfileAnimal.CHICK,
      local.app_animal_cow.toLowerCase(): ProfileAnimal.COW,
      local.app_animal_deer.toLowerCase(): ProfileAnimal.DEER,
      local.app_animal_dog.toLowerCase(): ProfileAnimal.DOG,
      local.app_animal_eagle.toLowerCase(): ProfileAnimal.EAGLE,
      local.app_animal_elephant.toLowerCase(): ProfileAnimal.ELEPHANT,
      local.app_animal_fox.toLowerCase(): ProfileAnimal.FOX,
      local.app_animal_frog.toLowerCase(): ProfileAnimal.FROG,
      local.app_animal_hippo.toLowerCase(): ProfileAnimal.HIPPO,
      local.app_animal_hummingbird.toLowerCase(): ProfileAnimal.HUMMINGBIRD,
      local.app_animal_koala.toLowerCase(): ProfileAnimal.KOALA,
      local.app_animal_lion.toLowerCase(): ProfileAnimal.LION,
      local.app_animal_monkey.toLowerCase(): ProfileAnimal.MONKEY,
      local.app_animal_mouse.toLowerCase(): ProfileAnimal.MOUSE,
      local.app_animal_owl.toLowerCase(): ProfileAnimal.OWL,
      local.app_animal_ox.toLowerCase(): ProfileAnimal.OX,
      local.app_animal_panda.toLowerCase(): ProfileAnimal.PANDA,
      local.app_animal_pig.toLowerCase(): ProfileAnimal.PIG,
      local.app_animal_rabbit.toLowerCase(): ProfileAnimal.RABBIT,
      local.app_animal_seagull.toLowerCase(): ProfileAnimal.SEAGULL,
      local.app_animal_sheep.toLowerCase(): ProfileAnimal.SHEEP,
      local.app_animal_snake.toLowerCase(): ProfileAnimal.SNAKE,
    };

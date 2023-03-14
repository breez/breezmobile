import 'package:breez_translations/generated/breez_translations.dart';
import 'package:breez_translations/generated/breez_translations_de.dart';
import 'package:breez_translations/generated/breez_translations_en.dart';
import 'package:breez_translations/generated/breez_translations_es.dart';
import 'package:breez_translations/generated/breez_translations_fi.dart';
import 'package:breez_translations/generated/breez_translations_fr.dart';
import 'package:breez_translations/generated/breez_translations_it.dart';
import 'package:breez_translations/generated/breez_translations_pt.dart';
import 'package:breez_translations/generated/breez_translations_sv.dart';
import 'package:flutter/material.dart';

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

ProfileAnimal profileAnimalFromName(String name, BreezTranslations texts) {
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
  String name(BreezTranslations texts) {
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
        return const IconData(0xe900, fontFamily: 'animals');
      case ProfileAnimal.BEAR:
        return const IconData(0xe901, fontFamily: 'animals');
      case ProfileAnimal.BOAR:
        return const IconData(0xe902, fontFamily: 'animals');
      case ProfileAnimal.CAT:
        return const IconData(0xe903, fontFamily: 'animals');
      case ProfileAnimal.CHICK:
        return const IconData(0xe904, fontFamily: 'animals');
      case ProfileAnimal.COW:
        return const IconData(0xe905, fontFamily: 'animals');
      case ProfileAnimal.DEER:
        return const IconData(0xe906, fontFamily: 'animals');
      case ProfileAnimal.DOG:
        return const IconData(0xe907, fontFamily: 'animals');
      case ProfileAnimal.EAGLE:
        return const IconData(0xe908, fontFamily: 'animals');
      case ProfileAnimal.ELEPHANT:
        return const IconData(0xe909, fontFamily: 'animals');
      case ProfileAnimal.FOX:
        return const IconData(0xe90a, fontFamily: 'animals');
      case ProfileAnimal.FROG:
        return const IconData(0xe90b, fontFamily: 'animals');
      case ProfileAnimal.HIPPO:
        return const IconData(0xe90c, fontFamily: 'animals');
      case ProfileAnimal.HUMMINGBIRD:
        return const IconData(0xe90d, fontFamily: 'animals');
      case ProfileAnimal.KOALA:
        return const IconData(0xe90e, fontFamily: 'animals');
      case ProfileAnimal.LION:
        return const IconData(0xe90f, fontFamily: 'animals');
      case ProfileAnimal.MONKEY:
        return const IconData(0xe910, fontFamily: 'animals');
      case ProfileAnimal.MOUSE:
        return const IconData(0xe911, fontFamily: 'animals');
      case ProfileAnimal.OWL:
        return const IconData(0xe912, fontFamily: 'animals');
      case ProfileAnimal.OX:
        return const IconData(0xe913, fontFamily: 'animals');
      case ProfileAnimal.PANDA:
        return const IconData(0xe914, fontFamily: 'animals');
      case ProfileAnimal.PIG:
        return const IconData(0xe915, fontFamily: 'animals');
      case ProfileAnimal.RABBIT:
        return const IconData(0xe916, fontFamily: 'animals');
      case ProfileAnimal.SEAGULL:
        return const IconData(0xe917, fontFamily: 'animals');
      case ProfileAnimal.SHEEP:
        return const IconData(0xe918, fontFamily: 'animals');
      case ProfileAnimal.SNAKE:
        return const IconData(0xe919, fontFamily: 'animals');
      default:
        return Icons.bug_report;
    }
  }
}

Map<String, Map<String, ProfileAnimal>> _animalsFromName = {
  "de": _buildAnimalsFromName(BreezTranslationsDe()),
  "en": _buildAnimalsFromName(BreezTranslationsEn()),
  "es": _buildAnimalsFromName(BreezTranslationsEs()),
  "fi": _buildAnimalsFromName(BreezTranslationsFi()),
  "fr": _buildAnimalsFromName(BreezTranslationsFr()),
  "it": _buildAnimalsFromName(BreezTranslationsIt()),
  "pt": _buildAnimalsFromName(BreezTranslationsPt()),
  "sv": _buildAnimalsFromName(BreezTranslationsSv()),
};

Map<String, ProfileAnimal> _buildAnimalsFromName(BreezTranslations local) => {
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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_es.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fr.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_pt.dart';

enum ProfileColor {
  SALMON,
  BLUE,
  TURQUOISE,
  ORCHID,
  PURPLE,
  TOMATO,
  CYAN,
  CRIMSON,
  ORANGE,
  LIME,
  PINK,
  GREEN,
  RED,
  YELLOW,
  AZURE,
  SILVER,
  MAGENTA,
  OLIVE,
  VIOLET,
  ROSE,
  WINE,
  MINT,
  INDIGO,
  JADE,
  CORAL,
}

ProfileColor profileColorFromName(String name, AppLocalizations texts) {
  final key = name.toLowerCase();
  final localizedNames = _colorsFromName[texts.locale];

  if (localizedNames.containsKey(key)) {
    return localizedNames[key];
  }

  for (var map in _colorsFromName.values) {
    if (map.containsKey(key)) {
      return map[key];
    }
  }

  // Not a known color name
  return null;
}

extension ProfileColorExtension on ProfileColor {
  String name(AppLocalizations texts) {
    switch (this) {
      case ProfileColor.SALMON:
        return texts.app_color_salmon;
      case ProfileColor.BLUE:
        return texts.app_color_blue;
      case ProfileColor.TURQUOISE:
        return texts.app_color_turquoise;
      case ProfileColor.ORCHID:
        return texts.app_color_orchid;
      case ProfileColor.PURPLE:
        return texts.app_color_purple;
      case ProfileColor.TOMATO:
        return texts.app_color_tomato;
      case ProfileColor.CYAN:
        return texts.app_color_cyan;
      case ProfileColor.CRIMSON:
        return texts.app_color_crimson;
      case ProfileColor.ORANGE:
        return texts.app_color_orange;
      case ProfileColor.LIME:
        return texts.app_color_lime;
      case ProfileColor.PINK:
        return texts.app_color_pink;
      case ProfileColor.GREEN:
        return texts.app_color_green;
      case ProfileColor.RED:
        return texts.app_color_red;
      case ProfileColor.YELLOW:
        return texts.app_color_yellow;
      case ProfileColor.AZURE:
        return texts.app_color_azure;
      case ProfileColor.SILVER:
        return texts.app_color_silver;
      case ProfileColor.MAGENTA:
        return texts.app_color_magenta;
      case ProfileColor.OLIVE:
        return texts.app_color_olive;
      case ProfileColor.VIOLET:
        return texts.app_color_violet;
      case ProfileColor.ROSE:
        return texts.app_color_rose;
      case ProfileColor.WINE:
        return texts.app_color_wine;
      case ProfileColor.MINT:
        return texts.app_color_mint;
      case ProfileColor.INDIGO:
        return texts.app_color_indigo;
      case ProfileColor.JADE:
        return texts.app_color_jade;
      case ProfileColor.CORAL:
        return texts.app_color_coral;
      default:
        return "";
    }
  }

  Color get color {
    switch (this) {
      case ProfileColor.SALMON:
        return Color(0xFFFA8072);
      case ProfileColor.BLUE:
        return Color(0xFF4169E1);
      case ProfileColor.TURQUOISE:
        return Color(0xFF00CED1);
      case ProfileColor.ORCHID:
        return Color(0xFF9932CC);
      case ProfileColor.PURPLE:
        return Color(0xFF800080);
      case ProfileColor.TOMATO:
        return Color(0xFFFF6347);
      case ProfileColor.CYAN:
        return Color(0xFF008B8B);
      case ProfileColor.CRIMSON:
        return Color(0xFFDC143C);
      case ProfileColor.ORANGE:
        return Color(0xFFFFA500);
      case ProfileColor.LIME:
        return Color(0xFF32CD32);
      case ProfileColor.PINK:
        return Color(0xFFFF69B4);
      case ProfileColor.GREEN:
        return Color(0xFF00A644);
      case ProfileColor.RED:
        return Color(0xFFFF2727);
      case ProfileColor.YELLOW:
        return Color(0xFFEECA0C);
      case ProfileColor.AZURE:
        return Color(0xFF00C4FF);
      case ProfileColor.SILVER:
        return Color(0xFF53687F);
      case ProfileColor.MAGENTA:
        return Color(0xFFFF00FF);
      case ProfileColor.OLIVE:
        return Color(0xFF808000);
      case ProfileColor.VIOLET:
        return Color(0xFF7F01FF);
      case ProfileColor.ROSE:
        return Color(0xFFFF0080);
      case ProfileColor.WINE:
        return Color(0xFF950347);
      case ProfileColor.MINT:
        return Color(0xFF7ADEB8);
      case ProfileColor.INDIGO:
        return Color(0xFF4B0082);
      case ProfileColor.JADE:
        return Color(0xFF00B27A);
      case ProfileColor.CORAL:
        return Color(0xFFFF7F50);
      default:
        return Colors.white;
    }
  }
}

Map<String, Map<String, ProfileColor>> _colorsFromName = {
  "en": _buildColorsFromName(AppLocalizationsEn()),
  "es": _buildColorsFromName(AppLocalizationsEs()),
  "fi": _buildColorsFromName(AppLocalizationsFi()),
  "fr": _buildColorsFromName(AppLocalizationsFr()),
  "it": _buildColorsFromName(AppLocalizationsIt()),
  "pt": _buildColorsFromName(AppLocalizationsPt()),
};

Map<String, ProfileColor> _buildColorsFromName(AppLocalizations local) => {
      local.app_color_salmon.toLowerCase(): ProfileColor.SALMON,
      local.app_color_blue.toLowerCase(): ProfileColor.BLUE,
      local.app_color_turquoise.toLowerCase(): ProfileColor.TURQUOISE,
      local.app_color_orchid.toLowerCase(): ProfileColor.ORCHID,
      local.app_color_purple.toLowerCase(): ProfileColor.PURPLE,
      local.app_color_tomato.toLowerCase(): ProfileColor.TOMATO,
      local.app_color_cyan.toLowerCase(): ProfileColor.CYAN,
      local.app_color_crimson.toLowerCase(): ProfileColor.CRIMSON,
      local.app_color_orange.toLowerCase(): ProfileColor.ORANGE,
      local.app_color_lime.toLowerCase(): ProfileColor.LIME,
      local.app_color_pink.toLowerCase(): ProfileColor.PINK,
      local.app_color_green.toLowerCase(): ProfileColor.GREEN,
      local.app_color_red.toLowerCase(): ProfileColor.RED,
      local.app_color_yellow.toLowerCase(): ProfileColor.YELLOW,
      local.app_color_azure.toLowerCase(): ProfileColor.AZURE,
      local.app_color_silver.toLowerCase(): ProfileColor.SILVER,
      local.app_color_magenta.toLowerCase(): ProfileColor.MAGENTA,
      local.app_color_olive.toLowerCase(): ProfileColor.OLIVE,
      local.app_color_violet.toLowerCase(): ProfileColor.VIOLET,
      local.app_color_rose.toLowerCase(): ProfileColor.ROSE,
      local.app_color_wine.toLowerCase(): ProfileColor.WINE,
      local.app_color_mint.toLowerCase(): ProfileColor.MINT,
      local.app_color_indigo.toLowerCase(): ProfileColor.INDIGO,
      local.app_color_jade.toLowerCase(): ProfileColor.JADE,
      local.app_color_coral.toLowerCase(): ProfileColor.CORAL,
    };

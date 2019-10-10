import 'package:flutter/material.dart';

import 'themes.dart';

class CustomTheme extends Object {
  final ThemeId themeId;

  const CustomTheme(
    this.themeId,
  );

  ThemeData get theme {
    switch (themeId) {
      case (ThemeId.BLUE):
        return Themes.blueTheme;
      case (ThemeId.DARK):
        return Themes.darkTheme;
      default:
        return Themes.blueTheme;
    }
  }
}

import 'package:anytime/ui/themes.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

Widget withPodcastTheme(BreezUserModel user, Widget child) {
  var currentTheme = theme.themeMap[user.themeId];
  return Theme(
      child: child,
      data: user.themeId == "BLUE"
          ? Themes.lightTheme()
              .themeData
              .copyWith(appBarTheme: currentTheme.appBarTheme)
          : Themes.darkTheme()
              .themeData
              .copyWith(appBarTheme: currentTheme.appBarTheme));
}

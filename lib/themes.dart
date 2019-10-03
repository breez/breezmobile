import 'package:flutter/material.dart';

import 'theme_data.dart' as theme;

enum ThemeId { BLUE, DARK }

class Themes {
  static final ThemeData blueTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color.fromRGBO(255, 255, 255, 1.0),
    primaryColorDark: theme.BreezColors.blue[900],
    primaryColorLight: Color.fromRGBO(0, 133, 251, 1.0),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Color.fromRGBO(0, 133, 251, 1.0)),
    accentColor: Color(0xFFffffff),
    canvasColor: theme.BreezColors.blue[500],
    backgroundColor: Colors.white,
    appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.transparent,), actionsIconTheme: IconThemeData(color: Color.fromRGBO(0, 120, 253, 1.0))),
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(color: theme.BreezColors.grey[600], fontSize: 20.5, letterSpacing: 0.25),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)))),
    errorColor: theme.errorColor,
    dividerColor: Color(0x33ffffff),
    buttonColor: Colors.white,
    cardColor: theme.BreezColors.blue[500],
    highlightColor: theme.BreezColors.blue[200],
    textTheme: TextTheme(
        subtitle: TextStyle(color: theme.BreezColors.grey[600], fontSize: 14.3, letterSpacing: 0.2),
        headline: TextStyle(color: theme.BreezColors.grey[600], fontSize: 26.0),
        button: TextStyle(color: theme.BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25)),
    primaryTextTheme: TextTheme(
        display1: TextStyle(
            color: theme.BreezColors.grey[500], fontSize: 14.0, letterSpacing: 0.0, height: 1.28, fontFamily: 'IBMPlexSansMedium'),
        display2: TextStyle(color: theme.BreezColors.grey[500], fontSize: 14.0, letterSpacing: 0.0, height: 1.28),
        headline: TextStyle(
            color: theme.BreezColors.grey[500], fontSize: 24.0, letterSpacing: 0.0, height: 1.28, fontFamily: 'IBMPlexSansMedium'),
        body1: TextStyle(color: theme.BreezColors.blue[900], fontSize: 16.4, letterSpacing: 0.15, fontFamily: 'IBMPlexSansMedium'),
        subtitle: TextStyle(color: theme.BreezColors.white[500], fontSize: 10.0, letterSpacing: 0.09),
        button: TextStyle(color: theme.BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25)),
    textSelectionColor: Color.fromRGBO(255, 255, 255, 0.5),
    primaryIconTheme: IconThemeData(color: theme.BreezColors.grey[500]),
    textSelectionHandleColor: Color(0xFF0085fb),
    fontFamily: 'IBMPlexSansRegular',
  );

  // Color(0xFF121212) values are tbd
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF7aa5eb),
    primaryColorDark: Color(0xFF0c2031),
    primaryColorLight: Color(0xFF4B89EB),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Color(0xFF4B89EB)),
    accentColor: Colors.white,
    canvasColor: Color(0xFF0c2031),
    backgroundColor: Color(0xFF152a3d),
    appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white,), actionsIconTheme: IconThemeData(color: Colors.white)),
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.5, letterSpacing: 0.25),
        contentTextStyle: TextStyle(color: Colors.white70, fontSize: 16.0, height: 1.5),
        backgroundColor: Color(0xFF152a3d),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)))),
    errorColor: Color(0xFFeddc97),
    dividerColor: Colors.lightBlueAccent,
    buttonColor: Color(0xFF4B89EB),
    cardColor: Color(0xFF121212),
    highlightColor: Color(0xFF121212),
    textTheme: TextTheme(
        subtitle: TextStyle(color: Colors.white, fontSize: 14.3, letterSpacing: 0.2),
        headline: TextStyle(color: Colors.white, fontSize: 26.0),
        button: TextStyle(color: Colors.white, fontSize: 14.3, letterSpacing: 1.25)),
    primaryTextTheme: TextTheme(
        display1: TextStyle(color: Colors.white, fontSize: 14.0, letterSpacing: 0.0, height: 1.28, fontFamily: 'IBMPlexSansMedium'),
        display2: TextStyle(color: Colors.white, fontSize: 14.0, letterSpacing: 0.0, height: 1.28),
        headline: TextStyle(color: Colors.white, fontSize: 24.0, letterSpacing: 0.0, height: 1.28, fontFamily: 'IBMPlexSansMedium'),
        body1: TextStyle(color: Colors.white, fontSize: 16.4, letterSpacing: 0.15, fontFamily: 'IBMPlexSansMedium'),
        button: TextStyle(color: Colors.lightBlueAccent, fontSize: 14.3, letterSpacing: 1.25),
        subtitle: TextStyle(color: theme.BreezColors.white[500], fontSize: 10.0, letterSpacing: 0.09)),
    primaryIconTheme: IconThemeData(color: Colors.lightBlueAccent),
    textSelectionColor: Color(0xFF121212).withOpacity(0.5),
    textSelectionHandleColor: Color(0xFF121212),
    fontFamily: 'IBMPlexSansRegular',
  );

  static ThemeData getThemeFromId(ThemeId themeId) {
    switch (themeId) {
      case ThemeId.BLUE:
        return blueTheme;
      case ThemeId.DARK:
        return darkTheme;
      default:
        return blueTheme;
    }
  }
}

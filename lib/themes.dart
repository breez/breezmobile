import 'package:flutter/material.dart';

import 'theme_data.dart' as theme_data;

class Themes {
  static final Map<String, ThemeData> themeMap = {"BLUE": blueTheme, "DARK": darkTheme};

  static final ThemeData blueTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color.fromRGBO(255, 255, 255, 1.0),
    primaryColorDark: theme_data.BreezColors.blue[900],
    primaryColorLight: Color.fromRGBO(0, 133, 251, 1.0),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Color.fromRGBO(0, 133, 251, 1.0)),
    accentColor: Colors.white,
    canvasColor: theme_data.BreezColors.blue[500],
    backgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          title: TextStyle(color: Colors.white, fontSize: 18.0, letterSpacing: 0.22),
        ),
        iconTheme: IconThemeData(
          color: Colors.transparent,
        ),
        actionsIconTheme: IconThemeData(color: Color.fromRGBO(0, 120, 253, 1.0))),
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(color: theme_data.BreezColors.grey[600], fontSize: 20.5, letterSpacing: 0.25),
        contentTextStyle: TextStyle(color: theme_data.BreezColors.grey[500], fontSize: 16.0, height: 1.5),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)))),
    dialogBackgroundColor: Colors.transparent,
    errorColor: Color(0xffffe685),
    dividerColor: Color(0x33ffffff),
    buttonColor: Colors.white,
    cardColor: theme_data.BreezColors.blue[500],
    highlightColor: theme_data.BreezColors.blue[200],
    textTheme: TextTheme(
      subtitle: TextStyle(color: theme_data.BreezColors.grey[600], fontSize: 14.3, letterSpacing: 0.2),
      headline: TextStyle(color: theme_data.BreezColors.grey[600], fontSize: 26.0),
      button: TextStyle(color: theme_data.BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25),
      caption: TextStyle(color: Color(0xffffe685), fontSize: 18.0, letterSpacing: 0.8, height: 1.25, fontFamily: 'IBMPlexSansMedium'),
    ),
    primaryTextTheme: TextTheme(
        display1: TextStyle(
            color: theme_data.BreezColors.grey[500], fontSize: 14.0, letterSpacing: 0.0, height: 1.28, fontFamily: 'IBMPlexSansMedium'),
        display2: TextStyle(color: theme_data.BreezColors.grey[500], fontSize: 14.0, letterSpacing: 0.0, height: 1.28),
        headline: TextStyle(
            color: theme_data.BreezColors.grey[500], fontSize: 24.0, letterSpacing: 0.0, height: 1.28, fontFamily: 'IBMPlexSansMedium'),
        body1: TextStyle(color: theme_data.BreezColors.blue[900], fontSize: 16.4, letterSpacing: 0.15, fontFamily: 'IBMPlexSansMedium'),
        subtitle: TextStyle(color: theme_data.BreezColors.white[500], fontSize: 10.0, letterSpacing: 0.09),
        button: TextStyle(color: theme_data.BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25)),
    textSelectionColor: Color.fromRGBO(255, 255, 255, 0.5),
    primaryIconTheme: IconThemeData(color: theme_data.BreezColors.grey[500]),
    textSelectionHandleColor: Color(0xFF0085fb),
    fontFamily: 'IBMPlexSansRegular',
  );

  // Color(0xFF121212) values are tbd
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF7aa5eb),
    primaryColorDark: Color(0xFF00081C),
    primaryColorLight: Color(0xFF4B89EB),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Color(0xFF4B89EB)),
    accentColor: Colors.white,
    canvasColor: Color(0xFF0c2031),
    backgroundColor: Color(0xFF152a3d),
    appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          title: TextStyle(color: Colors.white, fontSize: 18.0, letterSpacing: 0.22),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: IconThemeData(color: Colors.white)),
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.5, letterSpacing: 0.25),
        contentTextStyle: TextStyle(color: Colors.white70, fontSize: 16.0, height: 1.5),
        backgroundColor: Color(0xFF152a3d),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)))),
    dialogBackgroundColor: Colors.transparent,
    errorColor: Color(0xFFeddc97),
    dividerColor: Color(0x337aa5eb),
    buttonColor: Color(0xFF4B89EB),
    cardColor: Color(0xFF121212),
    highlightColor: Color(0xFF4B88EB),
    textTheme: TextTheme(
      subtitle: TextStyle(color: Colors.white, fontSize: 14.3, letterSpacing: 0.2),
      headline: TextStyle(color: Colors.white, fontSize: 26.0),
      button: TextStyle(color: Colors.white, fontSize: 14.3, letterSpacing: 1.25),
      caption: TextStyle(color: Color(0xFFeddc97), fontSize: 18.0, letterSpacing: 0.8, height: 1.25, fontFamily: 'IBMPlexSansMedium'),
    ),
    primaryTextTheme: TextTheme(
        display1: TextStyle(color: Colors.white, fontSize: 14.0, letterSpacing: 0.0, height: 1.28, fontFamily: 'IBMPlexSansMedium'),
        display2: TextStyle(color: Colors.white, fontSize: 14.0, letterSpacing: 0.0, height: 1.28),
        headline: TextStyle(color: Colors.white, fontSize: 24.0, letterSpacing: 0.0, height: 1.28, fontFamily: 'IBMPlexSansMedium'),
        body1: TextStyle(color: Colors.white, fontSize: 16.4, letterSpacing: 0.15, fontFamily: 'IBMPlexSansMedium'),
        button: TextStyle(color: Color(0xFF7aa5eb), fontSize: 14.3, letterSpacing: 1.25),
        subtitle: TextStyle(color: theme_data.BreezColors.white[500], fontSize: 10.0, letterSpacing: 0.09)),
    primaryIconTheme: IconThemeData(color: Color(0xFF7aa5eb)),
    textSelectionColor: Color(0xFF121212).withOpacity(0.5),
    textSelectionHandleColor: Color(0xFF121212),
    fontFamily: 'IBMPlexSansRegular',
  );
}

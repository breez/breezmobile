import 'package:anytime/ui/themes.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

Widget withPodcastTheme(BreezUserModel user, Widget child) {
  var currentTheme = theme.themeMap[user.themeId];
  return Theme(
    child: child,
    data: user.themeId == "BLUE"
        ? Themes.lightTheme().themeData.copyWith(
              brightness: Brightness.light,
              primaryColor: Color.fromRGBO(0, 133, 251, 1.0),
              primaryColorBrightness: Brightness.light,
              primaryColorLight: Color.fromRGBO(0, 117, 255, 1.0),
              primaryColorDark: Color.fromRGBO(19, 85, 191, 1.0),
              accentColor: Color.fromRGBO(0, 117, 255, 1.0),
              accentColorBrightness: Brightness.light,
              canvasColor: Color(0xfffafafa),
              scaffoldBackgroundColor: Color(0xffffffff),
              bottomAppBarColor: Color(0xff4D88EC),
              cardColor: Color(0xffffffff),
              dividerColor: Color.fromRGBO(0, 0, 0, 0.12),
              highlightColor: Color.fromRGBO(0, 117, 255, 1.0),
              splashColor: Color(0x66c8c8c8),
              selectedRowColor: Color(0xfff5f5f5),
              unselectedWidgetColor: Color(0x8a000000),
              disabledColor: Color(0x77ffffff),
              buttonColor: Color.fromRGBO(0, 133, 251, 1.0),
              toggleableActiveColor: Color.fromRGBO(0, 133, 251, 1.0),
              secondaryHeaderColor: Color(0xfffff3e0),
              textSelectionColor: Color(0xffffcc80),
              cursorColor: Colors.blue,
              textSelectionHandleColor: Color(0xffffb74d),
              backgroundColor: Colors.white,
              dialogBackgroundColor: Color(0xffffffff),
              indicatorColor: Colors.grey[800],
              hintColor: Color(0x8a000000),
              errorColor: Color(0xffffe685),
              primaryTextTheme:
                  Typography.material2018(platform: TargetPlatform.android)
                      .black
                      .apply(fontFamily: 'IBMPlexSans'),
              textTheme:
                  Typography.material2018(platform: TargetPlatform.android)
                      .black
                      .apply(
                        fontFamily: 'IBMPlexSans',
                      )
                      .copyWith(
                        headline6: Typography.material2018(
                                platform: TargetPlatform.android)
                            .black
                            .headline6
                            .copyWith(
                                fontWeight: FontWeight.w400, fontSize: 14.3),
                      ),
              accentTextTheme:
                  Typography.material2018(platform: TargetPlatform.android)
                      .white
                      .apply(fontFamily: 'IBMPlexSans'),
              primaryIconTheme:
                  IconThemeData(color: Color.fromRGBO(0, 133, 251, 1.0)),
              iconTheme: IconThemeData(color: Colors.white, size: 32.0),
              appBarTheme: currentTheme.appBarTheme,
            )
        : Themes.darkTheme().themeData.copyWith(
              brightness: Brightness.dark,
              primaryColor: Color(0xFF4B89EB),
              primaryColorBrightness: Brightness.dark,
              primaryColorLight: Color(0xFF81acf1),
              primaryColorDark: Color(0xFF00081C),
              accentColor: Color(0xffffffff),
              accentColorBrightness: Brightness.dark,
              canvasColor: Color(0xFF0c2031),
              scaffoldBackgroundColor: Color(0xFF0c2031),
              bottomAppBarColor: Color(0xff4D88EC),
              cardColor: Colors.black,
              dividerColor: Color.fromRGBO(0, 0, 0, 0.12),
              highlightColor: Color(0xFF81acf1),
              splashColor: Color(0x66c8c8c8),
              selectedRowColor: Color(0xfff5f5f5),
              unselectedWidgetColor: Color(0x8a000000),
              disabledColor: Color(0x77ffffff),
              buttonColor: Color(0xFF4B89EB),
              toggleableActiveColor: Color(0xFF4B89EB),
              secondaryHeaderColor: Color(0xfffff3e0),
              textSelectionColor: Color(0xffffcc80),
              cursorColor: Colors.orange,
              textSelectionHandleColor: Color(0xffffb74d),
              backgroundColor: Color(0xFF0c2031),
              dialogBackgroundColor: Color(0xFF0c2031),
              indicatorColor: Color(0xfff5f5f5),
              hintColor: Color(0x80ffffff),
              errorColor: Color(0xFFeddc97),
              primaryTextTheme:
                  Typography.material2018(platform: TargetPlatform.android)
                      .white
                      .apply(fontFamily: 'IBMPlexSans'),
              textTheme: Typography.material2018(
                      platform: TargetPlatform.android)
                  .white
                  .apply(fontFamily: 'IBMPlexSans')
                  .copyWith(
                    headline6: Typography.material2018(
                            platform: TargetPlatform.android)
                        .white
                        .headline6
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 14.3),
                  ),
              accentTextTheme:
                  Typography.material2018(platform: TargetPlatform.android)
                      .white
                      .apply(fontFamily: 'IBMPlexSans'),
              primaryIconTheme: IconThemeData(color: Colors.white),
              iconTheme: IconThemeData(color: Colors.white, size: 32.0),
              dividerTheme: Themes.darkTheme().themeData.dividerTheme.copyWith(
                    color: Color(0xff444444),
                  ),
              appBarTheme: currentTheme.appBarTheme,
            ),
  );
}

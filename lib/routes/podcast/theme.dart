import 'package:anytime/ui/themes.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

Widget withBreezTheme(BuildContext context, Widget child) {
  UserProfileBloc userProfileBloc =
      AppBlocsProvider.of<UserProfileBloc>(context);
  return StreamBuilder<BreezUserModel>(
    stream: userProfileBloc.userStream,
    builder: (context, snapshot) {
      var user = snapshot.data;
      if (user == null) {
        return child;
      }
      var currentTheme = theme.themeMap[user.themeId];
      return Theme(child: child, data: currentTheme);
    },
  );
}

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
              canvasColor: Color.fromRGBO(5, 93, 235, 1.0),
              scaffoldBackgroundColor: Color(0xffffffff),
              bottomAppBarColor: Color(0xFF0085fb),
              cardColor: Color(0xffffffff),
              dividerColor: Color.fromRGBO(0, 0, 0, 0.10),
              highlightColor: Color.fromRGBO(0, 117, 255, 1.0),
              splashColor: Color(0x66c8c8c8),
              selectedRowColor: Color.fromRGBO(0, 133, 251, 1.0),
              unselectedWidgetColor: Color(0x8a000000),
              disabledColor: Colors.blueGrey,
              buttonColor: Color.fromRGBO(0, 133, 251, 1.0),
              toggleableActiveColor: Color.fromRGBO(0, 133, 251, 1.0),
              secondaryHeaderColor: Color(0xfffff3e0),
              textSelectionColor: Color(0xffffcc80),
              cursorColor: Colors.orange,
              textSelectionHandleColor: Color(0xffffb74d),
              backgroundColor: Color(0xFFf3f8fc),
              dialogBackgroundColor: Color(0xffffffff),
              indicatorColor: Colors.grey[800],
              hintColor: Color(0x8a000000),
              errorColor: Color(0xffffe685),
              dialogTheme: currentTheme.dialogTheme,
              buttonTheme: Themes.lightTheme().themeData.buttonTheme.copyWith(
                    colorScheme: Themes.lightTheme()
                        .themeData
                        .buttonTheme
                        .colorScheme
                        .copyWith(
                            primary:
                                currentTheme.primaryTextTheme.button.color),
                  ),
              primaryTextTheme: Typography.material2018(
                      platform: TargetPlatform.android)
                  .black
                  .apply(fontFamily: 'IBMPlexSans')
                  .copyWith(
                    headline6: Typography.material2018(
                            platform: TargetPlatform.android)
                        .black
                        .headline6
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 14.3),
                    button: currentTheme.primaryTextTheme.button,
                  ),
              textTheme:
                  Typography.material2018(platform: TargetPlatform.android)
                      .black
                      .apply(
                        fontFamily: 'IBMPlexSans',
                      )
                      .copyWith(
                        button: Typography.material2018(
                                platform: TargetPlatform.android)
                            .black
                            .button
                            .copyWith(color: Color.fromRGBO(5, 93, 235, 1.0)),
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
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: currentTheme.scaffoldBackgroundColor,
              ),
              appBarTheme: currentTheme.appBarTheme.copyWith(
                color: currentTheme.backgroundColor,
                backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
                foregroundColor: Colors.white,
                textTheme: currentTheme.appBarTheme.textTheme.copyWith(
                    headline6: currentTheme.appBarTheme.textTheme.headline6
                        .copyWith(color: Color.fromRGBO(0, 133, 251, 1.0))),
              ),
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
              dividerColor: Colors.white.withOpacity(0.2),
              highlightColor: Color(0xFF81acf1),
              splashColor: Color(0x66c8c8c8),
              selectedRowColor: Color(0xFF4B89EB),
              unselectedWidgetColor: Color(0x8a000000),
              disabledColor: Color(0x77ffffff),
              buttonColor: Colors.white,
              toggleableActiveColor: Color(0xFF4B89EB),
              secondaryHeaderColor: Color(0xfffff3e0),
              textSelectionColor: Color(0xffffcc80),
              cursorColor: Color(0xFF4B89EB),
              textSelectionHandleColor: Color(0xffffb74d),
              backgroundColor: Color(0xFF152a3d),
              dialogBackgroundColor: Color(0xFF0c2031),
              indicatorColor: Color(0xfff5f5f5),
              hintColor: Color(0x80ffffff),
              errorColor: Color(0xFFeddc97),
              dialogTheme: currentTheme.dialogTheme,
              buttonTheme: Themes.darkTheme().themeData.buttonTheme.copyWith(
                    colorScheme: Themes.darkTheme()
                        .themeData
                        .buttonTheme
                        .colorScheme
                        .copyWith(
                            primary:
                                currentTheme.primaryTextTheme.button.color),
                  ),
              primaryTextTheme:
                  Typography.material2018(platform: TargetPlatform.android)
                      .white
                      .apply(fontFamily: 'IBMPlexSans')
                      .copyWith(
                        button: currentTheme.primaryTextTheme.button,
                      ),
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
              appBarTheme: currentTheme.appBarTheme.copyWith(
                  backgroundColor: Color(0xFF0c2031),
                  color: currentTheme.backgroundColor),
            ),
  );
}

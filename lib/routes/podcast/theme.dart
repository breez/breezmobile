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
        return SizedBox();
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
              primaryColorLight: Color.fromRGBO(0, 117, 255, 1.0),
              primaryColorDark: Color.fromRGBO(19, 85, 191, 1.0),
              sliderTheme: SliderThemeData(
                valueIndicatorColor: Color.fromRGBO(0, 117, 255, 1.0),
                valueIndicatorTextStyle: TextStyle(color: Colors.white),
              ),
              canvasColor: Color.fromRGBO(5, 93, 235, 1.0),
              scaffoldBackgroundColor: Color(0xffffffff),
              bottomAppBarTheme: BottomAppBarTheme(
                elevation: 0,
                color: Color(0xFF0085fb),
              ),
              cardColor: Color(0xffffffff),
              dividerColor: Color.fromRGBO(0, 0, 0, 0.10),
              highlightColor: Color.fromRGBO(0, 117, 255, 1.0),
              splashColor: Color(0x66c8c8c8),
              unselectedWidgetColor: Color(0x8a000000),
              disabledColor: Colors.blueGrey,
              secondaryHeaderColor: Color(0xfffff3e0),
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: Color.fromRGBO(0, 117, 255, 0.25),
                selectionHandleColor: Color(0xFF0085fb),
                cursorColor: Color.fromRGBO(0, 133, 251, 1.0),
              ),
              dialogBackgroundColor: Color(0xffffffff),
              indicatorColor: Colors.orange,
              hintColor: Color(0x8a000000),
              dialogTheme: currentTheme.dialogTheme,
              buttonTheme: Themes.lightTheme().themeData.buttonTheme.copyWith(
                    colorScheme: Themes.lightTheme()
                        .themeData
                        .buttonTheme
                        .colorScheme
                        .copyWith(
                            primary:
                                currentTheme.primaryTextTheme.labelLarge.color,
                            onPrimary: Color.fromRGBO(0, 133, 251, 1.0),
                            onSecondary: Color.fromRGBO(178, 241, 255, 1.0),
                            onSurface: Colors.blueGrey),
                  ),
              primaryTextTheme:
                  Typography.material2018(platform: TargetPlatform.android)
                      .black
                      .apply(fontFamily: 'IBMPlexSans')
                      .copyWith(
                        labelLarge: currentTheme.primaryTextTheme.labelLarge,
                      ),
              textTheme:
                  Typography.material2018(platform: TargetPlatform.android)
                      .black
                      .apply(
                        fontFamily: 'IBMPlexSans',
                      )
                      .copyWith(
                        labelLarge: Typography.material2018(
                                platform: TargetPlatform.android)
                            .black
                            .labelLarge
                            .copyWith(color: Color.fromRGBO(5, 93, 235, 1.0)),
                        titleLarge: Typography.material2018(
                                platform: TargetPlatform.android)
                            .black
                            .titleLarge
                            .copyWith(
                                fontWeight: FontWeight.w400, fontSize: 14.3),
                      ),
              primaryIconTheme:
                  IconThemeData(color: Color.fromRGBO(0, 133, 251, 1.0)),
              iconTheme: IconThemeData(color: Colors.white, size: 32.0),
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: currentTheme.scaffoldBackgroundColor,
              ),
              appBarTheme: currentTheme.appBarTheme.copyWith(
                color: currentTheme.colorScheme.background,
                //backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
                foregroundColor: Color.fromRGBO(5, 93, 235, 1.0),
              ),
              colorScheme: ColorScheme.light(
                primary: Color.fromRGBO(0, 117, 255, 1.0),
                secondary: Color.fromRGBO(0, 133, 251, 1.0),
                onSecondary: Colors.black,
                background: Color(0xFFf3f8fc),
              ).copyWith(error: Color(0xffffe685)),
              switchTheme: SwitchThemeData(
                thumbColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return null;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return Color.fromRGBO(0, 133, 251, 1.0);
                  }
                  return null;
                }),
                trackColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return null;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return Color.fromRGBO(0, 133, 251, 1.0);
                  }
                  return null;
                }),
              ),
              radioTheme: currentTheme.radioTheme.copyWith(
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return null;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return Color.fromRGBO(0, 133, 251, 1.0);
                  }
                  return null;
                }),
              ),
              checkboxTheme: CheckboxThemeData(
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return null;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return Color.fromRGBO(0, 133, 251, 1.0);
                  }
                  return null;
                }),
              ),
            )
        : Themes.darkTheme().themeData.copyWith(
              brightness: Brightness.dark,
              primaryColor: Color(0xFF0085fb),
              primaryColorLight: Color(0xFF81acf1),
              primaryColorDark: Color(0xFF0085fb),
              sliderTheme: SliderThemeData(
                valueIndicatorColor: Color(0xFF0085fb),
                valueIndicatorTextStyle: TextStyle(color: Colors.white),
              ),
              canvasColor: Color(0xFF0c2031),
              scaffoldBackgroundColor: Color(0xFF0c2031),
              bottomAppBarTheme: BottomAppBarTheme(
                elevation: 0,
                color: Color(0xFF0085fb),
              ),
              cardColor: Colors.black,
              dividerColor: Colors.white.withOpacity(0.2),
              highlightColor: Color(0xFF0085fb),
              splashColor: Color(0x66c8c8c8),
              unselectedWidgetColor: Color(0x8a000000),
              disabledColor: Color(0x77ffffff),
              secondaryHeaderColor: Color(0xfffff3e0),
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: Color.fromRGBO(255, 255, 255, 0.25),
                selectionHandleColor: Color(0xFF0085fb),
                cursorColor: Colors.white,
              ),
              dialogBackgroundColor: Color(0xFF0c2031),
              indicatorColor: Color(0xFF0085fb),
              hintColor: Color(0x80ffffff),
              dialogTheme: currentTheme.dialogTheme,
              buttonTheme: Themes.darkTheme().themeData.buttonTheme.copyWith(
                    colorScheme: Themes.darkTheme()
                        .themeData
                        .buttonTheme
                        .colorScheme
                        .copyWith(
                            primary:
                                currentTheme.primaryTextTheme.labelLarge.color,
                            onPrimary: Colors.white,
                            onSecondary: Color(0xFF0085fb),
                            onSurface: Color(0x77ffffff)),
                  ),
              primaryTextTheme:
                  Typography.material2018(platform: TargetPlatform.android)
                      .white
                      .apply(fontFamily: 'IBMPlexSans')
                      .copyWith(
                        labelLarge: currentTheme.primaryTextTheme.labelLarge,
                      ),
              textTheme: Typography.material2018(
                      platform: TargetPlatform.android)
                  .white
                  .apply(fontFamily: 'IBMPlexSans')
                  .copyWith(
                    titleLarge: Typography.material2018(
                            platform: TargetPlatform.android)
                        .white
                        .titleLarge
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 14.3),
                  ),
              primaryIconTheme: IconThemeData(color: Colors.white),
              iconTheme: IconThemeData(color: Colors.white, size: 32.0),
              dividerTheme: Themes.darkTheme().themeData.dividerTheme.copyWith(
                    color: Color(0xff444444),
                  ),
              appBarTheme: currentTheme.appBarTheme.copyWith(
                  //backgroundColor: Color(0xFF0c2031),
                  color: currentTheme.colorScheme.background),
              colorScheme: ColorScheme.dark(
                primary: Colors.white,
                secondary: Colors.white,
                onSecondary: Colors.white,
                background: Color(0xFF152a3d),
              ).copyWith(error: Color(0xFFeddc97)),
              switchTheme: SwitchThemeData(
                thumbColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return null;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return Color(0xFF0085fb);
                  }
                  return null;
                }),
                trackColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return null;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return Color(0xFF0085fb);
                  }
                  return null;
                }),
              ),
              radioTheme: currentTheme.radioTheme.copyWith(
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return null;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return Color(0xFF0085fb);
                  }
                  return Colors.white;
                }),
              ),
              checkboxTheme: CheckboxThemeData(
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return null;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return Color(0xFF0085fb);
                  }
                  return null;
                }),
              ),
            ),
  );
}

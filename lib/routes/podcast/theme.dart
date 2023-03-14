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
        return const SizedBox();
      }
      var currentTheme = theme.themeMap[user.themeId];
      return Theme(data: currentTheme, child: child);
    },
  );
}

Widget withPodcastTheme(BreezUserModel user, Widget child) {
  var currentTheme = theme.themeMap[user.themeId];
  return Theme(
    data: user.themeId == "BLUE"
        ? Themes.lightTheme().themeData.copyWith(
              brightness: Brightness.light,
              primaryColor: const Color.fromRGBO(0, 133, 251, 1.0),
              primaryColorLight: const Color.fromRGBO(0, 117, 255, 1.0),
              primaryColorDark: const Color.fromRGBO(19, 85, 191, 1.0),
              sliderTheme: const SliderThemeData(
                valueIndicatorColor: Color.fromRGBO(0, 117, 255, 1.0),
                valueIndicatorTextStyle: TextStyle(color: Colors.white),
              ),
              canvasColor: const Color.fromRGBO(5, 93, 235, 1.0),
              scaffoldBackgroundColor: const Color(0xffffffff),
              bottomAppBarTheme: const BottomAppBarTheme(
                elevation: 0,
                color: Color(0xFF0085fb),
              ),
              cardColor: const Color(0xffffffff),
              dividerColor: const Color.fromRGBO(0, 0, 0, 0.10),
              highlightColor: const Color.fromRGBO(0, 117, 255, 1.0),
              splashColor: const Color(0x66c8c8c8),
              unselectedWidgetColor: const Color(0x8a000000),
              disabledColor: Colors.blueGrey,
              secondaryHeaderColor: const Color(0xfffff3e0),
              textSelectionTheme: const TextSelectionThemeData(
                selectionColor: Color.fromRGBO(0, 117, 255, 0.25),
                selectionHandleColor: Color(0xFF0085fb),
                cursorColor: Color.fromRGBO(0, 133, 251, 1.0),
              ),
              dialogBackgroundColor: const Color(0xffffffff),
              indicatorColor: Colors.orange,
              hintColor: const Color(0x8a000000),
              dialogTheme: currentTheme.dialogTheme,
              buttonTheme: Themes.lightTheme().themeData.buttonTheme.copyWith(
                    colorScheme: Themes.lightTheme()
                        .themeData
                        .buttonTheme
                        .colorScheme
                        .copyWith(
                            primary:
                                currentTheme.primaryTextTheme.labelLarge.color,
                            onPrimary: const Color.fromRGBO(0, 133, 251, 1.0),
                            onSecondary: const Color.fromRGBO(178, 241, 255, 1.0),
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
                            .copyWith(color: const Color.fromRGBO(5, 93, 235, 1.0)),
                        titleLarge: Typography.material2018(
                                platform: TargetPlatform.android)
                            .black
                            .titleLarge
                            .copyWith(
                                fontWeight: FontWeight.w400, fontSize: 14.3),
                      ),
              primaryIconTheme:
                  const IconThemeData(color: Color.fromRGBO(0, 133, 251, 1.0)),
              iconTheme: const IconThemeData(color: Colors.white, size: 32.0),
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: currentTheme.scaffoldBackgroundColor,
              ),
              appBarTheme: currentTheme.appBarTheme.copyWith(
                color: currentTheme.colorScheme.background,
                //backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
                foregroundColor: const Color.fromRGBO(5, 93, 235, 1.0),
              ),
              colorScheme: const ColorScheme.light(
                primary: Color.fromRGBO(0, 117, 255, 1.0),
                secondary: Color.fromRGBO(0, 133, 251, 1.0),
                onSecondary: Colors.black,
                background: Color(0xFFf3f8fc),
              ).copyWith(error: const Color(0xffffe685)),
              switchTheme: SwitchThemeData(
                thumbColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return null;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return const Color.fromRGBO(0, 133, 251, 1.0);
                  }
                  return null;
                }),
                trackColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return null;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return const Color.fromRGBO(0, 133, 251, 1.0);
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
                    return const Color.fromRGBO(0, 133, 251, 1.0);
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
                    return const Color.fromRGBO(0, 133, 251, 1.0);
                  }
                  return null;
                }),
              ),
            )
        : Themes.darkTheme().themeData.copyWith(
              brightness: Brightness.dark,
              primaryColor: const Color(0xFF0085fb),
              primaryColorLight: const Color(0xFF81acf1),
              primaryColorDark: const Color(0xFF0085fb),
              sliderTheme: const SliderThemeData(
                valueIndicatorColor: Color(0xFF0085fb),
                valueIndicatorTextStyle: TextStyle(color: Colors.white),
              ),
              canvasColor: const Color(0xFF0c2031),
              scaffoldBackgroundColor: const Color(0xFF0c2031),
              bottomAppBarTheme: const BottomAppBarTheme(
                elevation: 0,
                color: Color(0xFF0085fb),
              ),
              cardColor: Colors.black,
              dividerColor: Colors.white.withOpacity(0.2),
              highlightColor: const Color(0xFF0085fb),
              splashColor: const Color(0x66c8c8c8),
              unselectedWidgetColor: const Color(0x8a000000),
              disabledColor: const Color(0x77ffffff),
              secondaryHeaderColor: const Color(0xfffff3e0),
              textSelectionTheme: const TextSelectionThemeData(
                selectionColor: Color.fromRGBO(255, 255, 255, 0.25),
                selectionHandleColor: Color(0xFF0085fb),
                cursorColor: Colors.white,
              ),
              dialogBackgroundColor: const Color(0xFF0c2031),
              indicatorColor: const Color(0xFF0085fb),
              hintColor: const Color(0x80ffffff),
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
                            onSecondary: const Color(0xFF0085fb),
                            onSurface: const Color(0x77ffffff)),
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
              primaryIconTheme: const IconThemeData(color: Colors.white),
              iconTheme: const IconThemeData(color: Colors.white, size: 32.0),
              dividerTheme: Themes.darkTheme().themeData.dividerTheme.copyWith(
                    color: const Color(0xff444444),
                  ),
              appBarTheme: currentTheme.appBarTheme.copyWith(
                  //backgroundColor: Color(0xFF0c2031),
                  color: currentTheme.colorScheme.background),
              colorScheme: const ColorScheme.dark(
                primary: Colors.white,
                secondary: Colors.white,
                onSecondary: Colors.white,
                background: Color(0xFF152a3d),
              ).copyWith(error: const Color(0xFFeddc97)),
              switchTheme: SwitchThemeData(
                thumbColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return null;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return const Color(0xFF0085fb);
                  }
                  return null;
                }),
                trackColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return null;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return const Color(0xFF0085fb);
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
                    return const Color(0xFF0085fb);
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
                    return const Color(0xFF0085fb);
                  }
                  return null;
                }),
              ),
            ),
    child: child,
  );
}

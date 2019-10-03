import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'themes.dart';

class CustomTheme extends StatefulWidget {
  final Widget child;
  final ThemeId initialThemeId;

  const CustomTheme({
    Key key,
    this.initialThemeId,
    @required this.child,
  }) : super(key: key);

  @override
  CustomThemeState createState() => new CustomThemeState();

  static CustomThemeState instanceOf(BuildContext context) {
    _CustomTheme inherited = (context.inheritFromWidgetOfExactType(_CustomTheme) as _CustomTheme);
    return inherited.data;
  }

  static ThemeData of(BuildContext context) {
    _CustomTheme inherited = (context.inheritFromWidgetOfExactType(_CustomTheme) as _CustomTheme);
    return inherited.data.theme;
  }
}

class CustomThemeState extends State<CustomTheme> {
  ThemeData _theme;

  ThemeData get theme => _theme;

  @override
  Widget build(BuildContext context) {
    return new _CustomTheme(
      data: this,
      child: widget.child,
    );
  }

  void changeTheme(ThemeId themeKey) {
    setState(() {
      _theme = Themes.getThemeFromId(themeKey);
    });
  }

  @override
  void initState() {
    _theme = Themes.getThemeFromId(widget.initialThemeId);
    super.initState();
  }
}

class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  _CustomTheme({
    this.data,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomTheme oldWidget) {
    return true;
  }
}

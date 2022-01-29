import 'package:anytime/l10n/L.dart';
import 'package:breez/l10n/anytime_localizations_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  // Add ! at the end after enabling non-nullable feature, sdk: >2.12.0
  AppLocalizations get l10n => AppLocalizations.of(this);

  Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates() {
    return [
      AppLocalizations.delegate,
      const LocalisationsDelegate(),
      const AnytimeFallbackLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
  }

  Iterable<Locale> supportedLocales() {
    return [
      const Locale('en', ''),
      const Locale('es', ''),
      const Locale('fi', ''),
      const Locale('pt', ''),
    ];
  }
}

extension MediaQueryExt on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get mediaQuerySize => MediaQuery.of(this).size;

  EdgeInsets get mediaQueryPadding => MediaQuery.of(this).padding;

  EdgeInsets get mediaQueryViewInsets => MediaQuery.of(this).viewInsets;

  double get textScaleFactor => MediaQuery.of(this).textScaleFactor;

  double get minFontSize => (12 / textScaleFactor).floorToDouble();
}

extension NavigatorExt on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  Future<T> push<T>(Route<T> route) => Navigator.push(this, route);

  void pop<T extends Object>([T result]) => Navigator.pop(this, result);

  Future<T> pushNamed<T>(String routeName, {Object arguments}) =>
      Navigator.pushNamed<T>(this, routeName, arguments: arguments);

  bool canPop() => Navigator.canPop(this);

  void popUntil(RoutePredicate predicate) =>
      Navigator.popUntil(this, predicate);
}

extension ThemeExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  AppBarTheme get appBarTheme => Theme.of(this).appBarTheme;

  DialogTheme get dialogTheme => Theme.of(this).dialogTheme;

  IconThemeData get iconTheme => Theme.of(this).iconTheme;

  ListTileThemeData get listTileTheme => ListTileTheme.of(this);

  TextTheme get primaryTextTheme => Theme.of(this).primaryTextTheme;

  Color get backgroundColor => Theme.of(this).backgroundColor;

  Color get canvasColor => Theme.of(this).canvasColor;

  Color get primaryColor => Theme.of(this).primaryColor;

  Color get primaryColorLight => Theme.of(this).primaryColorLight;

  Color get highlightColor => Theme.of(this).highlightColor;

  Color get splashColor => Theme.of(this).splashColor;

  Color get errorColor => Theme.of(this).errorColor;
}

extension ScaffoldExt on BuildContext {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
          SnackBar snackbar) =>
      ScaffoldMessenger.of(this).showSnackBar(snackbar);

  void openDrawer() => Scaffold.of(this).openDrawer();
}

class _Form {
  _Form(this._context);

  final BuildContext _context;

  bool validate() => Form.of(_context).validate();

  void reset() => Form.of(_context).reset();

  void save() => Form.of(_context).save();
}

extension FormExt on BuildContext {
  _Form get form => _Form(this);
}

class _FocusScope {
  const _FocusScope(this._context);

  final BuildContext _context;

  FocusScopeNode _node() => FocusScope.of(_context);

  bool get hasFocus => _node().hasFocus;

  bool get hasPrimaryFocus => _node().hasPrimaryFocus;

  void nextFocus() => _node().nextFocus();

  void requestFocus([FocusNode node]) => _node().requestFocus(node);

  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) =>
      _node().unfocus(disposition: disposition);
}

extension FocusScopeExt on BuildContext {
  _FocusScope get focusScope => _FocusScope(this);

  void hideKeyboard() => this.focusScope.requestFocus(FocusNode());
}

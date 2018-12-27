
import 'package:breez/bloc/app_blocs.dart';
import 'package:flutter/material.dart';

class AppBlocsProvider extends InheritedWidget {

  final AppBlocs appBlocs;

  AppBlocsProvider({Key key, Widget child, this.appBlocs}) : super(key: key, child: child);
  
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {    
    return true;
  }

  static AppBlocs of(BuildContext context) {
    AppBlocsProvider widget = context.inheritFromWidgetOfExactType(AppBlocsProvider);
    if (widget == null) {
      return null;
    }

    return widget.appBlocs;
  }
}
import 'package:breez/bloc/app_blocs.dart';
import 'package:flutter/material.dart';

class AppBlocsProvider extends InheritedWidget {
  final AppBlocs appBlocs;

  const AppBlocsProvider({Key key, Widget child, this.appBlocs})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static T of<T>(BuildContext context) {
    AppBlocsProvider widget =
        context.dependOnInheritedWidgetOfExactType<AppBlocsProvider>();
    if (widget == null) {
      return null;
    }
    return widget.appBlocs.getBloc<T>();
  }
}

abstract class Bloc {
  void dispose();
}

class BlocProvider<T extends Bloc> extends StatefulWidget {
  final T Function() creator;
  final WidgetBuilder builder;

  const BlocProvider({Key key, this.creator, this.builder}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BlocProviderState<T>();
  }

  static T of<T>(BuildContext context) {
    return _Inherited.of<T>(context);
  }
}

class _BlocProviderState<T extends Bloc> extends State<BlocProvider<T>> {
  T _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.creator();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Inherited<T>(bloc: _bloc, child: widget.builder(context));
  }
}

class _Inherited<T> extends InheritedWidget {
  final T bloc;

  const _Inherited({Key key, Widget child, this.bloc})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static T of<T>(BuildContext context) {
    _Inherited widget =
        context.dependOnInheritedWidgetOfExactType<_Inherited<T>>();
    if (widget == null) {
      return null;
    }
    return widget.bloc;
  }
}

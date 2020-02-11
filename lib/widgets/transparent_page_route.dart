import 'package:flutter/material.dart';

class TransparentPageRoute<T> extends ModalRoute<T> {
  final Widget Function(BuildContext context) builder;

  TransparentPageRoute(this.builder);

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  bool get maintainState => false;

  @override
  Duration get transitionDuration => Duration(seconds: 0);
}

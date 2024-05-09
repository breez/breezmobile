// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';

const double _kBreezDrawerHeaderHeight = 160.0 + 1.0; // bottom edge

class BreezDrawerHeader extends DrawerHeader {
  @override
  final Decoration decoration;
  @override
  final EdgeInsetsGeometry padding;
  @override
  final EdgeInsetsGeometry margin;
  @override
  final Duration duration;
  @override
  final Curve curve;
  @override
  final Widget child;

  const BreezDrawerHeader({
    Key key,
    this.decoration,
    this.margin = const EdgeInsets.only(bottom: 16.0),
    this.padding = const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.fastOutSlowIn,
    @required this.child,
  }) : super(key: key, child: child);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMediaQuery(context));
    final ThemeData theme = Theme.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: statusBarHeight + _kBreezDrawerHeaderHeight,
      margin: margin,
      child: AnimatedContainer(
        padding: padding.add(EdgeInsets.only(top: statusBarHeight)),
        decoration: decoration,
        duration: duration,
        curve: curve,
        child: child == null
            ? null
            : DefaultTextStyle(
                style: theme.textTheme.headlineMedium,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: child,
                ),
              ),
      ),
    );
  }
}

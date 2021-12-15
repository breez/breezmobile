import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Given 2 items, lets say "Big and long text" and "Small text", it will place items as follow:
/// | <Nothing> <Text> <1/2 of space> <Divider centered on screen> <1/2 of space> <Text> <Nothing> |
///
/// To be able to properly center the divider and equally add spaces on its side
/// and set text aligned to the divider we must precalculate the text size and check
/// how much space we have left on the screen and based on that we set the divider width
class ViewSwitch extends StatelessWidget {
  final int selected;
  final Color tint;
  final Color textTint;
  final List<ViewSwitchItem> items;

  const ViewSwitch({
    this.selected: 0,
    this.tint: Colors.white,
    this.textTint: Colors.white,
    this.items: const [],
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final size = MediaQuery.of(context).size;

    var maxTextWidth = 0.0;
    var index = 0;
    for (var item in items) {
      final itemTextWidth = _textSize(themeData, index, item.text).width;
      maxTextWidth = max(maxTextWidth, itemTextWidth);
      index++;
    }

    var emptyWidth = size.width;
    for (var item in items) {
      emptyWidth -= maxTextWidth;
      if (item.iconData != null) {
        emptyWidth -= 24;
      }
    }

    List<Widget> children = [];
    index = 0;
    for (var item in items) {
      if (index > 0) {
        children.add(
          Container(
            height: 20,
            child: VerticalDivider(
              width: max(16, emptyWidth / items.length),
              color: tint,
            ),
          ),
        );
      }

      children.add(
        Flexible(
          flex: 1,
          child: Align(
            alignment: _alignment(index),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: item.onTap,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 48.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _icon(themeData, item, index),
                    Text(
                      item.text,
                      style: _textStyle(themeData, index),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      index++;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  Widget _icon(ThemeData themeData, ViewSwitchItem item, int index) {
    if (item.iconData == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Icon(
        item.iconData,
        color: tint.withOpacity(selected == index ? 1 : 0.5),
      ),
    );
  }

  Alignment _alignment(int index) {
    if (index == 0) return Alignment.centerRight;
    if (index == items.length - 1) return Alignment.centerLeft;
    return Alignment.center;
  }

  Size _textSize(ThemeData themeData, int index, String text) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: _textStyle(themeData, index)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  TextStyle _textStyle(ThemeData themeData, index) {
    return themeData.textTheme.button.copyWith(
      color: textTint.withOpacity(selected == index ? 1 : 0.5),
    );
  }
}

class ViewSwitchItem {
  final String text;
  final IconData iconData;
  final GestureTapCallback onTap;

  const ViewSwitchItem(
    this.text,
    this.onTap, {
    this.iconData,
  });
}

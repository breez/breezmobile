import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class WarningBox extends StatelessWidget {
  final EdgeInsets boxPadding;
  final EdgeInsets contentPadding;
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;

  WarningBox({
    this.child,
    this.boxPadding,
    this.contentPadding,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: boxPadding ??
          const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
      child: Container(
          padding: contentPadding ??
              EdgeInsets.symmetric(horizontal: 12.3, vertical: 16.2),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: backgroundColor ?? theme.warningBoxColor,
              borderRadius: BorderRadius.all(Radius.circular(6)),
              border: Border.all(
                  color: borderColor != null
                      ? borderColor
                      : theme.themeId == "BLUE"
                          ? Color.fromRGBO(250, 239, 188, 0.6)
                          : Color.fromRGBO(227, 180, 47, 0.6))),
          child: this.child),
    );
  }
}

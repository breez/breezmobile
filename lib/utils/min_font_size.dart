import 'package:flutter/material.dart';

class MinFontSize {
  final BuildContext context;
  final double fontSize;

  MinFontSize(this.context, {this.fontSize});

  double get minFontSize =>
      ((fontSize ?? 12) / MediaQuery.of(context).textScaleFactor)
          .floorToDouble();
}

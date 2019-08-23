import 'package:flutter/material.dart';

class MinFontSize {
  final BuildContext context;
  final double fontSize;

  MinFontSize(this.context, {this.fontSize});

  double get minFontSize => ((this.fontSize ?? 12) / MediaQuery.of(this.context).textScaleFactor).floorToDouble();
}

import 'package:flutter/material.dart';

class MinFontSize {
  final BuildContext context;

  MinFontSize(this.context);

  double get minFontSize => (12 / MediaQuery.of(this.context).textScaleFactor).floorToDouble();
}

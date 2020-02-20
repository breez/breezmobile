import 'dart:math';

import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class SuccessAvatar extends StatelessWidget {
  const SuccessAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        width: 20.0 * 2,
        height: 20.0 * 2,
        alignment: FractionalOffset.center,
        child: Transform(
            transform: Matrix4.identity()..rotateY(pi),
            alignment: Alignment.center,
            child: Icon(Icons.check, color: theme.BreezColors.blue[500])));
  }
}

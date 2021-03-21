import 'dart:math';

import 'package:flutter/material.dart';

class SuccessAvatar extends StatelessWidget {
  final double radius;

  const SuccessAvatar({Key key, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: Transform(
        transform: Matrix4.identity()..rotateY(pi),
        alignment: Alignment.center,
        child: Icon(
          Icons.check_rounded,
          color: Color(0xb3303234),
        ),
      ),
    );
  }
}

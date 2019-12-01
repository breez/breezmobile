import 'package:flutter/material.dart';

class AlignMiddle extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  AlignMiddle({this.child, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[child],
      ),
    );
  }
}

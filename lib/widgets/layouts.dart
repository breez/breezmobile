import 'package:flutter/material.dart';

class AlignMiddle extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  const AlignMiddle({this.child, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[child],
      ),
    );
  }
}

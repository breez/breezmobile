import 'package:flutter/material.dart';

class ListLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Image.asset(
          "src/images/waves-home.png",
          fit: BoxFit.contain,
          width: double.infinity,
          alignment: Alignment.bottomCenter,
        )
      ],
    );
  }
}

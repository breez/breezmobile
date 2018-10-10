import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: FractionalOffset.center, children: <Widget>[
      new CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(51, 255, 255, 0.7),),
        backgroundColor: Colors.red,
      ),
    ]);
  }
}

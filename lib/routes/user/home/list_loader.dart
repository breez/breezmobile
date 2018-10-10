import 'package:flutter/material.dart';

class ListLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double oneThird = MediaQuery.of(context).size.width / 3;
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(top: 0.0, left: oneThird, right: oneThird, bottom: oneThird),
          child: new Image.asset(
            'src/images/splash-animation.gif',
            fit: BoxFit.contain,
            gaplessPlayback: true,
            alignment: Alignment.center,
          ),
        ),
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

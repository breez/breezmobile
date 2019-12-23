import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final double width;

  const CircularButton({
    Key key,
    @required this.child,
    @required this.onTap,
    @required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        customBorder: new CircleBorder(),
        child: Container(
            width: width,
            child: FlatButton(padding: EdgeInsets.all(16), child: child)),
        onTap: onTap);
  }
}

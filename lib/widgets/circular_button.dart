import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Widget child;
  final Function onTap;

  const CircularButton({
    Key key,
    @required this.child,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        customBorder: CircleBorder(),
        child: Container(
          child: TextButton( // ignore: missing_required_param
              style: TextButton.styleFrom(padding: EdgeInsets.all(24)),
              child: child),
        ),
        onTap: onTap);
  }
}

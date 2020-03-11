import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  final Function onPressed;
  final IconData iconData;

  BackButton({this.onPressed, this.iconData});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(iconData ?? IconData(0xe906, fontFamily: 'icomoon')),
        onPressed: this.onPressed ??
            () {
              Navigator.pop(context);
            });
  }
}

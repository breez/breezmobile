import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  final Function onPressed;
  final IconData iconData;

  const BackButton({this.onPressed, this.iconData});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(iconData ?? const IconData(0xe906, fontFamily: 'icomoon')),
        onPressed: onPressed ??
            () {
              Navigator.pop(context);
            });
  }
}

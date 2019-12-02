import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  final Function onPressed;

  BackButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(IconData(0xe906, fontFamily: 'icomoon')),
        onPressed: this.onPressed ??
            () {
              Navigator.pop(context);
            });
  }
}

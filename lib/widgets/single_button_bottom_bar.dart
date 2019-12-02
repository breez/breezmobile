import 'package:flutter/material.dart';

class SingleButtonBottomBar extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SingleButtonBottomBar({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
                height: 48.0,
                width: 168.0,
                child: SubmitButton(
                  this.text,
                  this.onPressed,
                ))
          ],
        ));
  }
}

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SubmitButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 48.0,
        width: 168.0,
        child: RaisedButton(
          child: Text(
            this.text,
            style: Theme.of(context).textTheme.button,
          ),
          color: Theme.of(context).buttonColor,
          elevation: 0.0,
          shape: const StadiumBorder(),
          onPressed: this.onPressed,
        ));
  }
}

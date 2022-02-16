import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SingleButtonBottomBar extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool stickToBottom;

  const SingleButtonBottomBar({
    this.text,
    this.onPressed,
    this.stickToBottom = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: this.stickToBottom
            ? MediaQuery.of(context).viewInsets.bottom + 40.0
            : 40.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 48.0,
              minWidth: 168.0,
            ),
            child: SubmitButton(
              this.text,
              this.onPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SubmitButton(
    this.text,
    this.onPressed,
  );

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 48.0,
        minWidth: 168.0,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).buttonColor,
          elevation: 0.0,
          shape: const StadiumBorder(),
        ),
        child: AutoSizeText(
          this.text,
          maxLines: 1,
          style: Theme.of(context).textTheme.button,
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}

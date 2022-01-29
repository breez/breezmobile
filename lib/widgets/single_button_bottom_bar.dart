import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/utils/build_context.dart';
import 'package:flutter/material.dart';

import '../theme_data.dart';

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
            ? context.mediaQueryViewInsets.bottom + 40.0
            : 40.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 48.0,
            width: 168.0,
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
    ThemeData theme = context.theme;
    TextTheme textTheme = theme.textTheme;

    return SizedBox(
      height: 48.0,
      width: 168.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary:
              (themeId == "BLUE") ? Colors.white : context.primaryColorLight,
          elevation: 0.0,
          shape: const StadiumBorder(),
        ),
        child: AutoSizeText(
          this.text,
          maxLines: 1,
          style: textTheme.button,
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}

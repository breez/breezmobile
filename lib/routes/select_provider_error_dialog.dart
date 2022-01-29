import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void showProviderErrorDialog(
    BuildContext context, String error, Function() onSelect) {
  String message = "In order to activate Breez, please ";
  if (error != null) {
    message =
        "There was an error connecting to the selected provider. " + message;
  }
  DialogTheme dialogTheme = context.dialogTheme;

  promptError(
    context,
    "Connection Error",
    RichText(
      text: TextSpan(
          style: dialogTheme.contentTextStyle,
          text: message,
          children: <TextSpan>[
            TextSpan(
                text: "select ",
                style: theme.blueLinkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    context.pop();
                    onSelect();
                  }),
            TextSpan(text: "a provider.", style: dialogTheme.contentTextStyle),
          ]),
    ),
  );
}

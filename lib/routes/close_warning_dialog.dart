import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CloseWarningDialog extends StatelessWidget {
  final int inactiveDuration;

  const CloseWarningDialog(
    this.inactiveDuration,
  );

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Theme(
      data: themeData.copyWith(
        unselectedWidgetColor: themeData.canvasColor,
      ),
      child: AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
        title: Text(
          texts.close_warning_dialog_title,
          style: themeData.dialogTheme.titleTextStyle,
        ),
        contentPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _getContent(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              texts.close_warning_dialog_action_ok,
              style: themeData.primaryTextTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getContent(
    BuildContext context,
  ) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return [
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 12.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: texts.close_warning_dialog_message_begin(
                  inactiveDuration ~/ 86400,
                ),
                style: themeData.primaryTextTheme.displaySmall.copyWith(
                  fontSize: 16,
                ),
              ),
              _LinkTextSpan(
                text: texts.close_warning_dialog_message_middle,
                url: texts.close_warning_dialog_url,
                style: themeData.primaryTextTheme.displaySmall.copyWith(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
              TextSpan(
                text: texts.close_warning_dialog_message_end,
                style: themeData.primaryTextTheme.displaySmall.copyWith(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({
    TextStyle style,
    String url,
    String text,
  }) : super(
          style: style,
          text: text ?? url,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchUrlString(url);
            },
        );
}

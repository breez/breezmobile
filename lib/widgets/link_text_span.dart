import 'package:breez/utils/external_browser.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LinkTextSpan extends TextSpan {
  LinkTextSpan({
    TextStyle style,
    String url,
    String text,
  }) : super(
          style: style,
          text: text ?? url,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchLinkOnExternalBrowser(url);
            },
        );
}

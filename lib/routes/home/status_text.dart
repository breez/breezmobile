import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme_data.dart';

class StatusText extends StatefulWidget {
  final AccountModel account;
  final String message;

  StatusText(this.account, {this.message});

  @override
  State<StatefulWidget> createState() {
    return _StatusTextState();
  }
}

class _StatusTextState extends State<StatusText> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = context.theme;
    TextTheme textTheme = themeData.textTheme;
    Color secondaryColor =
        (themeId == "BLUE") ? BreezColors.grey[600] : Colors.white;

    if (widget.message != null) {
      return LoadingAnimatedText(widget.message);
    }

    if (widget.account.processingConnection) {
      return LoadingAnimatedText("",
          textAlign: TextAlign.center,
          textElements: <TextSpan>[
            TextSpan(
                text: "Breez is ",
                style: textTheme.bodyText2.copyWith(color: secondaryColor)),
            _LinkTextSpan(
                text: "opening a secure channel",
                url: widget.account.channelFundingTxUrl,
                style: textTheme.bodyText2.copyWith(
                    color: secondaryColor,
                    decoration: TextDecoration.underline)),
            // style: theme.blueLinkStyle),
            TextSpan(
              text:
                  " with our server. This might take a while, but don't worry, we'll notify you when the app is ready to send and receive payments.",
              style: textTheme.bodyText2.copyWith(color: secondaryColor),
            )
          ]);
    }

    if (widget.account == null || widget.account.statusMessage == null) {
      return AutoSizeText(
        "Breez is ready to receive funds.",
        style: textTheme.bodyText2.copyWith(color: secondaryColor),
        textAlign: TextAlign.center,
        minFontSize: context.minFontSize,
        stepGranularity: 0.1,
      );
    }

    var swapError = widget.account.swapFundsStatus?.error;
    bool loading = swapError == null || swapError.isEmpty;
    return loading
        ? LoadingAnimatedText(widget.account.statusMessage)
        : Text(widget.account.statusMessage,
            style: textTheme.bodyText2.copyWith(color: secondaryColor),
            textAlign: TextAlign.center);
  }
}

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(url, forceSafariVC: false);
              });
}

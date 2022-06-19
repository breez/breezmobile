import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StatusText extends StatelessWidget {
  final AccountModel account;
  final String message;

  const StatusText(
    this.account, {
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    if (message != null) {
      return LoadingAnimatedText(message);
    }

    if (account.processingConnection) {
      return LoadingAnimatedText(
        "",
        textAlign: TextAlign.center,
        textElements: [
          TextSpan(
            text: texts.status_text_loading_begin,
            style: themeData.accentTextTheme.bodyText2,
          ),
          _LinkTextSpan(
            text: texts.status_text_loading_middle,
            url: account.channelFundingTxUrl,
            style: themeData.accentTextTheme.bodyText2.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(
            text: texts.status_text_loading_end,
            style: themeData.accentTextTheme.bodyText2,
          ),
        ],
      );
    }

    if (account == null || account.statusMessage == null) {
      return AutoSizeText(
        texts.status_text_ready,
        style: themeData.accentTextTheme.bodyText2,
        textAlign: TextAlign.center,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
      );
    }

    var swapError = account.swapFundsStatus?.error;
    bool loading = swapError == null || swapError.isEmpty;
    return loading
        ? LoadingAnimatedText(account.statusMessage)
        : Text(
            account.statusMessage,
            style: themeData.accentTextTheme.bodyText2,
            textAlign: TextAlign.center,
          );
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

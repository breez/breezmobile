import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/theme_data.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/link_text_span.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

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
    final texts = context.texts();

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
            style: themeData.statusTextStyle,
          ),
          LinkTextSpan(
            text: texts.status_text_loading_middle,
            url: account.channelFundingTxUrl,
            style: themeData.statusTextStyle.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(
            text: texts.status_text_loading_end,
            style: themeData.statusTextStyle,
          ),
        ],
      );
    }

    if (account == null || account.statusMessage == null) {
      return AutoSizeText(
        texts.status_text_ready,
        style: themeData.statusTextStyle,
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
            style: themeData.statusTextStyle,
            textAlign: TextAlign.center,
          );
  }
}

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/home/moonpay_route.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

import 'error_dialog.dart';

promptLSPFeeAndNavigate(
  BuildContext context,
  AccountModel account,
  OpeningFeeParams longestValidOpeningFeeParams,
  String route,
) {
  final themeData = Theme.of(context);
  final navigator = Navigator.of(context);
  final texts = context.texts();

  promptAreYouSure(
    context,
    texts.lsp_fee_warning_title,
    Text(
      _formatFeeMessage(context, account, longestValidOpeningFeeParams),
      style: themeData.dialogTheme.contentTextStyle,
    ),
    cancelText: texts.lsp_fee_warning_action_cancel,
    okText: texts.lsp_fee_warning_action_ok,
  ).then((ok) {
    if (ok) {
      if (route == "/buy_bitcoin") {
        showMoonpayWebview(context);
      } else {
        navigator.pushNamed(route);
      }
    }
  });
}

String _formatFeeMessage(
  BuildContext context,
  AccountModel acc,
  OpeningFeeParams longestValidOpeningFeeParams,
) {
  if (longestValidOpeningFeeParams == null) return "";
  final texts = context.texts();
  final int minFee = (longestValidOpeningFeeParams.minMsat.toInt() ~/ 1000);
  final showMinFeeMessage = minFee > 0;
  final connected = acc.connected;

  final minFeeFormatted = acc.currency.format(
    longestValidOpeningFeeParams.minMsat ~/ 1000,
  );
  final setUpFee = (longestValidOpeningFeeParams.proportional / 10000).toString();
  final liquidity = acc.currency.format(acc.maxInboundLiquidity);

  if (connected && showMinFeeMessage) {
    return texts.invoice_lightning_warning_with_min_fee_account_connected(
      setUpFee,
      minFeeFormatted,
      liquidity,
    );
  } else if (connected && !showMinFeeMessage) {
    return texts.invoice_lightning_warning_without_min_fee_account_connected(
      setUpFee,
      liquidity,
    );
  } else if (!connected && showMinFeeMessage) {
    return texts.invoice_lightning_warning_with_min_fee_account_not_connected(
      setUpFee,
      minFeeFormatted,
    );
  } else {
    return texts.invoice_lightning_warning_without_min_fee_account_not_connected(
      setUpFee,
    );
  }
}

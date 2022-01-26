import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/routes/home/moonpay_route.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/l10n/locales.dart';

import 'error_dialog.dart';

promptLSPFeeAndNavigate(
  BuildContext context,
  AccountModel account,
  LSPInfo lsp,
  String route,
) {
  promptAreYouSure(
    context,
    context.l10n.lsp_fee_warning_title,
    Text(
      _formatFeeMessage(context, account, lsp),
      style: Theme.of(context).dialogTheme.contentTextStyle,
    ),
    cancelText: context.l10n.lsp_fee_warning_action_cancel,
    okText: context.l10n.lsp_fee_warning_action_ok,
  ).then((ok) {
    if (ok) {
      if (route == "/buy_bitcoin") {
        showMonpayWebview(context);
      } else {
        Navigator.of(context).pushNamed(route);
      }
    }
  });
}

String _formatFeeMessage(
  BuildContext context,
  AccountModel acc,
  LSPInfo lsp,
) {
  if (lsp == null) return "";
  final showMinFeeMessage = lsp.channelMinimumFeeMsat > 0;
  final connected = acc.connected;

  final minFeeFormatted = acc.currency.format(
    Int64(lsp.channelMinimumFeeMsat ?? 0) ~/ 1000,
  );
  final setUpFee = (lsp.channelFeePermyriad / 100).toString();
  final liquidity = acc.currency.format(acc.maxInboundLiquidity);

  if (connected && showMinFeeMessage) {
    return context.l10n.invoice_ln_address_warning_with_min_fee_account_connected(
      setUpFee,
      minFeeFormatted,
      liquidity,
    );
  } else if (connected && !showMinFeeMessage) {
    return context.l10n.invoice_ln_address_warning_without_min_fee_account_connected(
      setUpFee,
      liquidity,
    );
  } else if (!connected && showMinFeeMessage) {
    return context.l10n.invoice_ln_address_warning_with_min_fee_account_not_connected(
      setUpFee,
      minFeeFormatted,
    );
  } else {
    return context.l10n
        .invoice_ln_address_warning_without_min_fee_account_not_connected(
      setUpFee,
    );
  }
}

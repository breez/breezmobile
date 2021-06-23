import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/routes/home/moonpay_route.dart';
import 'package:flutter/material.dart';

import 'error_dialog.dart';

promptLSPFeeAndNavigate(
    BuildContext context, AccountModel account, LSPInfo lsp, String route) {
  var navigator = Navigator.of(context);
  promptAreYouSure(
          context,
          "Setup Fee",
          Text(_formatFeeMessage(account, lsp),
              style: Theme.of(context).dialogTheme.contentTextStyle),
          cancelText: "CANCEL",
          okText: "OK")
      .then((ok) {
    if (ok) {
      if (route == "/buy_bitcoin") {
        showMonpayWebview(context);
      } else {
        navigator.pushNamed(route);
      }
    }
  });
}

String _formatFeeMessage(AccountModel acc, LSPInfo lsp) {
  String minFees = (lsp != null && lsp.channelMinimumFeeMsat > 0) ? "with a minimum of ${lsp.channelMinimumFeeMsat / 1000} sats " : "";
  if (acc.connected) {
    var liquidity = acc.currency.format(acc.maxInboundLiquidity);
    return "A setup fee of ${lsp.channelFeePermyriad / 100}% ${minFees}will be applied for buying more than $liquidity.";
  }
  return "A setup fee of ${lsp.channelFeePermyriad / 100}% ${minFees}will be applied on the received amount.";
}

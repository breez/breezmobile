import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
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
      navigator.pushNamed(route);
    }
  });
}

String _formatFeeMessage(AccountModel acc, LSPInfo lsp) {
  if (acc.connected) {
    var liquidity = Currency.SAT.format(acc.maxInboundLiquidity);
    return "A setup fee of ${lsp.channelFeePermyriad / 100}% will be applied for buying more than $liquidity.";
  }
  return "A setup fee of ${lsp.channelFeePermyriad / 100}% will be applied on the received amount.";
}

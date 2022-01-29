import 'package:breez/utils/build_context.dart';
import 'package:flutter/cupertino.dart';

// Some times you have to construct a model that needs a text but you are out
// of a BuildContext context, using TextUri you link it to a text and the
// consumer reads the real text using its BuildContext
enum TextUri {
  BOTTOM_ACTION_BAR_BUY_BITCOIN,
  BOTTOM_ACTION_BAR_RECEIVE_BTC_ADDRESS,
}

String textFromUri(
  BuildContext context,
  TextUri uri, {
  String def: "",
}) {
  var l10n = context.l10n;

  if (uri == null) return def;
  switch (uri) {
    case TextUri.BOTTOM_ACTION_BAR_BUY_BITCOIN:
      return l10n.bottom_action_bar_buy_bitcoin;
    case TextUri.BOTTOM_ACTION_BAR_RECEIVE_BTC_ADDRESS:
      return l10n.bottom_action_bar_receive_btc_address;
  }
  return def;
}

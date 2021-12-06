import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Some times you have to construct a model that needs a text but you are out
// of a BuildContext context, using TextUri you link it to a text and the
// consumer reads the real text using its BuildContext
enum TextUri {
  BOTTOM_ACTION_BAR_BUY_BITCOIN,
  BOTTOM_ACTION_BAR_RECEIVE_BTC_ADDRESS,
}

String textFromUri(
  AppLocalizations texts,
  TextUri uri, {
  String def: "",
}) {
  if (uri == null) return def;
  switch (uri) {
    case TextUri.BOTTOM_ACTION_BAR_BUY_BITCOIN:
      return texts.bottom_action_bar_buy_bitcoin;
    case TextUri.BOTTOM_ACTION_BAR_RECEIVE_BTC_ADDRESS:
      return texts.bottom_action_bar_receive_btc_address;
  }
  return def;
}

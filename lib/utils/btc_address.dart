import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';

Map<String, String> parseBTCAddress(
    String scannedString, AccountModel account) {
  Map<String, String> btcAddressMap = Map<String, String>();
  try {
    Uri uri = Uri.parse(scannedString);
    String amount = uri.queryParameters["amount"];
    btcAddressMap["address"] = uri.path;
    if (amount != null) {
      btcAddressMap["amount"] = account.currency.format(
          Currency.BTC.toSats(double.parse(amount)),
          userInput: true,
          includeDisplayName: false,
          removeTrailingZeros: true);
    }
  } on FormatException {} // do nothing.
  return btcAddressMap;
}

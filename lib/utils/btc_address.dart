import 'package:breez/bloc/user_profile/currency.dart';
import 'package:fixnum/fixnum.dart';

BTCAddressInfo parseBTCAddress(String scannedString) {
  String address;
  Int64 satAmount;
  Uri uri = Uri.tryParse(scannedString);
  if (uri != null) {
    address = uri.path;
    if (uri.queryParameters["amount"] != null) {
      double btcAmount = double.tryParse(uri.queryParameters["amount"]);
      satAmount = btcAmount != null ? Currency.BTC.toSats(btcAmount) : null;
    }
  }
  return BTCAddressInfo(address, satAmount: satAmount);
}

class BTCAddressInfo {
  final String address;
  final Int64 satAmount;

  BTCAddressInfo(this.address, {this.satAmount});
}

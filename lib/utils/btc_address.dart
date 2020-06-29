import 'package:breez/bloc/user_profile/currency.dart';
import 'package:fixnum/fixnum.dart';

BTCAddressInfo parseBTCAddress(String scannedString) {
  Uri uri = Uri.parse(scannedString);
  String address = uri.path;
  Int64 satAmount;
  if (uri.queryParameters["amount"] != null)
    satAmount =
        Currency.BTC.toSats(double.parse(uri.queryParameters["amount"]));
  return BTCAddressInfo(address, satAmount: satAmount);
}

class BTCAddressInfo {
  final String address;
  final Int64 satAmount;

  BTCAddressInfo(this.address, {this.satAmount});
}

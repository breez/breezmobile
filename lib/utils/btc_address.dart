import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/services/injector.dart';
import 'package:fixnum/fixnum.dart';

Future<BTCAddressInfo> parseBTCAddress(String scannedString) {
  Uri uri = Uri.parse(scannedString);
  String address = uri.path;
  Int64 satAmount;
  if (uri.queryParameters["amount"] != null)
    satAmount =
        Currency.BTC.toSats(double.parse(uri.queryParameters["amount"]));
  return ServiceInjector()
      .breezBridge
      .validateAddress(address)
      .then((_) => BTCAddressInfo(address, satAmount: satAmount))
      .catchError((err) => null);
}

class BTCAddressInfo {
  final String address;
  final Int64 satAmount;

  BTCAddressInfo(this.address, {this.satAmount});
}

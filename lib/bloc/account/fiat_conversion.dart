import 'package:breez/services/currency_data.dart';
import 'package:fixnum/fixnum.dart';

class FiatConversion {
  CurrencyData currencyData;
  double exchangeRate;

  FiatConversion(this.currencyData, this.exchangeRate);

  String get logoPath {
    switch (currencyData.symbol) {
      case "€":
        return "src/icon/btc_eur.png";
      case "£":
        return "src/icon/btc_gbp.png";
      case "¥":
        return "src/icon/btc_yen.png";
      case "\$":
        return "src/icon/btc_usd.png";
      default:
        return "src/icon/btc_convert.png";
    }
  }

  Int64 fiatToSat(double fiatAmount) {
    return Int64((fiatAmount / this.exchangeRate * 100000000).round());
  }

  double satToFiat(Int64 satoshies) {
    return satoshies.toDouble() / 100000000 * this.exchangeRate;
  }

  String format(Int64 amount, {bool toFiat}) {
    String _formattedAmount;
    if (toFiat ?? false) {
      _formattedAmount = satToFiat(amount).toStringAsFixed(this.currencyData.fractionSize);
      // Add '<' prefix if the converted value is below 0.01
      if (satToFiat(amount) < 0.01) {
        return "< ${this.currencyData.symbol}0.01";
      }
    } else {
      _formattedAmount = fiatToSat(amount.toDouble()).toString();
      // Add '<' prefix if the converted value is below 0.01
      if (fiatToSat(amount.toDouble()) < 0.01) {
        return "< ${this.currencyData.symbol}0.01";
      }
    }
    return "${this.currencyData.symbol}$_formattedAmount";
  }
}

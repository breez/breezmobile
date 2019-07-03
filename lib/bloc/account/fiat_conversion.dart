import 'package:breez/services/currency_data.dart';

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

  double convertToBTC(double fiatAmount) {
    return fiatAmount / this.exchangeRate;
  }

  double convertToFiat(double satoshies) {
    return satoshies / 100000000 * this.exchangeRate;
  }

  String format(double amount, {bool toFiat}) {
    String _formattedAmount;
    if (toFiat ?? false) {
      _formattedAmount = convertToFiat(amount).toStringAsFixed(this.currencyData.fractionSize);
      // Add '<' prefix if the converted value is below 0.01
      if (convertToFiat(amount) < 0.01) {
        return "< ${this.currencyData.symbol}0.01";
      }
    } else {
      _formattedAmount = convertToBTC(amount).toStringAsFixed(this.currencyData.fractionSize);
      // Add '<' prefix if the converted value is below 0.01
      if (convertToBTC(amount) < 0.01) {
        return "< ${this.currencyData.symbol}0.01";
      }
    }
    return "${this.currencyData.symbol}$_formattedAmount";
  }
}

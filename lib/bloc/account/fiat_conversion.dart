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

  double convert(double amount) {
    return amount / this.exchangeRate;
  }

  String format(double amount) {
    String _formattedAmount = convert(amount).toStringAsFixed(this.currencyData.fractionSize);
    // Add '<' prefix if the converted value is below 0.01
    if(convert(amount) < 0.01){
      return "< ${this.currencyData.symbol}0.01";
    }
    return "${this.currencyData.symbol}$_formattedAmount";
  }
}

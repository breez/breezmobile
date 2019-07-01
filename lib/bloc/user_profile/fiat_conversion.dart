import 'package:breez/bloc/user_profile/currency_data.dart';

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
    // TODO: Add '>' prefix if the converted value is below 1 and trailing digits without zeros exceed fractionSize
    return convert(amount).toStringAsFixed(this.currencyData.fractionSize);
  }
}

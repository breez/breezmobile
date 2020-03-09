import 'dart:math';

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

  String format(Int64 amount) {
    double fiatValue = satToFiat(amount);
    return formatFiat(fiatValue);
  }

  String formatFiat(double fiatAmount,
      {bool addCurrencyPrefix = true, bool removeTrailingZeros = false}) {
    int fractionSize = this.currencyData.fractionSize;
    double minimumAmount = 1 / (pow(10, fractionSize));

    String formattedAmount = "";
    String prefix = '${this.currencyData.symbol}';
    // if conversion result is less than the minimum it doesn't make sense to display
    // it.
    if (fiatAmount < minimumAmount) {
      formattedAmount += minimumAmount.toStringAsFixed(fractionSize);
      prefix = '< ' + prefix;
    } else {
      // Otherwise just show the formatted value.
      formattedAmount += fiatAmount.toStringAsFixed(fractionSize);
    }
    if (addCurrencyPrefix) {
      formattedAmount = prefix + formattedAmount;
    }
    if (removeTrailingZeros) {
      RegExp removeTrailingZeros = RegExp(r"([.]0*)(?!.*\d)");
      formattedAmount.replaceAll(removeTrailingZeros, "");
    }
    return formattedAmount;
  }
}

import 'dart:math';

import 'package:breez/services/currency_data.dart';
import 'package:breez/utils/currency_formatter.dart';
import 'package:fixnum/fixnum.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';

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

  RegExp get whitelistedPattern => this.currencyData.fractionSize == 0
      ? RegExp(r'\d+')
      : RegExp("^\\d+\\.?\\d{0,${this.currencyData.fractionSize ?? 2}}");

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

  String formatFiat(
    double fiatAmount, {
    bool addCurrencyPrefix = true,
    bool removeTrailingZeros = false,
    bool allowBelowMin = false,
  }) {
    int fractionSize = this.currencyData.fractionSize;
    double minimumAmount = 1 / (pow(10, fractionSize));

    String formattedAmount = "";
    String prefix = '${this.currencyData.symbol}';
    // if conversion result is less than the minimum it doesn't make sense to display
    // it.
    if (!allowBelowMin && fiatAmount < minimumAmount) {
      formattedAmount = minimumAmount.toStringAsFixed(fractionSize);
      prefix = '< ' + prefix;
    } else {
      final formatter = CurrencyFormatter().formatter;
      formatter.minimumFractionDigits = fractionSize;
      formatter.maximumFractionDigits = fractionSize;
      formattedAmount = formatter.format(fiatAmount);
    }
    if (addCurrencyPrefix) {
      formattedAmount = prefix + formattedAmount;
    }
    if (removeTrailingZeros) {
      RegExp removeTrailingZeros = RegExp(r"([.]0*)(?!.*\d)");
      formattedAmount = formattedAmount.replaceAll(removeTrailingZeros, "");
    }
    return formattedAmount;
  }

  double get satConversionRate => 1 / exchangeRate * 100000000;
}

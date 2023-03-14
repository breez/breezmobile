import 'dart:math';

import 'package:breez/services/currency_data.dart';
import 'package:breez/utils/currency_formatter.dart';
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

  RegExp get whitelistedPattern => currencyData.fractionSize == 0
      ? RegExp(r'\d+')
      : RegExp("^\\d+\\.?\\d{0,${currencyData.fractionSize ?? 2}}");

  Int64 fiatToSat(double fiatAmount) {
    return Int64((fiatAmount / exchangeRate * 100000000).round());
  }

  double satToFiat(Int64 satoshies) {
    return satoshies.toDouble() / 100000000 * exchangeRate;
  }

  String format(Int64 amount) {
    double fiatValue = satToFiat(amount);
    return formatFiat(fiatValue);
  }

  String formatFiat(
    double fiatAmount, {
    bool includeDisplayName = false,
    bool addCurrencySymbol = true,
    bool removeTrailingZeros = false,
    bool allowBelowMin = false,
  }) {
    final currencyData = this.currencyData.localeAware();
    int fractionSize = currencyData.fractionSize;
    double minimumAmount = 1 / (pow(10, fractionSize));

    String formattedAmount = "";
    String spacing = " " * currencyData.spacing;
    String symbol = currencyData.rightSideSymbol
        ? '$spacing${currencyData.symbol}'
        : '${currencyData.symbol}$spacing';
    // if conversion result is less than the minimum it doesn't make sense to display
    // it.
    if (!allowBelowMin && fiatAmount < minimumAmount) {
      formattedAmount = minimumAmount.toStringAsFixed(fractionSize);
      symbol = '< $symbol';
    } else {
      final formatter = CurrencyFormatter().formatter;
      formatter.minimumFractionDigits = fractionSize;
      formatter.maximumFractionDigits = fractionSize;
      formattedAmount = formatter.format(fiatAmount);
    }
    if (addCurrencySymbol) {
      formattedAmount = currencyData.rightSideSymbol
          ? formattedAmount + symbol
          : symbol + formattedAmount;
    } else if (includeDisplayName) {
      formattedAmount += currencyData.shortName;
    }
    if (removeTrailingZeros) {
      RegExp removeTrailingZeros = RegExp(r"([.]0*)(?!.*\d)");
      formattedAmount = formattedAmount.replaceAll(removeTrailingZeros, "");
    }
    return formattedAmount;
  }

  double get satConversionRate => 1 / exchangeRate * 100000000;
}

import 'package:breez/utils/currency_formatter.dart';
import 'package:fixnum/fixnum.dart';

enum CurrencyID { BTC, SAT }

class Currency extends Object {
  final String tickerSymbol;
  static const Currency BTC = Currency._internal("BTC");
  static const Currency SAT = Currency._internal("SAT");
  static final List<Currency> currencies = List.unmodifiable([BTC, SAT]);

  const Currency._internal(this.tickerSymbol);

  factory Currency.fromTickerSymbol(String tickerSymbol) {
    return currencies.firstWhere(
        (c) => c.tickerSymbol.toUpperCase() == tickerSymbol.toUpperCase(),
        orElse: () => null);
  }

  String format(
    Int64 sat, {
    includeCurrencySymbol = false,
    includeDisplayName = true,
    removeTrailingZeros = false,
    userInput = false,
  }) =>
      _CurrencyFormatter().format(sat, this,
          addCurrencySymbol: includeCurrencySymbol,
          addCurrencySuffix: includeDisplayName,
          removeTrailingZeros: removeTrailingZeros,
          userInput: userInput);

  Int64 parse(String amountStr) => _CurrencyFormatter().parse(amountStr, this);

  int parseToInt(
    String amountStr, {
    int def: 0,
  }) {
    int value;
    try {
      value = parse(amountStr).toInt() ?? def;
    } catch (e) {
      return def;
    }
    return value;
  }

  Int64 toSats(double amount) => _CurrencyFormatter().toSats(amount, this);

  String get displayName =>
      tickerSymbol.toLowerCase() == "sat" ? "sats" : tickerSymbol;

  String get symbol {
    switch (this.tickerSymbol) {
      case "BTC":
        return "₿";
      case "SAT":
        return "丰";
      default:
        return "₿";
    }
  }

  RegExp get whitelistedPattern {
    switch (this.tickerSymbol) {
      case "BTC":
        return RegExp("^\\d+\\.?\\d{0,8}");
      case "SAT":
        return RegExp(r'\d+');
      default:
        return RegExp("^\\d+\\.?\\d{0,8}");
    }
  }

  double get satConversionRate => this == SAT ? 1.0 : 100000000;
}

class _CurrencyFormatter {
  static final formatter = CurrencyFormatter().formatter;

  String format(satoshies, Currency currency,
      {bool addCurrencySuffix = true,
      bool addCurrencySymbol = false,
      removeTrailingZeros = false,
      userInput = false}) {
    String formattedAmount = formatter.format(satoshies);
    switch (currency) {
      case Currency.BTC:
        double amountInBTC = (satoshies.toInt() / 100000000);
        formattedAmount = amountInBTC.toStringAsFixed(8);
        if (removeTrailingZeros) {
          if (amountInBTC.truncateToDouble() == amountInBTC) {
            formattedAmount = amountInBTC.toInt().toString();
          } else {
            formattedAmount = formattedAmount.replaceAllMapped(
                RegExp(r'^(\d+\.\d*?[1-9])0+$'), (match) => match.group(1));
          }
        }
        break;
      case Currency.SAT:
        formattedAmount = formatter.format(satoshies);
        break;
    }
    if (addCurrencySymbol) {
      formattedAmount = currency.symbol + formattedAmount;
    } else if (addCurrencySuffix) {
      formattedAmount += ' ${currency.displayName}';
    }

    if (userInput) {
      return formattedAmount.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    }

    return formattedAmount;
  }

  Int64 parse(String amount, Currency currency) {
    switch (currency) {
      case Currency.BTC:
        return Int64((double.parse(amount) * 100000000).round());
      case Currency.SAT:
        return Int64(int.parse(amount.replaceAll(RegExp('\\s+'), '')));
      default:
        return Int64((double.parse(amount) * 100000000).round());
    }
  }

  Int64 toSats(double amount, Currency currency) {
    switch (currency) {
      case Currency.BTC:
        return Int64((amount * 100000000).round());
      case Currency.SAT:
        return Int64(amount.toInt());
      default:
        return Int64((amount * 100000000).round());
    }
  }
}

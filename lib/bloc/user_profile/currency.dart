import 'package:fixnum/fixnum.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';

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
    includeDisplayName = true,
    removeTrailingZeros = false,
    userInput = false,
  }) =>
      _CurrencyFormatter().format(sat, this,
          addCurrencySuffix: includeDisplayName,
          removeTrailingZeros: removeTrailingZeros,
          userInput: userInput);

  Int64 parse(String amountStr) => _CurrencyFormatter().parse(amountStr, this);

  Int64 toSats(double amount) => _CurrencyFormatter().toSats(amount, this);

  String get displayName =>
      tickerSymbol.toLowerCase() == "sat" ? "sats" : tickerSymbol;

  String get symbol {
    switch (this.tickerSymbol) {
      case "BTC":
        return "₿";
      case "SAT":
        return "S";
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
}

class _CurrencyFormatter {
  static final formatter = _defineFormatter();

  static NumberFormat _defineFormatter() {
    numberFormatSymbols['space-between'] = NumberSymbols(
      NAME: "zz",
      DECIMAL_SEP: '.',
      GROUP_SEP: '\u00A0',
      PERCENT: '%',
      ZERO_DIGIT: '0',
      PLUS_SIGN: '+',
      MINUS_SIGN: '-',
      EXP_SYMBOL: 'e',
      PERMILL: '\u2030',
      INFINITY: '\u221E',
      NAN: 'NaN',
      DECIMAL_PATTERN: '#,##0.###',
      SCIENTIFIC_PATTERN: '#E0',
      PERCENT_PATTERN: '#,##0%',
      CURRENCY_PATTERN: '\u00A4#,##0.00',
      DEF_CURRENCY_CODE: 'AUD',
    );
    final formatter = NumberFormat('###,###.##', 'space-between');
    return formatter;
  }

  String format(satoshies, Currency currency,
      {bool addCurrencySuffix = true,
      removeTrailingZeros = false,
      userInput = false}) {
    String formattedAmount = formatter.format(satoshies);
    switch (currency) {
      case Currency.BTC:
        double amountInBTC = (satoshies.toInt() / 100000000);
        if (!removeTrailingZeros) {
          formattedAmount = amountInBTC.toStringAsFixed(8);
        } else {
          // #.0* should be displayed without trailing zeros
          formattedAmount = amountInBTC.truncateToDouble() == amountInBTC
              ? amountInBTC.toStringAsFixed(0)
              : amountInBTC.toString();
        }
        break;
      case Currency.SAT:
        formattedAmount = formatter.format(satoshies);
        break;
    }
    if (addCurrencySuffix) {
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
        return Int64(int.parse(amount));
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

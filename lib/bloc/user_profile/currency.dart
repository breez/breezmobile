import 'package:fixnum/fixnum.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';

enum CurrencyID { BTC, SAT }

class Currency extends Object {
  final String symbol;
  static const Currency BTC = Currency._internal("BTC");
  static const Currency SAT = Currency._internal("Sat");
  static final List<Currency> currencies = List.unmodifiable([BTC, SAT]);

  const Currency._internal(this.symbol);
  factory Currency.fromSymbol(String symbol) {
    return currencies.firstWhere((c) => c.symbol == symbol, orElse: () => null);
  }

  String format(Int64 sat,
          {includeSymbol = true, fixedDecimals = true, userInput = false}) =>
      _CurrencyFormatter().format(sat, this,
          addCurrencySuffix: includeSymbol,
          fixedDecimals: fixedDecimals,
          userInput: userInput);
  Int64 parse(String amountStr) => _CurrencyFormatter().parse(amountStr, this);
  String get displayName => symbol == "Sat" ? "sats" : symbol;
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
      fixedDecimals = true,
      userInput = false}) {
    String formattedAmount = formatter.format(satoshies);
    switch (currency) {
      case Currency.BTC:
        if (fixedDecimals) {
          formattedAmount = (satoshies.toInt() / 100000000).toStringAsFixed(8);
        } else {
          formattedAmount = (satoshies.toInt() / 100000000).toString();
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
}

enum FiatCurrencyID { USD, EUR, GBP, JPY }

class FiatCurrency extends Object {
  final String symbol;
  static const FiatCurrency USD = FiatCurrency._internal("\$");
  static const FiatCurrency EUR = FiatCurrency._internal("€");
  static const FiatCurrency GBP = FiatCurrency._internal("£");
  static const FiatCurrency JPY = FiatCurrency._internal("¥");
  static final List<FiatCurrency> currencies = List.unmodifiable([USD, EUR, GBP, JPY]);

  const FiatCurrency._internal(this.symbol);

  factory FiatCurrency.fromSymbol(String symbol) {
    return currencies.firstWhere((c) => c.shortName == symbol);
  }

  String get shortName {
    if (symbol == "€") {
      return "EUR";
    } else if (symbol == "£") {
      return "GBP";
    } else if (symbol == "¥") {
      return "JPY";
    } else {
      return "USD";
  String get logoPath {
    switch (symbol) {
      case "€":
        return "src/icon/btc_eur.png";
      case "£":
        return "src/icon/btc_gbp.png";
      case "¥":
        return "src/icon/btc_yen.png";
      case "\$":
        return "src/icon/btc_usd.png";
      default:
        return "src/icon/btc_usd.png";
    }
  }
}

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/user_profile/currency.dart';

class CurrencyWrapper {
  final Currency btc;
  final FiatConversion fiat;

  CurrencyWrapper._internal(this.btc, this.fiat);

  factory CurrencyWrapper.fromBTC(Currency btc) {
    return CurrencyWrapper._internal(btc, null);
  }

  factory CurrencyWrapper.fromFiat(FiatConversion fiat) {
    return CurrencyWrapper._internal(null, fiat);
  }

  factory CurrencyWrapper.fromShortName(String symbol, AccountModel account) {
    var btcCurrency = Currency.fromTickerSymbol(symbol);
    if (btcCurrency != null) {
      return CurrencyWrapper.fromBTC(btcCurrency);
    }
    var fiatCurrency = account.getFiatCurrencyByShortName(symbol);
    if (fiatCurrency != null) {
      return CurrencyWrapper.fromFiat(fiatCurrency);
    }
    return null;
  }

  bool get isFiat => fiat != null;

  String get shortName => btc?.tickerSymbol ?? fiat.currencyData.shortName;

  String get symbol => btc?.symbol ?? fiat.currencyData.symbol;

  String get chargeSuffix => btc?.displayName ?? fiat.currencyData.shortName;

  bool get rtl => fiat?.currencyData?.rtl ?? false;

  int get fractionSize {
    if (btc != null) {
      return btc == Currency.SAT ? 0 : 8;
    }
    return fiat.currencyData.fractionSize;
  }

  double get satConversionRate {
    if (btc != null) {
      return btc.satConversionRate;
    }
    return fiat.satConversionRate;
  }

  RegExp get whitelistedPattern =>
      btc?.whitelistedPattern ?? fiat.whitelistedPattern;

  String format(
    double value, {
    userInput = false,
    bool includeDisplayName = false,
    bool includeCurrencySymbol = false,
    removeTrailingZeros = false,
  }) {
    if (btc != null) {
      var satValue = btc.toSats(value);
      return btc.format(satValue,
          userInput: userInput,
          addCurrencySuffix: includeDisplayName,
          addCurrencySymbol: includeCurrencySymbol,
          removeTrailingZeros: removeTrailingZeros);
    }
    return fiat.formatFiat(value,
        addCurrencySuffix: includeDisplayName,
        addCurrencySymbol: includeCurrencySymbol,
        allowBelowMin: true,
        removeTrailingZeros: removeTrailingZeros);
  }
}

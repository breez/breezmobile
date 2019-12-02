import 'package:flutter/services.dart';
import 'package:breez/services/currency_data.dart';

class CurrencyService {
  CurrencyService();

  Future<Map<String, CurrencyData>> currencies() async {
    String jsonCurrencies =
        await rootBundle.loadString('src/json/currencies.json');
    return currencyDataFromJson(jsonCurrencies);
  }
}

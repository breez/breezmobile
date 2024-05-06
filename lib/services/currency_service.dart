import 'package:breez/services/currency_data.dart';
import 'package:flutter/services.dart';

class CurrencyService {
  CurrencyService();

  Future<Map<String, CurrencyData>> currencies() async {
    String jsonCurrencies = await rootBundle.loadString('src/json/currencies.json');
    return currencyDataFromJson(jsonCurrencies);
  }
}

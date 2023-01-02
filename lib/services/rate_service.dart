import 'dart:convert';

import 'package:dio/dio.dart';

import 'data/fiat_rate.dart';

class RateService {

  RateService();

  Future<Map<String, double>> getRate(String url) async {
    var dio = Dio();
    Response response = await dio.get(url);
    final fiatFromJson =
        FiatRate.fromJson(response.data);
    Map<String, double> rates =
        fiatFromJson.rates.map((key, value) => MapEntry(key, value.value));
    return rates;
  }
}

class RateCoin {
  String key;
  double value;
}

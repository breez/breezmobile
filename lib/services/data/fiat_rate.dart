import 'coin_rate.dart';

class FiatRate {
  FiatRate({
    this.rates,
  });

  Map<String, CoinRate> rates;

  factory FiatRate.fromJson(Map<String, dynamic> json) => FiatRate(
        rates: Map.from(json["rates"])
            .map((k, v) => MapEntry<String, CoinRate>(k, CoinRate.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "rates": Map.from(rates)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}
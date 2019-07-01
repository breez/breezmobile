import 'dart:convert';

Map<String, CurrencyData> currencyDataFromJson(String str) =>
    new Map.from(json.decode(str)).map((k, v) => new MapEntry<String, CurrencyData>(k, CurrencyData.fromJson(v)));

class CurrencyData {
  String name;
  int fractionSize;
  Symbol symbol;

  CurrencyData({
    this.name,
    this.fractionSize,
    this.symbol,
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) => new CurrencyData(
        name: json["name"],
        fractionSize: json["fractionSize"],
        symbol: json["symbol"] == null ? null : Symbol.fromJson(json["symbol"]),
      );
}

class Symbol {
  String grapheme;

  Symbol({
    this.grapheme,
  });

  factory Symbol.fromJson(Map<String, dynamic> json) => new Symbol(
        grapheme: json["grapheme"],
      );
}

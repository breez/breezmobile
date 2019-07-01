import 'dart:convert';

Map<String, CurrencyData> currencyDataFromJson(String str) =>
    new Map.from(json.decode(str)).map((k, v) => new MapEntry<String, CurrencyData>(k, CurrencyData.fromJson(k, v)));

class CurrencyData {
  String name;
  String shortName;
  int fractionSize;
  Symbol symbol;

  CurrencyData({
    this.name,
    this.shortName,
    this.fractionSize,
    this.symbol,
  });

  factory CurrencyData.fromJson(String shortName, Map<String, dynamic> json) => new CurrencyData(
        name: json["name"],
        shortName: shortName,
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

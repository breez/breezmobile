import 'dart:convert';

import 'package:breez/utils/locale.dart';

Map<String, CurrencyData> currencyDataFromJson(String str) =>
    Map.from(json.decode(str)).map((k, v) =>
        MapEntry<String, CurrencyData>(k, CurrencyData.fromJson(k, v)));

Map<String, CurrencyDataOverride> currencyDataOverrideFromJson(
  CurrencyData base,
  Map<String, dynamic> src,
) {
  if (src == null || src.isEmpty) return {};
  return src.map((locale, json) => MapEntry<String, CurrencyDataOverride>(
        locale,
        CurrencyDataOverride.fromJson(base, json),
      ));
}

class CurrencyData {
  String name;
  String shortName;
  int fractionSize;
  String symbol;
  bool rtl;
  int position;
  int spacing;
  Map<String, CurrencyDataOverride> localeOverrides = {};

  CurrencyData({
    this.name,
    this.shortName,
    this.fractionSize,
    this.symbol,
    this.rtl,
    this.position,
    this.spacing,
  });

  CurrencyData localeAware() {
    if (localeOverrides.isEmpty) return this;
    final locale = getSystemLocale();
    if (localeOverrides.containsKey(locale.toLanguageTag())) {
      return localeOverrides[locale.toLanguageTag()];
    }
    if (localeOverrides.containsKey(locale.languageCode)) {
      return localeOverrides[locale.languageCode];
    }
    return this;
  }

  factory CurrencyData.fromJson(String shortName, Map<String, dynamic> json) {
    final currencyData = CurrencyData(
      name: json["name"],
      shortName: shortName,
      fractionSize: json["fractionSize"] ?? 0,
      symbol: json["symbol"] != null ? json["symbol"]["grapheme"] : shortName,
      rtl: json["symbol"] != null ? json["symbol"]["rtl"] : false,
      position: json["symbol"] != null ? json["symbol"]["position"] ?? 0 : 0,
      spacing: json["spacing"] ?? 1,
    );
    final localeOverrides = currencyDataOverrideFromJson(
      currencyData,
      json["localeOverrides"],
    );
    currencyData.localeOverrides = localeOverrides;
    return currencyData;
  }
}

class CurrencyDataOverride extends CurrencyData {
  CurrencyDataOverride({
    CurrencyData base,
    int position,
    int spacing,
  }) : super(
          name: base.name,
          shortName: base.shortName,
          fractionSize: base.fractionSize,
          symbol: base.symbol,
          rtl: base.rtl,
          position: position ?? base.position,
          spacing: spacing ?? base.spacing,
        );

  factory CurrencyDataOverride.fromJson(
    CurrencyData base,
    Map<String, dynamic> json,
  ) {
    return CurrencyDataOverride(
      base: base,
      position: json["symbol"] != null ? json["symbol"]["position"] : null,
      spacing: json["spacing"],
    );
  }
}

class CoinRate {
  CoinRate({
    this.name,
    this.unit,
    this.value,
    // this.type,
  });

  String name;
  String unit;
  double value;
  // Type type;

  factory CoinRate.fromJson(Map<String, dynamic> json) => CoinRate(
        name: json["name"],
        unit: json["unit"],
        value: json["value"].toDouble(),
        // type: typeValues.map[json["type"]],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "unit": unit,
        "value": value,
        // "type": typeValues.reverse[type],
      };
}

enum Type { FIAT, CRYPTO, COMMODITY }

final typeValues = EnumValues(
    {"commodity": Type.COMMODITY, "crypto": Type.CRYPTO, "fiat": Type.FIAT});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class LoungePaymentOptions {
  final int preferredBoostValue;
  final int preferredSatsPerMinValue;
  final int customBoostValue;
  final int customSatsPerMinValue;

  LoungePaymentOptions._({
    this.preferredBoostValue = 10000,
    this.preferredSatsPerMinValue = 0,
    this.customBoostValue,
    this.customSatsPerMinValue,
  });

  LoungePaymentOptions.initial()
      : this._(preferredBoostValue: 10000, preferredSatsPerMinValue: 0);

  LoungePaymentOptions copyWith({
    int preferredBoostValue,
    int preferredSatsPerMinValue,
    int customBoostValue,
    int customSatsPerMinValue,
  }) {
    return LoungePaymentOptions._(
      preferredBoostValue: preferredBoostValue ?? this.preferredBoostValue,
      preferredSatsPerMinValue:
      preferredSatsPerMinValue ?? this.preferredSatsPerMinValue,
      customBoostValue: customBoostValue ?? this.customBoostValue,
      customSatsPerMinValue:
      customSatsPerMinValue ?? this.customSatsPerMinValue,
    );
  }

  LoungePaymentOptions.fromJson(Map<String, dynamic> json)
      : preferredBoostValue = json['preferredBoostValue'] ?? 5000,
        preferredSatsPerMinValue = json['preferredSatsPerMinValue'] ?? 0,
        customBoostValue = json['customBoostValue'],
        customSatsPerMinValue = json['customSatsPerMinValue'];

  Map<String, dynamic> toJson() => {
    'preferredBoostValue': preferredBoostValue,
    'preferredSatsPerMinValue': preferredSatsPerMinValue,
    'customBoostValue': customBoostValue,
    'customSatsPerMinValue': customSatsPerMinValue,
  };

  List get presetBoostAmountsList => [1000, 5000, 10000, 25000, 50000, 100000];

  List get boostAmountList {
    List boostAmountList = presetBoostAmountsList;
    if (customBoostValue != null) boostAmountList.add(customBoostValue);
    boostAmountList.sort();
    // short-hand for toSet().toList() which removes duplicates
    return [
      ...{...boostAmountList}
    ];
  }

  List get presetSatsPerMinuteAmountsList =>
      [0, 50, 100, 250, 500, 1000, 2500, 5000];

  List get satsPerMinuteIntervalsList {
    List satsPerMinuteIntervalsList = presetSatsPerMinuteAmountsList;
    if (customSatsPerMinValue != null)
      satsPerMinuteIntervalsList.add(customSatsPerMinValue);
    satsPerMinuteIntervalsList.sort();
    // short-hand for toSet().toList() which removes duplicates
    return [
      ...{...satsPerMinuteIntervalsList}
    ];
  }
}

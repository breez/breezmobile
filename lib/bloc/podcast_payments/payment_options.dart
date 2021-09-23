class PodcastPaymentOptions {
  final int preferredBoostValue;
  final int preferredSatsPerMinValue;
  final int customBoostValue;
  final int customSatsPerMinValue;

  PodcastPaymentOptions._({
    this.preferredBoostValue = 5000,
    this.preferredSatsPerMinValue = 0,
    this.customBoostValue,
    this.customSatsPerMinValue,
  });

  PodcastPaymentOptions.initial()
      : this._(preferredBoostValue: 5000, preferredSatsPerMinValue: 0);

  PodcastPaymentOptions copyWith({
    int preferredBoostValue,
    int preferredSatsPerMinValue,
    int customBoostValue,
    int customSatsPerMinValue,
  }) {
    return PodcastPaymentOptions._(
      preferredBoostValue: preferredBoostValue ?? this.preferredBoostValue,
      preferredSatsPerMinValue:
          preferredSatsPerMinValue ?? this.preferredSatsPerMinValue,
      customBoostValue: customBoostValue ?? this.customBoostValue,
      customSatsPerMinValue:
          customSatsPerMinValue ?? this.customSatsPerMinValue,
    );
  }

  PodcastPaymentOptions.fromJson(Map<String, dynamic> json)
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

  List<int> get presetBoostAmountsList =>
      [50, 100, 500, 1000, 5000, 10000, 50000];

  List get boostAmountList {
    List boostAmountList = presetBoostAmountsList;
    if (customBoostValue != null) boostAmountList.add(customBoostValue);
    boostAmountList.sort();
    // short-hand for toSet().toList() which removes duplicates
    return [
      ...{...boostAmountList}
    ];
  }

  List<int> get presetSatsPerMinuteAmountsList =>
      [0, 10, 25, 50, 100, 250, 500, 1000];

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

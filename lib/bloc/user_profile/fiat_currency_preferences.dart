class FiatCurrencyPreferences {
  final List<String> preferredFiatCurrencies;

  FiatCurrencyPreferences._({this.preferredFiatCurrencies});

  FiatCurrencyPreferences copyWith({List<String> preferredFiatCurrencies}) {
    return FiatCurrencyPreferences._(
        preferredFiatCurrencies:
            preferredFiatCurrencies ?? this.preferredFiatCurrencies);
  }

  FiatCurrencyPreferences.initial()
      : this._(
          preferredFiatCurrencies: [
            'USD',
            'EUR',
            'GBP',
            'JPY',
          ],
        );

  FiatCurrencyPreferences.fromJson(Map<String, dynamic> json)
      : preferredFiatCurrencies =
            (json['preferredFiatCurrencies'] as List<dynamic>).cast<String>() ??
                [
                  'USD',
                  'EUR',
                  'GBP',
                  'JPY',
                ];

  Map<String, dynamic> toJson() => {
        'preferredFiatCurrencies': preferredFiatCurrencies,
      };
}

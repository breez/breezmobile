import 'package:breez/bloc/user_profile/currency.dart';

import '../podcast_payments/payment_options.dart';
import 'business_adress.dart';

class BackupUserPreferences {
  final String name;
  final String color;
  final String animal;
  final String image;
  final bool hideBalance;
  final Currency currency;
  final String fiatCurrency;
  final List<String> preferredCurrencies;
  final String posCurrencyShortName;
  final double cancellationTimeoutValue;
  final BusinessAddress businessAddress;
  final PaymentOptions paymentOptions;

  BackupUserPreferences._(
      this.name,
      this.color,
      this.animal, {
        this.image,
        this.hideBalance = false,
        this.currency = Currency.SAT,
        this.fiatCurrency = "USD",
        this.preferredCurrencies,
        this.posCurrencyShortName = "SAT",
        this.cancellationTimeoutValue = 90.0,
        this.businessAddress,
        this.paymentOptions,
      });

  BackupUserPreferences copyWith({
    String name,
    String color,
    String animal,
    String image,
    bool hideBalance,
    Currency currency,
    String fiatCurrency,
    List<String> preferredCurrencies,
    String posCurrencyShortName,
    double cancellationTimeoutValue,
    BusinessAddress businessAddress,
    PaymentOptions paymentOptions,
  }) {
    return BackupUserPreferences._(
      name ?? this.name,
      color ?? this.color,
      animal ?? this.animal,
      image: image ?? this.image,
      hideBalance: hideBalance ?? this.hideBalance,
      currency: currency ?? this.currency,
      fiatCurrency: fiatCurrency ?? this.fiatCurrency,
      preferredCurrencies: preferredCurrencies ?? this.preferredCurrencies,
      posCurrencyShortName: posCurrencyShortName ?? this.posCurrencyShortName,
      cancellationTimeoutValue:
      cancellationTimeoutValue ?? this.cancellationTimeoutValue,
      businessAddress: businessAddress ?? this.businessAddress,
      paymentOptions: paymentOptions ?? this.paymentOptions,
    );
  }

  BackupUserPreferences.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'],
        color = json['color'],
        animal = json['animal'],
        image = json['image'],
        hideBalance = json['hideBalance'] ?? false,
        currency = json['currency'] == null
            ? Currency.SAT
            : Currency.fromTickerSymbol(json['currency']),
        fiatCurrency =
        json['fiatCurrency'] == null ? "USD" : json['fiatCurrency'],
        preferredCurrencies =
            (json['preferredCurrencies'] as List<dynamic>)?.cast<String>() ??
                <String>['USD', 'EUR', 'GBP', 'JPY'],
        posCurrencyShortName = json['posCurrencyShortName'] ?? "SAT",
        cancellationTimeoutValue = json['cancellationTimeoutValue'] == null
            ? 90.0
            : json['cancellationTimeoutValue'],
        businessAddress = json['businessAddress'] == null
            ? BusinessAddress.initial()
            : json['businessAddress'].runtimeType == BusinessAddress
            ? json['businessAddress']
            : BusinessAddress.fromJson(json['businessAddress']),
        paymentOptions = json["paymentOptions"] == null
            ? PaymentOptions.initial()
            : json["paymentOptions"].runtimeType == PaymentOptions
            ? json["paymentOptions"]
            : PaymentOptions.fromJson(json["paymentOptions"]);

  Map<String, dynamic> toJson() => {
    'name': name,
    'color': color,
    'animal': animal,
    'image': image,
    'hideBalance': hideBalance,
    'currency': currency.tickerSymbol,
    'fiatCurrency': fiatCurrency,
    'preferredCurrencies': preferredCurrencies,
    'posCurrencyShortName': posCurrencyShortName,
    'cancellationTimeoutValue': cancellationTimeoutValue,
    'businessAddress': businessAddress,
    'paymentOptions': paymentOptions,
  };
}
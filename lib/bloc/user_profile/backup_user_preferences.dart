
import '../podcast_payments/payment_options.dart';
import 'business_address.dart';

class BackupUserPreferences {
  final String name;
  final String color;
  final String animal;
  final String image;
  final String themeId;
  final List<String> preferredCurrencies;
  final double cancellationTimeoutValue;
  final BusinessAddress businessAddress;
  final PaymentOptions paymentOptions;

  BackupUserPreferences._(
    this.name,
    this.color,
    this.animal, {
    this.image,
    this.themeId = "DARK",
    this.preferredCurrencies,
    this.cancellationTimeoutValue = 90.0,
    this.businessAddress,
    this.paymentOptions,
  });

  BackupUserPreferences copyWith({
    String name,
    String color,
    String animal,
    String image,
    String themeId,
    List<String> preferredCurrencies,
    double cancellationTimeoutValue,
    BusinessAddress businessAddress,
    PaymentOptions paymentOptions,
  }) {
    return BackupUserPreferences._(
      name ?? this.name,
      color ?? this.color,
      animal ?? this.animal,
      image: image ?? this.image,
      themeId: themeId ?? this.themeId,
      preferredCurrencies: preferredCurrencies ?? this.preferredCurrencies,
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
        themeId = json['themeId'] ?? "DARK",
        preferredCurrencies =
            (json['preferredCurrencies'] as List<dynamic>)?.cast<String>() ??
                <String>['USD', 'EUR', 'GBP', 'JPY'],
        cancellationTimeoutValue = json['cancellationTimeoutValue'] ?? 90.0,
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
        'themeId': themeId,
        'preferredCurrencies': preferredCurrencies,
        'cancellationTimeoutValue': cancellationTimeoutValue,
        'businessAddress': businessAddress.toJson(),
        'paymentOptions': paymentOptions.toJson(),
      };
}
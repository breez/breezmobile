import 'package:breez/bloc/user_profile/currency.dart';

class BreezUserModel {
  String userID;
  final Currency currency;
  final String fiatCurrency;
  String token = '';
  String name = '';
  String color = '';
  String animal = '';
  String _image;

  BreezUserModel(this.userID, this.name, this.color, this.animal, {this.currency = Currency.SAT, this.fiatCurrency = "USD", String image}) {
    this._image = image;
  }
  BreezUserModel copyWith({String name, String color, String animal, Currency currency, String fiatCurrency, String image}) {
    return new BreezUserModel(this.userID, name ?? this.name, color ?? this.color, animal ?? this.animal, currency: currency ?? this.currency, fiatCurrency: fiatCurrency ?? this.fiatCurrency, image: image ?? this._image);
  }

  bool get registered {
    return userID != null;
  }

  String get avatarURL => _image == null || _image.isEmpty ? 'breez://profile_image?animal=$animal&color=$color' : _image;

  BreezUserModel.fromJson(Map<String, dynamic> json)
      : userID = json['userID'],
        token = json['token'],
        currency = json['currency'] == null ? Currency.SAT : Currency.fromSymbol(json['currency']),
        fiatCurrency = json['fiatCurrency'] == null ? "USD" : json['fiatCurrency'],
        name = json['name'],
        color = json['color'],
        animal = json['animal'],
        _image = json['image'];

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'token': token,
        'currency': currency.symbol,
        'fiatCurrency': fiatCurrency,
        'name': name,
        'color': color,
        'animal': animal,
        'image': _image
      };
}



class SecurityModel {
  final String pinCode;

  SecurityModel({this.pinCode});

  SecurityModel copyWith({String pinCode}) {
    return new SecurityModel(pinCode: pinCode ?? this.pinCode);
  }
}

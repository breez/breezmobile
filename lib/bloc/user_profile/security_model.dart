class SecurityModel {
  bool hasSecurityPIN;

  SecurityModel({this.hasSecurityPIN});

  SecurityModel copyWith({bool hasSecurityPIN}) {
    return new SecurityModel(hasSecurityPIN: hasSecurityPIN ?? this.hasSecurityPIN);
  }
}

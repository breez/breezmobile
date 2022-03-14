class AddFundsSettings {
  final bool moonpayIpCheck;

  AddFundsSettings({this.moonpayIpCheck});

  AddFundsSettings.start() : this(moonpayIpCheck: true);

  AddFundsSettings copyWith({bool moonpayIpCheck}) {
    return AddFundsSettings(
        moonpayIpCheck: moonpayIpCheck ?? this.moonpayIpCheck);
  }

  AddFundsSettings.fromJson(Map<String, dynamic> json)
      : this(moonpayIpCheck: json["moonpayIpCheck"] ?? true);

  Map<String, dynamic> toJson() => {"moonpayIpCheck": moonpayIpCheck};
}

class AddFundsInfo {
  final bool newAddress;
  final bool isMoonpay;
  AddFundsInfo(this.newAddress, this.isMoonpay);
}

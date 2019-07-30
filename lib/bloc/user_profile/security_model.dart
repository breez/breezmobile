class SecurityModel {
  final String pinCode;
  final bool secureBackupWithPin;

  SecurityModel({this.pinCode, this.secureBackupWithPin});

  SecurityModel copyWith({String pinCode, bool secureBackupWithPin}) {
    return new SecurityModel(pinCode: pinCode, secureBackupWithPin: secureBackupWithPin ?? this.secureBackupWithPin);
  }

  SecurityModel.initial() : this(pinCode: null, secureBackupWithPin: false);

  SecurityModel.fromJson(Map<String, dynamic> json)
      : pinCode = null,
        secureBackupWithPin = json['secureBackupWithPin'];

  Map<String, dynamic> toJson() => {
        'secureBackupWithPin': secureBackupWithPin,
      };
}

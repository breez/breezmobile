class SecurityModel {
  final bool requiresPin;
  final String pinCode;
  final bool secureBackupWithPin;

  SecurityModel({this.requiresPin, this.pinCode, this.secureBackupWithPin});

  SecurityModel copyWith({bool requiresPin, String pinCode, bool secureBackupWithPin}) {
    return new SecurityModel(requiresPin: requiresPin ?? this.requiresPin, pinCode: pinCode ?? this.pinCode, secureBackupWithPin: secureBackupWithPin ?? this.secureBackupWithPin);
  }

  SecurityModel.initial() : this(requiresPin:false, pinCode: null, secureBackupWithPin: false);

  SecurityModel.fromJson(Map<String, dynamic> json)
      : pinCode = null,
        requiresPin = json['requiresPin'] ?? false,
        secureBackupWithPin = json['secureBackupWithPin'] ?? false;

  Map<String, dynamic> toJson() => {
        'secureBackupWithPin': secureBackupWithPin,
        'requiresPin': requiresPin,
      };
}

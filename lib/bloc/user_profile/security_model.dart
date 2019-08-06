class SecurityModel {

  static List<int> lockIntervals = List.unmodifiable([0, 30, 120, 300, 600, 1800, 3600]);
  static const int _defaultLockInterval = 5;

  final bool requiresPin;
  final String pinCode;
  final bool secureBackupWithPin;
  final int automaticallyLockInterval;

  SecurityModel({this.requiresPin, this.pinCode, this.secureBackupWithPin, this.automaticallyLockInterval});

  SecurityModel copyWith({bool requiresPin, String pinCode, bool secureBackupWithPin, int automaticallyLockInterval}) {
    return new SecurityModel(requiresPin: requiresPin ?? this.requiresPin, pinCode: pinCode ?? this.pinCode, secureBackupWithPin: secureBackupWithPin ?? this.secureBackupWithPin, automaticallyLockInterval: automaticallyLockInterval ?? this.automaticallyLockInterval);
  }

  SecurityModel.initial() : this(requiresPin:false, pinCode: null, secureBackupWithPin: false, automaticallyLockInterval: _defaultLockInterval);

  SecurityModel.fromJson(Map<String, dynamic> json)
      : pinCode = null,
        requiresPin = json['requiresPin'] ?? false,
        automaticallyLockInterval = json['automaticallyLockInterval'] ?? _defaultLockInterval,
        secureBackupWithPin = json['secureBackupWithPin'] ?? false;

  Map<String, dynamic> toJson() => {
        'secureBackupWithPin': secureBackupWithPin,
        'automaticallyLockInterval': automaticallyLockInterval,
        'requiresPin': requiresPin,
      };
}

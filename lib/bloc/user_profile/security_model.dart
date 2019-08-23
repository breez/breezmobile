class SecurityModel {

  static List<int> lockIntervals = List.unmodifiable([0, 30, 120, 300, 600, 1800, 3600]);
  static const int _defaultLockInterval = 120;

  final bool requiresPin;  
  final bool secureBackupWithPin;
  final int automaticallyLockInterval;

  SecurityModel({this.requiresPin, this.secureBackupWithPin, this.automaticallyLockInterval});

  SecurityModel copyWith({bool requiresPin, bool secureBackupWithPin, int automaticallyLockInterval}) {
    return new SecurityModel(requiresPin: requiresPin ?? this.requiresPin, secureBackupWithPin: secureBackupWithPin ?? this.secureBackupWithPin, automaticallyLockInterval: automaticallyLockInterval ?? this.automaticallyLockInterval);
  }

  SecurityModel.initial() : this(requiresPin:false, secureBackupWithPin: false, automaticallyLockInterval: _defaultLockInterval);

  SecurityModel.fromJson(Map<String, dynamic> json)
      : requiresPin = json['requiresPin'] ?? false,
        automaticallyLockInterval = json['automaticallyLockInterval'] ?? _defaultLockInterval,
        secureBackupWithPin = json['secureBackupWithPin'] ?? false;

  Map<String, dynamic> toJson() => {
        'secureBackupWithPin': secureBackupWithPin,
        'automaticallyLockInterval': automaticallyLockInterval,
        'requiresPin': requiresPin,
      };
}

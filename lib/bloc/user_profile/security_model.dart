class SecurityModel {
  static List<int> lockIntervals = List.unmodifiable([0, 30, 120, 300, 600, 1800, 3600]);
  static const int _defaultLockInterval = 120;

  final bool requiresPin;
  final bool secureBackupWithPin;
  final bool secureBackupWithPhrase;
  final int automaticallyLockInterval;

  SecurityModel({this.requiresPin, this.secureBackupWithPin, this.secureBackupWithPhrase, this.automaticallyLockInterval});

  SecurityModel copyWith({bool requiresPin, int automaticallyLockInterval, bool secureBackupWithPin, bool secureBackupWithPhrase}) {
    return new SecurityModel(
        requiresPin: requiresPin ?? this.requiresPin,
        automaticallyLockInterval: automaticallyLockInterval ?? this.automaticallyLockInterval,
        secureBackupWithPin: secureBackupWithPin ?? this.secureBackupWithPin,
        secureBackupWithPhrase: secureBackupWithPhrase ?? this.secureBackupWithPhrase);
  }

  SecurityModel.initial()
      : this(
            requiresPin: false, automaticallyLockInterval: _defaultLockInterval, secureBackupWithPin: false, secureBackupWithPhrase: false);

  SecurityModel.fromJson(Map<String, dynamic> json)
      : requiresPin = json['requiresPin'] ?? false,
        automaticallyLockInterval = json['automaticallyLockInterval'] ?? _defaultLockInterval,
        secureBackupWithPin = json['secureBackupWithPin'] ?? false,
        secureBackupWithPhrase = json['secureBackupWithPhrase'] ?? false;

  Map<String, dynamic> toJson() => {
        'automaticallyLockInterval': automaticallyLockInterval,
        'requiresPin': requiresPin,
        'secureBackupWithPin': secureBackupWithPin,
        'secureBackupWithPhrase': secureBackupWithPhrase
      };
}

class SecurityModel {
  static List<int> lockIntervals = List.unmodifiable([0, 30, 120, 300, 600, 1800, 3600]);
  static const int _defaultLockInterval = 120;

  final bool requiresPin;
  final bool isFingerprintEnabled;
  final int automaticallyLockInterval;

  SecurityModel._({this.requiresPin, this.isFingerprintEnabled, this.automaticallyLockInterval});

  SecurityModel copyWith({bool requiresPin, bool isFingerprintEnabled, int automaticallyLockInterval}) {
    return new SecurityModel._(
        requiresPin: requiresPin ?? this.requiresPin,
        isFingerprintEnabled: isFingerprintEnabled ?? this.isFingerprintEnabled,
        automaticallyLockInterval: automaticallyLockInterval ?? this.automaticallyLockInterval);
  }

  SecurityModel.initial() : this._(requiresPin: false, isFingerprintEnabled: false, automaticallyLockInterval: _defaultLockInterval);

  SecurityModel.fromJson(Map<String, dynamic> json)
      : requiresPin = json['requiresPin'] ?? false,
        isFingerprintEnabled = json['isFingerprintEnabled'] ?? false,
        automaticallyLockInterval = json['automaticallyLockInterval'] ?? _defaultLockInterval;

  Map<String, dynamic> toJson() => {
        'requiresPin': requiresPin,
        'isFingerprintEnabled': isFingerprintEnabled,
        'automaticallyLockInterval': automaticallyLockInterval,
      };
}

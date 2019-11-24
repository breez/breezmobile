class SecurityModel {
  static List<int> lockIntervals = List.unmodifiable([0, 30, 120, 300, 600, 1800, 3600]);
  static const int _defaultLockInterval = 120;

  final bool requiresPin;
  final bool isFingerprintEnabled;
  final String enrolledBiometrics;
  final int automaticallyLockInterval;

  SecurityModel._({this.requiresPin, this.isFingerprintEnabled, this.enrolledBiometrics, this.automaticallyLockInterval});

  SecurityModel copyWith({bool requiresPin, bool isFingerprintEnabled, String enrolledBiometrics, int automaticallyLockInterval}) {
    return new SecurityModel._(
        requiresPin: requiresPin ?? this.requiresPin,
        isFingerprintEnabled: isFingerprintEnabled ?? this.isFingerprintEnabled,
        enrolledBiometrics: enrolledBiometrics ?? this.enrolledBiometrics,
        automaticallyLockInterval: automaticallyLockInterval ?? this.automaticallyLockInterval);
  }

  SecurityModel.initial() : this._(requiresPin: false, isFingerprintEnabled: false, enrolledBiometrics: "", automaticallyLockInterval: _defaultLockInterval);

  SecurityModel.fromJson(Map<String, dynamic> json)
      : requiresPin = json['requiresPin'] ?? false,
        isFingerprintEnabled = json['isFingerprintEnabled'] ?? false,
        enrolledBiometrics = json['enrolledBiometrics'] ?? "",
        automaticallyLockInterval = json['automaticallyLockInterval'] ?? _defaultLockInterval;

  Map<String, dynamic> toJson() => {
        'requiresPin': requiresPin,
        'isFingerprintEnabled': isFingerprintEnabled,
        'enrolledBiometrics': enrolledBiometrics,
        'automaticallyLockInterval': automaticallyLockInterval,
      };
}

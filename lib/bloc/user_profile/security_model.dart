class SecurityModel {
  static List<int> lockIntervals = List.unmodifiable([0, 30, 120, 300, 600, 1800, 3600]);
  static const int _defaultLockInterval = 120;

  final bool requiresPin;  
  final int automaticallyLockInterval;

  SecurityModel._({this.requiresPin, this.automaticallyLockInterval});

  SecurityModel copyWith({bool requiresPin, int automaticallyLockInterval}) {
    return new SecurityModel._(
        requiresPin: requiresPin ?? this.requiresPin,
        automaticallyLockInterval: automaticallyLockInterval ?? this.automaticallyLockInterval);
  }

  SecurityModel.initial()
      : this._(
            requiresPin: false, automaticallyLockInterval: _defaultLockInterval);

  SecurityModel.fromJson(Map<String, dynamic> json)
      : requiresPin = json['requiresPin'] ?? false,
        automaticallyLockInterval = json['automaticallyLockInterval'] ?? _defaultLockInterval;

  Map<String, dynamic> toJson() => {
        'automaticallyLockInterval': automaticallyLockInterval,
        'requiresPin': requiresPin        
      };
}

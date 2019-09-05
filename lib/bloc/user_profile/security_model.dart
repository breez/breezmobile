class SecurityModel {

  static List<int> lockIntervals = List.unmodifiable([0, 30, 120, 300, 600, 1800, 3600]);
  static const int _defaultLockInterval = 120;

  final bool requiresPin;
  final String backupPhrase;
  final int automaticallyLockInterval;

  SecurityModel({this.requiresPin, this.backupPhrase, this.automaticallyLockInterval});

  SecurityModel copyWith({bool requiresPin, String backupPhrase, int automaticallyLockInterval}) {
    return new SecurityModel(requiresPin: requiresPin ?? this.requiresPin, backupPhrase: backupPhrase ?? this.backupPhrase, automaticallyLockInterval: automaticallyLockInterval ?? this.automaticallyLockInterval);
  }

  SecurityModel.initial() : this(requiresPin:false, backupPhrase: "", automaticallyLockInterval: _defaultLockInterval);

  SecurityModel.fromJson(Map<String, dynamic> json)
      : requiresPin = json['requiresPin'] ?? false,
        automaticallyLockInterval = json['automaticallyLockInterval'] ?? _defaultLockInterval,
        backupPhrase = "";

  Map<String, dynamic> toJson() => {
        'automaticallyLockInterval': automaticallyLockInterval,
        'requiresPin': requiresPin,
      };
}

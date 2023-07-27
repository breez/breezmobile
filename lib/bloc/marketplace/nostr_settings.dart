class NostrSettings {
  final bool enableNostr;
  final bool isRememberPubKey;
  final bool isRememberSignEvent;
  final bool isLoggedIn;

  NostrSettings(
      {this.enableNostr = true,
      this.isRememberPubKey = false,
      this.isRememberSignEvent = false,
      this.isLoggedIn = false});

  static const String NOSTR_SETTINGS_PREFERENCES_KEY = "nostr_settings";

  NostrSettings.start()
      : this(
          enableNostr: true,
          isRememberPubKey: false,
          isRememberSignEvent: false,
          isLoggedIn: false,
        );

  NostrSettings copyWith({
    bool enableNostr,
    bool isRememberPubKey,
    bool isRememberSignEvent,
    bool isLoggedIn,
  }) {
    return NostrSettings(
      enableNostr: enableNostr ?? this.enableNostr,
      isRememberPubKey: isRememberPubKey ?? this.isRememberPubKey,
      isRememberSignEvent: isRememberSignEvent ?? this.isRememberSignEvent,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  NostrSettings.fromJson(Map<String, dynamic> json)
      : this(
          enableNostr: json["enableNostr"] ?? true,
          isRememberPubKey: json["isRememberPubKey"] ?? false,
          isRememberSignEvent: json["isRememberSignEvent"] ?? false,
          isLoggedIn: json["isLoggedIn"] ?? false,
        );

  Map<String, dynamic> toJson() => {
        "enableNostr": enableNostr,
        "isRememberPubKey": isRememberPubKey,
        "isRememberSignEvent": isRememberSignEvent,
        "isLoggedIn": isLoggedIn,
      };
}

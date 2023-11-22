class NostrSettings {
  final bool enableNostr;
  final bool isRememberPubKey;
  final bool isRememberSignEvent;

  NostrSettings(
      {this.enableNostr = true,
      this.isRememberPubKey = false,
      this.isRememberSignEvent = false});

  static const String NOSTR_SETTINGS_PREFERENCES_KEY = "nostr_settings";

  NostrSettings.initial()
      : this(
          enableNostr: true,
          isRememberPubKey: false,
          isRememberSignEvent: false,
        );

  NostrSettings copyWith(
      {bool enableNostr, bool isRememberPubKey, bool isRememberSignEvent}) {
    return NostrSettings(
      enableNostr: enableNostr ?? this.enableNostr,
      isRememberPubKey: isRememberPubKey ?? this.isRememberPubKey,
      isRememberSignEvent: isRememberSignEvent ?? this.isRememberSignEvent,
    );
  }

  NostrSettings.fromJson(Map<String, dynamic> json)
      : this(
          enableNostr: json["enableNostr"] ?? true,
          isRememberPubKey: json["isRememberPubKey"] ?? false,
          isRememberSignEvent: json["isRememberSignEvent"] ?? false,
        );

  Map<String, dynamic> toJson() => {
        "enableNostr": enableNostr,
        "isRememberPubKey": isRememberPubKey,
        "isRememberSignEvent": isRememberSignEvent,
      };
}

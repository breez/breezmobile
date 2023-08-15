class NostrSettings {
  final bool enableNostr;
  final bool isRememberPubKey;
  final bool isRememberSignEvent;
  final bool isLoggedIn;
  List<String> relayList;

  static List<String> defaultRelayList = [
    "wss://relay.damus.io",
    "wss://nostr1.tunnelsats.com",
    "wss://nostr-pub.wellorder.net",
    "wss://relay.nostr.info",
    "wss://nostr-relay.wlvs.space",
    "wss://nostr.bitcoiner.social",
    "wss://nostr-01.bolt.observer",
    "wss://relayer.fiatjaf.com",
  ];

  NostrSettings({
    this.enableNostr = true,
    this.isRememberPubKey = false,
    this.isRememberSignEvent = false,
    this.isLoggedIn = false,
    this.relayList = const [],
  });

  static const String NOSTR_SETTINGS_PREFERENCES_KEY = "nostr_settings";

// start should be done by retrieving the values set in sharedPreferences
  NostrSettings.initial({
    bool enableNostr,
    bool isRememberPubKey,
    bool isRememberSignEvent,
    bool isLoggedIn,
    List<String> relayList,
  }) : this(
          enableNostr: enableNostr ?? true,
          isRememberPubKey: isRememberPubKey ?? false,
          isRememberSignEvent: isRememberSignEvent ?? false,
          isLoggedIn: isLoggedIn ?? false,
          relayList: relayList ?? defaultRelayList,
        );

  NostrSettings copyWith({
    bool enableNostr,
    bool isRememberPubKey,
    bool isRememberSignEvent,
    bool isLoggedIn,
    List<String> relayList,
  }) {
    return NostrSettings(
      enableNostr: enableNostr ?? this.enableNostr,
      isRememberPubKey: isRememberPubKey ?? this.isRememberPubKey,
      isRememberSignEvent: isRememberSignEvent ?? this.isRememberSignEvent,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      relayList: relayList ?? this.relayList,
    );
  }

  NostrSettings.fromJson(Map<String, dynamic> json)
      : this(
          enableNostr: json["enableNostr"] ?? true,
          isRememberPubKey: json["isRememberPubKey"] ?? false,
          isRememberSignEvent: json["isRememberSignEvent"] ?? false,
          isLoggedIn: json["isLoggedIn"] ?? false,
          relayList: (json["relayList"] as List<dynamic>)
                  .map((item) => item.toString())
                  .toList() ??
              defaultRelayList,
        );

  Map<String, dynamic> toJson() => {
        "enableNostr": enableNostr,
        "isRememberPubKey": isRememberPubKey,
        "isRememberSignEvent": isRememberSignEvent,
        "isLoggedIn": isLoggedIn,
        "relayList": relayList,
      };
}

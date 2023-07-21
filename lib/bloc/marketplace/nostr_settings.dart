import 'package:shared_preferences/shared_preferences.dart';

class NostrSettings {
  final bool showSnort;
  final bool isRememberPubKey;
  final bool isRememberSignEvent;

  NostrSettings(
      {this.showSnort = true,
      this.isRememberPubKey = false,
      this.isRememberSignEvent = false});

  static const String NOSTR_SETTINGS_PREFERENCES_KEY = "nostr_settings";

  NostrSettings.start()
      : this(
          showSnort: true,
          isRememberPubKey: false,
          isRememberSignEvent: false,
        );

  NostrSettings copyWith(
      {bool showSnort, bool isRememberPubKey, bool isRememberSignEvent}) {
    return NostrSettings(
      showSnort: showSnort ?? this.showSnort,
      isRememberPubKey: isRememberPubKey ?? this.isRememberPubKey,
      isRememberSignEvent: isRememberSignEvent ?? this.isRememberSignEvent,
    );
  }

  NostrSettings.fromJson(Map<String, dynamic> json)
      : this(
          showSnort: json["showSnort"] ?? true,
          isRememberPubKey: json["isRememberPubKey"] ?? false,
          isRememberSignEvent: json["isRememberSignEvent"] ?? false,
        );

  Map<String, dynamic> toJson() => {
        "showSnort": showSnort,
        "isRememberPubKey": isRememberPubKey,
        "isRememberSignEvent": isRememberSignEvent,
      };
}

import 'package:breez/utils/nostrConnect.dart';
import 'package:nostr_tools/nostr_tools.dart';

Map<int, String> eventKind = {
  0: 'metadata',
  1: 'Text',
  2: 'RecommendRelay',
  3: 'Contacts',
  4: 'EncryptedDirectMessage',
  5: 'EventDeletion',
  6: 'Repost',
  7: 'Reaction',
  9734: 'ZapRequest',
  9735: 'Zap',
  10002: 'RelayList',
  30078: 'Application Specific Data'
};

Event mapToEvent(Map<String, dynamic> eventObject) {
  return Event(
    kind: eventObject['kind'] as int,
    tags: eventObject['tags'] as List<List<String>>,
    content: eventObject['content'] as String,
    created_at: eventObject['created_at'] as int,
    id: eventObject['id'] as String,
    sig: eventObject['sig'] as String,
    pubkey: eventObject['pubkey'] as String,
  );
}

Map<String, dynamic> eventToMap(Event event) {
  Map<String, dynamic> eventObject;
  eventObject = {
    'kind': event.kind,
    'tags': event.tags,
    'content': event.content,
    'created_at': event.created_at,
    'id': event.id,
    'sig': event.sig,
    'pubkey': event.pubkey,
  };
  return eventObject;
}

class NostrSettings {
  final bool enableNostr;
  final bool isRememberPubKey;
  final bool isRememberSignEvent;
  final bool isLoggedIn;
  List<String> relayList;
  List<ConnectUri> connectedAppsList;

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
  static List<ConnectUri> defaultConnectedAppsList = [];

  NostrSettings({
    this.enableNostr = true,
    this.isRememberPubKey = false,
    this.isRememberSignEvent = false,
    this.isLoggedIn = false,
    this.relayList = const [],
    this.connectedAppsList = const [],
  });

  static const String NOSTR_SETTINGS_PREFERENCES_KEY = "nostr_settings";

// start should be done by retrieving the values set in sharedPreferences
  NostrSettings.initial({
    bool enableNostr,
    bool isRememberPubKey,
    bool isRememberSignEvent,
    bool isLoggedIn,
    List<String> relayList,
    List<ConnectUri> connectedAppsList,
  }) : this(
          enableNostr: enableNostr ?? true,
          isRememberPubKey: isRememberPubKey ?? false,
          isRememberSignEvent: isRememberSignEvent ?? false,
          isLoggedIn: isLoggedIn ?? false,
          relayList: relayList ?? defaultRelayList,
          connectedAppsList: connectedAppsList ?? defaultConnectedAppsList,
        );

  NostrSettings copyWith({
    bool enableNostr,
    bool isRememberPubKey,
    bool isRememberSignEvent,
    bool isLoggedIn,
    List<String> relayList,
    List<ConnectUri> connectedAppsList,
  }) {
    return NostrSettings(
      enableNostr: enableNostr ?? this.enableNostr,
      isRememberPubKey: isRememberPubKey ?? this.isRememberPubKey,
      isRememberSignEvent: isRememberSignEvent ?? this.isRememberSignEvent,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      relayList: relayList ?? this.relayList,
      connectedAppsList: connectedAppsList ?? defaultConnectedAppsList,
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
          connectedAppsList: (json["connectedAppsList"] as List<dynamic>)
                  .map((item) => ConnectUri.fromJson(item))
                  .toList() ??
              defaultConnectedAppsList,
        );

  Map<String, dynamic> toJson() => {
        "enableNostr": enableNostr,
        "isRememberPubKey": isRememberPubKey,
        "isRememberSignEvent": isRememberSignEvent,
        "isLoggedIn": isLoggedIn,
        "relayList": relayList,
        "connectedAppsList": connectedAppsList,
      };
}

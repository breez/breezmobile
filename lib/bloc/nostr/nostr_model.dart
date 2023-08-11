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

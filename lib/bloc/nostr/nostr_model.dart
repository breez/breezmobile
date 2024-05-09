class Event {
  String id;
  int kind;
  String pubKey;
  String content;
  List<List<String>> tags;
  int createdAt;
  String sig;

  Event({
    this.id,
    this.kind,
    this.pubKey,
    this.content,
    this.tags,
    this.createdAt,
    this.sig,
  });
}

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

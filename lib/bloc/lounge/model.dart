abstract class DBItem {
  Map<String, dynamic> toMap();
}

class Lounge implements DBItem {
  final int id;
  final String loungeID;
  final String title;

  Lounge({this.id, this.loungeID, this.title});

  Lounge copyWith({String title}) {
    return Lounge(
      id: this.id,
      loungeID: this.loungeID,
      title: title ?? this.title,
    );
  }

  Lounge.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        loungeID = json["loungeID"],
        title = json["title"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'loungeID': loungeID,
      'title': title,
    };
  }
}

enum LoungePaymentEventType { BoostStarted, StreamCompleted }

class LoungePaymentEvent {
  final LoungePaymentEventType type;
  final int sats;
  final String nodeID;

  LoungePaymentEvent(this.type, this.sats, this.nodeID);
}

abstract class DBItem {
  Map<String, dynamic> toMap();
}

class Lounge implements DBItem {
  final int id;
  final String loungeID;
  final String title;
  final bool isHosted;

  Lounge({this.id, this.loungeID, this.title, this.isHosted});

  Lounge copyWith({String title}) {
    return Lounge(
      id: this.id,
      loungeID: this.loungeID,
      title: title ?? this.title,
      isHosted: this.isHosted,
    );
  }

  Lounge.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        loungeID = json["loungeID"],
        title = json["title"],
        isHosted = json["isHosted"] == 1 ? true : false;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'loungeID': loungeID,
      'title': title,
      'isHosted': isHosted ? 1 : 0,
    };
  }

  String get payeeNodeID {
    if (!this.loungeID.startsWith("breez-")) {
      return null;
    }
    return this.loungeID.substring(6);
  }
}

enum LoungePaymentEventType { BoostStarted, StreamCompleted }

class LoungePaymentEvent {
  final LoungePaymentEventType type;
  final int sats;
  final String nodeID;

  LoungePaymentEvent(this.type, this.sats, this.nodeID);
}

class Conference {
  final String id;

  Conference(this.id);
  factory Conference.fromURL(String url) {
    var uri = Uri.parse(url);
    return Conference(uri.pathSegments.last);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }
}

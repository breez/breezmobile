abstract class DBItem {
  Map<String, dynamic> toMap();
}

class SatsZone implements DBItem {
  final int id;
  final String zoneID;
  final String title;

  SatsZone({this.id, this.zoneID, this.title});

  SatsZone copyWith({String title}) {
    return SatsZone(
      id: this.id,
      zoneID: this.zoneID,
      title: title ?? this.title,
    );
  }

  SatsZone.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        zoneID = json["zoneID"],
        title = json["title"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'zoneID': zoneID,
      'title': title,
    };
  }
}

enum PaymentEventType { BoostStarted, StreamCompleted }

class PaymentEvent {
  final PaymentEventType type;
  final int sats;
  final String nodeID;

  PaymentEvent(this.type, this.sats, this.nodeID);
}

enum ZonePaymentEventType { BoostStarted, StreamCompleted }

class ZonePaymentEvent {
  final ZonePaymentEventType type;
  final int sats;

  ZonePaymentEvent(this.type, this.sats);
}

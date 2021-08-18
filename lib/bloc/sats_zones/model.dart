abstract class DBItem {
  Map<String, dynamic> toMap();
}

class SatsZone implements DBItem {
  final int id;
  final String roomID;
  final String title;

  SatsZone({this.id, this.roomID, this.title});

  SatsZone copyWith({String title}) {
    return SatsZone(
      id: this.id,
      roomID: this.roomID,
      title: title ?? this.title,
    );
  }

  SatsZone.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        roomID = json["roomID"],
        title = json["title"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomID': roomID,
      'title': title,
    };
  }
}

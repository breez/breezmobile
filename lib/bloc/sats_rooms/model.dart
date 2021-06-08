abstract class DBItem {
  Map<String, dynamic> toMap();
}

class SatsRoom implements DBItem {
  final int id;
  final String roomID;
  final String title;

  SatsRoom({this.id, this.roomID, this.title});

  SatsRoom copyWith({String title}) {
    return SatsRoom(
      id: this.id,
      roomID: this.roomID,
      title: title ?? this.title,
    );
  }

  SatsRoom.fromMap(Map<String, dynamic> json)
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

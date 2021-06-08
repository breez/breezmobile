import 'package:breez/bloc/sats_rooms/model.dart';

abstract class Repository {
  // Sats Rooms
  Future<int> addSatsRoom(SatsRoom satsRoom);
  Future<SatsRoom> fetchSatsRoomByID(int id);
  Future<void> updateSatsRoom(SatsRoom satsRoom);
  Future<void> deleteSatsRoom(int id);
  Future<List<SatsRoom>> fetchSatsRooms({String filter});
}

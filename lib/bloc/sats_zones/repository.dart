import 'package:breez/bloc/sats_rooms/model.dart';

abstract class Repository {
  // Sats Zones
  Future<int> addSatsZone(SatsZone satsZone);
  Future<SatsZone> fetchSatsZoneByID(int id);
  Future<void> updateSatsZone(SatsZone satsZone);
  Future<void> deleteSatsZone(int id);
  Future<List<SatsZone>> fetchSatsZones({String filter});
}

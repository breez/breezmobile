import 'package:breez/bloc/lounge/model.dart';

abstract class Repository {
  // Lounges
  Future<int> addLounge(Lounge lounge);
  Future<Lounge> fetchLoungeByID(int id);
  Future<Lounge> fetchLoungeByLoungeID(String id);
  Future<void> updateLounge(Lounge lounge);
  Future<void> deleteLounge(int id);
  Future<List<Lounge>> fetchLounge({String filter});
}

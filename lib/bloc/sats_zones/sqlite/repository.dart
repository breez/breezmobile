import 'dart:io';

import 'package:breez/bloc/sats_zones/model.dart';
import 'package:sqflite/sqflite.dart';

import '../repository.dart';
import 'db.dart';

class SqliteRepository implements Repository {
  Future dropDB() async {
    Database db = await getDB();
    await db.close();
    await File(db.path).delete();
    print("deleted ${db.path}");
  }

  /*
   * Sats Zones
   */
  @override
  Future<int> addSatsZone(SatsZone satsZone) async {
    return _addDBItem(await getDB(), "SatsZone", satsZone);
  }

  @override
  Future<void> deleteSatsZone(int id) async {
    return _deleteDBItems(await getDB(), "SatsZone",
        where: "id = ?", whereArgs: [id]);
  }

  @override
  Future<SatsZone> fetchSatsZoneByID(int id) async {
    var items = await _fetchDBItems(
        await getDB(), "SatsZone", (e) => SatsZone.fromMap(e),
        where: "id = ?", whereArgs: [id]);
    return items.length > 0 ? items[0] : null;
  }

  @override
  Future<List<SatsZone>> fetchSatsZones({String filter}) async {
    return _fetchDBItems(await getDB(), "SatsZone", (e) => SatsZone.fromMap(e),
        where: filter == null ? null : "title LIKE",
        whereArgs: ['%$filter%', '%$filter%']);
  }

  @override
  Future<void> updateSatsZone(SatsZone satsZone) async {
    return _updateDBItem(await getDB(), "SatsZone", satsZone.toMap(),
        where: "id = ?", whereArgs: [satsZone.id]);
  }

  /*
   * Helpers
   */
  Future<int> _addDBItem(
      DatabaseExecutor executor, String tableName, DBItem item) async {
    return executor.insert(
      tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<int> _updateDBItem(DatabaseExecutor executor, String tableName,
      Map<String, dynamic> toUpdate,
      {String where, List whereArgs}) async {
    return executor.update(
      tableName,
      toUpdate,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> _deleteDBItems(DatabaseExecutor executor, String table,
      {String where, List whereArgs}) async {
    return await executor.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<T>> _fetchDBItems<T>(DatabaseExecutor executor, String table,
      T Function(Map<String, dynamic>) fromMapFunc,
      {String where, List whereArgs}) async {
    List<Map<String, dynamic>> items;
    if (where == null) {
      items = await executor.query(table);
    } else {
      items = await executor.query(table, where: where, whereArgs: whereArgs);
    }
    if (items.length == 0) {
      return [];
    }
    return items.map((row) => fromMapFunc(row)).toList();
  }
}

import 'dart:io';

import 'package:breez/bloc/lounge/model.dart';
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
   * Lounge
   */
  @override
  Future<int> addLounge(Lounge lounge) async {
    return _addDBItem(await getDB(), "Lounge", lounge);
  }

  @override
  Future<void> deleteLounge(int id) async {
    return _deleteDBItems(await getDB(), "Lounge",
        where: "id = ?", whereArgs: [id]);
  }

  @override
  Future<Lounge> fetchLoungeByID(int id) async {
    var items = await _fetchDBItems(
        await getDB(), "Lounge", (e) => Lounge.fromMap(e),
        where: "id = ?", whereArgs: [id]);
    return items.length > 0 ? items[0] : null;
  }

  @override
  Future<List<Lounge>> fetchLounge({String filter}) async {
    return _fetchDBItems(await getDB(), "Lounge", (e) => Lounge.fromMap(e),
        where: filter == null ? null : "title LIKE",
        whereArgs: ['%$filter%', '%$filter%']);
  }

  @override
  Future<void> updateLounge(Lounge lounge) async {
    return _updateDBItem(await getDB(), "Lounge", lounge.toMap(),
        where: "id = ?", whereArgs: [lounge.id]);
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

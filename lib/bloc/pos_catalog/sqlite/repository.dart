import 'dart:convert';

import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

import '../repository.dart';
import 'db.dart';

class SqliteRepository implements Repository {
  /*
   * Images
   */
  Future<String> addAsset(List<int> data) async {
    var hash = base64.encode(sha256.convert(data).bytes);
    await _addDBItem(await getDB(), "asset", Asset(hash, data));
    return hash;
  }

  Future<void> deleteAsset(String url) async {
    return _deleteDBItems(await getDB(), "asset",
        where: "url = ?", whereArgs: [url]);
  }

  Future<List<int>> fetchAssetByURL(String url) async {
    var assets = await _fetchDBItems(
        await getDB(), "asset", (e) => Asset.fromMap(e),
        where: "url = ?", whereArgs: [url]);
    return assets.length > 0 ? assets[0].data : null;
  }

  /*
   * Items
   */
  @override
  Future<void> addItem(Item item) async {
    return _addDBItem(await getDB(), "item", item);
  }

  @override
  Future<void> updateItem(Item item) async {
    return _updateDBItem(await getDB(), "item", item.toMap(),
        where: "id = ?", whereArgs: [item.id]);
  }

  @override
  Future<List<Item>> fetchAllItems() async {
    return _fetchDBItems(await getDB(), "item", (e) => Item.fromMap(e));
  }

  @override
  Future<void> deleteItem(int id) async {
    return _deleteDBItems(await getDB(), "item",
        where: "id = ?", whereArgs: [id]);
  }

  @override
  Future<Item> fetchItemByID(int id) async {
    var items = await _fetchDBItems(
        await getDB(), "item", (e) => Item.fromMap(e),
        where: "id = ?", whereArgs: [id]);
    return items.length > 0 ? items[0] : null;
  }

  /*
   * Sales
   */
  @override
  Future<void> addSale(Sale sale) async {
    (await getDB()).transaction((txn) async {
      await _addDBItem(txn, "sale", sale);
      sale.saleLines.forEach((sl) async {
        await _addDBItem(txn, "sale_line", sl);
      });
    });
  }

  @override
  Future<Sale> fetchSaleByID(int id) async {
    var items = await _fetchDBItems(
        await getDB(), "item", (e) => Sale.fromMap(e),
        where: "id = ?", whereArgs: [id]);
    if (items.length == 0) {
      return null;
    }
    Sale s = items[0];
    var saleLines = await _fetchDBItems(
        await getDB(), "sale_line", (e) => SaleLine.fromMap(e),
        where: "sale_id = ?", whereArgs: [s.id]);
    return s.copyWith(saleLines: saleLines);
  }

  /*
   * Helpers
   */
  Future<int> _addDBItem(
      DatabaseExecutor executor, String tableName, DBItem item) async {
    return executor.insert(
      tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
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
    var map = await executor.query(table, where: where, whereArgs: whereArgs);
    if (map.length == 0) {
      return null;
    }
    return map.map((row) => fromMapFunc(row)).toList();
  }
}

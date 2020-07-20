import 'dart:convert';
import 'dart:io';

import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:crypto/crypto.dart';
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

  Future replaceDB(List<Item> itemList) async {
    (await getDB()).transaction((txn) async {
      await _emptyTables(txn);
      // Populate DB with items
      itemList.forEach((item) async {
        await _addDBItem(txn, "item", item);
      });
    });
  }

  Future _emptyTables(Transaction txn) async {
    await txn.rawDelete('DELETE FROM asset');
    await txn.rawDelete('DELETE FROM  item');
  }

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
  Future<int> addItem(Item item) async {
    return _addDBItem(await getDB(), "item", item);
  }

  @override
  Future<void> updateItem(Item item) async {
    return _updateDBItem(await getDB(), "item", item.toMap(),
        where: "id = ?", whereArgs: [item.id]);
  }

  @override
  Future<List<Item>> fetchItems({String filter}) async {
    return _fetchDBItems(await getDB(), "item", (e) => Item.fromMap(e),
        where: filter == null ? null : "name LIKE ? OR sku LIKE ?",
        whereArgs: ['%$filter%', '%$filter%']);
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
  Future<int> addSale(Sale sale, String paymentHash) async {
    return (await getDB()).transaction((txn) async {
      int saleID = await _addDBItem(txn, "sale", sale);
      sale.saleLines.forEach((sl) async {
        var saleLineWithID = sl.copyWith(saleID: saleID);
        await _addDBItem(txn, "sale_line", saleLineWithID);
      });
      await _addSalePayment(txn, saleID, paymentHash);
      return saleID;
    });
  }

  @override
  Future<Sale> fetchSaleByID(int id) async {
    var items = await _fetchDBItems(
        await getDB(), "sale", (e) => Sale.fromMap(e),
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

  @override
  Future<Sale> fetchSaleByPaymentHash(String paymentHash) async {
    int saleID = await (await getDB()).transaction((txn) async {
      var salePayment = await txn.query("sale_payments",
          where: "payment_hash = ?", whereArgs: [paymentHash]);
      if (salePayment.length == 0) {
        return null;
      }
      return salePayment.first["sale_id"];
    });

    if (saleID != null) {
      return fetchSaleByID(saleID);
    }
    return null;
  }

  Future<int> _addSalePayment(
      DatabaseExecutor executor, int saleID, String paymentHash) async {
    return await executor.insert(
      "sale_payments",
      {"sale_id": saleID, "payment_hash": paymentHash},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'pos_repository_db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(
    tables: [Items, Categories, Units], daos: [ItemDao, CategoryDao, UnitDao])
class ItemsDatabase extends _$ItemsDatabase {
  ItemsDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [Items, Categories, Units])
class ItemDao extends DatabaseAccessor<ItemsDatabase> with _$ItemDaoMixin {
  final ItemsDatabase db;

  ItemDao(this.db) : super(db);

  Future<List<Item>> getAllItems() => select(items).get();

  Stream<List<Item>> watchAllItems() {
    return (select(items)
          ..orderBy([
            (i) => OrderingTerm(expression: i.name, mode: OrderingMode.asc),
            (i) => OrderingTerm(expression: i.price, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Stream<List<ItemWithUnitAndCategory>> itemsWithUnitAndCategory() {
    final query = select(items).join([
      leftOuterJoin(categories, categories.id.equalsExp(items.category)),
      leftOuterJoin(units, units.id.equalsExp(items.unit)),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return ItemWithUnitAndCategory(
          row.readTable(items),
          row.readTable(units),
          row.readTable(categories),
        );
      }).toList();
    });
  }

  Future<int> insertItem(Insertable<Item> item) => into(items).insert(item);

  Future updateItem(Insertable<Item> item) => update(items).replace(item);

  Future deleteItem(Insertable<Item> item) => delete(items).delete(item);
}

@UseDao(tables: [Categories])
class CategoryDao extends DatabaseAccessor<ItemsDatabase>
    with _$CategoryDaoMixin {
  final ItemsDatabase db;

  CategoryDao(this.db) : super(db);

  Future<List<Category>> getAllCategories() => select(categories).get();

  Stream<List<Category>> watchAllCategories() {
    return (select(categories)
          ..orderBy([
            (c) => OrderingTerm(expression: c.name, mode: OrderingMode.asc),
          ]))
        .watch();
  }

  Future<int> insertCategory(Insertable<Category> category) =>
      into(categories).insert(category);

  Future updateCategory(Insertable<Category> category) =>
      update(categories).replace(category);

  Future deleteCategory(Insertable<Category> category) =>
      delete(categories).delete(category);
}

@UseDao(tables: [Units])
class UnitDao extends DatabaseAccessor<ItemsDatabase> with _$UnitDaoMixin {
  final ItemsDatabase db;

  UnitDao(this.db) : super(db);

  Future<List<Unit>> getAllUnits() => select(units).get();

  Stream<List<Unit>> watchAllUnits() => select(units).watch();

  Future<int> insertUnit(Insertable<Unit> unit) => into(units).insert(unit);

  Future updateUnit(Insertable<Unit> unit) => update(units).replace(unit);

  Future deleteUnit(Insertable<Unit> unit) => delete(units).delete(unit);
}

class ItemWithUnitAndCategory {
  ItemWithUnitAndCategory(this.item, this.unit, this.category);

  final Item item;
  final Unit unit;
  final Category category;
}

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 32)();

  TextColumn get description => text().withLength(min: 1, max: 64)();

  IntColumn get price => integer()();

  IntColumn get category => integer().nullable()();

  IntColumn get unit => integer().nullable()();
}

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 32)();
}

class Units extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 32)();

  TextColumn get type => text().withLength(min: 1, max: 8)();

  TextColumn get symbol => text().withLength(min: 1, max: 8)();
}

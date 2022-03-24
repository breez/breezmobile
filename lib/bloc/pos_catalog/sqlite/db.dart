import 'dart:async';

import 'package:breez/bloc/pos_catalog/sqlite/migrations.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<String> getDatabasePath() async {
  return join(
    await databaseFactory.getDatabasesPath(),
    "product-catalog.db",
  );
}

Future<Database> getDB() async {
  return openDatabase(
    await getDatabasePath(),
    onCreate: (db, version) async {
      await db.execute(
        """
        CREATE TABLE asset(
          url TEXT PRIMARY KEY,
          data BLOB 
        )
        """,
      );

      await db.execute(
        """
        CREATE TABLE item(
          id INTEGER PRIMARY KEY,
          name TEXT, 
          sku TEXT,
          imageURL TEXT,
          price REAL, 
          currency TEXT
        )
        """,
      );

      await db.execute(
        """
        CREATE TABLE sale(
          id INTEGER PRIMARY KEY,
          note TEXT,
          date INTEGER
        )
        """,
      );

      await db.execute(
        """
        CREATE TABLE sale_payments(
          id INTEGER PRIMARY KEY,
          sale_id INTEGER,
          payment_hash TEXT
        )
        """,
      );

      await db.execute(
        """
        CREATE TABLE sale_line(
          id INTEGER PRIMARY KEY,
          sale_id INTEGER,
          item_name TEXT,
          item_id INTEGER,
          item_sku TEXT,
          item_image_url TEXT,
          quantity INTEGER, 
          price_per_item REAL,
          currency TEXT,
          sat_conversion_rate REAL,
          FOREIGN KEY(sale_id) REFERENCES sale(id)
        )
        """,
      );
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      for (var version = oldVersion; version < newVersion; version++) {
        switch (version) {
          case 1:
            await fromVersion1ToVersion2(db);
            break;
        }
      }
    },
    version: 2,
  );
}

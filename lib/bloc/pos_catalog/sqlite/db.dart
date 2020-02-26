import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDB() async {
  return openDatabase(
    // Set the path to the database.
    join(await databaseFactory.getDatabasesPath(), 'product-catalog.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) async {
      await db.execute(
        """
        CREATE TABLE asset(          
          url TEXT PRIMARY, 
          data BLOB,          
        )
        """,
      );

      await db.execute(
        """
        CREATE TABLE item(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT, 
          imageURL TEXT,
          price REAL, 
          currency TEXT,          
        )
        """,
      );

      await db.execute(
        """
        CREATE TABLE sale(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sale_id INTEGER,
        )
        """,
      );

      await db.execute(
        """
        CREATE TABLE sale_line(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sale_id INTEGER,
          item_name TEXT,
          item_image_url TEXT,
          quantity INTEGER, 
          price_per_item REAL,          
          currency TEXT,
          sat_conversion_rate REAL,
          FOREIGN KEY(sale) REFERENCES sale(id),
        )
        """,
      );
    },
    version: 1,
  );
}

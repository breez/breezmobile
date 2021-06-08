import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDB() async {
  return openDatabase(
    // Set the path to the database.
    join(await databaseFactory.getDatabasesPath(), 'sats-rooms.db'),
    // When the database is first created, create a table to store sats rooms.
    onCreate: (db, version) async {
      await db.execute(
        """
        CREATE TABLE SatsRoom(
          id INTEGER PRIMARY KEY,
          roomID TEXT, 
          title TEXT
        )
        """,
      );
    },
    version: 1,
  );
}

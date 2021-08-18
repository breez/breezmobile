import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDB() async {
  return openDatabase(
    // Set the path to the database.
    join(await databaseFactory.getDatabasesPath(), 'sats-zone.db'),
    // When the database is first created, create a table to store sats zones.
    onCreate: (db, version) async {
      await db.execute(
        """
        CREATE TABLE SatsZone(
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

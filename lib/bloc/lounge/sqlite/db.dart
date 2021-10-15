import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDB() async {
  return openDatabase(
    // Set the path to the database.
    join(await databaseFactory.getDatabasesPath(), 'lounge.db'),
    // When the database is first created, create a table to store lounges.
    onCreate: (db, version) async {
      await db.execute(
        """
        CREATE TABLE Lounge(
          id INTEGER PRIMARY KEY,
          loungeID TEXT, 
          title TEXT,
          isHosted INTEGER
        )
        """,
      );
    },
    version: 1,
  );
}

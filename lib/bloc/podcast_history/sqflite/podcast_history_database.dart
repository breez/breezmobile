import 'dart:developer';

import 'package:breez/bloc/podcast_history/sqflite/podcast_history_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../../logger.dart';
import '../../pos_catalog/sqlite/db.dart';

class PodcastHistoryDatabase {
  static final PodcastHistoryDatabase instance = PodcastHistoryDatabase._init();

  static Database _database;
  PodcastHistoryDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDB("podcast_history.db");
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasePath();
    final path = dbPath + filePath;
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final fieldIdType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final doubleType = 'DECIMAL NOT NULL';

    await db.execute('''
CREATE TABLE $podcastHistoryTable(
${PodcastHistoryFields.fieldId} $fieldIdType,
${PodcastHistoryFields.podcastId} $textType,
${PodcastHistoryFields.timeStamp} $textType,
${PodcastHistoryFields.satsSpent} $integerType,
${PodcastHistoryFields.boostagramsSent} $integerType,
${PodcastHistoryFields.podcastName} $textType,
${PodcastHistoryFields.podcastImageUrl} $textType,
${PodcastHistoryFields.durationInMins} $doubleType
 )
 ''');
  }

  Future<PodcastHistoryModel> create(PodcastHistoryModel podcastHistory) async {
    final db = await instance.database;
    final id = await db.insert(podcastHistoryTable, podcastHistory.toJson());
    return podcastHistory.copy(fieldId: id);
  }

  Future<List<PodcastHistoryModel>> readAllHistory(
      {DateTime filterStartDate, DateTime filterEndDate}) async {
    final db = await instance.database;
    List<Map<String, Object>> result;

    result = await db.rawQuery('''

 SELECT  ${PodcastHistoryFields.podcastId},${PodcastHistoryFields.podcastName},${PodcastHistoryFields.podcastImageUrl},SUM( ${PodcastHistoryFields.durationInMins} ) AS ${PodcastHistoryFields.durationInMins}, SUM( ${PodcastHistoryFields.satsSpent} ) AS ${PodcastHistoryFields.satsSpent} , SUM( ${PodcastHistoryFields.boostagramsSent} ) AS ${PodcastHistoryFields.boostagramsSent}  ,MAX( ${PodcastHistoryFields.timeStamp} ) AS ${PodcastHistoryFields.timeStamp} 
 FROM $podcastHistoryTable 
 WHERE ${PodcastHistoryFields.timeStamp} >= '${filterStartDate.toIso8601String()}' AND ${PodcastHistoryFields.timeStamp}<='${filterEndDate.toIso8601String()}'
 GROUP BY  ${PodcastHistoryFields.podcastId}

        ''');

    return result.map((json) => PodcastHistoryModel.fromJson(json)).toList();
  }
}

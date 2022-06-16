import 'package:breez/bloc/podcast_history/sqflite/podcast_history_local_model.dart';
import 'package:sqflite/sqflite.dart';
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
    //Create Table for TimeRange
    await db.execute('''
CREATE TABLE $podcastHistoryTimeRangeTable (
${PodcastHistoryTimeRangeFields.fieldId} INTEGER PRIMARY KEY,
${PodcastHistoryTimeRangeFields.timeRangeKey} TEXT NOT NULL
 )
 ''');

    //Create Table for PodcastHistoryRecord
    await db.execute('''
CREATE TABLE $podcastHistoryTable(
${PodcastHistoryFields.fieldId} INTEGER PRIMARY KEY AUTOINCREMENT,
${PodcastHistoryFields.podcastId} TEXT NOT NULL,
${PodcastHistoryFields.timeStamp} TEXT NOT NULL,
${PodcastHistoryFields.satsSpent} INTEGER NOT NULL,
${PodcastHistoryFields.boostagramsSent} INTEGER NOT NULL,
${PodcastHistoryFields.podcastName} TEXT NOT NULL,
${PodcastHistoryFields.podcastImageUrl} TEXT NOT NULL,
${PodcastHistoryFields.durationInMins} 'DECIMAL NOT NULL'
 )
 ''');
  }

  Future<PodcastHistoryModel> addToPodcastHistoryRecord(
      PodcastHistoryModel podcastHistory) async {
    final db = await instance.database;
    final id = await db.insert(podcastHistoryTable, podcastHistory.toJson());
    return podcastHistory.copy(fieldId: id);
  }

  updatePodcastHistoryTimeRange(String podcastHistoryTimeRangeKey) async {
    final db = await instance.database;

    List<Map<String, Object>> localTimeRangeData =
        await db.query(podcastHistoryTimeRangeTable);

    PodcastHistoryTimeRangeDbModel podcastHistoryTimeRangeDbModel =
        PodcastHistoryTimeRangeDbModel(
            fieldId: 1, podcastHistoryTimeRangeKey: podcastHistoryTimeRangeKey);

//If the data in sqflite is empty we insert else update
    if (localTimeRangeData.isEmpty) {
      await db.insert(podcastHistoryTimeRangeTable,
          podcastHistoryTimeRangeDbModel.toJson());
    } else {
      await db.update(
          podcastHistoryTimeRangeTable, podcastHistoryTimeRangeDbModel.toJson(),
          where: '${PodcastHistoryTimeRangeFields.fieldId} = ?',
          whereArgs: [podcastHistoryTimeRangeDbModel.fieldId]);
    }
  }

  Future<PodcastHistoryTimeRangeDbModel> fetchPodcastHistoryTimeRange() async {
    final db = await instance.database;
    var localTimeRangeData = await db.query(podcastHistoryTimeRangeTable);
    if (localTimeRangeData.isEmpty) {
      return null;
    }
    return PodcastHistoryTimeRangeDbModel.fromJson(localTimeRangeData.first);
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

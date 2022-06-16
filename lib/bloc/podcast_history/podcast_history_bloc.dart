import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/podcast_history/actions.dart';
import 'package:breez/bloc/podcast_history/model.dart';
import 'package:breez/bloc/podcast_history/sqflite/podcast_history_database.dart';
import 'package:breez/bloc/podcast_history/sqflite/podcast_history_model.dart';
import 'package:rxdart/rxdart.dart';
import '../../services/injector.dart';

class PodcastHistoryBloc with AsyncActionsHandler {
  final BehaviorSubject<PodcastHistoryTimeRange> _podcastHistoryRange =
      BehaviorSubject();

  Stream<PodcastHistoryTimeRange> get posReportRange =>
      _podcastHistoryRange.stream;

  final BehaviorSubject<bool> _showShareButton = BehaviorSubject();

  Stream<bool> get showShareButton => _showShareButton.stream;

  final BehaviorSubject<PodcastHistoryRecord>
      _podcastHistoryRecordBehaviourSubject = BehaviorSubject();

  Stream<PodcastHistoryRecord> get podcastHistoryRecord =>
      _podcastHistoryRecordBehaviourSubject.stream;

  final BehaviorSubject<PodcastHistorySortEnum> _podcastHistorySortOption =
      BehaviorSubject();

  Stream<PodcastHistorySortEnum> get podcastHistorySortOption =>
      _podcastHistorySortOption.stream;

  //A buffer model comes in use while sorting
  PodcastHistoryRecord _podcastHistoryRecordBuffer = PodcastHistoryRecord(
      totalBoostagramSentSum: 0,
      totalDurationInMinsSum: 0,
      totalSatsStreamedSum: 0,
      podcastHistoryList: []);

  PodcastHistoryBloc() {
    registerAsyncHandlers({
      UpdatePodcastHistoryTimeRange: _updatePodcastHistoryTimeRange,
      UpdatePodcastHistorySort: _updateSortOption
    });
    listenActions();

    _loadSelectedReportTimeRange();
  }

  void _loadSelectedReportTimeRange() async {
    PodcastHistoryTimeRange timeRange =
        await getPodcastHistoryTimeRageFromPrefs();

    _podcastHistoryRange.add(timeRange);
  }

  void _updateSortOption(UpdatePodcastHistorySort action) async {
    _podcastHistorySortOption.add(action.sortOptions);
    _sortList(action.sortOptions);
  }

  Future<PodcastHistoryTimeRange> getPodcastHistoryTimeRageFromPrefs() async {
    final prefs = await ServiceInjector().sharedPreferences;
    PodcastHistoryTimeRange timeRange;
    if (prefs.containsKey(_podcastHistoryTimeRangeKey)) {
      timeRange = PodcastHistoryTimeRange.fromJson(
        prefs.getString(_podcastHistoryTimeRangeKey),
      );
    } else {
      timeRange = PodcastHistoryTimeRange.monthly();
    }
    return timeRange;
  }

  Future _updatePodcastHistoryTimeRange(
    UpdatePodcastHistoryTimeRange action,
  ) async {
    final prefs = await ServiceInjector().sharedPreferences;
    prefs.setString(_podcastHistoryTimeRangeKey, action.range.toJson());
    await fetchPodcastHistory(
        startDate: action.range.startDate, endDate: action.range.endDate);

    _podcastHistoryRange.add(action.range);
  }

  Future<List<PodcastHistoryModel>> fetchPodcastHistory(
      {DateTime startDate,
      DateTime endDate,
      PodcastHistorySortEnum sortOption}) async {
    _showShareButton.add(false);
    var _podcastList = await PodcastHistoryDatabase.instance
        .readAllHistory(filterStartDate: startDate, filterEndDate: endDate);

    ///These "total" values contains sum of the respective values present in history list.
    /// In UI these are displayed on top
    int totalSatsSum = 0;
    int totalBoostagramSum = 0;
    double totalDurationSum = 0;

    _podcastList.forEach((element) {
      totalDurationSum = totalDurationSum + element.durationInMins;
      totalBoostagramSum = totalBoostagramSum + element.boostagramsSent;
      totalSatsSum = totalSatsSum + element.satsSpent;
    });

    _sortList(PodcastHistorySortEnum.SORT_RECENTLY_HEARD);

    PodcastHistoryRecord podcastHistoryRecord = PodcastHistoryRecord(
        totalSatsStreamedSum: totalSatsSum,
        totalBoostagramSentSum: totalBoostagramSum,
        totalDurationInMinsSum: totalDurationSum,
        podcastHistoryList: _podcastList);
    _podcastHistoryRecordBuffer = podcastHistoryRecord;

    _podcastHistoryRecordBehaviourSubject.add(podcastHistoryRecord);

//The share button will only be dislayed if the list is not empty
    if (_podcastList.isNotEmpty) {
      _showShareButton.add(true);
    }

    return _podcastList;
  }

  _sortList(PodcastHistorySortEnum sortOption) {
    List<PodcastHistoryModel> processedList = []
      ..addAll(_podcastHistoryRecordBuffer.podcastHistoryList);

    if (sortOption != null) {
      if (sortOption == PodcastHistorySortEnum.SORT_DURATION_DESCENDING) {
        processedList
            .sort((a, b) => b.durationInMins.compareTo(a.durationInMins));
      } else if (sortOption == PodcastHistorySortEnum.SORT_RECENTLY_HEARD) {
        processedList.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
      } else if (sortOption == PodcastHistorySortEnum.SORT_SATS_DESCENDING) {
        processedList.sort((a, b) => b.satsSpent.compareTo(a.satsSpent));
      }
    }
    _podcastHistoryRecordBehaviourSubject.add(PodcastHistoryRecord(
        totalBoostagramSentSum:
            _podcastHistoryRecordBuffer.totalBoostagramSentSum,
        totalSatsStreamedSum: _podcastHistoryRecordBuffer.totalSatsStreamedSum,
        totalDurationInMinsSum:
            _podcastHistoryRecordBuffer.totalDurationInMinsSum,
        podcastHistoryList: processedList));
  }

  @override
  dispose() {
    _podcastHistoryRecordBehaviourSubject.close();
  }
}

const _podcastHistoryTimeRangeKey = "PODCAST_HISTORY_TIME_RANGE_JSON";

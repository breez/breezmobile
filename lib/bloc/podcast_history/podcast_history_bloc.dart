import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/podcast_history/actions.dart';
import 'package:breez/bloc/podcast_history/model.dart';
import 'package:breez/bloc/podcast_history/sqflite/podcast_history_database.dart';
import 'package:breez/bloc/podcast_history/sqflite/podcast_history_local_model.dart';
import 'package:rxdart/rxdart.dart';

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

  //A buffer model comes in use while sorting
  PodcastHistoryRecord _podcastHistoryRecordBuffer = PodcastHistoryRecord(
      totalBoostagramSentSum: 0,
      totalDurationInMinsSum: 0,
      totalSatsStreamedSum: 0,
      podcastHistoryList: []);

  PodcastHistoryBloc() {
    registerAsyncHandlers({
      UpdatePodcastHistoryTimeRange: _updatePodcastHistoryTimeRange,
    });
    listenActions();

    _loadSelectedReportTimeRange();
  }

  void _loadSelectedReportTimeRange() async {
    PodcastHistoryTimeRange timeRange =
        await getPodcastHistoryTimeRageFromLocalDb();

    _podcastHistoryRange.add(timeRange);
  }

  void updateSortOption(PodcastHistorySortEnum sortOption) async {
    _sortList(sortOption);
  }

  Future<PodcastHistoryTimeRange> getPodcastHistoryTimeRageFromLocalDb() async {
    PodcastHistoryTimeRange timeRange;

    var localTimeRange =
        await PodcastHistoryDatabase.instance.fetchPodcastHistoryTimeRange();

    //If localTimeRange is null by default monthly range is set
    if (localTimeRange == null) {
      timeRange = PodcastHistoryTimeRange.monthly();
      await PodcastHistoryDatabase.instance
          .updatePodcastHistoryTimeRange(timeRange.timeRangeKey);
    } else {
      timeRange = PodcastHistoryTimeRange.getTimeRange(
          timeRangeKey: localTimeRange.podcastHistoryTimeRangeKey);
    }

    return timeRange;
  }

  Future _updatePodcastHistoryTimeRange(
    UpdatePodcastHistoryTimeRange action,
  ) async {
    await fetchPodcastHistory(
        startDate: action.range.startDate, endDate: action.range.endDate);
    PodcastHistoryDatabase.instance
        .updatePodcastHistoryTimeRange(action.range.timeRangeKey);

    _podcastHistoryRange.add(action.range);
  }

  fetchPodcastHistory(
      {DateTime startDate,
      DateTime endDate,
      PodcastHistorySortEnum sortOption}) async {
    _showShareButton.add(false);
    var podcastList = await PodcastHistoryDatabase.instance
        .readAllHistory(filterStartDate: startDate, filterEndDate: endDate);

    ///These "total" values contains sum of the respective values present in history list.
    /// In UI these are displayed on top
    int totalSatsSum = 0;
    int totalBoostagramSum = 0;
    double totalDurationSum = 0;

    for (var element in podcastList) {
      totalDurationSum = totalDurationSum + element.durationInMins;
      totalBoostagramSum = totalBoostagramSum + element.boostagramsSent;
      totalSatsSum = totalSatsSum + element.satsSpent;
    }

    PodcastHistoryRecord podcastHistoryRecord = PodcastHistoryRecord(
        totalSatsStreamedSum: totalSatsSum,
        totalBoostagramSentSum: totalBoostagramSum,
        totalDurationInMinsSum: totalDurationSum,
        podcastHistoryList: podcastList);
    _podcastHistoryRecordBuffer = podcastHistoryRecord;

    _sortList(PodcastHistorySortEnum.SORT_RECENTLY_HEARD);

//The share button will only be dislayed if the list is not empty
    if (podcastList.isNotEmpty) {
      _showShareButton.add(true);
    }
  }

  _sortList(PodcastHistorySortEnum sortOption) {
    List<PodcastHistoryModel> processedList = [
      ..._podcastHistoryRecordBuffer.podcastHistoryList
    ];

    if (sortOption == PodcastHistorySortEnum.SORT_DURATION_DESCENDING) {
      processedList
          .sort((a, b) => b.durationInMins.compareTo(a.durationInMins));
    } else if (sortOption == PodcastHistorySortEnum.SORT_RECENTLY_HEARD) {
      processedList.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    } else if (sortOption == PodcastHistorySortEnum.SORT_SATS_DESCENDING) {
      processedList.sort((a, b) => b.satsSpent.compareTo(a.satsSpent));
    } else if (sortOption == PodcastHistorySortEnum.SORT_BOOSTS_DESCENDING) {
      processedList
          .sort((a, b) => b.boostagramsSent.compareTo(a.boostagramsSent));
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
  Future dispose() {
    _podcastHistoryRecordBehaviourSubject.close();
    return super.dispose();
  }
}

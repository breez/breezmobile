import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/podcast_history/actions.dart';
import 'package:breez/bloc/podcast_history/model.dart';
import 'package:breez/bloc/podcast_history/sqflite/podcast_history_database.dart';
import 'package:breez/bloc/podcast_history/sqflite/podcast_history_model.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import '../../services/injector.dart';

class PodcastHistoryBloc with AsyncActionsHandler {
  final BehaviorSubject<PodcastHistoryTimeRange> _podcastHistoryRange =
      BehaviorSubject();

  Stream<PodcastHistoryTimeRange> get posReportRange =>
      _podcastHistoryRange.stream;

  final BehaviorSubject<bool> _showShareButton = BehaviorSubject();

  Stream<bool> get showShareButton => _showShareButton.stream;

  final BehaviorSubject<PodcastHistorySummationValues>
      _podcastHistorySumValues = BehaviorSubject();

  Stream<PodcastHistorySummationValues> get podcastHistorySumValues =>
      _podcastHistorySumValues.stream;

  final BehaviorSubject<List<PodcastHistoryModel>> _podcastHistoryList =
      BehaviorSubject();

  Stream<List<PodcastHistoryModel>> get podcastHistoryList =>
      _podcastHistoryList.stream;

  final BehaviorSubject<PodcastHistorySortOptions> _podcastHistorySortOption =
      BehaviorSubject();

  Stream<PodcastHistorySortOptions> get podcastHistorySortOption =>
      _podcastHistorySortOption.stream;

  //A buffer list comes in use while sorting
  List<PodcastHistoryModel> bufferPodcastHistoryList = [];

  PodcastHistoryBloc() {
    registerAsyncHandlers({
      UpdatePodcastHistoryTimeRange: _updatePodcastHistoryTimeRange,
      UpdatePodcastHistorySort: _updateSortOption
    });
    listenActions();

    _loadSelectedReportTimeRange();
    _initializeSortOption();
  }

  void _loadSelectedReportTimeRange() async {
    PodcastHistoryTimeRange timeRange =
        await getPodcastHistoryTimeRageFromPrefs();

    _podcastHistoryRange.add(timeRange);
  }

  void _initializeSortOption() async {
    PodcastHistorySortOptions sortOption =
        await getPodcastHistorySortOptionFromPrefs();

    _podcastHistorySortOption.add(sortOption);
  }

  void _updateSortOption(UpdatePodcastHistorySort action) async {
    final prefs = await ServiceInjector().sharedPreferences;
    prefs.setString(_podcastHistorySortKey, action.sortOptions.toJson());

    _podcastHistorySortOption.add(action.sortOptions);
  }

  Future<PodcastHistorySortOptions>
      getPodcastHistorySortOptionFromPrefs() async {
    final prefs = await ServiceInjector().sharedPreferences;
    PodcastHistorySortOptions sortOption;
    if (prefs.containsKey(_podcastHistorySortKey)) {
      sortOption = PodcastHistorySortOptions.fromJson(
        prefs.getString(_podcastHistorySortKey),
      );
    } else {
      sortOption = PodcastHistorySortOptions.recentlyHeard();
    }
    return sortOption;
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
      PodcastHistorySortOptions sortOption}) async {
    _showShareButton.add(false);
    var list = await PodcastHistoryDatabase.instance
        .readAllHistory(filterStartDate: startDate, filterEndDate: endDate);
    List<PodcastHistoryModel> processedList = [];
    final groups = groupBy(list, (PodcastHistoryModel e) {
      return e.podcastId;
    });

    ///These "total" values contains sum of the respective values present in history list.
    /// In UI these are displayed on top
    int totalSatsSum = 0;
    int totalBoostagramSum = 0;
    double totalDurationSum = 0;

    groups.forEach((key, value) {
      int satsSum = 0;
      int boostagramSum = 0;
      double durationSum = 0;
      String podcastName = value.first.podcastName;
      String podcastImagUrl = value.first.podcastImageUrl;

      value.forEach((element) {
        satsSum = satsSum + element.satsSpent;
        boostagramSum = boostagramSum + element.boostagramsSent;
        durationSum = durationSum + element.durationInMins;
      });
      totalSatsSum = totalSatsSum + satsSum;
      totalBoostagramSum = totalBoostagramSum + boostagramSum;
      totalDurationSum = totalDurationSum + durationSum;
      processedList.add(PodcastHistoryModel(
          podcastId: key,
          timeStamp: value.last.timeStamp,
          podcastImageUrl: podcastImagUrl,
          podcastName: podcastName,
          satsSpent: satsSum,
          boostagramsSent: boostagramSum,
          durationInMins: durationSum));
    });

    bufferPodcastHistoryList.clear();

    // By default the list is sorted on the basis os recency
    processedList.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));

    bufferPodcastHistoryList.addAll(processedList);
    _podcastHistoryList.add(processedList);

    _podcastHistorySumValues.add(PodcastHistorySummationValues(
        totalSatsStreamedSum: totalSatsSum,
        totalBoostagramSentSum: totalBoostagramSum,
        totalDurationInMinsSum: totalDurationSum));

//The share button will only be dislayed if the list is not empty
    if (processedList.isNotEmpty) {
      _showShareButton.add(true);
    }

    return processedList;
  }

  sortList(PodcastHistorySortOptions sortOption) {
    List<PodcastHistoryModel> processedList = []
      ..addAll(bufferPodcastHistoryList);

    if (sortOption != null) {
      if (sortOption is PodcastHistorySortDurationDescending) {
        processedList
            .sort((a, b) => b.durationInMins.compareTo(a.durationInMins));
      } else if (sortOption is PodcastHistorySortRecentlyHeard) {
        processedList.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
      } else if (sortOption is PodcastHistorySortSatsDescendings) {
        processedList.sort((a, b) => b.satsSpent.compareTo(a.satsSpent));
      }
    }

    _podcastHistoryList.add(processedList);
  }

  @override
  dispose() {
    _podcastHistorySumValues.close();
    _podcastHistoryList.close();
  }
}

const _podcastHistoryTimeRangeKey = "PODCAST_HISTORY_TIME_RANGE_JSON";
const _podcastHistorySortKey = "PODCAST_HISTORY_SORT_JSON";

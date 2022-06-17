import 'package:breez/bloc/podcast_history/sqflite/podcast_history_local_model.dart';

const _podcastHistoryTimeRangeDaily = "Podcast_History_TimeRange_Daily";
const _podcastHistoryTimeRangeWeekly = "Podcast_History_TimeRange_Weekly";
const _podcastHistoryTimeRangeMonthly = "Podcast_History_TimeRange_Monthly";
const _podcastHistoryTimeRangeYearly = "Podcast_History_TimeRange_Yearly";
const _podcastHistoryTimeRangeAllTime = "Podcast_History_TimeRange_AllTime";

// A const year for filtering on "All Time"
const _allTimeRangeYear = 2015;

abstract class PodcastHistoryTimeRange {
  final DateTime startDate;
  final DateTime endDate;
  final String timeRangeKey;

  PodcastHistoryTimeRange._({
    this.startDate,
    this.endDate,
    this.timeRangeKey,
  });

  factory PodcastHistoryTimeRange.daily() = PodcastHistoryTimeRangeDaily;

  factory PodcastHistoryTimeRange.weekly() = PodcastHistoryTimeRangeWeekly;

  factory PodcastHistoryTimeRange.monthly() = PodcastHistoryTimeRangeMonthly;

  factory PodcastHistoryTimeRange.yearly() = PodcastHistoryTimeRangeYearly;

  factory PodcastHistoryTimeRange.allTime() = PodcastHistoryTimeRangeAllTime;

  static PodcastHistoryTimeRange getTimeRange({String timeRangeKey}) {
    switch (timeRangeKey) {
      case _podcastHistoryTimeRangeDaily:
        return PodcastHistoryTimeRangeDaily();
      case _podcastHistoryTimeRangeWeekly:
        return PodcastHistoryTimeRangeWeekly();
      case _podcastHistoryTimeRangeMonthly:
        return PodcastHistoryTimeRangeMonthly();
      case _podcastHistoryTimeRangeYearly:
        return PodcastHistoryTimeRange.yearly();
      case _podcastHistoryTimeRangeAllTime:
        return PodcastHistoryTimeRange.allTime();
      default:
        return PodcastHistoryTimeRangeMonthly();
    }
  }
}

class PodcastHistoryTimeRangeDaily extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeDaily()
      : super._(
            startDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              0,
              0,
              0,
            ),
            endDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              23,
              59,
              59,
              999,
            ),
            timeRangeKey: _podcastHistoryTimeRangeDaily);
}

class PodcastHistoryTimeRangeWeekly extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeWeekly()
      : super._(
            startDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now()
                  .subtract(Duration(days: DateTime.now().weekday))
                  .day,
              0,
              0,
              0,
            ),
            endDate: DateTime.now(),
            timeRangeKey: _podcastHistoryTimeRangeWeekly);
}

class PodcastHistoryTimeRangeMonthly extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeMonthly()
      : super._(
            startDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              1,
              0,
              0,
              0,
            ),
            endDate: DateTime.now(),
            timeRangeKey: _podcastHistoryTimeRangeMonthly);
}

class PodcastHistoryTimeRangeYearly extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeYearly()
      : super._(
            startDate: DateTime(
              DateTime.now().year - 1,
              DateTime.now().month,
              1,
              0,
              0,
              0,
            ),
            endDate: DateTime.now(),
            timeRangeKey: _podcastHistoryTimeRangeYearly);
}

class PodcastHistoryTimeRangeAllTime extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeAllTime()
      : super._(
            startDate: DateTime(
              _allTimeRangeYear,
              DateTime.now().month,
              1,
              0,
              0,
              0,
            ),
            endDate: DateTime.now(),
            timeRangeKey: _podcastHistoryTimeRangeAllTime);
}

class PodcastHistoryRecord {
  final int totalSatsStreamedSum;
  final int totalBoostagramSentSum;
  final double totalDurationInMinsSum;
  List<PodcastHistoryModel> podcastHistoryList;

  PodcastHistoryRecord(
      {this.totalSatsStreamedSum,
      this.totalBoostagramSentSum,
      this.totalDurationInMinsSum,
      this.podcastHistoryList});
}

enum PodcastHistorySortEnum {
  SORT_RECENTLY_HEARD,
  SORT_DURATION_DESCENDING,
  SORT_SATS_DESCENDING
}

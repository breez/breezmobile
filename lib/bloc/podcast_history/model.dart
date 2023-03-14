import 'package:breez/bloc/podcast_history/sqflite/podcast_history_local_model.dart';

const _podcastHistoryTimeRangeWeekly = "Podcast_History_TimeRange_Weekly";
const _podcastHistoryTimeRangeMonthly = "Podcast_History_TimeRange_Monthly";
const _podcastHistoryTimeRangeYearly = "Podcast_History_TimeRange_Yearly";

abstract class PodcastHistoryTimeRange {
  final DateTime startDate;
  final DateTime endDate;
  final String timeRangeKey;

  PodcastHistoryTimeRange._({
    this.startDate,
    this.endDate,
    this.timeRangeKey,
  });

  factory PodcastHistoryTimeRange.weekly() = PodcastHistoryTimeRangeWeekly;

  factory PodcastHistoryTimeRange.monthly() = PodcastHistoryTimeRangeMonthly;

  factory PodcastHistoryTimeRange.yearly() = PodcastHistoryTimeRangeYearly;

  static PodcastHistoryTimeRange getTimeRange({String timeRangeKey}) {
    switch (timeRangeKey) {
      case _podcastHistoryTimeRangeWeekly:
        return PodcastHistoryTimeRangeWeekly();
      case _podcastHistoryTimeRangeMonthly:
        return PodcastHistoryTimeRangeMonthly();
      case _podcastHistoryTimeRangeYearly:
        return PodcastHistoryTimeRange.yearly();

      default:
        return PodcastHistoryTimeRangeMonthly();
    }
  }
}

class PodcastHistoryTimeRangeWeekly extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeWeekly()
      : super._(
            startDate: DateTime.now().subtract(const Duration(days: 7)),
            endDate: DateTime.now(),
            timeRangeKey: _podcastHistoryTimeRangeWeekly);
}

class PodcastHistoryTimeRangeMonthly extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeMonthly()
      : super._(
            startDate: DateTime.now().subtract(const Duration(days: 30)),
            endDate: DateTime.now(),
            timeRangeKey: _podcastHistoryTimeRangeMonthly);
}

class PodcastHistoryTimeRangeYearly extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeYearly()
      : super._(
            startDate: DateTime.now().subtract(const Duration(days: 365)),
            endDate: DateTime.now(),
            timeRangeKey: _podcastHistoryTimeRangeYearly);
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
  SORT_SATS_DESCENDING,
  SORT_BOOSTS_DESCENDING,
}

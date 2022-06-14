import 'dart:convert';

const _podcastHistoryTimeRangeDaily = 1;
const _podcastHistoryTimeRangeWeekly = 2;
const _podcastHistoryTimeRangeMonthly = 3;
const _podcastHistoryTimeRangeYearly = 4;
const _podcastHistoryTimeRangeAllTime = 5;

// A const year for filtering on "All Time"
const _allTimeRangeYear = 2015;

abstract class PodcastHistoryTimeRange {
  final DateTime startDate;
  final DateTime endDate;

  const PodcastHistoryTimeRange._(
    this.startDate,
    this.endDate,
  );

  int _type();

  factory PodcastHistoryTimeRange.daily() = PodcastHistoryTimeRangeDaily;

  factory PodcastHistoryTimeRange.weekly() = PodcastHistoryTimeRangeWeekly;

  factory PodcastHistoryTimeRange.monthly() = PodcastHistoryTimeRangeMonthly;

  factory PodcastHistoryTimeRange.yearly() = PodcastHistoryTimeRangeYearly;

  factory PodcastHistoryTimeRange.allTime() = PodcastHistoryTimeRangeAllTime;

  static PodcastHistoryTimeRange fromJson(String json) {
    final Map<String, dynamic> jsonMap = jsonDecode(json) ?? {};
    final type = jsonMap["type"] ?? 0;

    switch (type) {
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
        return PodcastHistoryTimeRangeDaily();
    }
  }

  String toJson() {
    return json.encode({
      "type": _type(),
      "startDate": startDate.millisecondsSinceEpoch,
      "endDate": endDate.millisecondsSinceEpoch,
    });
  }
}

class PodcastHistoryTimeRangeDaily extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeDaily()
      : super._(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            0,
            0,
            0,
          ),
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            23,
            59,
            59,
            999,
          ),
        );

  @override
  int _type() => _podcastHistoryTimeRangeDaily;
}

class PodcastHistoryTimeRangeWeekly extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeWeekly()
      : super._(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().subtract(Duration(days: DateTime.now().weekday)).day,
            0,
            0,
            0,
          ),
          DateTime.now(),
        );

  @override
  int _type() => _podcastHistoryTimeRangeWeekly;
}

class PodcastHistoryTimeRangeMonthly extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeMonthly()
      : super._(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            1,
            0,
            0,
            0,
          ),
          DateTime.now(),
        );

  @override
  int _type() => _podcastHistoryTimeRangeMonthly;
}

class PodcastHistoryTimeRangeYearly extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeYearly()
      : super._(
          DateTime(
            DateTime.now().year - 1,
            DateTime.now().month,
            1,
            0,
            0,
            0,
          ),
          DateTime.now(),
        );

  @override
  int _type() => _podcastHistoryTimeRangeYearly;
}

class PodcastHistoryTimeRangeAllTime extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeAllTime()
      : super._(
          DateTime(
            _allTimeRangeYear,
            DateTime.now().month,
            1,
            0,
            0,
            0,
          ),
          DateTime.now(),
        );

  @override
  int _type() => _podcastHistoryTimeRangeAllTime;
}

class PodcastHistorySummationValues {
  final int totalSatsStreamedSum;
  final int totalBoostagramSentSum;
  final double totalDurationInMinsSum;

  PodcastHistorySummationValues(
      {this.totalSatsStreamedSum,
      this.totalBoostagramSentSum,
      this.totalDurationInMinsSum});
}

abstract class PodcastHistorySortOptions {
  PodcastHistorySortOptions();

  String _type();

  factory PodcastHistorySortOptions.recentlyHeard() =
      PodcastHistorySortRecentlyHeard;

  factory PodcastHistorySortOptions.durationDescending() =
      PodcastHistorySortDurationDescending;

  factory PodcastHistorySortOptions.satsDecending() =
      PodcastHistorySortSatsDescendings;

  static PodcastHistorySortOptions fromJson(String json) {
    final Map<String, dynamic> jsonMap = jsonDecode(json) ?? {};
    final String type = jsonMap["type"] ?? "";

    if (_podcastHistoryKeyFromEnum(
            PodcastHistorySortEnum.SORT_DURATION_DESCENDING) ==
        type) {
      return PodcastHistorySortDurationDescending();
    } else if (_podcastHistoryKeyFromEnum(
            PodcastHistorySortEnum.SORT_SATS_DESCENDING) ==
        type) {
      return PodcastHistorySortSatsDescendings();
    } else {
      return PodcastHistorySortRecentlyHeard();
    }
  }

  String toJson() {
    return json.encode({
      "type": _type(),
    });
  }
}

class PodcastHistorySortRecentlyHeard extends PodcastHistorySortOptions {
  @override
  String _type() =>
      _podcastHistoryKeyFromEnum(PodcastHistorySortEnum.SORT_RECENTLY_HEARD);
}

class PodcastHistorySortDurationDescending extends PodcastHistorySortOptions {
  @override
  String _type() => _podcastHistoryKeyFromEnum(
      PodcastHistorySortEnum.SORT_DURATION_DESCENDING);
}

class PodcastHistorySortSatsDescendings extends PodcastHistorySortOptions {
  @override
  String _type() =>
      _podcastHistoryKeyFromEnum(PodcastHistorySortEnum.SORT_SATS_DESCENDING);
}

enum PodcastHistorySortEnum {
  SORT_RECENTLY_HEARD,
  SORT_DURATION_DESCENDING,
  SORT_SATS_DESCENDING
}

String _podcastHistoryKeyFromEnum(
    PodcastHistorySortEnum podcastHistorySortEnum) {
  return podcastHistorySortEnum.toString().split(".").last;
}

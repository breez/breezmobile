import 'dart:convert';

const _kPodcastHistoryTimeRangeDaily = 1;
const _kPodcastHistoryTimeRangeWeekly = 2;
const _kPodcastHistoryTimeRangeMonthly = 3;
const _kPodcastHistoryTimeRangeYearly = 4;
const _kPodcastHistoryTimeRangeAllTime = 5;

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
      case _kPodcastHistoryTimeRangeDaily:
        return PodcastHistoryTimeRangeDaily();
      case _kPodcastHistoryTimeRangeWeekly:
        return PodcastHistoryTimeRangeWeekly();
      case _kPodcastHistoryTimeRangeMonthly:
        return PodcastHistoryTimeRangeMonthly();
      case _kPodcastHistoryTimeRangeYearly:
        return PodcastHistoryTimeRange.yearly();
      case _kPodcastHistoryTimeRangeAllTime:
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
  int _type() => _kPodcastHistoryTimeRangeDaily;
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
  int _type() => _kPodcastHistoryTimeRangeWeekly;
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
  int _type() => _kPodcastHistoryTimeRangeMonthly;
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
  int _type() => _kPodcastHistoryTimeRangeYearly;
}

class PodcastHistoryTimeRangeAllTime extends PodcastHistoryTimeRange {
  PodcastHistoryTimeRangeAllTime()
      : super._(
          DateTime(
            2015,
            DateTime.now().month,
            1,
            0,
            0,
            0,
          ),
          DateTime.now(),
        );

  @override
  int _type() => _kPodcastHistoryTimeRangeAllTime;
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

const _podcastHistorySortRecentlyAdded = 'SORT_RECENTLY_HEARD';
const _podcastHistorySortDurationDescending = 'SORT_DURATION_DESCENDING';
const _podcastHistorySortSatsDescending = 'SORT_SATS_DESCENDING';

abstract class PodcastHistorySortOptions {
  final String title;
  bool isSelected;

  PodcastHistorySortOptions._(
    this.title,
    this.isSelected,
  );

  String _type();

  factory PodcastHistorySortOptions.recentlyHeard() =
      PodcastHistorySortRecentlyHeard;

  factory PodcastHistorySortOptions.durationDescending() =
      PodcastHistorySortDurationDescending;

  factory PodcastHistorySortOptions.satsDecending() =
      PodcastHistorySortSatsDescendings;

  static PodcastHistorySortOptions fromJson(String json) {
    final Map<String, dynamic> jsonMap = jsonDecode(json) ?? {};
    final type = jsonMap["type"] ?? 0;

    switch (type) {
      case _podcastHistorySortRecentlyAdded:
        return PodcastHistorySortRecentlyHeard();
      case _podcastHistorySortDurationDescending:
        return PodcastHistorySortDurationDescending();
      case _podcastHistorySortSatsDescending:
        return PodcastHistorySortSatsDescendings();
      default:
        return PodcastHistorySortRecentlyHeard();
    }
  }

  String toJson() {
    return json.encode({
      "type": _type(),
      "title": title,
      "isSelected": isSelected,
    });
  }
}

class PodcastHistorySortRecentlyHeard extends PodcastHistorySortOptions {
  PodcastHistorySortRecentlyHeard()
      : super._(
          "Recent First",
          false,
        );

  @override
  String _type() => _podcastHistorySortRecentlyAdded;
}

class PodcastHistorySortDurationDescending extends PodcastHistorySortOptions {
  PodcastHistorySortDurationDescending()
      : super._(
          "Most Listened First",
          false,
        );

  @override
  String _type() => _podcastHistorySortDurationDescending;
}

class PodcastHistorySortSatsDescendings extends PodcastHistorySortOptions {
  PodcastHistorySortSatsDescendings()
      : super._(
          "Higest sats Streamed First",
          false,
        );

  @override
  String _type() => _podcastHistorySortSatsDescending;
}

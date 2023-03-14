const String podcastHistoryTable = 'podcast_history_table';
const String podcastHistoryTimeRangeTable = 'podcast_history_time_range_table';

class PodcastHistoryTimeRangeFields {
  static final List<String> values = [fieldId, timeRangeKey];
  static const String fieldId = '_id';
  static const String timeRangeKey = 'timeRangeKey';
}

class PodcastHistoryTimeRangeDbModel {
  final int fieldId;
  final String podcastHistoryTimeRangeKey;

  PodcastHistoryTimeRangeDbModel(
      {this.fieldId, this.podcastHistoryTimeRangeKey});

  Map<String, Object> toJson() => {
        PodcastHistoryTimeRangeFields.fieldId: fieldId,
        PodcastHistoryTimeRangeFields.timeRangeKey: podcastHistoryTimeRangeKey,
      };

  static PodcastHistoryTimeRangeDbModel fromJson(Map<String, Object> json) =>
      PodcastHistoryTimeRangeDbModel(
          fieldId: json[PodcastHistoryTimeRangeFields.fieldId] as int,
          podcastHistoryTimeRangeKey:
              json[PodcastHistoryTimeRangeFields.timeRangeKey] as String);
}

class PodcastHistoryFields {
  static final List<String> values = [
    fieldId,
    podcastId,
    timeStamp,
    satsSpent,
    boostagramsSent,
    podcastName,
    durationInMins,
    podcastImageUrl,
    podcastUrl
  ];

  static const String fieldId = '_id';
  static const String podcastId = 'podcastId';
  static const String timeStamp = 'timeStamp';
  static const String satsSpent = 'satsSpent';
  static const String boostagramsSent = 'boostagramSent';
  static const String durationInMins = 'durationInMins';
  static const String podcastName = 'podcastName';
  static const String podcastImageUrl = 'podcastImageUrl';
  static const String podcastUrl = 'podcastUrl';
}

class PodcastHistoryModel {
  final int fieldId;
  final String podcastId;
  final DateTime timeStamp;
  final int satsSpent;
  final int boostagramsSent;
  final double durationInMins;
  final String podcastName;
  final String podcastImageUrl;
  final String podcastUrl;

  PodcastHistoryModel(
      {this.fieldId,
      this.podcastId,
      this.timeStamp,
      this.satsSpent,
      this.boostagramsSent,
      this.durationInMins,
      this.podcastName,
      this.podcastImageUrl,
      this.podcastUrl});

  Map<String, Object> toJson() => {
        PodcastHistoryFields.fieldId: fieldId,
        PodcastHistoryFields.podcastId: podcastId,
        PodcastHistoryFields.durationInMins: durationInMins,
        PodcastHistoryFields.timeStamp: timeStamp?.toIso8601String(),
        PodcastHistoryFields.satsSpent: satsSpent,
        PodcastHistoryFields.boostagramsSent: boostagramsSent,
        PodcastHistoryFields.podcastName: podcastName,
        PodcastHistoryFields.podcastImageUrl: podcastImageUrl,
        PodcastHistoryFields.podcastUrl: podcastUrl,
      };

  static PodcastHistoryModel fromJson(Map<String, Object> json) =>
      PodcastHistoryModel(
        fieldId: json[PodcastHistoryFields.fieldId] as int,
        podcastId: json[PodcastHistoryFields.podcastId] as String,
        timeStamp: json[PodcastHistoryFields.timeStamp] != null
            ? DateTime.parse(json[PodcastHistoryFields.timeStamp] as String)
            : null,
        satsSpent: json[PodcastHistoryFields.satsSpent] as int,
        boostagramsSent: json[PodcastHistoryFields.boostagramsSent] as int,
        durationInMins: json[PodcastHistoryFields.durationInMins] as double,
        podcastName: json[PodcastHistoryFields.podcastName] as String,
        podcastImageUrl: json[PodcastHistoryFields.podcastImageUrl] as String,
        podcastUrl: json[PodcastHistoryFields.podcastUrl] as String,
      );

  PodcastHistoryModel copy(
          {int fieldId,
          String podcastId,
          DateTime timeStamp,
          int satsSpent,
          int boostagramsSent,
          String podcastName,
          String podcastImageUrl,
          String podcastUrl}) =>
      PodcastHistoryModel(
          fieldId: fieldId ?? this.fieldId,
          podcastId: podcastId ?? this.podcastId,
          satsSpent: satsSpent ?? this.satsSpent,
          durationInMins: durationInMins ?? durationInMins,
          boostagramsSent: boostagramsSent ?? this.boostagramsSent,
          podcastName: podcastName ?? this.podcastName,
          podcastImageUrl: podcastImageUrl ?? this.podcastImageUrl,
          podcastUrl: podcastUrl ?? this.podcastUrl);
}

final String podcastHistoryTable = 'podcast_history_table';
final String podcastHistoryTimeRangeTable = 'podcast_history_time_range_table';

class PodcastHistoryTimeRangeFields {
  static final List<String> values = [fieldId, timeRangeKey];
  static final String fieldId = '_id';
  static final String timeRangeKey = 'timeRangeKey';
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
    podcastImageUrl
  ];

  static final String fieldId = '_id';
  static final String podcastId = 'podcastId';
  static final String timeStamp = 'timeStamp';
  static final String satsSpent = 'satsSpent';
  static final String boostagramsSent = 'boostagramSent';
  static final String durationInMins = 'durationInMins';
  static final String podcastName = 'podcastName';
  static final String podcastImageUrl = 'podcastImageUrl';
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

  PodcastHistoryModel(
      {this.fieldId,
      this.podcastId,
      this.timeStamp,
      this.satsSpent,
      this.boostagramsSent,
      this.durationInMins,
      this.podcastName,
      this.podcastImageUrl});

  Map<String, Object> toJson() => {
        PodcastHistoryFields.fieldId: fieldId,
        PodcastHistoryFields.podcastId: podcastId,
        PodcastHistoryFields.durationInMins: durationInMins,
        PodcastHistoryFields.timeStamp:
            timeStamp != null ? timeStamp.toIso8601String() : null,
        PodcastHistoryFields.satsSpent: satsSpent,
        PodcastHistoryFields.boostagramsSent: boostagramsSent,
        PodcastHistoryFields.podcastName: podcastName,
        PodcastHistoryFields.podcastImageUrl: podcastImageUrl,
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
      );

  PodcastHistoryModel copy(
          {int fieldId,
          String podcastId,
          DateTime timeStamp,
          int satsSpent,
          int boostagramsSent,
          String podcastName,
          String podcastImageUrl}) =>
      PodcastHistoryModel(
        fieldId: fieldId ?? this.fieldId,
        podcastId: podcastId ?? this.podcastId,
        satsSpent: satsSpent ?? this.satsSpent,
        durationInMins: durationInMins ?? this.durationInMins,
        boostagramsSent: boostagramsSent ?? this.boostagramsSent,
        podcastName: podcastName ?? this.podcastName,
        podcastImageUrl: podcastImageUrl ?? this.podcastImageUrl,
      );
}

import 'package:anytime/entities/episode.dart';

class PodcastClipDetailsModel {
  final Duration startTimeStamp;
  final Duration endTimeStamp;
  final int clipDuration;
  final Episode episodeDetails;
  final Duration episodeLength;

  PodcastClipDetailsModel(
      {this.startTimeStamp,
      this.endTimeStamp,
      this.clipDuration,
      this.episodeLength,
      this.episodeDetails});

  PodcastClipDetailsModel copy(
          {Duration startTimeStamp, Duration endTimeStamp, int clipDuration}) =>
      PodcastClipDetailsModel(
          startTimeStamp: startTimeStamp ?? this.startTimeStamp,
          endTimeStamp: endTimeStamp ?? this.endTimeStamp,
          clipDuration: clipDuration ?? this.clipDuration,
          episodeDetails: this.episodeDetails,
          episodeLength: this.episodeLength);
}

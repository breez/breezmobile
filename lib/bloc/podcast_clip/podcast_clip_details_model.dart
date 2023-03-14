import 'package:anytime/entities/episode.dart';

class PodcastClipDetailsModel {
  final Duration startTimeStamp;
  final Duration endTimeStamp;
  final int clipDuration;
  final Episode episodeDetails;
  final Duration episodeLength;
  final PodcastClipState podcastClipState;
  PodcastClipDetailsModel(
      {this.startTimeStamp,
      this.endTimeStamp,
      this.clipDuration,
      this.episodeLength,
      this.episodeDetails,
      this.podcastClipState});

  PodcastClipDetailsModel copy(
          {Duration startTimeStamp,
          Duration endTimeStamp,
          int clipDuration,
          PodcastClipState podcastClipState}) =>
      PodcastClipDetailsModel(
          startTimeStamp: startTimeStamp ?? this.startTimeStamp,
          endTimeStamp: endTimeStamp ?? this.endTimeStamp,
          clipDuration: clipDuration ?? this.clipDuration,
          episodeDetails: episodeDetails,
          episodeLength: episodeLength,
          podcastClipState: podcastClipState ?? this.podcastClipState);
}

enum PodcastClipState {
  IDLE,
  FETCHING_IMAGE,
  FETCHING_AUDIO_CLIP,
  GENERATING_CLIP
}

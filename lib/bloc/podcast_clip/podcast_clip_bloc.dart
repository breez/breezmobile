import 'dart:async';
import 'dart:io';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/podcast_clip/podcast_clip_details_model.dart';
import 'package:ffmpeg_kit_flutter_https_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_https_gpl/ffmpeg_session.dart';

import 'package:ffmpeg_kit_flutter_https_gpl/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

enum PodcastClipState {
  IDLE,
  FETCHING_IMAGE,
  FETCHING_AUDIO_CLIP,
  GENERATING_CLIP
}

const int _initialSeconds = 10;
const int _maxClipDuration = 120;

class PodcastClipBloc with AsyncActionsHandler {
  final BehaviorSubject<PodcastClipDetailsModel> _clipDetailsBehaviourSubject =
      BehaviorSubject();

  Stream<PodcastClipDetailsModel> get clipDetails =>
      _clipDetailsBehaviourSubject.stream;

  final BehaviorSubject<PodcastClipState> _clipStateBehaviourSubject =
      BehaviorSubject();

  Stream<PodcastClipState> get clipState => _clipStateBehaviourSubject.stream;

  setPodcastClipDetails({PositionState position}) {
    _clipStateBehaviourSubject.add(PodcastClipState.IDLE);
    Duration endTime = position.position + Duration(seconds: _initialSeconds);

    PodcastClipDetailsModel podcastClipDetails = PodcastClipDetailsModel(
        startTimeStamp: position.position,
        endTimeStamp: endTime,
        clipDuration: _initialSeconds,
        episodeLength: position.length,
        episodeDetails: position.episode);

    _clipDetailsBehaviourSubject.add(podcastClipDetails);
  }

// This funcation is called when user enters custom duration
  setPodcastClipDuration({int durationInSeconds}) async {
    var clipDetails = getCurrentPodcastClipDetails();

// Check if the duration exceeds the episode length
    if ((clipDetails.startTimeStamp + Duration(seconds: durationInSeconds)) >
        clipDetails.episodeLength) {
      return;
    }

    Duration clipEndTime =
        clipDetails.startTimeStamp + Duration(seconds: durationInSeconds);

    _clipDetailsBehaviourSubject.add(clipDetails.copy(
        clipDuration: durationInSeconds, endTimeStamp: clipEndTime));
  }

  incrementDuration() async {
    var clipDetails = getCurrentPodcastClipDetails();
    int currentClipDuration = clipDetails.clipDuration;

    //If duration is less than 10 seconds return
    if (_maxClipDuration - currentClipDuration <= 0) {
      return;
    }

    int incrementedClipDuration = 0;
    if (currentClipDuration % 10 != 0) {
      incrementedClipDuration =
          currentClipDuration - currentClipDuration % 10 + _initialSeconds;
    } else {
      incrementedClipDuration = currentClipDuration + _initialSeconds;
    }
    setPodcastClipDuration(durationInSeconds: incrementedClipDuration);
  }

  decrementDuration() async {
    var clipDetails = getCurrentPodcastClipDetails();
    int currentCLipDuration = clipDetails.clipDuration;

    //return if duration needs to be greator than 10 seconds
    if (currentCLipDuration <= _initialSeconds) {
      return;
    }
    int decrementedClipDuration = 0;

    if (currentCLipDuration % 10 != 0) {
      decrementedClipDuration = currentCLipDuration - currentCLipDuration % 10;
    } else {
      decrementedClipDuration = currentCLipDuration - _initialSeconds;
    }

    setPodcastClipDuration(durationInSeconds: decrementedClipDuration);
  }

  Future<String> _getAudioClipPath(
      {PodcastClipDetailsModel clipDetails}) async {
    var clipDetails = getCurrentPodcastClipDetails();

    String episodeUrl = clipDetails.episodeDetails.contentUrl;
    String audioClipPath = await initClipDirectory(isVideoClip: false);
    audioClipPath = audioClipPath + '/clip.mp3';

    //Getting the raw audio clip
    String clippedAudioCommand =
        '-i "$episodeUrl" -ss ${clipDetails.startTimeStamp.inSeconds} -to ${clipDetails.endTimeStamp.inSeconds}  -acodec copy $audioClipPath';

    FFmpegSession ffpegSessionDetails =
        await FFmpegKit.execute(clippedAudioCommand);

    final returnCode = await ffpegSessionDetails.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      return audioClipPath;
    } else {
      String failedStackTrace = await ffpegSessionDetails.getFailStackTrace();

      throw failedStackTrace;
    }
  }

  getVideoClipPath({String audioClipPath, String episodeImagepath}) async {
    String videoClipPath = await initClipDirectory(isVideoClip: true);
    videoClipPath = videoClipPath + '/VideoClip.mp4';

    String clippedVideoCommand =
        '-i  $audioClipPath -i $episodeImagepath -filter_complex "[0:a]showwaves=colors=0xffffff@0.9:mode=p2p,format=yuva420p[v];[1:v]scale=2120:2560[bg];[bg][v]overlay=(main_w-overlay_w)/2:H*0.8[outv]" -map "[outv]" -map 0:a -c:v libx264 -c:a copy $videoClipPath';

    FFmpegSession ffpegSessionDetails =
        await FFmpegKit.execute(clippedVideoCommand);

    final returnCode = await ffpegSessionDetails.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      return videoClipPath;
    } else {
      String failedStackTrace = await ffpegSessionDetails.getFailStackTrace();

      throw failedStackTrace;
    }
  }

  Future<bool> isEpisodeClipable() async {
    var clipDetails = getCurrentPodcastClipDetails();

    // Check if there is time to create a clip of minimun 10 secs
    if ((clipDetails.endTimeStamp + Duration(seconds: _initialSeconds)) >
        clipDetails.episodeLength) {
      return false;
    }
    return true;
  }

  Future<String> clipEpisode({String podcastImageWidgetPath}) async {
    _clipStateBehaviourSubject.add(PodcastClipState.FETCHING_AUDIO_CLIP);
    var clipDetails = getCurrentPodcastClipDetails();
    if (clipDetails == null) {
      return null;
    }
    String audioClipPath = await _getAudioClipPath(clipDetails: clipDetails);

    if (audioClipPath == null) {
      return null;
    }

    String videoClipPath = await getVideoClipPath(
        audioClipPath: audioClipPath, episodeImagepath: podcastImageWidgetPath);

    _clipStateBehaviourSubject.add(PodcastClipState.IDLE);
    if (videoClipPath == null) {
      return null;
    }

    return videoClipPath;
  }

  setPodcastState(PodcastClipState clipState) {
    _clipStateBehaviourSubject.add(clipState);
  }

  Future<String> initClipDirectory({bool isVideoClip}) async {
    Directory tempDirectory = await getTemporaryDirectory();

    String tempClipPath = isVideoClip ? '/VideoClip' : '/tempAudioClip';
    String finalPath = tempDirectory.path + tempClipPath;

    final pathExists = await Directory(finalPath).exists();
    if (pathExists) {
      Directory(finalPath).deleteSync(recursive: true);
    }

    var x = await Directory(tempDirectory.path + tempClipPath)
        .create(recursive: true);

    finalPath = x.path;
    return finalPath;
  }

  PodcastClipDetailsModel getCurrentPodcastClipDetails() {
    return _clipDetailsBehaviourSubject.value;
  }

  Future<PodcastClipState> getPodcastClipState() async {
    try {
      return await clipState.first.timeout(Duration(seconds: 1));
    } catch (e) {
      return null;
    }
  }
}

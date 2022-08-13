import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/podcast_clip/podcast_clip_details_model.dart';
import 'package:ffmpeg_kit_flutter_https_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_https_gpl/ffmpeg_session.dart';

import 'package:ffmpeg_kit_flutter_https_gpl/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

enum PodcastClipState { IDLE, FETCHING_AUDIO_CLIP, GENERATING_CLIP }

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

    print("dante ${position.episode.author}");
    print("dante downloaded ${position.episode.downloaded}");

    Duration endTime = position.position + Duration(seconds: _initialSeconds);

    PodcastClipDetailsModel podcastClipDetails = PodcastClipDetailsModel(
        startTimeStamp: position.position,
        endTimeStamp: endTime,
        clipDuration: _initialSeconds,
        episodeLength: position.length,
        episodeDetails: position.episode);

    _clipDetailsBehaviourSubject.add(podcastClipDetails);
  }

  setPodcastClipDuration({int durationInSeconds}) async {
    var clipDetails = await getCurrentPodcastClipDetails();

    if ((clipDetails.endTimeStamp + Duration(seconds: durationInSeconds)) >
        clipDetails.episodeLength) {
      return;
    }

    Duration clipEndTime = clipDetails.endTimeStamp +
        Duration(seconds: durationInSeconds) -
        Duration(seconds: _initialSeconds);

    _clipDetailsBehaviourSubject.add(clipDetails.copy(
        clipDuration: durationInSeconds, endTimeStamp: clipEndTime));
  }

  incrementDuration() async {
    var clipDetails = await getCurrentPodcastClipDetails();
    int currentCLipDuration = clipDetails.clipDuration;

//If  duration is less than 10 seconds return
    if (_maxClipDuration - currentCLipDuration <= 0) {
      return;
    }
    if ((clipDetails.endTimeStamp + Duration(seconds: _initialSeconds)) >
        clipDetails.episodeLength) {
      return;
    }

    int incrementedClipDuration =
        currentCLipDuration - currentCLipDuration % 10 + _initialSeconds;

    int initialDuration = clipDetails.endTimeStamp.inSeconds -
        clipDetails.endTimeStamp.inSeconds % 10;
    Duration incrementedClipEndTime =
        Duration(seconds: initialDuration) + Duration(seconds: _initialSeconds);

    _clipDetailsBehaviourSubject.add(clipDetails.copy(
        clipDuration: incrementedClipDuration,
        endTimeStamp: incrementedClipEndTime));
  }

  decrementCount() async {
    var clipDetails = await getCurrentPodcastClipDetails();
    int currentCLipDuration = clipDetails.clipDuration;

    //return if duration needs to be greator than 10 seconds
    if (currentCLipDuration <= _initialSeconds) {
      return;
    }
    int decrementedClipDuration = 0;
    Duration decrementedClipEndTime = Duration(seconds: 0);

    if (currentCLipDuration % 10 != 0) {
      decrementedClipDuration = currentCLipDuration - currentCLipDuration % 10;
      decrementedClipEndTime = Duration(
          seconds: clipDetails.endTimeStamp.inSeconds -
              clipDetails.endTimeStamp.inSeconds % 10);
    } else {
      decrementedClipDuration = currentCLipDuration - _initialSeconds;
      decrementedClipEndTime =
          clipDetails.endTimeStamp - Duration(seconds: _initialSeconds);
    }

    _clipDetailsBehaviourSubject.add(clipDetails.copy(
        clipDuration: decrementedClipDuration,
        endTimeStamp: decrementedClipEndTime));
  }

  Future<String> _getAudioClipPath(
      {PodcastClipDetailsModel clipDetails}) async {
    var clipDetails = await getCurrentPodcastClipDetails();

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
      return null;
    }
  }

  getVideoClipPath({String audioClipPath, String episodeImagepath}) async {
    String videoClipPath = await initClipDirectory(isVideoClip: true);
    videoClipPath = videoClipPath + '/VideoClip.mp4';

    String clippedVideoCommand =
        '-i  $audioClipPath -i $episodeImagepath -filter_complex "[0:a]showwaves=colors=0xffffff@0.6:mode=p2p,format=yuva420p[v];[1:v]scale=1060:1280[bg];[bg][v]overlay=(main_w-overlay_w)/2:H*0.8[outv]" -map "[outv]" -map 0:a -c:v libx264 -c:a copy $videoClipPath';

    FFmpegSession ffpegSessionDetails =
        await FFmpegKit.execute(clippedVideoCommand);

    String logs = await ffpegSessionDetails.getLogsAsString();
    log('cliplogs $logs');
    final returnCode = await ffpegSessionDetails.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      return videoClipPath;
    } else {
      return null;
    }
  }

  Future<bool> isEpisodeClipable() async {
    var clipDetails = await getCurrentPodcastClipDetails();

    if ((clipDetails.endTimeStamp + Duration(seconds: _initialSeconds)) >
        clipDetails.episodeLength) {
      return false;
    }
    return true;
  }

  Future<String> clipEpisode({String podcastImageWidgetPath}) async {
    _clipStateBehaviourSubject.add(PodcastClipState.FETCHING_AUDIO_CLIP);
    var clipDetails = await getCurrentPodcastClipDetails();
    if (clipDetails == null) {
      return null;
    }
    String audioClipPath = await _getAudioClipPath(clipDetails: clipDetails);

    if (audioClipPath == null) {
      //show error method
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

  Future<String> initClipDirectory({bool isVideoClip}) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    String tempClipPath = isVideoClip ? '/VideoClip' : '/tempAudioClip';
    String finalPath = appDocDirectory.path + tempClipPath;

    final pathExists = await Directory(finalPath).exists();
    if (pathExists) {
      Directory(finalPath).deleteSync(recursive: true);
    }

    var x = await Directory(appDocDirectory.path + tempClipPath)
        .create(recursive: true);

    finalPath = x.path;
    return finalPath;
  }

  Future<PodcastClipDetailsModel> getCurrentPodcastClipDetails() async {
    try {
      return await clipDetails.first.timeout(Duration(seconds: 1));
    } catch (e) {
      return null;
    }
  }

  Future<PodcastClipState> getPodcastClipState() async {
    try {
      return await clipState.first.timeout(Duration(seconds: 1));
    } catch (e) {
      return null;
    }
  }
}

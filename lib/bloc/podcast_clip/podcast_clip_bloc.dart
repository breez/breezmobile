import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/podcast_clip/podcast_clip_details_model.dart';
import 'package:ffmpeg_kit_flutter_https_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_https_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_https_gpl/return_code.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:breez/logger.dart';

const int _initialSeconds = 10;
const int _maxClipDuration = 120;

class PodcastClipBloc with AsyncActionsHandler {
  final BehaviorSubject<PodcastClipDetailsModel> _clipDetailsBehaviourSubject =
      BehaviorSubject();

  Stream<PodcastClipDetailsModel> get clipDetails =>
      _clipDetailsBehaviourSubject.stream;

//Used as a flag to disable sharing since ongoing ffmpeg commands can't be terminated.
  bool enableClipSharing = false;

  setPodcastClipDetails({PositionState position}) {
    Duration endTime = position.position + Duration(seconds: _initialSeconds);

    PodcastClipDetailsModel podcastClipDetails = PodcastClipDetailsModel(
        startTimeStamp: position.position,
        endTimeStamp: endTime,
        clipDuration: _initialSeconds,
        episodeLength: position.length,
        episodeDetails: position.episode,
        podcastClipState: PodcastClipState.IDLE);

    _clipDetailsBehaviourSubject.add(podcastClipDetails);
  }

  setClipSharingStatus({bool status}) {
    enableClipSharing = status;

    if (status == false) {
      //Clear the storage if anything is stored
      initClipDirectory(isVideoClip: true, createDirectory: false);
      initClipDirectory(isVideoClip: false, createDirectory: false);
    }
  }

  setPodcastClipDuration({int durationInSeconds}) async {
    var clipDetails = getCurrentPodcastClipDetails();

    // Check if the duration exceeds the episode length
    if ((clipDetails.startTimeStamp + Duration(seconds: durationInSeconds)) >
        clipDetails.episodeLength) {
      return;
    }
    //Return if the incremented duration is >=  _maxClipDuration or if the decremented duration is less <=0
    if ((_maxClipDuration + _initialSeconds - durationInSeconds <= 0) ||
        (durationInSeconds <= 0)) {
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
    int currentClipDuration = clipDetails.clipDuration;
    int decrementedClipDuration = 0;

    if (currentClipDuration % 10 != 0) {
      decrementedClipDuration = currentClipDuration - currentClipDuration % 10;
    } else {
      decrementedClipDuration = currentClipDuration - _initialSeconds;
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

  // ffmpeg is crashing if we send odd number
  int _forceEven(int number) {
    if (number.isEven) return number;
    return number - 1;
  }

  Future<String> getVideoClipPath({
    String audioClipPath,
    String episodeImagePath,
    int width,
    int height,
  }) async {
    String videoClipPath = await initClipDirectory(isVideoClip: true);
    videoClipPath = videoClipPath + '/clip.mp4';

    // https://ffmpeg.org/ffmpeg-filters.html#showwaves
    final showWaveColor = "colors=0xffffff@0.5";
    final mode = "mode=cline";
    final size = "size=${_forceEven((width * 0.8).toInt())}x${_forceEven((height * 0.3).toInt())}";
    final scale = "scale=lin";
    final scaleValue = "[1:v]scale=${_forceEven(width)}:${_forceEven(height)}[bg]";
    final format = "format=yuva420p[v]";
    final overlay = "[bg][v]overlay=(main_w-overlay_w)/2:${_forceEven((height * 0.7).toInt())}[outv]";
    final filterComplex = "[0:a]showwaves=$showWaveColor:$mode:$size:$scale,$format;$scaleValue;$overlay";
    final clippedVideoCommand = '-i  $audioClipPath -i $episodeImagePath -filter_complex $filterComplex -map "[outv]" -map 0:a -c:v libx264 -c:a copy $videoClipPath';
    log.info("ffmpeg command: $clippedVideoCommand");

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

  bool isEpisodeClipable() {
    var clipDetails = getCurrentPodcastClipDetails();

    // Check if there is time to create a clip of minimun 10 secs
    if ((clipDetails.endTimeStamp + Duration(seconds: _initialSeconds)) >
        clipDetails.episodeLength) {
      return false;
    }
    return true;
  }

  Future clipEpisode({Uint8List clipImage}) async {
    PodcastClipDetailsModel clipDetails = getCurrentPodcastClipDetails();
    try {
      final directory = await getTemporaryDirectory();
      final imageFile = await File('${directory.path}/image.png').create();
      await imageFile.writeAsBytes(clipImage);

      final image = decodeImage(imageFile.readAsBytesSync());
      final width = image.width;
      final height = image.height;

      String podcastImageWidgetPath = imageFile.path;

      _clipDetailsBehaviourSubject.add(clipDetails.copy(
          podcastClipState: PodcastClipState.FETCHING_AUDIO_CLIP));
      if (!enableClipSharing) {
        return;
      }

      String audioClipPath = await _getAudioClipPath(clipDetails: clipDetails);

      _clipDetailsBehaviourSubject.add(
          clipDetails.copy(podcastClipState: PodcastClipState.GENERATING_CLIP));
      if (!enableClipSharing) {
        return;
      }

      String videoClipPath = await getVideoClipPath(
        audioClipPath: audioClipPath,
        episodeImagePath: podcastImageWidgetPath,
        width: width,
        height: height,
      );

      if (!enableClipSharing) {
        return;
      } else {
        Share.shareXFiles([XFile(videoClipPath)]);
      }
    } catch (e) {
      log.warning(e);
      throw "Failed to clip the episode. More details: ${e.toString()}";
    } finally {
      _clipDetailsBehaviourSubject
          .add(clipDetails.copy(podcastClipState: PodcastClipState.IDLE));
    }
  }

  setPodcastState(PodcastClipState clipState) {
    var clipDetails = getCurrentPodcastClipDetails();
    _clipDetailsBehaviourSubject
        .add(clipDetails.copy(podcastClipState: clipState));
  }

  Future<String> initClipDirectory(
      {bool isVideoClip, bool createDirectory = true}) async {
    Directory tempDirectory = await getTemporaryDirectory();

    String tempClipPath = isVideoClip ? '/VideoClip' : '/tempAudioClip';
    String finalPath = tempDirectory.path + tempClipPath;

    final pathExists =  Directory(finalPath).existsSync();
    if (pathExists) {
      Directory(finalPath).deleteSync(recursive: true);
    }
    if (!createDirectory) {
      return null;
    }

    var x = await Directory(tempDirectory.path + tempClipPath)
        .create(recursive: true);

    finalPath = x.path;
    return finalPath;
  }

  PodcastClipDetailsModel getCurrentPodcastClipDetails() {
    return _clipDetailsBehaviourSubject.value;
  }
}

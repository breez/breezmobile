import 'dart:typed_data';

import 'package:anytime/entities/episode.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/podcast_clip/podcast_clip_bloc.dart';
import 'package:breez/bloc/podcast_clip/podcast_clip_details_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/podcast/podcast_clip/custom_clips_duration_dialog.dart';
import 'package:breez/theme_data.dart' as breezTheme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/network_image_builder.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screenshot/screenshot.dart';

class PodcastClipDetailBottomSheet extends StatefulWidget {
  const PodcastClipDetailBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  State<PodcastClipDetailBottomSheet> createState() =>
      _PodcastClipDetailBottomSheetState();
}

class _PodcastClipDetailBottomSheetState
    extends State<PodcastClipDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final podcastClipBloc = AppBlocsProvider.of<PodcastClipBloc>(context);
    final texts = context.texts();
    final displaySmall = Theme.of(context).primaryTextTheme.displaySmall;

    return StreamBuilder<PodcastClipDetailsModel>(
      stream: podcastClipBloc.clipDetails,
      builder: (context, clipDetailSnapshot) {
        return clipDetailSnapshot.data != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${_formatDuration(clipDetailSnapshot.data.startTimeStamp)} - ${_formatDuration(clipDetailSnapshot.data.endTimeStamp)}',
                            style: displaySmall.copyWith(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white),
                        const SizedBox(height: 20),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _durationToggleButton(
                                () {
                                  podcastClipBloc.decrementDuration();
                                },
                                Icons.remove_circle_outline,
                              ),
                              _numberPanel(
                                clipDetailSnapshot.data.clipDuration,
                              ),
                              _durationToggleButton(
                                () {
                                  podcastClipBloc.incrementDuration();
                                },
                                Icons.add_circle_outline,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12,
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            podcastClipBloc.setClipSharingStatus(
                              status: false,
                            );
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            texts.podcast_clips_cancel_button,
                            style: displaySmall.copyWith(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        clipDetailSnapshot.data.podcastClipState ==
                                PodcastClipState.IDLE
                            ? TextButton(
                                onPressed: () async {
                                  podcastClipBloc.setPodcastState(
                                      PodcastClipState.FETCHING_IMAGE);
                                  Episode e =
                                      clipDetailSnapshot.data.episodeDetails;
                                  var image = NetworkImage(e.imageUrl);

                                  image
                                      .resolve(const ImageConfiguration())
                                      .addListener(
                                    ImageStreamListener(
                                      (info, call) async {
                                        try {
                                          Uint8List screenShotImage =
                                              await ScreenshotController()
                                                  .captureFromWidget(
                                            _imageWidget(
                                              episodeDetails: clipDetailSnapshot
                                                  .data.episodeDetails,
                                            ),
                                            context: context,
                                            delay: const Duration(
                                              milliseconds: 10,
                                            ),
                                          );
                                          await podcastClipBloc.clipEpisode(
                                            clipImage: screenShotImage,
                                          );
                                        } catch (e) {
                                          log.warning(e);
                                          showFlushbar(
                                            context,
                                            message: texts.podcast_clips_error,
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  texts.podcast_clips_clip_button,
                                  style: displaySmall.copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              )
            : const CircularProgressIndicator();
      },
    );
  }

  Widget _durationToggleButton(
    Function() onTap,
    IconData icon,
  ) {
    final themeData = Theme.of(context);

    return GestureDetector(
      child: SizedBox(
        width: 32,
        height: 64,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(32),
          child: InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: onTap,
            splashColor: themeData.splashColor,
            highlightColor: Colors.transparent,
            child: Icon(
              icon,
              size: 20,
              color: breezTheme.BreezColors.white[400],
            ),
          ),
        ),
      ),
    );
  }

  Widget _numberPanel(int durationInSeconds) {
    final minFontSize = 9.0 / MediaQuery.of(context).textScaleFactor;
    var texts = context.texts();
    final displaySmall = Theme.of(context).primaryTextTheme.displaySmall;

    return GestureDetector(
      onTap: () => showDialog(
        useRootNavigator: true,
        context: context,
        builder: (c) => const CustomClipsDurationDialog(),
      ),
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 42,
              height: 20,
              child: AutoSizeText(
                durationInSeconds.toString(),
                textAlign: TextAlign.center,
                style: displaySmall.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
                minFontSize: minFontSize,
                stepGranularity: 0.1,
                maxLines: 1,
              ),
            ),
            AutoSizeText(
              texts.podcast_clips_seconds,
              textAlign: TextAlign.center,
              style: displaySmall.copyWith(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  _imageWidget({Episode episodeDetails, Image image}) {
    final displaySmall = Theme.of(context).primaryTextTheme.displaySmall;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            breezTheme.BreezColors.blue[500],
            breezTheme.BreezColors.blue[500].withOpacity(0.5)
          ],
        ),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            episodeDetails.author,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: displaySmall.copyWith(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CustomImageBuilderWidget(
              imageurl: episodeDetails.imageUrl,
              image: image,
              height: 300,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            episodeDetails.podcast,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: displaySmall.copyWith(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            episodeDetails.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: displaySmall.copyWith(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Clipped by ",
                style: displaySmall.copyWith(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SvgPicture.asset(
                "src/images/logo-color.svg",
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcATop,
                ),
                width: (MediaQuery.of(context).size.width) / 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0");
}

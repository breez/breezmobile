import 'dart:typed_data';

import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/entities/episode.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/podcast_clip/podcast_clip_bloc.dart';
import 'package:breez/bloc/podcast_clip/podcast_clip_details_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/theme_data.dart' as breezTheme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/network_image_builder.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class PodcastClipWidget extends StatelessWidget {
  const PodcastClipWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final podcastClipBloc = AppBlocsProvider.of<PodcastClipBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              _showClipsBottomSheet(
                  audioBloc: audioBloc,
                  podcastClipBloc: podcastClipBloc,
                  context: context);
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.cut_outlined,
                color: theme.buttonTheme.colorScheme.onPrimary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

_showClipsBottomSheet(
    {BuildContext context,
    AudioBloc audioBloc,
    PodcastClipBloc podcastClipBloc}) async {
  PositionState position = await getPositionDetails(audioBloc);
  if (position != null) {
    podcastClipBloc.setPodcastClipDetails(position: position);
  }
  bool canBeClipped = podcastClipBloc.isEpisodeClippable();
  if (!canBeClipped) {
    return;
  }
  podcastClipBloc.setClipSharingStatus(status: true);
  _pause(audioBloc);

  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
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
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .displaySmall
                                      .copyWith(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Divider(
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _durationToggleButton(context, () {
                                      podcastClipBloc.decrementDuration();
                                    }, Icons.remove_circle_outline),
                                    _numberPanel(context,
                                        clipDetailSnapshot.data.clipDuration),
                                    _durationToggleButton(context, () {
                                      podcastClipBloc.incrementDuration();
                                    }, Icons.add_circle_outline),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 12, left: 16, right: 16),
                          child: Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    podcastClipBloc.setClipSharingStatus(
                                        status: false);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    BreezTranslations.of(context)
                                        .podcast_clips_cancel_button,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .displaySmall
                                        .copyWith(
                                          fontSize: 16,
                                          color: Colors.white.withOpacity(0.5),
                                          fontWeight: FontWeight.w500,
                                        ),
                                  )),
                              const Spacer(),
                              clipDetailSnapshot.data.podcastClipState ==
                                      PodcastClipState.IDLE
                                  ? TextButton(
                                      onPressed: () async {
                                        podcastClipBloc.setPodcastState(
                                            PodcastClipState.FETCHING_IMAGE);
                                        Episode e = clipDetailSnapshot
                                            .data.episodeDetails;
                                        var image = NetworkImage(e.imageUrl);

                                        image
                                            .resolve(const ImageConfiguration())
                                            .addListener(
                                          ImageStreamListener(
                                            (info, call) async {
                                              Uint8List screenShotImage =
                                                  await ScreenshotController()
                                                      .captureFromWidget(
                                                          _imageWidget(
                                                              context: context,
                                                              episodeDetails:
                                                                  clipDetailSnapshot
                                                                      .data
                                                                      .episodeDetails),
                                                          context: context,
                                                          delay: const Duration(
                                                              milliseconds:
                                                                  10));
                                              try {
                                                await podcastClipBloc
                                                    .clipEpisode(
                                                        clipImage:
                                                            screenShotImage);
                                              } catch (e) {
                                                log.warning(e);
                                                showFlushbar(
                                                  context,
                                                  message: BreezTranslations.of(
                                                          context)
                                                      .podcast_clips_error,
                                                );
                                              }
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                          BreezTranslations.of(context)
                                              .podcast_clips_clip_button,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .displaySmall
                                              .copyWith(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              )))
                                  : const Center(
                                      child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    )),
                            ],
                          ),
                        )
                      ],
                    )
                  : const CircularProgressIndicator();
            });
      }).then((value) {
    podcastClipBloc.setClipSharingStatus(status: false);
    _play(audioBloc);
  });
}

Widget _numberPanel(BuildContext context, int durationInSeconds) {
  final minFontSize = 9.0 / MediaQuery.of(context).textScaleFactor;
  return GestureDetector(
    onTap: () => showDialog(
        useRootNavigator: true,
        context: context,
        builder: (c) => const CustomClipsDurationDialog()),
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
              style: Theme.of(context).primaryTextTheme.displaySmall.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  height: 1.2),
              minFontSize: minFontSize,
              stepGranularity: 0.1,
              maxLines: 1,
            ),
          ),
          AutoSizeText(
            BreezTranslations.of(context).podcast_clips_seconds,
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.displaySmall.copyWith(
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

Widget _durationToggleButton(
    BuildContext context, Function() onTap, IconData icon) {
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

Future<PositionState> getPositionDetails(AudioBloc audioBloc) async {
  PositionState position;
  try {
    position = await audioBloc.playPosition.first.timeout(const Duration(seconds: 1));
  } catch (e) {
    position = null;
  }
  return position;
}

_imageWidget({BuildContext context, Episode episodeDetails, Image image}) {
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
          breezTheme.BreezColors.blue[500],
          breezTheme.BreezColors.blue[500].withOpacity(0.5)
        ])),
    padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 28),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          episodeDetails.author,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).primaryTextTheme.displaySmall.copyWith(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(
          height: 8,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CustomImageBuilderWidget(
            imageurl: episodeDetails.imageUrl,
            image: image,
            height: 300,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          episodeDetails.podcast,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).primaryTextTheme.displaySmall.copyWith(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          episodeDetails.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).primaryTextTheme.displaySmall.copyWith(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(
          height: 60,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Clipped by ",
                style: Theme.of(context).primaryTextTheme.displaySmall.copyWith(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )),
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

class CustomClipsDurationDialog extends StatefulWidget {
  const CustomClipsDurationDialog({Key key}) : super(key: key);

  @override
  State<CustomClipsDurationDialog> createState() =>
      _CustomClipsDurationDialogState();
}

class _CustomClipsDurationDialogState extends State<CustomClipsDurationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _durationFocusNode = FocusNode();
  TextEditingController _clipDurationTextEditingController;

  @override
  void initState() {
    super.initState();
    _clipDurationTextEditingController = TextEditingController();
    _clipDurationTextEditingController.addListener(() {
      setState(() {});
    });
    if (_clipDurationTextEditingController.text.isEmpty) {
      _durationFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        BreezTranslations.of(context).podcast_clips_dialog_title,
        style: theme.dialogTheme.titleTextStyle.copyWith(
          fontSize: 16,
        ),
        maxLines: 1,
      ),
      content: _buildDurationDialogWidget(theme),
      actions: _buildActions(context),
    );
  }

  Widget _buildDurationDialogWidget(ThemeData theme) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: TextFormField(
        controller: _clipDurationTextEditingController,
        validator: (dur) => _Validator.validateDuration(dur),
        keyboardType: TextInputType.number,
        focusNode: _durationFocusNode,
        maxLength: 3,
        style: theme.dialogTheme.contentTextStyle.copyWith(
          height: 1.0,
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final podcastClipBloc = AppBlocsProvider.of<PodcastClipBloc>(context);

    List<Widget> actions = [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          texts.podcast_boost_action_cancel,
          style: themeData.primaryTextTheme.labelLarge,
        ),
      ),
    ];
    if (_clipDurationTextEditingController.text.isNotEmpty) {
      actions.add(
        TextButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.pop(context);
              int durationInSeconds =
                  int.parse(_clipDurationTextEditingController.text);
              podcastClipBloc.setPodcastClipDuration(
                  durationInSeconds: durationInSeconds);
            }
          },
          child: Text(
            BreezTranslations.of(context).podcast_clips_dialog_done,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
      );
    }
    return actions;
  }
}

void _play(AudioBloc audioBloc) {
  audioBloc.transitionState(TransitionState.play);
}

void _pause(AudioBloc audioBloc) {
  audioBloc.transitionState(TransitionState.pause);
}

String _formatDuration(Duration d) =>
    d.toString().split('.').first.padLeft(8, "0");

class _Validator {
  static String validateDuration(String value) {
    num duration = num.parse(value);
    if (duration < 10 || duration > 120) {
      return "Duration must be between 10 and 120";
    }

    return null;
  }
}

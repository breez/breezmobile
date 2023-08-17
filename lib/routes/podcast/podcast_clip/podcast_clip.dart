import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/podcast_clip/podcast_clip_bloc.dart';
import 'package:breez/routes/podcast/podcast_clip/podcast_clip_detail_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PodcastClipWidget extends StatefulWidget {
  const PodcastClipWidget({Key key}) : super(key: key);

  @override
  State<PodcastClipWidget> createState() => _PodcastClipWidgetState();
}

class _PodcastClipWidgetState extends State<PodcastClipWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () => _showClipsBottomSheet(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(
            Icons.cut_outlined,
            color: theme.buttonTheme.colorScheme.onPrimary,
            size: 16,
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showClipsBottomSheet() async {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final podcastClipBloc = AppBlocsProvider.of<PodcastClipBloc>(context);

    return await _getPositionDetails(audioBloc).then((position) async {
      if (position != null) {
        podcastClipBloc.setPodcastClipDetails(position: position);
      }
      bool canBeClipped = podcastClipBloc.isEpisodeClippable();
      if (!canBeClipped) {
        return;
      }
      podcastClipBloc.setClipSharingStatus(status: true);
      audioBloc.transitionState(TransitionState.pause);

      return await showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return const PodcastClipDetailBottomSheet();
        },
      ).then((value) {
        podcastClipBloc.setClipSharingStatus(status: false);
        audioBloc.transitionState(TransitionState.play);
      });
    });
  }
}

Future<PositionState> _getPositionDetails(AudioBloc audioBloc) async {
  PositionState position;
  try {
    position = await audioBloc.playPosition.first.timeout(
      const Duration(seconds: 1),
    );
  } catch (e) {
    position = null;
  }
  return position;
}

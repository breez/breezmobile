// Copyright 2020-2021 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/l10n/L.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:anytime/ui/widgets/sleep_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'speed_selector.dart';

/// Builds a transport control bar for rewind, play and fast-forward.
/// See [NowPlaying].
class PlayerTransportControls extends StatefulWidget {
  @override
  PlayerTransportControlsState createState() => PlayerTransportControlsState();
}

class PlayerTransportControlsState extends State<PlayerTransportControls>
    with SingleTickerProviderStateMixin {
  AnimationController _playPauseController;
  StreamSubscription<AudioState> _audioStateSubscription;
  bool init = true;

  @override
  void initState() {
    super.initState();

    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    _playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    /// Seems a little hacky, but when we load the form we want the play/pause
    /// button to be in the correct state. If we are building the first frame,
    /// just set the animation controller to the correct state; for all other
    /// frames we want to animate. Doing it this way prevents the play/pause
    /// button from animating when the form is first loaded.
    _audioStateSubscription = audioBloc.playingState.listen((event) {
      if (event == AudioState.playing || event == AudioState.buffering) {
        if (init) {
          _playPauseController.value = 1;
          init = false;
        } else {
          _playPauseController.forward();
        }
      } else {
        if (init) {
          _playPauseController.value = 0;
          init = false;
        } else {
          _playPauseController.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    _audioStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final theme = Theme.of(context);

    return StreamBuilder<AudioState>(
      stream: audioBloc.playingState,
      builder: (context, snapshot) {
        final audioState = snapshot.data;

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(flex: 1, child: Container()),
                SleepSelector(
                  //padding: EdgeInsets.zero,
                  iconOn: SvgPicture.asset(
                    'assets/icons/sleep_on.svg',
                    colorFilter: ColorFilter.mode(
                      theme.buttonTheme.colorScheme.onPrimary,
                      BlendMode.srcATop,
                    ),
                    height: 24.0,
                    width: 24.0,
                  ),
                  iconOff: SvgPicture.asset(
                    'assets/icons/sleep_off.svg',
                    colorFilter: ColorFilter.mode(
                      theme.buttonTheme.colorScheme.onPrimary,
                      BlendMode.srcATop,
                    ),
                    height: 24.0,
                    width: 24.0,
                  ),
                ),
                Expanded(flex: 1, child: Container()),
                IconButton(
                  onPressed: () {
                    return snapshot.data == AudioState.buffering ? null : _rewind(audioBloc);
                  },
                  tooltip: L.of(context).rewind_button_label,
                  padding: const EdgeInsets.all(0.0),
                  icon: SvgPicture.asset(
                    "src/icon/ic_backward.svg",
                    width: 48.0,
                    height: 48.0,
                    colorFilter: ColorFilter.mode(
                      theme.buttonTheme.colorScheme.onPrimary,
                      BlendMode.srcATop,
                    ),
                  ),
                ),
                Expanded(flex: 1, child: Container()),
                _PlayButton(
                  audioState: audioState,
                  onPlay: () => _play(audioBloc),
                  onPause: () => _pause(audioBloc),
                  playPauseController: _playPauseController,
                ),
                Expanded(flex: 1, child: Container()),
                IconButton(
                  onPressed: () {
                    return snapshot.data == AudioState.buffering ? null : _fastForward(audioBloc);
                  },
                  padding: const EdgeInsets.all(0.0),
                  icon: SvgPicture.asset(
                    "src/icon/ic_forward.svg",
                    width: 48.0,
                    height: 48.0,
                    colorFilter: ColorFilter.mode(
                      theme.buttonTheme.colorScheme.onPrimary,
                      BlendMode.srcATop,
                    ),
                  ),
                ),
                Expanded(flex: 1, child: Container()),
                SpeedSelectorWidget(
                  onChanged: (value) => audioBloc.playbackSpeed(value),
                ),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          ],
        );
      },
    );
  }

  void _play(AudioBloc audioBloc) {
    audioBloc.transitionState(TransitionState.play);
  }

  void _pause(AudioBloc audioBloc) {
    audioBloc.transitionState(TransitionState.pause);
  }

  void _rewind(AudioBloc audioBloc) {
    audioBloc.transitionState(TransitionState.rewind);
  }

  void _fastForward(AudioBloc audioBloc) {
    audioBloc.transitionState(TransitionState.fastforward);
  }
}

class _PlayButton extends StatelessWidget {
  final AudioState audioState;
  final Function() onPlay;
  final Function() onPause;
  final AnimationController playPauseController;

  const _PlayButton({Key key, this.audioState, this.onPlay, this.onPause, this.playPauseController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final playing = audioState == AudioState.playing;
    final buffering = audioState == null || audioState == AudioState.buffering;

    // in case we are buffering show progress indicator.
    final translations = L.of(context);

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        if (buffering)
          SpinKitRing(
            lineWidth: 2.0,
            color: themeData.colorScheme.secondary,
            size: 84,
          ),
        if (!buffering)
          const SizedBox(
            height: 84,
            width: 84,
          ),
        Tooltip(
          message: playing ? translations.pause_button_label : translations.play_button_label,
          child: TextButton(
            style: TextButton.styleFrom(
              shape: CircleBorder(
                side: BorderSide(color: themeData.highlightColor, width: 0.0),
              ),
              backgroundColor: themeData.primaryColor,
              padding: const EdgeInsets.all(8.0),
            ),
            onPressed: buffering
                ? null
                : () {
                    if (playing) {
                      onPause();
                    } else {
                      onPlay();
                    }
                  },
            child: AnimatedIcon(
              size: 60.0,
              icon: AnimatedIcons.play_pause,
              color: Colors.white,
              progress: playPauseController,
            ),
          ),
        ),
      ],
    );
  }
}

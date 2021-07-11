// Copyright 2020-2021 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/l10n/L.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'speed_selector.dart';

/// Builds a transport control bar for rewind, play and fast-forward.
/// See [NowPlaying].
class PlayerTransportControls extends StatefulWidget {
  @override
  _PlayerTransportControlsState createState() =>
      _PlayerTransportControlsState();
}

class _PlayerTransportControlsState extends State<PlayerTransportControls>
    with SingleTickerProviderStateMixin {
  AnimationController _playPauseController;
  StreamSubscription<AudioState> _audioStateSubscription;
  bool init = true;

  @override
  void initState() {
    super.initState();

    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    _playPauseController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    /// Seems a little hacky, but when we load the form we want the play/pause
    /// button to be in the correct state. If we are building the first frame,
    /// just set the animation controller to the correct state; for all other
    /// frames we want to animate. Doing it this way prevents the play/pause
    /// button from animating when the form is first loaded.
    _audioStateSubscription = audioBloc.playingState.listen((event) {
      if (event == AudioState.playing) {
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

    return Padding(
      padding: EdgeInsets.only(left: 70, right: 16),
      child: StreamBuilder<AudioState>(
          stream: audioBloc.playingState,
          builder: (context, snapshot) {
            final audioState = snapshot.data;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _rewind(audioBloc);
                  },
                  tooltip: L.of(context).rewind_button_label,
                  padding: const EdgeInsets.all(0.0),
                  icon: ImageIcon(
                    AssetImage('src/icon/replay_30.png'),
                    size: 48.0,
                    color: Theme.of(context).buttonColor,
                  ),
                ),
                _PlayButton(
                    audioState: audioState,
                    onPlay: () => _play(audioBloc),
                    onPause: () => _pause(audioBloc),
                    playPauseController: _playPauseController),
                IconButton(
                  onPressed: () {
                    _fastforward(audioBloc);
                  },
                  padding: const EdgeInsets.all(0.0),
                  icon: ImageIcon(
                    AssetImage('src/icon/forward_30.png'),
                    size: 48.0,
                    color: Theme.of(context).buttonColor,
                  ),
                ),
                SpeedSelector(
                  onChanged: (double value) {
                    print('Speed callback of $value');
                    audioBloc.playbackSpeed(value);
                  },
                ),
              ],
            );
          }),
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

  void _fastforward(AudioBloc audioBloc) {
    audioBloc.transitionState(TransitionState.fastforward);
  }
}

class _PlayButton extends StatelessWidget {
  final AudioState audioState;
  final Function() onPlay;
  final Function() onPause;
  final AnimationController playPauseController;

  const _PlayButton(
      {Key key,
      this.audioState,
      this.onPlay,
      this.onPause,
      this.playPauseController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playing = audioState == AudioState.playing;
    final bufferring = audioState == null || audioState == AudioState.buffering;

    // in case we are bufferring show progress indicator.
    if (bufferring) {
      return Tooltip(
          message: playing
              ? L.of(context).pause_button_label
              : L.of(context).play_button_label,
          child: TextButton(
            style: TextButton.styleFrom(
              shape: CircleBorder(),
            ),
            onPressed: null,
            child: SpinKitRing(
              lineWidth: 2.0,
              color: Theme.of(context).colorScheme.secondary,
              size: 60,
            ),
          ));
    }

    return Tooltip(
      message: playing
          ? L.of(context).pause_button_label
          : L.of(context).play_button_label,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: CircleBorder(
              side: BorderSide(
                  color: Theme.of(context).highlightColor, width: 0.0)),
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(8.0),
        ),
        onPressed: () {
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
    );
  }
}

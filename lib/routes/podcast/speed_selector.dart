// Copyright 2020-2021 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/bloc/settings/settings_bloc.dart';
import 'package:anytime/entities/app_settings.dart';
import 'package:anytime/l10n/L.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:provider/provider.dart';

/// This widget allows the user to change the playback speed and toggle audio
/// effects. The two audio effects, trim silence and volume boost, are
/// currently Android only.
class SpeedSelectorWidget extends StatefulWidget {
  final ValueChanged<double> onChanged;

  const SpeedSelectorWidget({
    this.onChanged,
  });

  @override
  SpeedSelectorWidgetState createState() => SpeedSelectorWidgetState();
}

class SpeedSelectorWidgetState extends State<SpeedSelectorWidget> {
  var speed = 1.0;

  @override
  void initState() {
    var settingsBloc = Provider.of<SettingsBloc>(context, listen: false);

    speed = settingsBloc.currentSettings.playbackSpeed;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    final settingsBloc = Provider.of<SettingsBloc>(context);

    return StreamBuilder<AppSettings>(
      stream: settingsBloc.settings,
      initialData: AppSettings.sensibleDefaults(),
      builder: (context, snapshot) {
        final speed = snapshot.data.playbackSpeed;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: themeData.colorScheme.background,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  builder: (context) => SpeedSlider(
                    onChanged: widget.onChanged,
                  ),
                );
              },
              child: Center(
                child: Text(
                  texts.podcast_speed_selector_speed(
                    speed % 1 == 0
                        ? speed.toStringAsFixed(0).toString()
                        : speed.toString(),
                  ),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: themeData.buttonTheme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SpeedSlider extends StatefulWidget {
  final ValueChanged<double> onChanged;

  const SpeedSlider({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  SpeedSliderState createState() => SpeedSliderState();
}

class SpeedSliderState extends State<SpeedSlider> {
  var speed = 1.0;
  var trimSilence = false;
  var volumeBoost = false;

  @override
  void initState() {
    final settingsBloc = Provider.of<SettingsBloc>(context, listen: false);

    speed = settingsBloc.currentSettings.playbackSpeed;
    trimSilence = settingsBloc.currentSettings.trimSilence;
    volumeBoost = settingsBloc.currentSettings.volumeBoost;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final settingsBloc = Provider.of<SettingsBloc>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 24,
            height: 4,
            decoration: BoxDecoration(
              color: themeData.buttonTheme.colorScheme.onPrimary,
              borderRadius: const BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
          ),
          child: Text(
            L.of(context).audio_settings_playback_speed_label,
            style: themeData.primaryTextTheme.titleLarge,
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            texts.podcast_speed_selector_speed(
              speed % 1 == 0
                  ? speed.toStringAsFixed(0).toString()
                  : speed.toString(),
            ),
            style: themeData.primaryTextTheme.headlineSmall,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: IconButton(
                iconSize: 28.0,
                icon: const Icon(Icons.remove_circle_outline),
                color: themeData.buttonTheme.colorScheme.onPrimary,
                onPressed: (speed <= 0.5)
                    ? null
                    : () {
                        setState(() {
                          speed -= 0.25;
                          audioBloc.playbackSpeed(speed);
                          settingsBloc.setPlaybackSpeed(speed);
                        });
                      },
              ),
            ),
            Expanded(
              flex: 4,
              child: Slider(
                value: speed,
                min: 0.5,
                max: 3.0,
                divisions: 10,
                activeColor: themeData.buttonTheme.colorScheme.onPrimary,
                onChanged: (value) {
                  setState(() {
                    speed = value;
                  });
                },
                onChangeEnd: (value) {
                  audioBloc.playbackSpeed(speed);
                  settingsBloc.setPlaybackSpeed(value);
                  if (widget.onChanged != null) {
                    widget.onChanged(value);
                  }
                },
              ),
            ),
            Expanded(
              child: IconButton(
                iconSize: 28.0,
                icon: const Icon(Icons.add_circle_outline),
                color: themeData.buttonTheme.colorScheme.onPrimary,
                onPressed: (speed >= 3.0)
                    ? null
                    : () {
                        setState(() {
                          speed += 0.25;
                          audioBloc.playbackSpeed(speed);
                          settingsBloc.setPlaybackSpeed(speed);
                        });
                      },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        const Divider(),
        if (themeData.platform == TargetPlatform.android) ...[
          /// Disable the trim silence option for now until the positioning bug
          /// in just_audio is resolved.
          // ListTile(
          //   title: Text(L.of(context).audio_effect_trim_silence_label),
          //   trailing: Switch.adaptive(
          //     value: trimSilence,
          //     onChanged: (value) {
          //       setState(() {
          //         trimSilence = value;
          //         audioBloc.trimSilence(value);
          //         settingsBloc.trimSilence(value);
          //       });
          //     },
          //   ),
          // ),
          ListTile(
            title: Text(L.of(context).audio_effect_volume_boost_label),
            trailing: Switch.adaptive(
              value: volumeBoost,
              onChanged: (boost) {
                setState(() {
                  volumeBoost = boost;
                  audioBloc.volumeBoost(boost);
                  settingsBloc.volumeBoost(boost);
                });
              },
            ),
          ),
        ] else
          const SizedBox(
            width: 0.0,
            height: 0.0,
          ),
      ],
    );
  }
}

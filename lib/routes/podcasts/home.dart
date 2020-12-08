import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsacdop/class/settingstate.dart';
import 'package:tsacdop/home/home.dart';
import 'package:tsacdop/state/audio_state.dart';
import 'package:tsacdop/state/download_state.dart';
import 'package:tsacdop/state/podcast_group.dart';
import 'package:tsacdop/state/refresh_podcast.dart';
import 'package:tsacdop/state/search_state.dart';
import 'package:feature_discovery/feature_discovery.dart';

///Initial theme settings
final SettingState themeSetting = SettingState();

class PodcastEnvelope extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(child: Home());
  }
}

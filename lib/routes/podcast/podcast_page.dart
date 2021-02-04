import 'package:anytime/api/podcast/mobile_podcast_api.dart';
import 'package:anytime/bloc/discovery/discovery_bloc.dart';
import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/bloc/podcast/episode_bloc.dart';
import 'package:anytime/bloc/podcast/podcast_bloc.dart';
import 'package:anytime/bloc/search/search_bloc.dart';
import 'package:anytime/bloc/settings/settings_bloc.dart';
import 'package:anytime/bloc/ui/pager_bloc.dart';
import 'package:anytime/repository/repository.dart';
import 'package:anytime/repository/sembast/sembast_repository.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:anytime/services/audio/mobile_audio_player_service.dart';
import 'package:anytime/services/download/download_service.dart';
import 'package:anytime/services/download/mobile_download_service.dart';
import 'package:anytime/services/podcast/mobile_podcast_service.dart';
import 'package:anytime/services/podcast/podcast_service.dart';
import 'package:anytime/services/settings/mobile_settings_service.dart';
import 'package:anytime/ui/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'anytime_downloader.dart';

var theme = Themes.lightTheme().themeData;

/// Anytime is a Podcast player. You can search and subscribe to podcasts,
/// download and stream episodes and view the latest podcast charts.
// ignore: must_be_immutable
class AnytimePodcastApp extends StatefulWidget {
  static String applicationVersion = '0.1.3';
  static String applicationBuildNumber = '22';

  final Repository repository;
  final MobilePodcastApi podcastApi;
  final Widget child;
  DownloadService downloadService;
  PodcastService podcastService;
  AudioPlayerService audioPlayerService;
  SettingsBloc settingsBloc;
  MobileSettingsService mobileSettingsService;

  AnytimePodcastApp(this.mobileSettingsService, this.child)
      : repository = SembastRepository(),
        podcastApi = MobilePodcastApi() {
    downloadService = MobileDownloadService(
        repository: repository, downloadManager: AnytimeDownloadManager());
    podcastService = MobilePodcastService(
        api: podcastApi,
        repository: repository,
        settingsService: mobileSettingsService);
    audioPlayerService = MobileAudioPlayerService(
        repository: repository, settingsService: mobileSettingsService);
    settingsBloc = SettingsBloc(mobileSettingsService);
  }

  @override
  _AnytimePodcastAppState createState() => _AnytimePodcastAppState();
}

class _AnytimePodcastAppState extends State<AnytimePodcastApp> {
  ThemeData theme;

  @override
  void initState() {
    super.initState();

    widget.settingsBloc.settings.listen((event) {
      setState(() {
        var newTheme = event.theme == 'dark'
            ? Themes.darkTheme().themeData
            : Themes.lightTheme().themeData;

        /// Only update the theme if it has changed.
        if (newTheme != theme) {
          theme = newTheme;
        }
      });
    });

    if (widget.mobileSettingsService.themeDarkMode) {
      theme = Themes.darkTheme().themeData;
    } else {
      theme = Themes.lightTheme().themeData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SearchBloc>(
          create: (_) => SearchBloc(
              podcastService: MobilePodcastService(
            api: widget.podcastApi,
            repository: widget.repository,
            settingsService: widget.mobileSettingsService,
          )),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<DiscoveryBloc>(
          create: (_) => DiscoveryBloc(
              podcastService: MobilePodcastService(
            api: widget.podcastApi,
            repository: widget.repository,
            settingsService: widget.mobileSettingsService,
          )),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<EpisodeBloc>(
          create: (_) => EpisodeBloc(
              podcastService: MobilePodcastService(
                api: widget.podcastApi,
                repository: widget.repository,
                settingsService: widget.mobileSettingsService,
              ),
              audioPlayerService: widget.audioPlayerService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<PodcastBloc>(
          create: (_) => PodcastBloc(
              podcastService: widget.podcastService,
              audioPlayerService: widget.audioPlayerService,
              downloadService: widget.downloadService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<PagerBloc>(
          create: (_) => PagerBloc(),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<AudioBloc>(
          create: (_) =>
              AudioBloc(audioPlayerService: widget.audioPlayerService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<SettingsBloc>(
          create: (_) => widget.settingsBloc,
          dispose: (_, value) => value.dispose(),
        ),
      ],
      child: widget.child,
    );
  }
}

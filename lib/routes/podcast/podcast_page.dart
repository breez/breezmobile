import 'package:anytime/api/podcast/podcast_api.dart';
import 'package:anytime/bloc/discovery/discovery_bloc.dart';
import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/bloc/podcast/episode_bloc.dart';
import 'package:anytime/bloc/podcast/podcast_bloc.dart';
import 'package:anytime/bloc/search/search_bloc.dart';
import 'package:anytime/bloc/settings/settings_bloc.dart';
import 'package:anytime/bloc/ui/pager_bloc.dart';
import 'package:anytime/repository/repository.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:anytime/services/audio/mobile_audio_player_service.dart';
import 'package:anytime/services/download/download_service.dart';
import 'package:anytime/services/download/mobile_download_service.dart';
import 'package:anytime/services/podcast/mobile_podcast_service.dart';
import 'package:anytime/services/podcast/podcast_service.dart';
import 'package:anytime/services/settings/mobile_settings_service.dart';
import 'package:anytime/ui/podcast/player_position_controls.dart';
import 'package:anytime/ui/themes.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/podcast_payments/model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/podcast/add_funds_message.dart';
import 'package:breez/routes/podcast/payment_adjustment.dart';
import 'package:breez/routes/podcast/podcast_index_api.dart';
import 'package:breez/routes/podcast/podcast_loader.dart';
import 'package:breez/routes/podcast/transport_controls.dart';
import 'package:breez/theme_data.dart' as breezTheme;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'anytime_downloader.dart';
import 'confetti.dart';

var theme = Themes.lightTheme().themeData;

/// Anytime is a Podcast player. You can search and subscribe to podcasts,
/// download and stream episodes and view the latest podcast charts.
// ignore: must_be_immutable
class AnytimePodcastApp extends StatefulWidget {
  static String applicationVersion = '0.1.3';
  static String applicationBuildNumber = '22';

  final podcastIndexClient = PodcastIndexClient();
  final Repository repository;
  final PodcastApi podcastApi;
  final Widget child;
  DownloadService downloadService;
  PodcastService podcastService;
  AudioPlayerService audioPlayerService;
  SettingsBloc settingsBloc;
  MobileSettingsService mobileSettingsService;

  AnytimePodcastApp(this.mobileSettingsService, this.repository, this.child)
      : podcastApi = PodcastIndexAPI() {
    downloadService = MobileDownloadService(
        repository: repository, downloadManager: AnytimeDownloadManager());
    podcastService = MobilePodcastService(
        api: podcastApi,
        repository: repository,
        settingsService: mobileSettingsService,
        loadMetadata: (url) => podcastIndexClient.loadFeed(url: url));
    audioPlayerService = MobileAudioPlayerService(
      repository: repository,
      podcastService: podcastService,
      settingsService: mobileSettingsService,
      androidNotificationColor: breezTheme.BreezColors.blue[500],
    );
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

class NowPlayingTransport extends StatelessWidget {
  final int duration;

  const NowPlayingTransport({@required this.duration});

  @override
  Widget build(BuildContext context) {
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    final userBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    return StreamBuilder<BreezUserModel>(
        stream: userBloc.userStream,
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return SizedBox();
          }
          var userModel = userSnapshot.data;
          return StreamBuilder<AccountModel>(
            stream: accountBloc.accountStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }

              List<Widget> widgets = [];
              widgets.add(Divider(height: 0.0));
              // We'll also show add funds message if user tries to boost and has no balance
              if (snapshot.data.balance < userModel.preferredSatsPerMinValue) {
                widgets.add(AddFundsMessage(accountModel: snapshot.data));
                widgets.add(Divider(height: 0.0));
              }
              widgets.add(WithConfettyPaymentEffect(
                  type: PaymentEventType.StreamCompleted,
                  child: PlayerPositionControls()));
              widgets.add(PlayerTransportControls());
              widgets.add(
                  Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)));
              widgets.add(Divider(height: 0.0, indent: 116, endIndent: 116));
              widgets.add(
                  Padding(padding: const EdgeInsets.symmetric(vertical: 4.0)));
              widgets.add(PaymentAdjustment(total: 100));
              return SizedBox(
                  height:
                      snapshot.data.balance < userModel.preferredSatsPerMinValue
                          ? 288.0
                          : 216.0,
                  child: Column(children: widgets));
            },
          );
        });
  }
}

WidgetBuilder playerBuilder(int duration) {
  final WidgetBuilder builder =
      (BuildContext context) => NowPlayingTransport(duration: duration);
  return builder;
}

WidgetBuilder placeholderBuilder() {
  final WidgetBuilder builder = (BuildContext context) => Container(
        color: Theme.of(context).primaryColor,
        constraints: BoxConstraints.expand(),
      );
  return builder;
}

WidgetBuilder errorPlaceholderBuilder() {
  final WidgetBuilder builder = (BuildContext context) => Placeholder(
        color: Theme.of(context).errorColor,
        strokeWidth: 1,
      );
  return builder;
}

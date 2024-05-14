import 'dart:async';

import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/bloc/podcast/podcast_bloc.dart';
import 'package:anytime/bloc/settings/settings_bloc.dart';
import 'package:anytime/entities/feed.dart';
import 'package:anytime/entities/podcast.dart';
import 'package:anytime/state/bloc_state.dart';
import 'package:anytime/ui/podcast/now_playing.dart';
import 'package:anytime/ui/podcast/podcast_details.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/admin_login_dialog.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uni_links/uni_links.dart';

class PodcastURLHandler {
  PodcastURLHandler(
    UserProfileBloc userProfileBloc,
    BuildContext context,
    Function(Object error) onError,
  ) {
    Rx.merge([getInitialLink().asStream(), linkStream])
        .where((l) => l != null && (l.contains("breez.link/p")))
        .listen((link) async {
      var loaderRoute = createLoaderRoute(context);
      try {
        Navigator.of(context).push(loaderRoute);
        await protectAdminAction(
          context,
          await userProfileBloc.userStream.firstWhere((u) => u != null),
          () async {
            final injector = ServiceInjector();
            final podcastLink = injector.deepLinks.parsePodcastShareLink(link);
            userProfileBloc.userActionsSink.add(
              SetAppMode(AppMode.podcasts),
            );

            await handleDeeplink(
              context,
              podcastLink.feedURL,
              podcastLink.episodeID,
            );
          },
        );
      } catch (e) {
        Navigator.popUntil(context, (route) => route.settings.name == "/");
        showFlushbar(context, message: e.toString());
      } finally {
        if (loaderRoute.isActive) {
          Navigator.of(context).removeRoute(loaderRoute);
        }
      }
    });
  }
}

Future handleDeeplink(
  BuildContext context,
  String podcastURL,
  String episodeID,
) async {
  final texts = context.texts();
  final navigator = Navigator.of(context);
  if (episodeID != null) {
    try {
      var podcastBloc = Provider.of<PodcastBloc>(context, listen: false);
      var podcast = Podcast.fromUrl(url: podcastURL);
      // Load the details of the Podcast specified in the URL
      podcastBloc.load(Feed(podcast: podcast));
      final audioBloc = Provider.of<AudioBloc>(context, listen: false);
      final settingsBloc = Provider.of<SettingsBloc>(context, listen: false);

      // Wait for the podcast details to load
      await podcastBloc.details
          .firstWhere((blocState) => blocState is! BlocLoadingState)
          .then((blocState) async {
        if (blocState is BlocErrorState) {
          throw texts.handler_podcast_error_load_episode;
        } else if (blocState is BlocPopulatedState) {
          // Retrieve episode list and play matching episode
          var episodeList = await podcastBloc.episodes.firstWhere((episodeList) => episodeList.isNotEmpty);
          var episode = episodeList.firstWhere(
            (episode) => episode.guid == episodeID,
            orElse: () => null,
          );
          if (episode != null) {
            audioBloc.play(episode);
            final settings = settingsBloc.currentSettings;
            if (settings.autoOpenNowPlaying) {
              navigator.pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  builder: (context) => NowPlaying(),
                  fullscreenDialog: false,
                ),
                ModalRoute.withName('/'),
              );
            }
          } else {
            await _navigateToPodcast(navigator, podcastURL);
          }
        }
      });
    } catch (e) {
      throw e.toString();
    }
  } else {
    try {
      await _navigateToPodcast(navigator, podcastURL);
    } catch (e) {
      throw Exception(texts.handler_podcast_error_load_episode_fallback);
    }
  }
}

Future _navigateToPodcast(NavigatorState navigator, String podcastURL) {
  return navigator.pushAndRemoveUntil(
    MaterialPageRoute<void>(
      builder: (context) => PodcastDetails(
        Podcast.fromUrl(url: podcastURL),
        Provider.of<PodcastBloc>(
          context,
          listen: false,
        ),
      ),
    ),
    ModalRoute.withName('/'),
  );
}

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
import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uni_links/uni_links.dart';

class PodcastURLHandler {
  PodcastURLHandler(UserProfileBloc userProfileBloc, BuildContext context,
      Function(Object error) onError) {
    Rx.merge([getInitialLink().asStream(), getLinksStream()])
        .where((l) => l != null && (l.contains("breez.link/p")))
        .listen((link) async {
      var loaderRoute = createLoaderRoute(context);
      try {
        Navigator.of(context).push(loaderRoute);
        var user =
            await userProfileBloc.userStream.firstWhere((u) => u != null);
        await protectAdminAction(context, user, () async {
          PodcastShareLinkModel podcastLink =
              ServiceInjector().deepLinks.parsePodcastShareLink(link);
          userProfileBloc.userActionsSink.add(SetAppMode(AppMode.podcasts));

          await handleDeeplink(
              context, podcastLink.feedURL, podcastLink.episodeID);
        });
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
    BuildContext context, String podcastURL, String episodeID) async {
  if (episodeID != null) {
    try {
      var podcastBloc = Provider.of<PodcastBloc>(context, listen: false);
      var podcast = Podcast.fromUrl(url: podcastURL);
      // Load the details of the Podcast specified in the URL
      podcastBloc.load(Feed(podcast: podcast));
      // Wait for the podcast details to load
      var blocstate = await podcastBloc.details.first;
      if (blocstate is BlocErrorState) {
        throw "Failed to load episode.";
      } else if (blocstate is BlocPopulatedState) {
        // Retrieve episode list and play matching episode
        var episodeList = await podcastBloc.episodes
            .firstWhere((episodeList) => episodeList.isNotEmpty);
        var episode =
            episodeList.firstWhere((episode) => episode.guid == episodeID);
        if (episode != null) {
          final audioBloc = Provider.of<AudioBloc>(context, listen: false);
          audioBloc.play(episode);
          final settings =
              Provider.of<SettingsBloc>(context, listen: false).currentSettings;
          if (settings.autoOpenNowPlaying) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                    builder: (context) => NowPlaying(),
                    fullscreenDialog: false),
                ModalRoute.withName('/'));
          }
        } else {
          throw "Episode not found.";
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  } else {
    try {
      await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
              builder: (context) => PodcastDetails(
                  Podcast.fromUrl(url: podcastURL),
                  Provider.of<PodcastBloc>(context, listen: false))),
          ModalRoute.withName('/'));
    } catch (e) {
      throw Exception("Failed to load podcast.");
    }
  }
}

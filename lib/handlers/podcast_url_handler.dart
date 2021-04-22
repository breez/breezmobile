import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/admin_login_dialog.dart';
import 'package:breez/routes/podcast/podcast_index_api.dart';
import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uni_links/uni_links.dart';

class PodcastURLHandler {
  PodcastURLHandler(
      UserProfileBloc userProfileBloc,
      BuildContext context,
      Function(PodcastShareLinkModel podcastShareLink) onValidPodcast,
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
          var podcast = await PodcastIndexAPI().loadFeed(podcastLink.feedURL);
          if (podcast != null) {
            Navigator.of(context).removeRoute(loaderRoute);
            if (podcastLink.episodeID != null) {
              var episode = podcast.episodes.firstWhere(
                  (episode) => episode.guid == podcastLink.episodeID);
              onValidPodcast(PodcastShareLinkModel(podcast.url,
                  episodeID: episode != null ? episode.guid : null));
            } else {
              onValidPodcast(PodcastShareLinkModel(podcast.url));
            }
          }
        });
      } catch (e) {
        onError(e);
      } finally {
        if (loaderRoute.isActive) {
          Navigator.of(context).removeRoute(loaderRoute);
        }
      }
    });
  }
}

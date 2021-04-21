import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/admin_login_dialog.dart';
import 'package:breez/routes/podcast/podcast_index_api.dart';
import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/cupertino.dart';

class PodcastURLHandler {
  PodcastURLHandler(
      UserProfileBloc userProfileBloc,
      BuildContext context,
      Function(String podcastURL) onValidPodcast,
      Function(Object error) onError) {
    DeepLinksService deepLinks = ServiceInjector().deepLinks;
    deepLinks.linksNotifications.listen((link) async {
      var loaderRoute = createLoaderRoute(context);
      try {
        Navigator.of(context).push(loaderRoute);
        var user =
            await userProfileBloc.userStream.firstWhere((u) => u != null);
        await protectAdminAction(context, user, () async {
          PodcastShareLinkModel podcastLink =
              deepLinks.parsePodcastShareLink(link);
          var podcast = await PodcastIndexAPI().loadFeed(podcastLink.feedURL);
          if (podcast != null) {
            Navigator.of(context).removeRoute(loaderRoute);
            onValidPodcast(podcast.url);
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

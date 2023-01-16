import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShareEpisodeButton extends StatelessWidget {
  final String podcastTitle;
  final String podcastURL;
  final String episodeTitle;
  final String episodeID;

  const ShareEpisodeButton({
    Key key,
    this.podcastTitle,
    this.podcastURL,
    this.episodeTitle,
    this.episodeID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
        onPressed: () async {
          DeepLinksService _deepLinks = ServiceInjector().deepLinks;
          var podcastShareLink = await _deepLinks.generatePodcastShareLink(
            PodcastShareLinkModel(
              podcastURL,
              episodeID: episodeID,
            ),
          );
          Share.share(
            texts.podcast_boost_share_texts(
              podcastTitle,
              episodeTitle,
              podcastShareLink,
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.share_rounded,
              size: 22,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
            ),
            Text(
              texts.podcast_boost_action_share,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

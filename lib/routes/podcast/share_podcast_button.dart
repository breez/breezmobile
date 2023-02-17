import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:share_plus/share_plus.dart';

class SharePodcastButton extends StatelessWidget {
  final String podcastTitle;
  final String podcastURL;

  const SharePodcastButton({
    Key key,
    this.podcastTitle,
    this.podcastURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          icon: Icon(
            Icons.share_rounded,
            color: themeData.buttonTheme.colorScheme.onPrimary,
            size: 22,
          ),
          onPressed: () async {
            DeepLinksService deepLinks = ServiceInjector().deepLinks;
            var podcastShareLink = await deepLinks.generatePodcastShareLink(
              PodcastShareLinkModel(podcastURL),
            );
            Share.share(
              texts.podcast_boost_share_texts_short(
                podcastTitle,
                podcastShareLink,
              ),
            );
          },
        ),
      ),
    );
  }
}

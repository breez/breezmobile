import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_extend/share_extend.dart';

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
    final texts = AppLocalizations.of(context);
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
            DeepLinksService _deepLinks = ServiceInjector().deepLinks;
            var podcastShareLink = await _deepLinks.generatePodcastShareLink(
              PodcastShareLinkModel(podcastURL),
            );
            ShareExtend.share(
              texts.podcast_boost_share_texts_short(
                podcastTitle,
                podcastShareLink,
              ),
              "text",
            );
          },
        ),
      ),
    );
  }
}

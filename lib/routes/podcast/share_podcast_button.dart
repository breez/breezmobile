import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

class SharePodcastButton extends StatefulWidget {
  final String podcastTitle;
  final String podcastURL;

  const SharePodcastButton({Key key, this.podcastTitle, this.podcastURL}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SharePodcastButtonState();
  }
}

class SharePodcastButtonState extends State<SharePodcastButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
          alignment: Alignment.centerRight,
          icon: Icon(
            Icons.share_rounded,
            color: Theme.of(context).buttonColor,
            size: 22,
          ),
          onPressed: () async {
            DeepLinksService _deepLinks = ServiceInjector().deepLinks;
            var podcastShareLink = await _deepLinks.generatePodcastShareLink(
                PodcastShareLinkModel(widget.podcastURL));
            ShareExtend.share(widget.podcastTitle + '\n' + podcastShareLink, "text");
          }),
    );
  }
}

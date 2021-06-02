import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

class ShareEpisodeButton extends StatefulWidget {
  final String podcastTitle;
  final String podcastURL;
  final String episodeTitle;
  final String episodeID;

  const ShareEpisodeButton(
      {Key key,
      this.podcastTitle,
      this.podcastURL,
      this.episodeTitle,
      this.episodeID})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShareEpisodeButtonState();
  }
}

class ShareEpisodeButtonState extends State<ShareEpisodeButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        ),
        onPressed: () async {
          DeepLinksService _deepLinks = ServiceInjector().deepLinks;
          var podcastShareLink = await _deepLinks.generatePodcastShareLink(
              PodcastShareLinkModel(widget.podcastURL,
                  episodeID: widget.episodeID));
          ShareExtend.share(
              widget.podcastTitle +
                  '\n' +
                  widget.episodeTitle +
                  '\n' +
                  podcastShareLink,
              "text");
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.share_rounded,
              color: Theme.of(context).buttonColor,
              size: 22,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
            ),
            Text(
              "Share",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).buttonColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

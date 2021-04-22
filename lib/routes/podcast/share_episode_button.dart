import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

class ShareEpisodeButton extends StatefulWidget {
  final String podcastURL;
  final String episodeID;

  const ShareEpisodeButton({Key key, this.podcastURL, this.episodeID})
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
      child: FlatButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        onPressed: () async {
          DeepLinksService _deepLinks = ServiceInjector().deepLinks;
          var podcastShareLink = await _deepLinks.generatePodcastShareLink(
              PodcastShareLinkModel(widget.podcastURL,
                  episodeID: widget.episodeID));
          ShareExtend.share(podcastShareLink, "text");
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
              "Share Episode",
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

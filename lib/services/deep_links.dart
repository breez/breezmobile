import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

final _log = Logger("DeepLinksService");

class DeepLinksService {
  static const SESSION_SECRET = "sessionSecret";

  final StreamController<String> _linksNotificationsController = BehaviorSubject<String>();
  Stream<String> get linksNotifications => _linksNotificationsController.stream;

  FirebaseDynamicLinks _dynamicLinks;

  DeepLinksService() {
    _dynamicLinks = FirebaseDynamicLinks.instance;
    Timer(const Duration(seconds: 2), listen);
  }

  void listen() async {
    publishLink(PendingDynamicLinkData data) async {
      final Uri uri = data?.link;
      if (uri != null) {
        _linksNotificationsController.add(uri.toString());
      }
    }

    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    publishLink(data);
    _dynamicLinks.onLink.listen(publishLink).onError((error) {
      _log.severe("Failed to fetch dynamic link $error");
    });
  }

  SessionLinkModel parseSessionInviteLink(String link) {
    return SessionLinkModel.fromLinkQuery(Uri.parse(link).query);
  }

  Future<String> generateSessionInviteLink(SessionLinkModel link) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: "https://breez.page.link",
        link: Uri.parse('https://breez.technology?${link.toLinkQuery()}'),
        androidParameters: const AndroidParameters(packageName: "com.breez.client"),
        iosParameters: const IOSParameters(bundleId: "technology.breez.client"));
    final ShortDynamicLink shortLink = await _dynamicLinks.buildShortLink(
      parameters,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );

    return shortLink.shortUrl.toString();
  }

  PodcastShareLinkModel parsePodcastShareLink(String link) {
    return PodcastShareLinkModel.fromLinkQuery(Uri.parse(link).query);
  }

  Future<String> generatePodcastShareLink(PodcastShareLinkModel link) async {
    return 'https://breez.link/p?${link.toLinkQuery()}';
  }
}

class SessionLinkModel {
  final String sessionID;
  final String sessionSecret;
  final String initiatorPubKey;

  SessionLinkModel(this.sessionID, this.sessionSecret, this.initiatorPubKey);

  String toLinkQuery() {
    return 'sessionID=$sessionID&sessionSecret=$sessionSecret&pubKey=$initiatorPubKey';
  }

  static SessionLinkModel fromLinkQuery(String queryStr) {
    Map<String, String> query = Uri.splitQueryString(queryStr);
    return SessionLinkModel(query["sessionID"], query["sessionSecret"], query["pubKey"]);
  }
}

class PodcastShareLinkModel {
  final String feedURL;
  final String episodeID;

  PodcastShareLinkModel(this.feedURL, {this.episodeID});

  String toLinkQuery() {
    return 'feedURL=${Uri.encodeQueryComponent(feedURL)}${episodeID != null ? '&episodeID=${Uri.encodeQueryComponent(episodeID)}' : ''}';
  }

  static PodcastShareLinkModel fromLinkQuery(String queryStr) {
    Map<String, String> query = Uri.splitQueryString(queryStr);
    return PodcastShareLinkModel(Uri.decodeComponent(query["feedURL"]),
        episodeID: query["episodeID"] == null ? null : Uri.decodeComponent(query["episodeID"]));
  }
}

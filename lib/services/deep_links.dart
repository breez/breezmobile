import 'dart:async';

import 'package:breez/logger.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:rxdart/rxdart.dart';

class DeepLinksService {
  static const SESSION_SECRET = "sessionSecret";

  final StreamController<String> _linksNotificationsController = new BehaviorSubject<String>();
  Stream<String> get linksNotifications => _linksNotificationsController.stream;

  DeepLinksService(){    
    Timer(Duration(seconds: 2), listen);
  }

  void listen() async {
    var publishLink = (PendingDynamicLinkData data) async {      
      final Uri uri = data?.link;
        if (uri != null) {
          _linksNotificationsController.add(uri.toString()); 
        }
    };

    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    publishLink(data);

    FirebaseDynamicLinks.instance.onLink(onSuccess: publishLink, onError: (err) async {
      log.severe("Failed to fetch dynamic link " + err.toString());
    });     
  }

  SessionLinkModel parseSessionInviteLink(String link) {     
    return SessionLinkModel.fromLinkQuery( Uri.parse(link).query);
  }

  Future<String> generateSessionInviteLink(SessionLinkModel link) async {
    ShortDynamicLink shortLink = await new DynamicLinkParameters(
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
      link: Uri.parse('https://breez.technology?${link.toLinkQuery()}'),
      uriPrefix: "https://breez.page.link",
      androidParameters: AndroidParameters(packageName: "com.breez.client"),
      iosParameters: IosParameters(bundleId: "technology.breez.client")      
    ).buildShortLink();

    return shortLink.shortUrl.toString();
  }
}

class SessionLinkModel {
  final String sessionID;
  final String sessionSecret;
  final String initiatorPubKey;

  SessionLinkModel(this.sessionID, this.sessionSecret, this.initiatorPubKey);

  String toLinkQuery(){
    return 'sessionID=$sessionID&sessionSecret=$sessionSecret&pubKey=$initiatorPubKey';
  }

  static SessionLinkModel fromLinkQuery(String queryStr) {       
    Map<String, String> query = Uri.splitQueryString(queryStr); 
    return SessionLinkModel(query["sessionID"], query["sessionSecret"], query["pubKey"]);
  }
}

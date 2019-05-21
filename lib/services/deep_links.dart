import 'dart:async';
import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DeepLinksService {
  static const SESSION_SECRET = "sessionSecret";

  final StreamController<String> _linksNotificationsController = new BehaviorSubject<String>();
  Stream<String> get linksNotifications => _linksNotificationsController.stream;

  DeepLinksService(){

    var fetchLink = () async {
      var data = await FirebaseDynamicLinks.instance.retrieveDynamicLink();
      final Uri uri = data?.link;
        if (uri != null) {
          _linksNotificationsController.add(uri.toString()); 
        }
    };

    fetchLink();
    ServiceInjector().device.eventStream.where((e) => e == NotificationType.RESUME)
      .listen((_) => fetchLink());   
  }

  SessionLinkModel parseSessionInviteLink(String link) {     
    return SessionLinkModel.fromLinkQuery( Uri.parse(link).query);
  }

  Future<String> generateSessionInviteLink(SessionLinkModel link) async {
    ShortDynamicLink shortLink = await new DynamicLinkParameters(
      link: Uri.parse('https://breez.technology?${link.toLinkQuery()}'),
      uriPrefix: "breez.page.link",
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

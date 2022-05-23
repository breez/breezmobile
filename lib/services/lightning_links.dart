import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:uni_links/uni_links.dart';

import '../logger.dart';

class LightningLinksService {
  final StreamController<String> _linksNotificationsController =
      BehaviorSubject<String>();

  Stream<String> get linksNotifications => _linksNotificationsController.stream;

  LightningLinksService() {
    Rx.merge([getInitialLink().asStream(), linkStream])
        .where(_canHandle)
        .listen((l) {
      log.info("Got lightning link: $l");
      if (l.startsWith("breez:")) {
        l = l.substring(6);
      }
      _linksNotificationsController.add(l);
    });
  }

  bool _canHandle(String link) {
    if (link == null) return false;
    var lowerCaseLink = link.toLowerCase();
    return lowerCaseLink.startsWith("breez:") ||
        lowerCaseLink.startsWith("lightning:") ||
        lowerCaseLink.startsWith("lnurlc:") ||
        lowerCaseLink.startsWith("lnurlp:") ||
        lowerCaseLink.startsWith("lnurlw:") ||
        lowerCaseLink.startsWith("keyauth:");
  }

  close() {
    _linksNotificationsController.close();
  }
}

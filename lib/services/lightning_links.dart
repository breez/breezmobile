import 'dart:async';

import 'package:breez/services/supported_schemes.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uni_links/uni_links.dart';

final _log = Logger("LightningLinksService");

class LightningLinksService {
  final StreamController<String> _linksNotificationsController =
      BehaviorSubject<String>();

  Stream<String> get linksNotifications => _linksNotificationsController.stream;

  LightningLinksService() {
    Rx.merge([getInitialLink().asStream(), linkStream])
        .where(canHandleScheme)
        .listen((l) {
      _log.info("Got lightning link: $l");
      if (l.startsWith("breez:")) {
        l = l.substring(6);
      }
      _linksNotificationsController.add(l);
    });
  }

  close() {
    _linksNotificationsController.close();
  }
}

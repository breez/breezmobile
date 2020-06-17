import 'dart:async';

import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uni_links/uni_links.dart';

import '../logger.dart';

class LightningLinksService {
  final StreamController<String> _linksNotificationsController =
      BehaviorSubject<String>();
  Stream<String> get linksNotifications => _linksNotificationsController.stream;

  LightningLinksService() {
    Observable.merge([
      getInitialLink().asStream(),
      getLinksStream(),
      ServiceInjector().deepLinks.linksNotifications
    ])
        .where((l) =>
            l != null && (l.startsWith("lightning:") || l.startsWith("breez:")))
        .listen((l) {
      log.info("Got lightning link: $l");
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

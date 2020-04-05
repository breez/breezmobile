import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:uni_links/uni_links.dart';

import '../logger.dart';

class LightningLinksService {
  final StreamController<String> _linksNotificationsController =
      BehaviorSubject<String>();
  Stream<String> get linksNotifications => _linksNotificationsController.stream;

  LightningLinksService() {
    Observable.merge([getInitialLink().asStream(), getLinksStream()])
        .where((l) => l != null && l.startsWith("lightning:"))
        .listen((l){
          log.info("Got lightning link: $l");
          _linksNotificationsController.add(l);
        });
  }

  close() {
    _linksNotificationsController.close();
  }
}

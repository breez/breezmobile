import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:uni_links/uni_links.dart';

class LightningLinksService {

  final StreamController<String> _linksNotificationsController = new BehaviorSubject<String>();
  Stream<String> get linksNotifications => _linksNotificationsController.stream;

  LightningLinksService(){
    Observable.merge([
      getInitialLink().asStream(),
      getLinksStream()
    ])    
      .where((l) => l != null && l.startsWith("lightning:"))
      .listen(_linksNotificationsController.add);    
  }
}
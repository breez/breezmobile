import 'dart:async';

import 'package:breez/services/device.dart';
import 'package:mockito/mockito.dart';

class DeviceMock extends Mock implements Device {
  final StreamController<NotificationType> _eventsController = StreamController.broadcast();

  Stream<NotificationType> get eventStream => _eventsController.stream;

  void dispose() {
    _eventsController.close();
  }
}

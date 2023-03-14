import 'dart:async';

import 'package:breez/services/nfc.dart';
import 'package:mockito/mockito.dart';

class NFCServiceMock extends Mock implements NFCService {
  StreamController<String> receivedBreezIdsController = StreamController<String>.broadcast();

  Stream<String> receivedBreezIds() => receivedBreezIdsController.stream;

  void dispose() {
    receivedBreezIdsController.close();
  }
}

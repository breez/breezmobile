import 'dart:async';

import 'package:breez/services/breez_server/server.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class BreezServerMock extends Mock implements BreezServer {
  Future<String> registerDevice(String token, String nodeid) {
    return Future<String>.value("1234");
  }
}

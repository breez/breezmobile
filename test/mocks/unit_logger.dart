import 'package:breez/logger.dart';
import 'package:flutter/foundation.dart';

void setUpLogger() {
  log.onRecord.listen((record) {
    if (kDebugMode) {
      print('$record');
    }
  });
}

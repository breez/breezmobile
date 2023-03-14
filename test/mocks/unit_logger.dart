import 'package:breez/logger.dart';

void setUpLogger() {
  log.onRecord.listen((record) {
    print('$record');
  });
}

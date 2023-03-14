import 'package:breez/services/notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FirebaseNotificationsMock extends Mock implements FirebaseNotifications {
  @override
  Future<String> getToken() => Future.value('a token');
}

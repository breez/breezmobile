import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';

class FlutterSecureStorageMock extends Mock implements FlutterSecureStorage {
  @override
  Future<String> read({
    String key,
    IOSOptions iOptions,
    AndroidOptions aOptions,
    LinuxOptions lOptions,
    WebOptions webOptions,
    MacOsOptions mOptions,
    WindowsOptions wOptions,
  }) =>
      Future<String>.value("${key}_value");

  @override
  Future<void> write({
    String key,
    String value,
    IOSOptions iOptions,
    AndroidOptions aOptions,
    LinuxOptions lOptions,
    WebOptions webOptions,
    MacOsOptions mOptions,
    WindowsOptions wOptions,
  }) =>
      Future<void>.value();
}

import 'dart:async';

import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mocks/fake_path_provider_platform.dart';
import '../../mocks/flutter_secure_storage_mock.dart';
import '../../mocks/injector_mock.dart';
import '../../mocks/sqflite_mock.dart';
import '../../mocks/unit_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  StreamController<BreezUserModel> userStreamController;
  StreamController<bool> backupAnytimeDbStreamController;
  InjectorMock injectorMock;
  FlutterSecureStorageMock secureStorageMock;
  FakePathProviderPlatform platform;

  group('update backup settings', () {
    setUp(() async {
      setUpLogger();
      sqfliteFfiInitAsMockMethodCallHandler();
      userStreamController = StreamController<BreezUserModel>.broadcast();
      backupAnytimeDbStreamController = StreamController<bool>.broadcast();
      SharedPreferences.setMockInitialValues({});
      injectorMock = InjectorMock();
      secureStorageMock = FlutterSecureStorageMock();
      platform = FakePathProviderPlatform();
      await platform.setUp();
      PathProviderPlatform.instance = platform;
    });

    tearDown(() async {
      userStreamController.close();
      backupAnytimeDbStreamController.close();
      injectorMock.dispose();
      await platform.tearDown();
    });

    Future<BackupBloc> make() async {
      final bloc = BackupBloc(
        userStreamController.stream,
        backupAnytimeDbStreamController.stream,
        serviceInjector: injectorMock,
        secureStorage: secureStorageMock,
      );
      // Await the list actions that are triggered by the constructor and is async.
      await Future.delayed(const Duration(milliseconds: 100));
      return bloc;
    }

    test('same setting should skip', () async {
      BackupBloc bloc = await make();

      final startSettings = BackupSettings.start();
      final action = UpdateBackupSettings(startSettings);
      bloc.backupActionsSink.add(action);
      final newSettings = await action.future;

      expect(newSettings, startSettings);
    });

    test('change to google drive should trigger backup', () async {
      BackupBloc bloc = await make();

      final startSettings = BackupSettings.start();
      final googleSettings = startSettings.copyWith(
        backupProvider: BackupSettings.googleBackupProvider(),
      );
      final action = UpdateBackupSettings(googleSettings);
      bloc.backupActionsSink.add(action);
      final newSettings = await action.future;

      expect(newSettings, googleSettings);
      expect(injectorMock.breezLibMock.backupProviderSet,
          googleSettings.backupProvider.name);
      expect(injectorMock.breezLibMock.backupAuthDataSet, isNull);
    });
  });
}

import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'bloc_tester.dart';
import 'mocks/fake_path_provider_platform.dart';
import 'mocks/injector_mock.dart';
import 'mocks/unit_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('breez_user_model_tests', () {
    InjectorMock _injector;
    UserProfileBloc _userProfileBloc;
    FakePathProviderPlatform platform;

    setUp(() async {
      setUpLogger();
      platform = FakePathProviderPlatform();
      await platform.setUp();
      PathProviderPlatform.instance = platform;
      _injector = InjectorMock();
      ServiceInjector.configure(_injector);
      _userProfileBloc = new UserProfileBloc();
    });

    tearDown(() async {
      _injector.dispose();
      await platform.tearDown();
    });

    test("should return empty user when not registered", () async {
      new BlocTester<void, BreezUserModel>(
        _userProfileBloc.userStream,
        (user) => expect(user.userID, null),
      );
    });

    test("shoud return registered user", () async {
      _userProfileBloc.registerSink.add(null);
      final userID = await _userProfileBloc.userStream
          .firstWhere((p) => p != null && p.userID != null)
          .then((p) => p.userID);
      expect(userID, isNotNull);
    });
  });
}

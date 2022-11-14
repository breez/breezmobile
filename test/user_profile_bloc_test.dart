import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'bloc_tester.dart';
import 'mocks.dart';
import 'utils/fake_path_provider_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final platform = FakePathProviderPlatform();
  group('breez_user_model_tests', () {
    InjectorMock _injector = new InjectorMock();
    UserProfileBloc _userProfileBloc;

    setUp(() async {
      await platform.setUp();
      PathProviderPlatform.instance = platform;
      ServiceInjector.configure(_injector);
      _userProfileBloc = new UserProfileBloc();
    });

    test("should return empty user when not registered", () async {
      new BlocTester<void, BreezUserModel>(
        _userProfileBloc.userStream,
        (user) => expect(user.userID, null),
      );
    });

    test("shoud return registered user", () async {
      _userProfileBloc.registerSink.add(null);
      var userID = await _userProfileBloc.userStream.firstWhere((p) => p != null && p.userID != null).then((p) => p.userID);
      expect(userID, isNotNull);
    });
  });
}

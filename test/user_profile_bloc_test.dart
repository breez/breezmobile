import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/services/injector.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc_tester.dart';
import 'mocks.dart';

void main() {
  group('breez_user_model_tests', () {
    InjectorMock _injector = new InjectorMock();   
    UserProfileBloc _userProfileBloc;

    setUp(() async {
      ServiceInjector.configure(_injector);
      when(_injector.nfc.startCardActivation("testUserID")).thenReturn((new BehaviorSubject(seedValue: null).stream));
      _userProfileBloc = new UserProfileBloc();
    });

    test("should return empty user when not registered", () async {
      new BlocTester<void, BreezUserModel>(_userProfileBloc.userStream, (user) => expect(user.userID, null));        
    });

    test("shoud return registered user", () async{
      _userProfileBloc.registerSink.add(null);
      var userID  = await _userProfileBloc.userStream.firstWhere((p) => p != null && p.userID != null).then((p) => p.userID);
      expect(userID, isNotNull);
    });

    test("shoud activate NFC card", () async {
      _userProfileBloc.registerSink.add(null);
      new BlocTester<void, bool>(_userProfileBloc.cardActivationInit(), (activated) => expect(activated, true));
    });
  });
}
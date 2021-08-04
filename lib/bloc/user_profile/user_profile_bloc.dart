import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:breez/bloc/async_action.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/bloc/user_profile/default_profile_generator.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/local_auth_service.dart';
import 'package:breez/services/notifications.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hex/hex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileBloc {
  static const PROFILE_DATA_FOLDER_PATH = "profile";
  static const String USER_DETAILS_PREFERENCES_KEY = "BreezUserModel.userID";

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  BreezServer _breezServer;
  Notifications _notifications;
  Device _deviceService;
  LocalAuthenticationService _localAuthService;
  Future<SharedPreferences> _preferences;
  BreezBridge _breezBridge;

  Map<Type, Function> _actionHandlers = Map();
  final _userActionsController = StreamController<AsyncAction>.broadcast();
  Sink<AsyncAction> get userActionsSink => _userActionsController.sink;
  final _registrationController = StreamController<void>();
  Sink<void> get registerSink => _registrationController.sink;

  final _userStreamController = BehaviorSubject<BreezUserModel>();
  Stream<BreezUserModel> get userStream => _userStreamController.stream;

  final _userStreamPreviewController = BehaviorSubject<BreezUserModel>();
  Stream<BreezUserModel> get userPreviewStream =>
      _userStreamPreviewController.stream;

  final _currencyController = BehaviorSubject<Currency>();
  Sink<Currency> get currencySink => _currencyController.sink;

  final _fiatConversionController = BehaviorSubject<String>();
  Sink<String> get fiatConversionSink => _fiatConversionController.sink;

  final _userController = BehaviorSubject<BreezUserModel>();
  Sink<BreezUserModel> get userSink => _userController.sink;

  final _randomizeController = BehaviorSubject<void>();
  Sink<void> get randomizeSink => _randomizeController.sink;

  UserProfileBloc() {
    ServiceInjector injector = ServiceInjector();
    _breezServer = injector.breezServer;
    _deviceService = injector.device;
    _preferences = injector.sharedPreferences;
    _localAuthService = injector.localAuthService;
    _notifications = injector.notifications;
    _breezBridge = injector.breezBridge;
    _actionHandlers = {
      UpdateSecurityModel: _updateSecurityModelAction,
      ResetSecurityModel: _resetSecurityModelAction,
      UpdatePreferredCurrencies: _updatePreferredCurrenciesAction,
      UpdatePinCode: _updatePinCode,
      ValidatePinCode: _validatePinCode,
      ChangeTheme: _changeThemeAction,
      ValidateBiometrics: _validateBiometrics,
      StopBiometrics: _stopBiometrics,
      GetEnrolledBiometrics: _getEnrolledBiometrics,
      SetLockState: _setLockState,
      CheckVersion: _checkVersion,
      SetAppMode: _setAppMode,
      SetAdminPassword: _setAdminPassword,
      VerifyAdminPassword: _verifyAdminPassword,
      UploadProfilePicture: _uploadProfilePicture,
      SetPOSCurrency: _setPOSCurrency,
      SetPaymentOptions: _setPaymentOptions,
      SetSeenPaymentStripTutorial: _setSeenPaymentStripTutorial,
    };
    print("UserProfileBloc started");

    //push already saved user to the stream
    _initializeWithSavedUser(injector).then((_) {
      //listen to user actions
      _listenUserActions();

      //listen to registration requests
      _listenRegistrationRequests(injector);

      //listen to changes in user preferences
      _listenCurrencyChange(injector);
      _listenFiatCurrencyChange(injector);

      //listen to changes in user avatar
      _listenUserChange(injector);

      //listen to randomize profile requests
      _listenRandomizeRequest(injector);

      startPINIntervalWatcher();

      _userStreamController.firstWhere((u) => u != null).then((user) {
        // automatic refresh registration on startup if we already passed the walkthrough.
        if (user.registrationRequested) {
          _refreshRegistration(_userStreamController.value);
        }
      });
    });
  }

  void startPINIntervalWatcher() {
    Timer watcher;

    _deviceService.eventStream.listen((e) {
      if (e == NotificationType.PAUSE) {
        watcher?.cancel();
        watcher = Timer(
            Duration(
                seconds: _userStreamController
                    .value.securityModel.automaticallyLockInterval), () {
          var currentUser = _userStreamController.value;
          if (currentUser.securityModel.requiresPin && !currentUser.locked) {
            _userStreamController.add(currentUser.copyWith(locked: true));
          }
        });
      }

      if (e == NotificationType.RESUME) {
        watcher?.cancel();
      }
    });
  }

  Future _initializeWithSavedUser(ServiceInjector injector) {
    return injector.sharedPreferences.then((preferences) async {
      print("UserProfileBloc got preferences");
      String jsonStr =
          preferences.getString(USER_DETAILS_PREFERENCES_KEY) ?? "{}";
      Map profile = json.decode(jsonStr);
      BreezUserModel user = BreezUserModel.fromJson(profile);

      // First time we create a user, initialize with random data.
      if (profile.isEmpty) {
        List randomName = generateDefaultProfile();
        user = user.copyWith(
            name: randomName[0] + ' ' + randomName[1],
            color: randomName[0],
            animal: randomName[1]);
      }
      user = user.copyWith(locked: user.securityModel.requiresPin);
      _publishUser(user);
    });
  }

  void _listenUserActions() {
    _userActionsController.stream.listen((action) {
      var handler = _actionHandlers[action.runtimeType];
      if (handler != null) {
        handler(action).catchError((e) => action.resolveError(e));
      }
    });
  }

  Future _setLockState(SetLockState action) async {
    _saveChanges(
        await _preferences, _currentUser.copyWith(locked: action.locked));
    action.resolve(action.locked);
  }

  Future _checkVersion(CheckVersion action) async {
    action.resolve(await _breezBridge.checkVersion());
  }

  Future _setAppMode(SetAppMode action) async {
    _saveChanges(
        await _preferences, _currentUser.copyWith(appMode: action.appMode));
    action.resolve(action.appMode);
  }

  Future _setPOSCurrency(SetPOSCurrency action) async {
    _saveChanges(await _preferences,
        _currentUser.copyWith(posCurrencyShortName: action.shortName));
    action.resolve(action.shortName);
  }

  Future _setPaymentOptions(SetPaymentOptions action) async {
    _saveChanges(await _preferences,
        _currentUser.copyWith(paymentOptions: action.paymentOptions));
    action.resolve(action.paymentOptions);
  }

  Future _uploadProfilePicture(UploadProfilePicture action) async {
    action.resolve(await _uploadImage(action.bytes));
  }

  Future _setSeenPaymentStripTutorial(
      SetSeenPaymentStripTutorial action) async {
    _saveChanges(
        await _preferences,
        _currentUser.copyWith(
            seenTutorials: _currentUser.seenTutorials
                .copyWith(paymentStripTutorial: action.seen)));
    action.resolve(action.seen);
  }

  Future _uploadImage(List<int> bytes) async {
    try {
      return _saveImage(bytes).then((file) {
        return _breezServer.uploadLogo(bytes).then((imageUrl) async {
          _userStreamPreviewController
              .add(_currentUser.copyWith(image: imageUrl));
          return Future.value(null);
        });
      });
    } catch (error) {
      log.severe(error);
      throw error;
    }
  }

  Future _updatePinCode(UpdatePinCode action) async {
    await _secureStorage.write(key: 'pinCode', value: action.newPin);
    _publishUser(_currentUser);
    action.resolve(null);
  }

  Future _validatePinCode(ValidatePinCode action) async {
    var pinCode = await _secureStorage.read(key: 'pinCode');
    if (pinCode != action.enteredPin) {
      throw Exception("Incorrect PIN");
    }
    action.resolve(pinCode == action.enteredPin);
  }

  Future _setAdminPassword(SetAdminPassword action) async {
    if (action.password == null) {
      await _secureStorage.delete(key: 'adminPassword');
    } else {
      var hashedPassword = sha256.convert(utf8.encode(action.password)).bytes;
      String hexHash = HEX.encode(hashedPassword);
      await _secureStorage.write(key: 'adminPassword', value: hexHash);
    }
    await _saveChanges(await _preferences,
        _currentUser.copyWith(hasAdminPassword: action.password != null));
    action.resolve(null);
  }

  Future _verifyAdminPassword(VerifyAdminPassword action) async {
    var encodedHash = await _secureStorage.read(key: 'adminPassword');
    var decodedHash = HEX.decode(encodedHash);
    var hashedPassword = sha256.convert(utf8.encode(action.password)).bytes;
    action.resolve(listEquals(decodedHash, hashedPassword));
  }

  Future _updateSecurityModelAction(
      UpdateSecurityModel updateSecurityModelAction) async {
    updateSecurityModelAction
        .resolve(await _updateSecurityModel(updateSecurityModelAction));
  }

  Future _resetSecurityModelAction(
      ResetSecurityModel resetSecurityModelAction) async {
    var updateSecurityModelAction =
        UpdateSecurityModel(SecurityModel.initial());
    resetSecurityModelAction
        .resolve(await _updateSecurityModel(updateSecurityModelAction));
  }

  Future _updateSecurityModel(
      UpdateSecurityModel updateSecurityModelAction) async {
    await _saveChanges(
        await _preferences,
        _currentUser.copyWith(
            securityModel: updateSecurityModelAction.newModel));
    return updateSecurityModelAction.newModel;
  }

  Future _updatePreferredCurrenciesAction(
      UpdatePreferredCurrencies updateCurrencies) async {
    var updated =
        _currentUser.copyWith(preferredCurrencies: updateCurrencies.currencies);
    await _saveChanges(await _preferences, updated);
    updateCurrencies.resolve(updateCurrencies.currencies);
  }

  Future _changeThemeAction(ChangeTheme action) async {
    action.resolve(await _changeTheme(action));
  }

  Future _changeTheme(ChangeTheme action) async {
    await _saveChanges(
        await _preferences, _currentUser.copyWith(themeId: action.newTheme));
    return action.newTheme;
  }

  Future _validateBiometrics(ValidateBiometrics action) async {
    action.resolve(await _localAuthService.authenticate(
        localizedReason: action.localizedReason));
  }

  Future _stopBiometrics(StopBiometrics action) async {
    action.resolve(await _localAuthService.stopAuthentication());
  }

  Future _getEnrolledBiometrics(GetEnrolledBiometrics action) async {
    action.resolve(await _localAuthService.enrolledBiometrics);
  }

  void _listenRegistrationRequests(ServiceInjector injector) {
    _registrationController.stream.listen((request) async {
      _refreshRegistration(_userStreamController.value);
    });
  }

  Future _refreshRegistration(BreezUserModel user) async {
    var userToRegister = user;
    SharedPreferences preferences = await _preferences;
    try {
      String token = await _notifications.getToken();
      if (token != user.token || user.userID == null || user.userID.isEmpty) {
        //var userID = await _breezServer.registerDevice(token);
        var userID = token;
        userToRegister = userToRegister.copyWith(token: token, userID: userID);
      }
    } catch (e) {
      _registrationController.addError(e);
    }
    userToRegister = userToRegister.copyWith(registrationRequested: true);
    await _saveChanges(preferences, userToRegister);
  }

  void _listenCurrencyChange(ServiceInjector injector) {
    _currencyController.stream.listen((currency) async {
      var preferences = await injector.sharedPreferences;
      await _saveChanges(
          preferences, _currentUser.copyWith(currency: currency));
    });
  }

  void _listenFiatCurrencyChange(ServiceInjector injector) {
    _fiatConversionController.stream.listen((shortName) async {
      var preferences = await injector.sharedPreferences;
      await _saveChanges(
          preferences, _currentUser.copyWith(fiatCurrency: shortName));
    });
  }

  void _listenUserChange(ServiceInjector injector) {
    _userController.stream.listen((userData) async {
      var preferences = await injector.sharedPreferences;
      await _saveChanges(preferences, userData);
    });
  }

  void _listenRandomizeRequest(ServiceInjector injector) {
    _randomizeController.stream.listen((request) async {
      var randomProfile = generateDefaultProfile();
      _userStreamPreviewController.add(_currentUser.copyWith(
          name: randomProfile[0] + ' ' + randomProfile[1],
          color: randomProfile[0],
          animal: randomProfile[1],
          image: ''));
    });
  }

  _saveImage(List<int> logoBytes) {
    return getApplicationDocumentsDirectory()
        .then((docDir) =>
            Directory([docDir.path, PROFILE_DATA_FOLDER_PATH].join("/"))
                .create(recursive: true))
        .then((profileDir) => File([
              profileDir.path,
              'profile-${DateTime.now().millisecondsSinceEpoch}-.png'
            ].join("/"))
                .writeAsBytes(logoBytes, flush: true));
  }

  Future<bool> _saveChanges(
      SharedPreferences preferences, BreezUserModel user) {
    var res =
        preferences.setString(USER_DETAILS_PREFERENCES_KEY, json.encode(user));
    _publishUser(user);
    return res;
  }

  void _publishUser(BreezUserModel user) {
    if (user?.token == null) {
      print("UserProfileBloc publish first user null token");
    } else {
      print("UserProfileBloc before _publishUser token = " + user.token);
    }
    _userStreamController.add(user);
    _userStreamPreviewController.add(user);
  }

  BreezUserModel get _currentUser => _userStreamController.value;

  close() {
    _registrationController.close();
    _currencyController.close();
    _fiatConversionController.close();
    _userActionsController.close();
    _userController.close();
    _randomizeController.close();
    _userStreamPreviewController.close();
  }
}

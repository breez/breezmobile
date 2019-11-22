import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:breez/bloc/async_action.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/bloc/user_profile/default_profile_generator.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/local_auth_service.dart';
import 'package:breez/services/nfc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileBloc {
  static const PROFILE_DATA_FOLDER_PATH = "profile";
  static const String USER_DETAILS_PREFERENCES_KEY = "BreezUserModel.userID";

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  BreezBridge _breezLib;
  NFCService _nfc;
  Device _deviceService;
  LocalAuthenticationService _localAuthService;
  Future<SharedPreferences> _preferences;
  
  Map<Type, Function> _actionHandlers = Map();
  final _userActionsController = new StreamController<AsyncAction>.broadcast();
  Sink<AsyncAction> get userActionsSink => _userActionsController.sink;
  final _registrationController = new StreamController<void>();
  Sink<void> get registerSink => _registrationController.sink;

  final _userStreamController = BehaviorSubject<BreezUserModel>();
  Stream<BreezUserModel> get userStream => _userStreamController.stream;

  final _userStreamPreviewController = BehaviorSubject<BreezUserModel>();
  Stream<BreezUserModel> get userPreviewStream => _userStreamPreviewController.stream;

  Stream<bool> cardActivationStream;

  final _currencyController = new BehaviorSubject<Currency>();
  Sink<Currency> get currencySink => _currencyController.sink;

  final _fiatConversionController = new BehaviorSubject<String>();
  Sink<String> get fiatConversionSink => _fiatConversionController.sink;

  final _userController = new BehaviorSubject<BreezUserModel>();
  Sink<BreezUserModel> get userSink => _userController.sink;

  final _randomizeController = new BehaviorSubject<void>();
  Sink<void> get randomizeSink => _randomizeController.sink;

  final _uploadImageController = new StreamController<List<int>>();
  Sink<List<int>> get uploadImageSink => _uploadImageController.sink;

  UserProfileBloc() {
    ServiceInjector injector = ServiceInjector();    
    _nfc = injector.nfc;    
    _breezLib = injector.breezBridge;
    _deviceService = injector.device;
    _preferences = injector.sharedPreferences;
    _localAuthService = injector.localAuthService;
    _actionHandlers = {
      UpdateSecurityModel: _updateSecurityModelAction,
      UpdatePinCode: _updatePinCode,
      ValidatePinCode: _validatePinCode,
      ChangeTheme: _changeThemeAction,
      ValidateBiometrics: _validateBiometrics,
      GetEnrolledBiometricIds: _getEnrolledBiometricIds,
    };
    print ("UserProfileBloc started");

    cardActivationStream = _nfc.cardActivationStream;

    //push already saved user to the stream
    _initializeWithSavedUser(injector);

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

    //listen upload image requests
    _listenUploadImageRequests(injector);

    _updateBiometricsSettings();

    startPINIntervalWatcher();
  }

  void startPINIntervalWatcher(){
    Timer watcher;

    _deviceService.eventStream.listen((e){      
      if (e == NotificationType.PAUSE) {
        watcher?.cancel();
        watcher = Timer(Duration(seconds: _userStreamController.value.securityModel.automaticallyLockInterval), (){
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

  void _initializeWithSavedUser(ServiceInjector injector) {    
    injector.sharedPreferences.then((preferences) async {
      print ("UserProfileBloc got preferences");
      String jsonStr =
          preferences.getString(USER_DETAILS_PREFERENCES_KEY) ?? "{}";
      Map profile = json.decode(jsonStr);      
      BreezUserModel user = BreezUserModel.fromJson(profile);

      // First time we create a user, initialize with random data.
      if (profile.isEmpty) {
        List randomName = generateDefaultProfile();
        user = user.copyWith(name: randomName[0] + ' ' + randomName[1], color: randomName[0], animal: randomName[1]);          
      }
           
      user = user.copyWith(locked: user.securityModel.requiresPin);
      if (user.userID != null) {
        saveUser(injector, preferences, user).then(_publishUser);
      }

      _publishUser(user);      
    });
  }

  Future<BreezUserModel> saveUser(ServiceInjector injector, SharedPreferences preferences, BreezUserModel user) async {    
    String currentToken = user.token;
    try {
      String token = await injector.notifications.getToken();      
      if (token != currentToken || user.userID == null || user.userID.isEmpty) {
        var userID = await injector.breezServer.registerDevice(token);                
        user = user.copyWith(token: token, userID: userID);        
      }
      _saveChanges(preferences, user);
    } catch(e) {
      _registrationController.addError(e);
    }
    return user;
  }

  _updateBiometricsSettings() {
    _checkBiometrics();
    _deviceService.eventStream.listen((e){
      if (e == NotificationType.RESUME) {
        _checkBiometrics();
      }
    });
  }

  Future _checkBiometrics() async {
    String enrolledBiometrics = await _localAuthService.enrolledBiometrics;
    String enrolledBiometricIds = (await _localAuthService.enrolledBiometricIds).join(",");
    if (_currentUser.securityModel.isFingerprintEnabled && _currentUser.securityModel.enrolledBiometricIds != enrolledBiometricIds){
      _updateSecurityModel(UpdateSecurityModel(
          _currentUser.securityModel.copyWith(isFingerprintEnabled: false, enrolledBiometricIds: "")));
    } else if (enrolledBiometrics == "") {
      _updateSecurityModel(UpdateSecurityModel(
          _currentUser.securityModel.copyWith(
              isFingerprintEnabled: false, enrolledBiometrics: enrolledBiometrics, enrolledBiometricIds: "")));
    } else {
      _updateSecurityModel(UpdateSecurityModel(_currentUser.securityModel.copyWith(enrolledBiometrics: enrolledBiometrics)));
    }
  }

  void _listenUserActions() {
    _userActionsController.stream.listen((action) {
      var handler = _actionHandlers[action.runtimeType];
      if (handler != null) {
        handler(action).catchError((e) => action.resolveError(e));
      }
    });
  }

  Future _updatePinCode(UpdatePinCode action) async {
    await _secureStorage.write(key: 'pinCode', value: action.newPin);
    _publishUser(_currentUser);
    action.resolve(null);
  }

  Future _validatePinCode(ValidatePinCode action) async {
    var pinCode = await _secureStorage.read(key: 'pinCode');
    if (pinCode != action.enteredPin) {
      throw new Exception("Incorrect PIN");
    }
    action.resolve(pinCode == action.enteredPin);
  }

  Future _updateSecurityModelAction(UpdateSecurityModel updateSecurityModelAction) async {
    updateSecurityModelAction.resolve(await _updateSecurityModel(updateSecurityModelAction));
  }

  Future _updateSecurityModel(UpdateSecurityModel updateSecurityModelAction) async {        
    _saveChanges(await _preferences, _currentUser.copyWith(securityModel: updateSecurityModelAction.newModel));
    return updateSecurityModelAction.newModel;
  }

  Future _changeThemeAction(ChangeTheme action) async {
    action.resolve(await _changeTheme(action));
  }

  Future _changeTheme(ChangeTheme action) async {
    _saveChanges(await _preferences, _currentUser.copyWith(themeId: action.newTheme));
    return action.newTheme;
  }

  Future _validateBiometrics(ValidateBiometrics action) async {
    action.resolve(await _localAuthService.authenticate(localizedReason: action.localizedReason));
  }

  Future _getEnrolledBiometricIds(GetEnrolledBiometricIds action) async {
    action.resolve((await _localAuthService.enrolledBiometricIds).join(","));
  }

  void _listenRegistrationRequests(ServiceInjector injector) {
    _registrationController.stream.listen((request) async {
      var preferences = await injector.sharedPreferences;
      saveUser(injector, preferences, _userStreamController.value);
    });
  }

  void _listenCurrencyChange(ServiceInjector injector) {
    _currencyController.stream.listen((currency) async {
      var preferences = await injector.sharedPreferences;
      _saveChanges(preferences, _currentUser.copyWith(currency: currency));
    });
  }

  void _listenFiatCurrencyChange(ServiceInjector injector) {
    _fiatConversionController.stream.listen((shortName) async {
      var preferences = await injector.sharedPreferences;
      _saveChanges(preferences, _currentUser.copyWith(fiatCurrency: shortName));
    });
  }

  void _listenUserChange(ServiceInjector injector) {
    _userController.stream.listen((userData) async {
      var preferences = await injector.sharedPreferences;
      _saveChanges(
          preferences,
          userData);
    });
  }

  void _listenRandomizeRequest(ServiceInjector injector) {
    _randomizeController.stream.listen((request) async {
      var randomProfile = generateDefaultProfile();
      _userStreamPreviewController.add(_currentUser.copyWith(name: randomProfile[0] + ' ' + randomProfile[1],
          color: randomProfile[0],
          animal: randomProfile[1],
          image: ''));
    });
  }

  void _listenUploadImageRequests(ServiceInjector injector) {
    BreezServer breezServer = injector.breezServer;
    _uploadImageController.stream.listen((image) {
      _saveImage(image).then((file) {
        return breezServer.uploadLogo(image).then((imageUrl) async {
          _userStreamPreviewController.add(_currentUser.copyWith(image: imageUrl));
        });
      }).catchError((err) {
        log.severe(err);
      });
    });
  }

  _saveImage(List<int> logoBytes) {
    return getApplicationDocumentsDirectory()
        .then((docDir) =>
            new Directory([docDir.path, PROFILE_DATA_FOLDER_PATH].join("/"))
                .create(recursive: true))
        .then((profileDir) => new File([
              profileDir.path,
              'profile-${DateTime.now().millisecondsSinceEpoch}-.png'
            ].join("/"))
                .writeAsBytes(logoBytes, flush: true));
  }

  void _saveChanges(SharedPreferences preferences, BreezUserModel user) {
    preferences.setString(USER_DETAILS_PREFERENCES_KEY, json.encode(user));
    _publishUser(user);    
  }

  void _publishUser(BreezUserModel user) {
    if (user?.token == null) {
      print ("UserProfileBloc publish first user null token");
    } else {
      print ("UserProfileBloc before _publishUser token = " + user.token);
    }
    _userStreamController.add(user);
    _userStreamPreviewController.add(user);
  }

  void cardActivationInit() {
    _nfc.startCardActivation(_userStreamController.value.userID);
  }

  BreezUserModel get _currentUser => _userStreamController.value;

  close() {
    _registrationController.close();
    _currencyController.close();
    _fiatConversionController.close();
    _userActionsController.close();
    _userController.close();
    _uploadImageController.close();
    _randomizeController.close();
    _userStreamPreviewController.close();
  }
}

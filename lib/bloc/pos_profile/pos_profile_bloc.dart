import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:breez/bloc/pos_profile/pos_profile_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/injector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class POSProfileBloc {

  static const PROFILE_DATA_FOLDER_PATH = "profile";
  
  static const String POS_PROFILE_PREFERENCES_KEY =
      "BreezUserModel.posProfile";

  final _requestPosProfileController = new StreamController<POSProfileModel>();
  Sink<POSProfileModel> get posProfileSink => _requestPosProfileController.sink;

  final _posProfileController = new BehaviorSubject<POSProfileModel>();
  Stream<POSProfileModel> get posProfileStream => _posProfileController.stream;

  final _uploadLogoController = new StreamController<List<int>>();
  Sink<List<int>> get uploadLogoSink => _uploadLogoController.sink; 

  final _profileUpdatesErrorController = new StreamController<Exception>.broadcast();
  Stream<Exception> get profileUpdatesErrorStream => _profileUpdatesErrorController.stream; 

  POSProfileBloc() {
    ServiceInjector injector = new ServiceInjector();
    _initializeWithSavedUser(injector);
    _listenRegistrationRequests(injector);
    _listenUploadLogoRequests(injector);
  }

  void _initializeWithSavedUser(ServiceInjector injector) {
    injector.sharedPreferences.then((preferences) {
      String jsonStr =
          preferences.getString(POS_PROFILE_PREFERENCES_KEY) ?? "{}";
      Map profile = json.decode(jsonStr);
      _posProfileController.add(POSProfileModel.fromJson(profile));
    });
  }

  _listenRegistrationRequests(ServiceInjector injector) {
    _requestPosProfileController.stream.listen((posProfile) async {
      _saveProfile(posProfile, injector);
    });
  }

  _listenUploadLogoRequests(ServiceInjector injector) {
    BreezServer breezServer = injector.breezServer;
    _uploadLogoController.stream.listen(
      (logoBytes) {        
        _saveLogoImage(logoBytes)        
        .then((file) {                    
          var oldProfile = _posProfileController.value;
          _posProfileController.add(oldProfile.copyWith(uploadInProgress: true, logoLocalPath: file.path));
          return breezServer.uploadLogo(logoBytes)
          .then( (logoURL) { 
            if(oldProfile.logoLocalPath != null) {
               new File(oldProfile.logoLocalPath).delete();
            }
            _saveProfile(_posProfileController.value.copyWith(logo: logoURL, uploadInProgress: false), injector);
          });
        })                    
        .catchError((err){
          log.severe(err);
          _posProfileController.add(_posProfileController.value.copyWith(uploadInProgress: false));
          _profileUpdatesErrorController.addError(err);
        });
      },
      onError: _profileUpdatesErrorController.addError
    );
  }

  _saveProfile(POSProfileModel posProfile, ServiceInjector injector) {
    injector.sharedPreferences.then((preferences) {
        preferences.setString(
            POS_PROFILE_PREFERENCES_KEY, json.encode(posProfile));
        _posProfileController.add(posProfile);
      }).catchError(_requestPosProfileController.addError);
  }

  _saveLogoImage(List<int> logoBytes){
    return getApplicationDocumentsDirectory()
        .then((docDir) => new Directory([docDir.path, PROFILE_DATA_FOLDER_PATH].join("/")).create(recursive: true))
        .then((profileDir) => new File( [profileDir.path, 'profile-${DateTime.now().millisecondsSinceEpoch}-.png'].join("/") )
          .writeAsBytes(logoBytes, flush: true)); 
  }

  close() {
    _requestPosProfileController.close(); 
    _uploadLogoController.close();   
    _profileUpdatesErrorController.close();
  }
}

library account;

import 'dart:async';

import 'package:breez/services/injector.dart';
import 'package:breez/services/permissions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPermissionsHandler {
  static const String PERMISSION_DIALOG_SHOWN_KEY =
      "PERMISSION_DIALOG_SHOWN_KEY";

  final _optimizationWhitelistRequestController =
      StreamController<void>.broadcast();
  Stream<void> get optimizationWhitelistRequestStream =>
      _optimizationWhitelistRequestController.stream;
  Sink<void> get optimizationWhitelistRequestSink =>
      _optimizationWhitelistRequestController.sink;

  final _optimizationWhitelistExplainController = BehaviorSubject<bool>();
  Stream<bool> get optimizationWhitelistExplainStream =>
      _optimizationWhitelistExplainController.stream;

  Permissions _permissionsService;
  Future<SharedPreferences> _preferences;

  AccountPermissionsHandler() {
    var injector = ServiceInjector();
    _permissionsService = injector.permissions;
    _preferences = injector.sharedPreferences;
    // _preferences.then((p){
    //   optimizationWhitelistRequestStream.listen((_){
    //     _permissionsService.requestOptimizationWhitelist().then((_){
    //       p.setBool(PERMISSION_DIALOG_SHOWN_KEY, true);
    //     });
    //   });
    // });
  }

  void triggerOptimizeWhitelistExplenation() async {
    var preferences = await _preferences;
    bool optimized = await _permissionsService.isInOptimizationWhitelist();
    if (!optimized && preferences.get(PERMISSION_DIALOG_SHOWN_KEY) != true) {
      _optimizationWhitelistExplainController.sink.add(true);
    }
  }

  dispose() {
    _optimizationWhitelistExplainController.close();
    _optimizationWhitelistRequestController.close();
  }
}

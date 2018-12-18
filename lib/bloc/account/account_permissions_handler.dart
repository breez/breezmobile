library account;

import 'dart:async';

import 'package:breez/services/injector.dart';
import 'package:breez/services/permissions.dart';
import 'package:rxdart/rxdart.dart';

class AccountPermissionsHandler {
  final _optimizationWhitelistRequestController = new StreamController<void>.broadcast();
  Stream<void> get optimizationWhitelistRequestStream => _optimizationWhitelistRequestController.stream;
  Sink<void> get optimizationWhitelistRequestSink => _optimizationWhitelistRequestController.sink;

  final _optimizationWhitelistExplainController = new BehaviorSubject<bool>();
  Stream<bool> get optimizationWhitelistExplainStream => _optimizationWhitelistExplainController.stream;  

  Permissions _permissionsService;

  AccountPermissionsHandler(){
    _permissionsService = ServiceInjector().permissions;
    optimizationWhitelistRequestStream.listen((_){
      _permissionsService.requestOptimizationWhitelist();
    });
  }

  void triggerOptimizeWhitelistExplenation() async {
    bool optimized = await _permissionsService.isInOptimizationWhitelist();
    if (!optimized) {
      _optimizationWhitelistExplainController.sink.add(true);
    }
  }

  dispose(){
    _optimizationWhitelistExplainController.close();
    _optimizationWhitelistRequestController.close();
  }
}
import 'package:breez/logger.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BreezNavigatorObserver extends NavigatorObserver {
  static final BreezNavigatorObserver _singleton = BreezNavigatorObserver._internal();

  final List<String> _routeStack = [];
  final BehaviorSubject<bool> _atHomeScreenSubject = BehaviorSubject.seeded(false);

  factory BreezNavigatorObserver() {
    return _singleton;
  }

  BreezNavigatorObserver._internal();

  Stream<bool> get atHomeScreenStream => _atHomeScreenSubject.distinct();

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    _routeStack.add(route?.settings?.name);
    _updateStreams();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (_routeStack.isEmpty) {
      log.warning("didRemove called with empty stack, route ${route?.settings?.name} "
          "previous: ${previousRoute?.settings?.name}");
      return;
    }
    _routeStack.removeLast();
    _updateStreams();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (_routeStack.isEmpty) {
      log.warning("didPop called with empty stack, route ${route?.settings?.name} "
          "previous: ${previousRoute?.settings?.name}");
      return;
    }
    _routeStack.removeLast();
    _updateStreams();
  }

  void _updateStreams() {
    _atHomeScreenSubject.add(_routeStack.isEmpty ? false : _routeStack.last == "/");
  }
}

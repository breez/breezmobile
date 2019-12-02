import 'dart:async';

import 'async_action.dart';

class AsyncActionsHandler {
  final _actionsController = StreamController<AsyncAction>.broadcast();
  Map<Type, Function> _actionHandlers = Map();

  Sink<AsyncAction> get actionsSink => _actionsController.sink;

  void registerAsyncHandlers(Map<Type, Function> handlers) {
    _actionHandlers.addEntries(handlers.entries);
  }

  void listenActions() {
    _actionsController.stream.listen((action) {
      var handler = _actionHandlers[action.runtimeType];
      if (handler != null) {
        handler(action).catchError((e) => action.resolveError(e));
      }
    });
  }

  Future dispose() async {
    await _actionsController.close();
  }
}

import 'dart:async';

class AsyncAction {
  Completer _completer = new Completer();

  Future get future => _completer.future;

  void resolve(Object value) {
    _completer.complete(value);
  }

  void resolveError(error) {
    _completer.completeError(error);
  }
}

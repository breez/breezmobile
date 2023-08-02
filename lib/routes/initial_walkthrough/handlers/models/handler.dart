import 'handler_context_provider.dart';

abstract class Handler {
  HandlerContextProvider contextProvider;

  void init(HandlerContextProvider contextProvider) {
    this.contextProvider = contextProvider;
  }

  void dispose() {
    contextProvider = null;
  }
}

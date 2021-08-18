import 'dart:async';

class BlocTester<Input, Out> {
  final Sink<Input> inSink;
  final Stream<Out> outStream;
  final dynamic input;
  final void Function(Out) testFunction;
  final void Function(dynamic) handleError;

  BlocTester(
    this.outStream,
    this.testFunction, [
    this.inSink,
    this.input,
    this.handleError,
  ]);

  Future<void> run() {
    Completer completer = new Completer<Out>();
    outStream.listen((data) => completer.complete(data)).onError((e) {
      if (handleError != null) {
        handleError(e);
        completer.completeError(e);
      } else {
        throw e;
      }
    });
    if (inSink != null) {
      inSink.add(input);
    }
    return completer.future
        .then((out) => this.testFunction(out))
        .catchError((e) {});
  }
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

class BlocTester<Input,Out> {
  final Sink<Input> inSink;
  final Stream<Out> outStream;
  final dynamic input;
  final void Function (Out) testFunction;

  BlocTester(this.outStream, this.testFunction, [this.inSink, this.input]){
    run();
  }

  Future<void> run() {
    Completer completer = new Completer<Out>();
    outStream.listen((data) => completer.complete(data));
    if (inSink != null) {
      inSink.add(input);
    }
    return completer.future.then( (out) => this.testFunction(out));
  }
}
import 'dart:async';

import 'package:breez/bloc/chain/conditional_poll_stream.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'mocks.dart';

int _counter = 0;
Future<int> increment() {
  _counter++;
  return Future.value(_counter);
}

void main() {
  group('poll_stream tests', () {
    InjectorMock _injector = new InjectorMock();

    setUpAll(() async {
      ServiceInjector.configure(_injector);
    });

    setUp(() async {
      _counter = 0;
    });

    test("simple pollstream", () async {
      var completer = new Completer();
      var simpleStream = new ConditionalPollStream<int>(increment, 1000);
      int streamValue;
      simpleStream.listen((number) {
        streamValue = number;
        completer.complete();
      });

      await completer.future;
      expect(streamValue, 1);
    });

    test("pause pollstream", () async {                
      var simpleStream = new ConditionalPollStream<int>(increment, 100);
      var subscription = simpleStream.listen((number) {});
      subscription.pause();  
      await Future.delayed(Duration(milliseconds: 200), (){});    
      expect(_counter, 1);
      subscription.cancel();
    });

    test("cancel pollstream", () async {                
      var simpleStream = new ConditionalPollStream<int>(increment, 100);
      var subscription = simpleStream.listen((number) {});
      await subscription.cancel();  
      await Future.delayed(Duration(milliseconds: 200), (){});    
      expect(_counter, 1);
    });

    test("resume pollstream", () async {                
      var simpleStream = new ConditionalPollStream<int>(increment, 100);
      var subscription = simpleStream.listen((number) {});
      subscription.pause();  
      await Future.delayed(Duration(milliseconds: 200), (){});
      subscription.resume();            
      await Future.delayed(Duration(milliseconds: 10), (){});
      expect(_counter, 2);
      subscription.cancel();
    });
  });
}
import 'dart:async';
import 'dart:convert';
import 'package:breez/bloc/connect_pay/encryption.dart';
import 'package:firebase_database/firebase_database.dart';

/*
This class abstracts a "channel" that handles all communciation between payment session peers.
The implementation is based on firebase messaging.
*/
class PaymentSessionChannel {
  final StreamController<Map<dynamic, dynamic>> _incomingMessagesController = new StreamController<Map<dynamic, dynamic>>.broadcast();
  Stream<Map<dynamic, dynamic>> get incomingMessagesStream => _incomingMessagesController.stream;

  final StreamController<void> _peerTerminatedController = new StreamController<void>();
  Stream<void> get peerTerminatedStream => _peerTerminatedController.stream;

  final String _sessionID;  
  final bool _payer;
  String _myKey;
  String _theirKey;
  StreamSubscription _theirDataListener;
  StreamSubscription _sessionRootListener;
  bool _terminated = false;
  MessageInterceptor interceptor;

  PaymentSessionChannel(this._sessionID, this._payer, {this.interceptor}) {
    _myKey = this._payer ? "payer" : "payee";
    _theirKey = this._payer ? "payee" : "payer";
    _listenIncomingMessages();
    Future sessionCreated =
        !_payer ? Future.value(null) : FirebaseDatabase.instance.reference().child('remote-payments/$_sessionID').update({"payer": "created"});
    sessionCreated.then((res) => _watchSessionTermination);
    _watchSessionTermination();
  }

  Future sendStateUpdate(Map<String, dynamic> newState) {
    String stateString = json.encode(newState);
    Future<String> toSend = Future.value(stateString);
    if (interceptor != null) {
      toSend = interceptor.transformOutgoingMessage(stateString);
    }
    return toSend.then( (valueToSend) {
      return FirebaseDatabase.instance.reference().child('remote-payments/$_sessionID/$_myKey').update({"state": valueToSend});
    });    
  }

  Future terminate({bool destroyHistory = false}) async {
    if (!_terminated) {
      await _theirDataListener.cancel();
      await _sessionRootListener.cancel();
      if (destroyHistory) {
        await FirebaseDatabase.instance.reference().child('remote-payments/$_sessionID').remove();
      }
      await _incomingMessagesController.close();
      _terminated = true;
    }
  }

  bool get terminated => _terminated;

  void _listenIncomingMessages() async {    
    var theirData = FirebaseDatabase.instance.reference().child('remote-payments/$_sessionID/$_theirKey/state');
    _theirDataListener = theirData.onValue.listen((event) async{
      var stateMessage = event.snapshot.value;
      if (stateMessage != null && stateMessage.runtimeType == String) {        
        if (interceptor != null) {                              
          stateMessage = await interceptor.transformIncoingMessage(stateMessage);
        }
        Map<String, dynamic> decodedState = json.decode(stateMessage);
        _incomingMessagesController.add(decodedState);       
      }
    });
  }

  Future<Map<dynamic,dynamic>> convert(Map<dynamic,dynamic> messageValue) async {
    var convertedValue = Map<dynamic,dynamic>();          
    Iterable<Future> conversions = messageValue.keys.map((k) { 
      if (messageValue[k].runtimeType == String) {
        return interceptor.transformIncoingMessage(messageValue[k])
          .then(
            (transformed) => convertedValue[k] = transformed
          ).catchError((err){
            print ("error");
          });
      }
      convertedValue[k] = messageValue[k];
      return Future.value(null);
    });      

    await Future.wait(conversions);
    return convertedValue;
  }

  void _watchSessionTermination() {
    var terminationPath = _payer ? _sessionID : '$_sessionID/payer';
    var sessionRoot = FirebaseDatabase.instance.reference().child('remote-payments/$terminationPath');
    _sessionRootListener = sessionRoot.onValue.listen((event) {
      if (event.snapshot.value == null) {
        _peerTerminatedController.add(null);
      }
    });
  }
}

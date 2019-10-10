import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/connect_pay/encryption.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

/*
This class abstracts a "channel" that handles all communciation between payment session peers.
The implementation is based on firebase messaging.
*/
class PaymentSessionChannel {

  static int _activeChannels = 0;

  final StreamController<Map<dynamic, dynamic>> _incomingMessagesController = new StreamController<Map<dynamic, dynamic>>.broadcast();
  Stream<Map<dynamic, dynamic>> get incomingMessagesStream => _incomingMessagesController.stream;

  final StreamController<void> _peerTerminatedController = new StreamController<void>();
  Stream<void> get peerTerminatedStream => _peerTerminatedController.stream;

  final StreamController<void> peerResetStreamController = new StreamController<void>();
  Stream<void> get peerResetStream => peerResetStreamController.stream;

  final String _sessionID;  
  final bool _payer;
  String _myKey;
  String _theirKey;
  StreamSubscription _theirDataListener;
  StreamSubscription _sessionRootListener;
  StreamSubscription _peerResetListener;
  bool _terminated = false;
  MessageInterceptor interceptor;

  PaymentSessionChannel(this._sessionID, this._payer, {this.interceptor}) {
    _activeChannels++;
    FirebaseDatabase.instance.goOnline();
    _myKey = this._payer ? "payer" : "payee";
    _theirKey = this._payer ? "payee" : "payer";
    _listenIncomingMessages();
    Future sessionCreated =
        !_payer ? Future.value(null) : FirebaseDatabase.instance.reference().child('remote-payments/$_sessionID').update({"lastUpdated": ServerValue.timestamp});
    sessionCreated.then((res) => _watchSessionTermination);
    _watchSessionTermination();
    _watchPeerReset();
  }

  Future sendStateUpdate(Map<String, dynamic> newState) {
    String stateString = json.encode(newState);
    Future<String> toSend = Future.value(stateString);
    if (interceptor != null) {
      toSend = interceptor.transformOutgoingMessage(stateString);
    }
    return toSend.then( (valueToSend) {
      if (!_terminated) {
        return FirebaseDatabase.instance.reference().child('remote-payments/$_sessionID/$_myKey').update({"state": valueToSend});
      }
    });    
  }

  Future sendResetMessage() async{
    await FirebaseDatabase.instance.reference().child('remote-payments/$_sessionID/${_payer ? "payee" : "payer"}').remove();
  }

  Future terminate({bool destroyHistory = false}) async {
    if (!_terminated) {
      _terminated = true;
      await _theirDataListener.cancel();
      await _sessionRootListener.cancel();
      await _peerResetListener.cancel();
      await peerResetStreamController.close();
      await _peerTerminatedController.close();
      if (destroyHistory) {
        await FirebaseDatabase.instance.reference().child('remote-payments/$_sessionID').remove();
      }
      await _incomingMessagesController.close();
      _activeChannels--;
      if (_activeChannels == 0) {
        await FirebaseDatabase.instance.goOffline();
      }      
    }
  }

  bool get terminated => _terminated;

  void _listenIncomingMessages() async {    
    var theirData = FirebaseDatabase.instance.reference().child('remote-payments/$_sessionID/$_theirKey/state');
    _theirDataListener = theirData.onValue.listen((event) async{
      var stateMessage = event.snapshot.value;
      if (stateMessage == null) {
        _incomingMessagesController.add(null);
        return;
      }

      if (stateMessage != null && stateMessage.runtimeType == String) {        
        if (interceptor != null) {                              
          stateMessage = await interceptor.transformIncomingMessage(stateMessage);
        }
        Map<String, dynamic> decodedState = json.decode(stateMessage);
        _incomingMessagesController.add(decodedState);       
      }
    });
  }
  
  void _watchSessionTermination() {    
    var sessionRoot = FirebaseDatabase.instance.reference().child('remote-payments/$_sessionID');
    _sessionRootListener = sessionRoot.onValue.listen((event) {
      if (event.snapshot.value == null) {        
        _peerTerminatedController.add(null);
      }      
    });
  }

  void _watchPeerReset(){
    var terminationPath = _payer ? '$_sessionID/payer' : '$_sessionID/payee';
    var terminationRef = FirebaseDatabase.instance.reference().child('remote-payments/$terminationPath');
    _peerResetListener = Observable(terminationRef.onValue)
      .delay(Duration(milliseconds: 500))
      .listen((event) {
        if (event.snapshot.value == null) {        
          peerResetStreamController.add(null);
        }      
      });
  }
}

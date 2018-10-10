import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

/*
This class abstracts a "channel" that handles all communciation between payment session peers.
The implementation is based on firebase messaging.
*/
class PaymentSessionChannel {
  final StreamController _incomingMessagesController = new StreamController<Map<dynamic, dynamic>>.broadcast();
  Stream<Map<dynamic, dynamic>> get incomingMessagesStream => _incomingMessagesController.stream;

  final StreamController<void> _peerTerminatedController = new StreamController<void>();
  Stream<void> get peerTerminatedStream => _peerTerminatedController.stream;

  final String _sessionSecret;
  final bool _payer;
  String _myKey;
  String _theirKey;
  StreamSubscription _theirDataListener;
  StreamSubscription _sessionRootListener;
  bool _terminated = false;

  PaymentSessionChannel(this._sessionSecret, this._payer) {
    _myKey = this._payer ? "payer" : "payee";
    _theirKey = this._payer ? "payee" : "payer";
    _listenIncomingMessages();
    Future sessionCreated =
        !_payer ? Future.value(null) : FirebaseDatabase.instance.reference().child('remote-payments/$_sessionSecret').update({"payer": "created"});
    sessionCreated.then((res) => _watchSessionTermination);
    _watchSessionTermination();
  }

  Future sendDataUpdate(String key, dynamic value) {
    return FirebaseDatabase.instance.reference().child('remote-payments/$_sessionSecret/$_myKey').update({key: value});
  }

  Future terminate({bool destroyHistory = false}) async {
    if (!_terminated) {
      await _theirDataListener.cancel();
      await _sessionRootListener.cancel();
      if (destroyHistory) {
        await FirebaseDatabase.instance.reference().child('remote-payments/$_sessionSecret').remove();
      }
      await _incomingMessagesController.close();
      _terminated = true;
    }
  }

  bool get terminated => _terminated;

  void _listenIncomingMessages() {
    var theirData = FirebaseDatabase.instance.reference().child('remote-payments/$_sessionSecret/$_theirKey');
    _theirDataListener = theirData.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _incomingMessagesController.add(event.snapshot.value);
      }
    });
  }

  void _watchSessionTermination() {
    var terminationPath = _payer ? _sessionSecret : '$_sessionSecret/payer';
    var sessionRoot = FirebaseDatabase.instance.reference().child('remote-payments/$terminationPath');
    _sessionRootListener = sessionRoot.onValue.listen((event) {
      if (event.snapshot.value == null) {
        _peerTerminatedController.add(null);
      }
    });
  }
}

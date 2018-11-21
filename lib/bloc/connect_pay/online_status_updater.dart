import 'dart:async';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:firebase_database/firebase_database.dart';

class OnlineStatusUpdater {
  StreamSubscription _onLocalConnectSubscription;    
  StreamSubscription _onRemoteConnectSubscription;    
  DatabaseReference _userStatusPath;


  void startStatusUpdates(String localKey, Function(PeerStatus) onLocalStatusChanged, String remoteKey, Function(PeerStatus) onRemoteStatusChanged) {
    if (_onLocalConnectSubscription != null) {
      throw new Exception("Status tracking alredy started, must be stopped before start again");
    }
    _userStatusPath = FirebaseDatabase.instance.reference().child(localKey);    

    _onLocalConnectSubscription = FirebaseDatabase.instance.reference().child('.info/connected').onValue.listen((event) {
      onLocalStatusChanged(PeerStatus(event.snapshot.value, DateTime.now().millisecondsSinceEpoch));      
      if (event.snapshot.value) {
        pushOnline();
      }     
    });

    _onRemoteConnectSubscription = FirebaseDatabase.instance.reference().child(remoteKey).onValue.listen((event) {
      var connected = event.snapshot.value != null && event.snapshot.value["online"];
      onRemoteStatusChanged(PeerStatus(connected, DateTime.now().millisecondsSinceEpoch));
    });
  }

  pushOnline(){
    var offlineStatus = {"online": false, "lastChanged": ServerValue.timestamp},
      onlineStatus = {"online": true, "lastChanged": ServerValue.timestamp};
    _userStatusPath.set(onlineStatus);
    _userStatusPath.onDisconnect().set(offlineStatus);
  }

  Future stopStatusUpdates(){
    if (_onLocalConnectSubscription == null) {
      return Future.value(null);
    }
    _userStatusPath.onDisconnect().remove();
    return Future.wait(
      [_onRemoteConnectSubscription.cancel(),_onLocalConnectSubscription.cancel()]
    ).then((_) {
      _onLocalConnectSubscription = null;
      _onRemoteConnectSubscription = null;
    });    
  }  
}

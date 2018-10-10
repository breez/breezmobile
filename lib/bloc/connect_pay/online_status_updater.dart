import 'dart:async';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:firebase_database/firebase_database.dart';

class OnlineStatusUpdater {
  StreamSubscription _onConnectSubscription;    
  DatabaseReference _userStatuPath;

  void startPushingStatuses(String updateKey, Function(PeerStatus) onStatusChanged) {
    if (_onConnectSubscription != null) {
      throw new Exception("Status tracking alredy started, must be stopped before start again");
    }
    _userStatuPath = FirebaseDatabase.instance.reference().child(updateKey);
    var offlineStatus = {"online": false, "lastChanged": ServerValue.timestamp},
      onlineStatus = {"online": true, "lastChanged": ServerValue.timestamp};

    _onConnectSubscription = FirebaseDatabase.instance.reference().child('.info/connected').onValue.listen((event) {
      onStatusChanged(PeerStatus(event.snapshot.value, DateTime.now().millisecondsSinceEpoch));      
      if (event.snapshot.value) {
        _userStatuPath.set(onlineStatus);
        _userStatuPath.onDisconnect().set(offlineStatus);
      }     
    });
  }

  Future stopPushingStatuses(){
    if (_onConnectSubscription == null) {
      return Future.value(null);
    }
    _userStatuPath.onDisconnect().remove();
    return _onConnectSubscription.cancel().then((_) => _onConnectSubscription = null);   
  }  
}

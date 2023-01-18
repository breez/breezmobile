import 'dart:async';

import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:firebase_database/firebase_database.dart';

class OnlineStatusUpdater {
  StreamSubscription _onLocalConnectSubscription;
  StreamSubscription _onRemoteConnectSubscription;
  DatabaseReference _userStatusPath;

  void startStatusUpdates(
      String localKey,
      Function(PeerStatus) onLocalStatusChanged,
      String remoteKey,
      Function(PeerStatus) onRemoteStatusChanged) {
    if (_onLocalConnectSubscription != null) {
      final texts = getSystemAppLocalizations();
      throw Exception(texts.connect_to_pay_error_status_tracking_already_started);
    }
    _userStatusPath = FirebaseDatabase.instance.ref().child(localKey);

    _onLocalConnectSubscription = FirebaseDatabase.instance
        .ref()
        .child('.info/connected')
        .onValue
        .listen((event) {
      onLocalStatusChanged(PeerStatus(
          event.snapshot.value, DateTime.now().millisecondsSinceEpoch));
      if (event.snapshot.value) {
        pushOnline();
      }
    });

    _onRemoteConnectSubscription = FirebaseDatabase.instance
        .ref()
        .child(remoteKey)
        .onValue
        .listen((event) {
      var connected = (event.snapshot.value as Map)["online"] ?? false;
      onRemoteStatusChanged(
          PeerStatus(connected, DateTime.now().millisecondsSinceEpoch));
    });
  }

  pushOnline() {
    var offlineStatus = {"online": false, "lastChanged": ServerValue.timestamp},
        onlineStatus = {"online": true, "lastChanged": ServerValue.timestamp};
    _userStatusPath.set(onlineStatus);
    _userStatusPath.onDisconnect().set(offlineStatus);
  }

  Future stopStatusUpdates() {
    if (_onLocalConnectSubscription == null) {
      return Future.value(null);
    }
    _userStatusPath.onDisconnect().remove();
    return Future.wait([
      _onRemoteConnectSubscription.cancel(),
      _onLocalConnectSubscription.cancel()
    ]).then((_) {
      _onLocalConnectSubscription = null;
      _onRemoteConnectSubscription = null;
    });
  }
}

import 'dart:async';

import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:firebase_database/firebase_database.dart';

class OnlineStatusUpdater {
  late StreamSubscription? _onLocalConnectSubscription;
  late StreamSubscription? _onRemoteConnectSubscription;
  late DatabaseReference _userStatusPath;

  void startStatusUpdates(
      String localKey,
      Function(PeerStatus) onLocalStatusChanged,
      String remoteKey,
      Function(PeerStatus) onRemoteStatusChanged) {
    if (_onLocalConnectSubscription != null) {
      final texts = getSystemAppLocalizations();
      throw Exception(
          texts.connect_to_pay_error_status_tracking_already_started);
    }
    _userStatusPath = FirebaseDatabase.instance.ref().child(localKey);

    _onLocalConnectSubscription = FirebaseDatabase.instance
        .ref()
        .child('.info/connected')
        .onValue
        .listen((DatabaseEvent event) {
      var connected = (event.snapshot.value as Map)["online"] ?? false;
      onLocalStatusChanged(
        PeerStatus(connected, DateTime.now().millisecondsSinceEpoch),
      );
      if (connected) {
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
      _onRemoteConnectSubscription?.cancel(),
      _onLocalConnectSubscription?.cancel()
    ] as Iterable<Future>)
        .then((_) {
      // TODO : Null Safety - cast
      _onLocalConnectSubscription = null;
      _onRemoteConnectSubscription = null;
    });
  }
}

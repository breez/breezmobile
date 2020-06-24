import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class NFCService {
  static const _platform = MethodChannel('com.breez.client/nfc');
  StreamController<String> _lnLinkController =
      StreamController<String>.broadcast();
  StreamSubscription _lnLinkListener;
  Timer _checkNfcStartedWithTimer;

  Stream<String> receivedLnLinks() {
    return _lnLinkController.stream;
  }

  NFCService() {
    int fnCalls = 0;
    _checkNfcStartedWithTimer =
        Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      if (fnCalls == 5) {
        _checkNfcStartedWithTimer.cancel();
        return;
      }
      fnCalls++;
      _checkNfcStartedWith();
    });
    _listenLnLinks();
  }

  _checkNfcStartedWith() async {
    _platform.invokeMethod("checkIfStartedWithNfc").then((lnLink) {
      if (lnLink != null && lnLink.toString().isNotEmpty) {
        _lnLinkController.add(lnLink);
        _checkNfcStartedWithTimer.cancel();
      }
    });
  }

  _listenLnLinks() {
    _lnLinkListener = NFC.readNDEF().listen(
      (message) {
        String lnLink = message.payload;
        if (lnLink.startsWith("lightning:")) _lnLinkController.add(lnLink);
      },
    );
  }

  close() {
    _lnLinkListener?.cancel();
    _checkNfcStartedWithTimer?.cancel();
  }
}

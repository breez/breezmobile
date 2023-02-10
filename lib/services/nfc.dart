import 'dart:async';
import 'dart:io';

import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/supported_schemes.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';

final _log = FimberLog("NFCService");

class NFCService {
  static const _platform = MethodChannel('com.breez.client/nfc');
  StreamController<String> _lnLinkController = StreamController<String>.broadcast();
  StreamSubscription _lnLinkListener;
  Timer _checkNfcStartedWithTimer;

  Stream<String> receivedLnLinks() {
    return _lnLinkController.stream;
  }

  NFCService() {
    if (Platform.isAndroid) {
      int fnCalls = 0;
      // Wrap with Future.delayed on debug mode.
      _checkNfcStartedWithTimer = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
        if (fnCalls == 5) {
          _checkNfcStartedWithTimer.cancel();
          return;
        }
        fnCalls++;
        _checkNfcStartedWith();
      });
    }
    _listenLnLinks();
  }

  starSession({bool autoClose}) {
    _startNFCSession(autoClose: autoClose);
  }

  _checkNfcStartedWith() async {
    _platform.invokeMethod("checkIfStartedWithNfc").then((lnLink) {
      if (lnLink != null && lnLink.toString().isNotEmpty) {
        _lnLinkController.add(lnLink);
        _checkNfcStartedWithTimer.cancel();
      }
    });
  }

  _listenLnLinks() async {
    // Check availability
    _log.v("check if nfc available");
    bool isAvailable = await NfcManager.instance.isAvailable();
    _log.v("nfc available $isAvailable");
    if (isAvailable && Platform.isAndroid) {
      _startNFCSession();
      ServiceInjector().device.eventStream.distinct().listen((event) {
        switch (event) {
          case NotificationType.RESUME:
            _startNFCSession();
            break;
          case NotificationType.PAUSE:
            _log.v("nfc stop session");
            NfcManager.instance.stopSession();
            break;
        }
      });
    }
  }

  _startNFCSession({bool autoClose = false}) async {
    await NfcManager.instance.stopSession();
    NfcManager.instance.startSession(      
      onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        _log.v("tag data: ${tag.data.toString()}");
        if (ndef != null) {
          for (var rec in ndef.cachedMessage.records) {           
            String payload = String.fromCharCodes(rec.payload);
            final link = extractPayloadLink(payload);
            if (link != null) {
              _log.v("nfc broadcasting link: $link");
              _lnLinkController.add(link);
              if (autoClose) {
                NfcManager.instance.stopSession();
              }
            } else {
              _log.v("nfc skip payload: $payload");
            }
          }
        }
      },
    );
  }

  close() {
    _lnLinkListener?.cancel();
    _checkNfcStartedWithTimer?.cancel();
  }
}

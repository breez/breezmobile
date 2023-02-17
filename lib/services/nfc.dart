import 'dart:async';
import 'dart:io';

import 'package:breez/logger.dart';
import 'package:breez/services/device.dart';
import 'package:breez/services/supported_schemes.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'injector.dart';

class NFCService {
  static const _platform = MethodChannel('com.breez.client/nfc');
  final StreamController<String> _lnLinkController = StreamController<String>.broadcast();
  StreamSubscription _lnLinkListener;
  Timer _checkNfcStartedWithTimer;

  Stream<String> receivedLnLinks() {
    return _lnLinkController.stream;
  }

  NFCService() {
    if (Platform.isAndroid) {
      int fnCalls = 0;
      // Wrap with Future.delayed on debug mode.
      _checkNfcStartedWithTimer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
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
    log.info("check if nfc available");
    bool isAvailable = await NfcManager.instance.isAvailable();
    log.info("nfc available $isAvailable");
    if (isAvailable && Platform.isAndroid) {
      _startNFCSession();
      ServiceInjector().device.eventStream.distinct().listen((event) {
        switch (event) {
          case NotificationType.RESUME:
            _startNFCSession();
            break;
          case NotificationType.PAUSE:
            log.info("nfc stop session");
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
        log.info("tag data: ${tag.data.toString()}");
        if (ndef != null) {
          for (var rec in ndef.cachedMessage.records) {           
            String payload = String.fromCharCodes(rec.payload);
            final link = extractPayloadLink(payload);
            if (link != null) {
              log.info("nfc broadcasting link: $link");
              _lnLinkController.add(link);
              if (autoClose) {
                NfcManager.instance.stopSession();
              }
            } else {
              log.info("nfc skip payload: $payload");
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

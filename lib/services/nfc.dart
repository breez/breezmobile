import 'dart:async';
import 'dart:io';

import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/supported_schemes.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:cktap_protocol/tap_protocol.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:nfc_manager/nfc_manager.dart';

final _log = Logger("NFC");

class NFCService {
  static const _platform = MethodChannel('com.breez.client/nfc');
  final StreamController<Satscard> _satscardController =
      StreamController<Satscard>.broadcast();

  final StreamController<String> _lnLinkController =
      StreamController<String>.broadcast();
  StreamSubscription _lnLinkListener;
  Timer _checkNfcStartedWithTimer;

  Stream<Satscard> receivedSatscards() {
    return _satscardController.stream;
  }

  Stream<String> receivedLnLinks() {
    return _lnLinkController.stream;
  }

  NFCService() {
    if (Platform.isAndroid) {
      int fnCalls = 0;
      // Wrap with Future.delayed on debug mode.
      _checkNfcStartedWithTimer =
          Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
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
    _log.info("check if nfc available");
    bool isAvailable = await NfcManager.instance.isAvailable();
    _log.info("nfc available $isAvailable");
    if (isAvailable && Platform.isAndroid) {
      _startNFCSession();
      ServiceInjector().device.eventStream.distinct().listen((event) {
        switch (event) {
          case NotificationType.RESUME:
            _startNFCSession();
            break;
          case NotificationType.PAUSE:
            _log.info("nfc stop session");
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
        _log.info("tag data: ${tag.data.toString()}");
        if (ndef != null) {
          for (var rec in ndef.cachedMessage.records) {
            String payload = String.fromCharCodes(rec.payload);
            if (!(await _handleSatscard(payload, tag)) ||
                _handleLnLink(payload)) {
              if (autoClose) {
                NfcManager.instance.stopSession();
              }
            } else {
              _log.info("nfc skip payload: $payload");
            }
          }
        }
      },
    );
  }

  bool _handleLnLink(String payload) {
    final link = extractPayloadLink(payload);
    if (link != null) {
      log.info("nfc broadcasting link: $link");
      _lnLinkController.add(link);
      return true;
    }

    return false;
  }

  Future<bool> _handleSatscard(String payload, NfcTag tag) async {
    if (!CKTapProtocol.isLikelySatscard(payload)) {
      return false;
    }

    try {
      var card = await CKTapProtocol.readCard(tag);
      if (card.isTapsigner) {
        log.info("nfc Tapsigner found but ignoring: ${card.toTapsigner()}");
        return false;
      }

      var satscard = card.toSatscard();
      if (satscard == null) {
        log.severe("nfc expected a Coinkite Satscard but received: $card");
        return false;
      }

      log.info("nfc broadcasting satscard: $satscard");
      _satscardController.add(satscard);
      return true;
    } catch (e, s) {
      log.severe("nfc error communicating with Coinkite NFC card", e, s);
    }

    return false;
  }

  close() {
    _lnLinkListener?.cancel();
    _checkNfcStartedWithTimer?.cancel();
  }
}

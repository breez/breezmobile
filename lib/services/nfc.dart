import 'dart:async';
import 'dart:io';

import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/supported_schemes.dart';
import 'package:cktap_protocol/cktap_protocol.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:nfc_manager/nfc_manager.dart';

final _log = Logger("NFC");

typedef SatscardTagCallback = Future<void> Function(NfcTag tag);

class NFCService {
  static const _platform = MethodChannel('com.breez.client/nfc');

  /// Instead of using a stream controller we need a direct callback because
  /// once the nfc_manager callback returns the given tag is erased and can't be
  /// used for transmission anymore. The upcoming version 4.0 should avoid this
  /// by re-architecting the entire plugin
  SatscardTagCallback onSatscardTag;

  final StreamController<String> _lnLinkController =
      StreamController<String>.broadcast();
  StreamSubscription _lnLinkListener;
  Timer _checkNfcStartedWithTimer;

  Stream<String> receivedLnLinks() {
    return _lnLinkController.stream;
  }

  /// A cache of whether NFC capabilities are available on this device
  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

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

  startSession({
    bool autoClose = false,
    String iosAlert,
    bool lnurlOnly = false,
    bool satscardOnly = false,
  }) {
    _startNFCSession(
        autoClose: autoClose,
        iosAlert: iosAlert,
        lnurlOnly: lnurlOnly,
        satscardOnly: satscardOnly);
  }

  stopSession({String iosAlert, String iosError}) {
    NfcManager.instance
        .stopSession(alertMessage: iosAlert, errorMessage: iosError);
  }

  updateAlert(String iosAlert) {
    NfcManager.instance.updateSession(iosAlert);
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
    _isAvailable = await NfcManager.instance.isAvailable();
    _log.info("nfc available $_isAvailable");
    if (_isAvailable && Platform.isAndroid) {
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

  _startNFCSession({
    bool autoClose = false,
    String iosAlert,
    bool lnurlOnly = false,
    bool satscardOnly = false,
  }) async {
    await NfcManager.instance.stopSession();
    NfcManager.instance.startSession(
      alertMessage: iosAlert,
      onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        _log.info("tag data: ${tag.data.toString()}");
        if (ndef != null) {
          for (var rec in ndef.cachedMessage.records) {
            final payload = String.fromCharCodes(rec.payload);
            final wasHandled = await _handlePayload(payload, tag,
                lnurlOnly: lnurlOnly, satscardOnly: satscardOnly);
            if (wasHandled) {
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

  Future<bool> _handlePayload(String payload, NfcTag tag,
      {bool lnurlOnly, bool satscardOnly}) async {
    final checkAll = !(lnurlOnly || satscardOnly);
    if (checkAll || lnurlOnly) {
      final link = extractPayloadLink(payload);
      if (link != null) {
        _log.info("nfc broadcasting link: $link");
        _lnLinkController.add(link);
        return true;
      }
    }
    if (checkAll || satscardOnly) {
      if (CKTap.isLikelySatscard(payload)) {
        if (onSatscardTag != null) {
          _log.info("nfc broadcasting possible satscard: $payload");
          await onSatscardTag(tag);
        } else {
          _log.warning(
              "nfc encountered Satscard but no callback was registered: $payload");
        }
        return true;
      }
    }
    return false;
  }

  close() {
    _lnLinkListener?.cancel();
    _checkNfcStartedWithTimer?.cancel();
  }
}

import 'dart:async';

import 'package:breez/logger.dart';
import 'package:flutter/services.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class NFCService {
  static const _platform = MethodChannel('com.breez.client/nfc');
  StreamController<String> _breezIdStreamController =
      StreamController<String>();

  StreamController<bool> _cardActivationController = StreamController<bool>();

  Stream<bool> get cardActivationStream =>
      _cardActivationController.stream.asBroadcastStream();

  StreamController<String> _bolt11BeamController;
  StreamController<String> _p2pBeamController;

  StreamController<String> _bolt11StreamController =
      StreamController<String>.broadcast();
  StreamController<String> _blankInvoiceController = StreamController<String>();
  StreamController<String> _lnLinkController =
      StreamController<String>.broadcast();
  StreamSubscription _lnLinkListener;
  Timer _checkNfcStartedWithTimer;

  void startCardActivation(String breezId) {
    _platform.invokeMethod("startCardActivation", {"breezId": breezId});
  }

  Future<bool> checkNFCSettings() async {
    final bool result = await _platform.invokeMethod('checkNFCSettings');
    return result;
  }

  void openSettings() {
    _platform.invokeMethod('openNFCSettings');
  }

  stopCardActivation() async {
    _platform.invokeMethod("stopCardActivation").then((success) {
      if (success) {
        //_cardActivationController.close();
      } else {
        _cardActivationController.addError(Error());
      }
    });
  }

  Stream<String> startBolt11Beam(String bolt11) {
    _bolt11BeamController = StreamController<String>();
    _platform.invokeMethod("startBolt11Beam", {"bolt11": bolt11});
    return _bolt11BeamController.stream;
  }

  Stream<String> startP2PBeam() {
    _p2pBeamController = StreamController<String>();
    _p2pBeamController.onCancel = () {
      stopP2PBeam();
    };
    _platform.invokeMethod("startP2PBeam");
    return _p2pBeamController.stream;
  }

  void stopP2PBeam() {
    _p2pBeamController.close();
    _platform.invokeMethod("stopBeam");
  }

  Stream<String> receivedBreezIds() {
    return _breezIdStreamController.stream;
  }

  Stream<String> receivedBolt11s() {
    return _bolt11StreamController.stream;
  }

  Stream<String> receivedBlankInvoices() {
    return _blankInvoiceController.stream;
  }

  Stream<String> receivedLnLinks() {
    return _lnLinkController.stream;
  }

  void idReceived(String breezId) {
    if (breezId == null) _breezIdStreamController.close();
    _breezIdStreamController.add(breezId);
  }

  NFCService() {
    /*
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
    */
    _listenLnLinks();
    _platform.setMethodCallHandler((MethodCall call) {
      if (call.method == 'receivedBreezId') {
        log.info("Received a Breez ID: " + call.arguments);
        idReceived(call.arguments);
      }
      if (call.method == 'receivedBlankInvoice') {
        log.info("Received a blank invoice: " + call.arguments);
        if (call.arguments == 'NOT_AVAILABLE') {
          _blankInvoiceController
              .addError("User not ready to receieve payments!");
        } else {
          _blankInvoiceController.add(call.arguments);
        }
      }
      if (call.method == 'cardActivation') {
        if (call.arguments) {
          _cardActivationController.add(true);
          stopCardActivation();
        } else {
          _cardActivationController.add(false);
        }
      }
      if (call.method == 'receivedBolt11') {
        log.info("Received BOLT-11: " + call.arguments);
        _bolt11StreamController.add(call.arguments);
      }
    });
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
    _breezIdStreamController.close();
    _cardActivationController.close();
    _bolt11BeamController.close();
    _p2pBeamController.close();
    _bolt11StreamController.close();
    _lnLinkListener?.cancel();
    _checkNfcStartedWithTimer?.cancel();
  }
}

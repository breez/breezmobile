import 'dart:async';

import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/satscard/satscard_actions.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/nfc.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:cktap_protocol/exceptions.dart';
import 'package:cktap_protocol/tap_protocol.dart';

class SatscardBloc with AsyncActionsHandler {
  final StreamController<Satscard> _unusedSatscardController =
      StreamController<Satscard>();
  Stream<Satscard> get unusedSatscardStream => _unusedSatscardController.stream;

  final StreamController<Satscard> _sweepableSatscardController =
      StreamController<Satscard>();
  Stream<Satscard> get sweepableSatscardStream =>
      _sweepableSatscardController.stream;

  BreezBridge _breezLib;

  SatscardBloc() {
    ServiceInjector injector = ServiceInjector();
    NFCService nfc = injector.nfc;
    _breezLib = injector.breezBridge;

    _listenSatscards(_breezLib, nfc);

    registerAsyncHandlers({
      InitializeSatscard: _initializeSatscard,
      SweepSatscard: _sweepSatscard,
    });
    listenActions();
  }

  void _listenSatscards(BreezBridge breezLib, NFCService nfc) {
    nfc.onSatscardTag = (tag) async {
      try {
        var card = await CKTapProtocol.readCard(tag);
        if (card.isTapsigner) {
          log.severe("Satscard expected but tapsigner was received: $card");
          return;
        }
        var satscard = card.toSatscard();
        switch (satscard.activeSlot.status) {
          case SlotStatus.unused:
            _unusedSatscardController.add(satscard);
            break;
          case SlotStatus.sealed:
          case SlotStatus.unsealed:
            // For debugging purposes send it to the unused controller
            _unusedSatscardController.add(satscard);
            //_sweepableSatscardController.add(satscard);
            break;
          default:
            log.severe(
                "Satscard detected with unknown slot status: ${satscard.activeSlot.status}");
            break;
        }
      } on NfcCommunicationException catch (e) {
        log.info("Reading a satscard failed due to a communication error: $e");
      } catch (e, s) {}
    };
  }

  Future _initializeSatscard(InitializeSatscard action) async {
    return Future.error("InitializeSatscard action not implemented");
  }

  Future _sweepSatscard(SweepSatscard action) async {
    return Future.error("SweepSatscard action not implemented");
  }

  close() {
    _unusedSatscardController.close();
    _sweepableSatscardController.close();
  }
}

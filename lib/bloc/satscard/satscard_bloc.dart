import 'dart:async';

import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/satscard/satscard_actions.dart';
import 'package:breez/bloc/satscard/satscard_detected_status.dart';
import 'package:breez/bloc/satscard/satscard_operation_status.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/nfc.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:cktap_protocol/exceptions.dart';
import 'package:cktap_protocol/transport.dart';

class SatscardBloc with AsyncActionsHandler {
  final BreezBridge _breezLib;
  final NFCService _nfc;

  final StreamController<DetectedSatscardStatus> _detectedController =
      StreamController<DetectedSatscardStatus>();
  Stream<DetectedSatscardStatus> get detectedStream =>
      _detectedController.stream;

  final StreamController<SatscardOperationStatus> _operationController =
      StreamController<SatscardOperationStatus>();
  Stream<SatscardOperationStatus> get operationStream =>
      _operationController.stream;

  SatscardBloc()
      : _breezLib = ServiceInjector().breezBridge,
        _nfc = ServiceInjector().nfc {
    _listenSatscards();

    registerAsyncHandlers({
      InitializeSatscard: _initializeSatscard,
      SweepSatscard: _sweepSatscard,
    });
    listenActions();
  }

  void _listenSatscards() {
    log.info("SatscardBloc: _listenSatscards registered with NFCService");
    _nfc.onSatscardTag = (tag) async {
      try {
        log.info("Attempting to read Satscard with the following tag: $tag");
        var card =
            await Satscard.fromTransport(TransportNfcManager.fromTag(tag));
        if (card.isUsedUp) {
          log.info("Found Satscard with no unused slots: $card");
          _detectedController.add(DetectedSatscardStatus.usedUp(card));
          return;
        }
        var slot = await card.getActiveSlot();
        switch (slot.status) {
          case SlotStatus.unused:
            log.info("Uninitialized active slot found on Satscard: $card");
            _detectedController.add(DetectedSatscardStatus.unused(card));
            break;
          case SlotStatus.sealed:
          case SlotStatus.unsealed:
            log.info("Sweepable Satscard found: $card");
            log.info("Active slot: $slot");
            _detectedController
                .add(DetectedSatscardStatus.sweepable(card, slot));
            break;
          default:
            log.severe(
                "Satscard detected with unknown slot status: ${slot.status}");
            break;
        }
      } on NfcCommunicationException catch (e) {
        log.warning(
            "Reading a satscard failed due to a communication error: $e");
      } catch (e, s) {
        log.severe("Reading a satscard failed with an unexpected error", e, s);
      }
    };
  }

  Future _initializeSatscard(InitializeSatscard action) async {
    final id = action.request.satscard.ident;
    _operationController.add(SatscardOperationStatus.pending(id));

    log.info("SatscardBloc: _initializeSatscard registered with NFCService");
    _nfc.onSatscardTag = (tag) async {
      try {
        log.info(
            "Attempting to initialize satscard slot with the following ID: $id");
        //var card = await CKTapProtocol.readCard(tag);
      } on NfcCommunicationException catch (e) {
        log.warning(
            "Slot initialization failed due to a communication error: $e");
        _operationController
            .add(SatscardOperationStatus.nfcError(id, e.toString()));
      } on TapProtoException catch (e, s) {
        log.severe("Slot initialization failed due to a protocol error", e, s);
        _operationController.add(SatscardOperationStatus.protocolError(id, e));
      } catch (e, s) {
        log.severe("Slot initialization failed with an unexpected error", e, s);
        _operationController
            .add(SatscardOperationStatus.unexpectedError(id, e.toString()));
      }
    };
  }

  Future _sweepSatscard(SweepSatscard action) async {
    return Future.error("SweepSatscard action not implemented");
  }

  close() {
    _detectedController.close();
  }
}

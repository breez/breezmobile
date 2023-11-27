import 'dart:async';

import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/satscard/satscard_actions.dart';
import 'package:breez/bloc/satscard/detected_satscard_status.dart';
import 'package:breez/bloc/satscard/satscard_op_status.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/nfc.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:cktap_protocol/exceptions.dart';
import 'package:cktap_protocol/transport.dart';
import 'package:logging/logging.dart';

final _log = Logger("SatscardBloc");

class SatscardBloc with AsyncActionsHandler {
  final _detectedController = StreamController<DetectedSatscardStatus>();
  Stream<DetectedSatscardStatus> get detectedStream =>
      _detectedController.stream;

  final _operationController = StreamController<SatscardOpStatus>.broadcast();
  Stream<SatscardOpStatus> get operationStream => _operationController.stream;

  final BreezBridge _breezLib;
  final NFCService _nfc;

  SatscardBloc()
      : _breezLib = ServiceInjector().breezBridge,
        _nfc = ServiceInjector().nfc {
    registerAsyncHandlers({
      CreateSlotSweepTransactions: _createSlotSweepTransactions,
      DisableListening: _disableListening,
      EnableListening: _enableListening,
      GetAddressInfo: _getAddressInfo,
      GetFeeRates: _getFeeRates,
      InitializeSlot: _initializeSlot,
      SweepSatscard: _sweepSatscard,
    });
    listenActions();
  }

  void _listenSatscards() {
    _log.info("_listenSatscards() registered with NFCService");
    _nfc.onSatscardTag = (tag) async {
      try {
        _log.info("Attempting to read Satscard with the following tag: $tag");
        final card = await Satscard.fromTransport(NfcManagerTransport(tag));
        if (card.isUsedUp) {
          _log.info("Found Satscard with no unused slots: $card");
          _detectedController.add(DetectedSatscardStatus.usedUp(card));
          return;
        }
        var slot = await card.getActiveSlot();
        switch (slot.status) {
          case SlotStatus.unused:
            _log.info("Uninitialized active slot found on Satscard: $card");
            _detectedController.add(DetectedSatscardStatus.unused(card));
            break;
          case SlotStatus.sealed:
          case SlotStatus.unsealed:
            _log.info("Sweepable Satscard found: $card");
            _log.info("Active slot: $slot");
            _detectedController
                .add(DetectedSatscardStatus.sweepable(card, slot));
            break;
          default:
            _log.severe(
                "Satscard detected with unknown slot status: ${slot.status}");
            break;
        }
      } on NfcCommunicationException catch (e) {
        _log.warning(
            "Reading a satscard failed due to a communication error: $e");
      } catch (e, s) {
        _log.severe("Reading a satscard failed with an unexpected error", e, s);
      }
    };
  }

  Future<void> _createSlotSweepTransactions(CreateSlotSweepTransactions action) async {
    return _breezLib
        .createSlotSweepTransactions(action.slotInfo, action.recipient)
        .then((result) => action.resolve(result));
  }

  Future<void> _disableListening(DisableListening action) async {
    _log.info("_disableListening() called");
    _nfc.onSatscardTag = (tag) async => _log
        .info("Ignoring Satscard tag due to listening being disabled: $tag");
    action.resolve(true);
  }

  Future<void> _enableListening(EnableListening action) async {
    _log.info("_enableListening() called");
    _listenSatscards();
    action.resolve(true);
  }

  Future<void> _getAddressInfo(GetAddressInfo action) async {
    return _breezLib
        .getMempoolAddressInfo(action.address)
        .then((result) => action.resolve(result));
  }

  Future<void> _getFeeRates(GetFeeRates action) async {
    return _breezLib
        .getMempoolRecommendedFees()
        .then((result) => action.resolve(result));
  }

  Future<void> _initializeSlot(InitializeSlot action) async {
    final id = action.request.satscard.ident;

    _log.info("_initializeSatscard() registered with NFCService");
    _nfc.onSatscardTag = (tag) async {
      try {
        _log.info(
            "Attempting to initialize satscard slot with the following ID: $id");
        _operationController.add(SatscardOpStatus.inProgress());

        // We need to establish that we are communicating with the correct card
        final transport = NfcManagerTransport(tag);
        final card = await Satscard.fromTransport(transport);
        if (card.ident != id) {
          _operationController.add(SatscardOpStatus.incorrectCard());
          return;
        }

        // Make sure the state of the card matches our previous read
        if (card.activeSlotIndex != action.request.satscard.activeSlotIndex ||
            card.isUsedUp) {
          _operationController.add(SatscardOpStatus.staleCard());
          return;
        }
        final activeSlot = await card.getActiveSlot();
        if (activeSlot.status != SlotStatus.unused) {
          _operationController.add(SatscardOpStatus.staleCard());
          return;
        }

        // Handle the auth delay
        final initialDelay = card.authDelay;
        if (initialDelay > 0) {
          _operationController
              .add(SatscardOpStatus.waiting(initialDelay, initialDelay));
          while (card.authDelay > 0) {
            final response = await card.wait(transport);
            if (!response.success) {
              throw Exception(
                  "Unexpected failure while awaiting the authentication delay");
            }
            _operationController
                .add(SatscardOpStatus.waiting(card.authDelay, initialDelay));
          }
        }

        // Proceed with the initialization
        _operationController.add(SatscardOpStatus.inProgress());
        final slot = await card.newSlot(transport, action.request.cvcCode,
            chainCode: action.request.chainCode);
        _operationController.add(SatscardOpStatus.slotInitialized(card, slot));
      } on NfcCommunicationException catch (e) {
        _log.warning(
            "Slot initialization failed due to a communication error: $e");
        _operationController.add(SatscardOpStatus.nfcError());
      } on TapProtoException catch (e, s) {
        _log.severe("Slot initialization failed due to a protocol error", e, s);
        _operationController.add(SatscardOpStatus.protocolError(e));
      } catch (e, s) {
        _log.severe(
            "Slot initialization failed with an unexpected error", e, s);
        _operationController
            .add(SatscardOpStatus.unexpectedError(e.toString()));
      }
    };
  }

  Future<void> _sweepSatscard(SweepSatscard action) async {
    return Future.error("SweepSatscard action not implemented");
  }

  @override
  Future dispose() async {
    await _detectedController.close();
    await _operationController.close();
  }
}

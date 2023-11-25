import 'package:cktap_protocol/cktapcard.dart';
import 'package:cktap_protocol/exceptions.dart';

abstract class SatscardOpStatus {
  const SatscardOpStatus();

  // Progress states

  factory SatscardOpStatus.inProgress() => const SatscardOpStatusInProgress();
  factory SatscardOpStatus.waiting(
          int currentAuthDelay, int initialAuthDelay) =>
      SatscardOpStatusWaiting(currentAuthDelay, initialAuthDelay);

  // Success states

  factory SatscardOpStatus.slotInitialized(Satscard card, Slot slot) =>
      SatscardOpStatusSlotInitialized(card, slot);

  // Failure states

  factory SatscardOpStatus.incorrectCard() =>
      const SatscardOpStatusIncorrectCard();
  factory SatscardOpStatus.nfcError() => const SatscardOpStatusNfcError();
  factory SatscardOpStatus.protocolError(TapProtoException e) {
    switch (e.code) {
      case TapProtoExceptionCode.BAD_AUTH:
        return const SatscardOpStatusBadAuth();
      default:
        return SatscardOpStatusProtocolError(e);
    }
  }
  factory SatscardOpStatus.staleCard() => const SatscardOpStatusStaleCard();
  factory SatscardOpStatus.unexpectedError(String message) =>
      SatscardOpStatusUnexpectedError(message);
}

class SatscardOpStatusInProgress extends SatscardOpStatus {
  const SatscardOpStatusInProgress();
}

class SatscardOpStatusWaiting extends SatscardOpStatus {
  final int currentAuthDelay;
  final int initialAuthDelay;

  const SatscardOpStatusWaiting(this.currentAuthDelay, this.initialAuthDelay);
}

class SatscardOpStatusSuccess extends SatscardOpStatus {
  const SatscardOpStatusSuccess();
}

class SatscardOpStatusSlotInitialized extends SatscardOpStatusSuccess {
  final Satscard card;
  final Slot slot;

  const SatscardOpStatusSlotInitialized(this.card, this.slot);
}

class SatscardOpStatusBadAuth extends SatscardOpStatus {
  const SatscardOpStatusBadAuth();
}

class SatscardOpStatusIncorrectCard extends SatscardOpStatus {
  const SatscardOpStatusIncorrectCard();
}

class SatscardOpStatusNfcError extends SatscardOpStatus {
  const SatscardOpStatusNfcError();
}

class SatscardOpStatusProtocolError extends SatscardOpStatus {
  final TapProtoException e;

  const SatscardOpStatusProtocolError(this.e);
}

class SatscardOpStatusStaleCard extends SatscardOpStatus {
  const SatscardOpStatusStaleCard();
}

class SatscardOpStatusUnexpectedError extends SatscardOpStatus {
  final String message;

  const SatscardOpStatusUnexpectedError(this.message);
}

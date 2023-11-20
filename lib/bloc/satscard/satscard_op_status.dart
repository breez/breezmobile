import 'package:cktap_protocol/cktapcard.dart';
import 'package:cktap_protocol/exceptions.dart';

abstract class SatscardOpStatus {
  const SatscardOpStatus();

  factory SatscardOpStatus.inProgress() => const SatscardOpStatusInProgress();

  factory SatscardOpStatus.waiting(
          int currentAuthDelay, int initialAuthDelay) =>
      SatscardOpStatusWaiting(currentAuthDelay, initialAuthDelay);

  factory SatscardOpStatus.slotInitialized(Satscard card, Slot slot) =>
      SatscardOpStatusSlotInitialized(card, slot);

  factory SatscardOpStatus.incorrectCard() =>
      const SatscardOpStatusIncorrectCard();

  factory SatscardOpStatus.staleCard() => const SatscardOpStatusStaleCard();

  factory SatscardOpStatus.nfcError() => const SatscardOpStatusNfcError();

  factory SatscardOpStatus.protocolError(TapProtoException e) =>
      SatscardOpStatusProtocolError(e);

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

class SatscardOpStatusSlotInitialized extends SatscardOpStatus {
  final Satscard card;
  final Slot slot;

  const SatscardOpStatusSlotInitialized(this.card, this.slot);
}

class SatscardOpStatusIncorrectCard extends SatscardOpStatus {
  const SatscardOpStatusIncorrectCard();
}

class SatscardOpStatusStaleCard extends SatscardOpStatus {
  const SatscardOpStatusStaleCard();
}

class SatscardOpStatusNfcError extends SatscardOpStatus {
  const SatscardOpStatusNfcError();
}

class SatscardOpStatusProtocolError extends SatscardOpStatus {
  final TapProtoException e;

  const SatscardOpStatusProtocolError(this.e);
}

class SatscardOpStatusUnexpectedError extends SatscardOpStatus {
  final String message;

  const SatscardOpStatusUnexpectedError(this.message);
}

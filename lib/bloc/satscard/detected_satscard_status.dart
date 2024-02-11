import 'package:cktap_protocol/cktapcard.dart';

abstract class DetectedSatscardStatus {
  const DetectedSatscardStatus();

  factory DetectedSatscardStatus.sweepable(Satscard card, Slot slot) =>
      DetectedSweepableSatscardStatus(card, slot);

  factory DetectedSatscardStatus.unused(Satscard card) =>
      DetectedUnusedSatscardStatus(card);

  factory DetectedSatscardStatus.usedUp(Satscard card) =>
      DetectedUsedUpSatscardStatus(card);

  factory DetectedSatscardStatus.nfcError() =>
      DetectedNoSatscardStatus();

  factory DetectedSatscardStatus.unknownError(String message) =>
      DetectedInvalidSatscardStatus(message);
}

class DetectedInvalidSatscardStatus extends DetectedSatscardStatus {
  final String message;

  DetectedInvalidSatscardStatus(this.message);
}

class DetectedNoSatscardStatus extends DetectedSatscardStatus {}

class DetectedSweepableSatscardStatus extends DetectedSatscardStatus {
  final Satscard card;
  final Slot slot;

  DetectedSweepableSatscardStatus(this.card, this.slot);
}

class DetectedUnusedSatscardStatus extends DetectedSatscardStatus {
  final Satscard card;

  DetectedUnusedSatscardStatus(this.card);
}

class DetectedUsedUpSatscardStatus extends DetectedSatscardStatus {
  final Satscard card;

  DetectedUsedUpSatscardStatus(this.card);
}

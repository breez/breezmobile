import 'package:cktap_protocol/cktapcard.dart';
import 'package:cktap_protocol/exceptions.dart';

abstract class SatscardOperationStatus {
  const SatscardOperationStatus();

  factory SatscardOperationStatus.pending(String id) =>
      SatscardOperationStatusPending(id);

  factory SatscardOperationStatus.started() =>
      const SatscardOperationStatusStarted();

  factory SatscardOperationStatus.slotInitialized(Satscard card) =>
      SatscardOperationStatusSlotInitialized(card);

  factory SatscardOperationStatus.nfcError(String id, String message) =>
      SatscardOperationStatusNfcError(id, message);

  factory SatscardOperationStatus.protocolError(String id, TapProtoException e) =>
      SatscardOperationStatusProtocolError(id, e);

  factory SatscardOperationStatus.unexpectedError(String id, String message) =>
      SatscardOperationStatusUnexpectedError(id, message);
}

class SatscardOperationStatusPending extends SatscardOperationStatus {
  final String id;

  const SatscardOperationStatusPending(this.id);
}

class SatscardOperationStatusStarted extends SatscardOperationStatus {
  const SatscardOperationStatusStarted();
}

class SatscardOperationStatusSlotInitialized extends SatscardOperationStatus {
  final Satscard card;

  const SatscardOperationStatusSlotInitialized(this.card);
}

class SatscardOperationStatusNfcError extends SatscardOperationStatus {
  final String id;
  final String message;

  const SatscardOperationStatusNfcError(this.id, this.message);
}

class SatscardOperationStatusProtocolError extends SatscardOperationStatus {
  final String id;
  final TapProtoException e;

  const SatscardOperationStatusProtocolError(this.id, this.e);
}

class SatscardOperationStatusUnexpectedError extends SatscardOperationStatus {
  final String id;
  final String message;

  const SatscardOperationStatusUnexpectedError(this.id, this.message);
}

import 'package:cktap_protocol/cktapcard.dart';

class InitializeSatscardModel {
  final Satscard satscard;
  final String cvcCode;
  final String chainCode;

  InitializeSatscardModel(
      this.satscard, this.cvcCode, this.chainCode);
}

class SweepSatscardModel {
  final Satscard satscard;
  final String cvcCode;

  SweepSatscardModel(this.satscard, this.cvcCode);
}

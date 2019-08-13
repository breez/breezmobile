import 'package:breez/services/breezlib/data/rpc.pb.dart';

class LSPInfo {
  final String lspID;
  final LSPInformation _lspInformation;

  LSPInfo(this._lspInformation, this.lspID);

  String get name => _lspInformation.name;
  String get pubKey => _lspInformation.pubkey;
  String get host => _lspInformation.host;
  bool get frozen => _lspInformation.isFrozen;
  int get minHtlcMsat => _lspInformation.minHtlcMsat.toInt();
  int get targetConf => _lspInformation.targetConf;
  int get timeLockDelta => _lspInformation.timeLockDelta;
  int get baseFeeMsat => _lspInformation.baseFeeMsat.toInt();
  int get channelCapacity => _lspInformation.channelCapacity.toInt();
}
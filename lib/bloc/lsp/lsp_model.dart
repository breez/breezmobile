import 'package:breez/services/breezlib/data/rpc.pb.dart';

enum LSPConnectionStatus {
  InProgress,
  Active,
  NotSelected,
}

class LSPStatus {
  final List<LSPInfo> availableLSPs;
  final String selectedLSP;
  final String lastConnectionError;

  LSPStatus._(this.availableLSPs, this.lastConnectionError, this.selectedLSP);

  LSPStatus.initial() : this._([], null, null);
  LSPStatus copyWith(
      {List<LSPInfo> availableLSPs,
      String lastConnectionError,
      String selectedLSP}) {
    return LSPStatus._(
        availableLSPs ?? this.availableLSPs,
        lastConnectionError ?? this.lastConnectionError,
        selectedLSP ?? this.selectedLSP);
  }

  bool get selectionRequired => selectedLSP == null && availableLSPs.length > 1;

  LSPInfo get currentLSP =>
      availableLSPs.firstWhere((element) => element.lspID == selectedLSP,
          orElse: () => null);
}

class LSPInfo {
  final String lspID;
  final LSPInformation _lspInformation;

  LSPInfo(this._lspInformation, this.lspID);

  String get name => _lspInformation.name;
  String get widgetURL => _lspInformation.widgetUrl;
  String get pubKey => _lspInformation.pubkey;
  String get host => _lspInformation.host;
  bool get frozen => _lspInformation.isFrozen;
  int get minHtlcMsat => _lspInformation.minHtlcMsat.toInt();
  int get targetConf => _lspInformation.targetConf;
  int get timeLockDelta => _lspInformation.timeLockDelta;
  int get baseFeeMsat => _lspInformation.baseFeeMsat.toInt();
  int get channelCapacity => _lspInformation.channelCapacity.toInt();
  int get channelFeePermyriad => _lspInformation.channelFeePermyriad.toInt();
  LSPInformation get raw => _lspInformation;
}

import 'package:breez/services/breezlib/data/rpc.pb.dart';

enum LSPConnectionStatus {
  InProgress,
  Active,
  NotSelected,
}

class LSPStatus {
  final List<LSPInfo> availableLSPs;
  final LSPConnectionStatus connectionStatus;
  final String lastConnectionError;
  final bool dontPromptToConnect;

  LSPStatus._(this.availableLSPs, this.connectionStatus,
      this.lastConnectionError, this.dontPromptToConnect);

  LSPStatus.initial() : this._([], null, null, null);
  LSPStatus copyWith(
      {List<LSPInfo> availableLSPs,
      LSPConnectionStatus connectionStatus,
      String lastConnectionError,
      bool dontPromptToConnect}) {
    return LSPStatus._(
        availableLSPs ?? this.availableLSPs,
        connectionStatus ?? this.connectionStatus,
        lastConnectionError ?? this.lastConnectionError,
        dontPromptToConnect ?? this.dontPromptToConnect);
  }

  bool get selectionRequired =>
      connectionStatus == LSPConnectionStatus.NotSelected && !shouldAutoReconnect;

  bool get shouldAutoReconnect =>
      connectionStatus == LSPConnectionStatus.NotSelected &&
              availableLSPs.length == 1 &&
              availableLSPs[0].widgetURL.isEmpty &&
              lastConnectionError == null;         
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
}

import 'package:breez/services/breezlib/breez_bridge.dart';

abstract class MessageInterceptor {
  Future<String> transformOutgoingMessage(String message);
  Future<String> transformIncomingMessage(String message);
}

class SessionEncryption implements MessageInterceptor {
  final BreezBridge _breezLib;
  final String sessionID;

  SessionEncryption(this._breezLib, this.sessionID);

  @override
  Future<String> transformIncomingMessage(String encryptedMessage) {
    return _breezLib.ratchetDecrypt(sessionID, encryptedMessage);
  }

  @override
  Future<String> transformOutgoingMessage(String message) {
    return _breezLib.ratchetEncrypt(sessionID, message);
  }
}

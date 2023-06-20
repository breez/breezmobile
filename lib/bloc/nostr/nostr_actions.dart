import 'package:breez/bloc/async_action.dart';

class GetPublicKey extends AsyncAction {
  GetPublicKey();
}

class SignEvent extends AsyncAction {
  final Map<String, dynamic> eventObject;
  final String privateKey;

  SignEvent(this.eventObject, this.privateKey);
}

class GetRelays extends AsyncAction {}

class Nip04Encrypt extends AsyncAction {
  final String data;
  final String publicKey;

  Nip04Encrypt(this.data, this.publicKey);
}

class Nip04Decrypt extends AsyncAction {
  final String encryptedData;
  final String privateKey;

  Nip04Decrypt(this.encryptedData, this.privateKey);
}

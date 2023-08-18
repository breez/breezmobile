import 'package:breez/bloc/async_action.dart';

class GetPublicKey extends AsyncAction {
  GetPublicKey();
}

class SignEvent extends AsyncAction {
  final Map<String, dynamic> eventObject;

  SignEvent(
    this.eventObject,
  );
}

class GetRelays extends AsyncAction {}

class Nip04Encrypt extends AsyncAction {
  final String data;

  Nip04Encrypt(
    this.data,
  );
}

class Nip04Decrypt extends AsyncAction {
  final String encryptedData;

  Nip04Decrypt(
    this.encryptedData,
  );
}

class StoreImportedPrivateKey extends AsyncAction {
  final String privateKey;
  StoreImportedPrivateKey({
    this.privateKey,
  });
}

class DeleteKey extends AsyncAction {
  DeleteKey();
}

class PublishRelays extends AsyncAction {
  final List<String> userRelayList;
  PublishRelays({
    this.userRelayList,
  });
}

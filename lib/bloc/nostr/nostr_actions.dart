import 'package:breez/bloc/async_action.dart';
import 'package:breez/utils/nostrConnect.dart';

import 'nostr_bloc.dart';

class GetPublicKey extends AsyncAction {
  GetPublicKey();
}

class SignEvent extends AsyncAction {
  final Map<String, dynamic> eventObject;
  final String privateKey;

  SignEvent(
    this.eventObject,
    this.privateKey,
  );
}

class GetRelays extends AsyncAction {}

class Nip04Encrypt extends AsyncAction {
  final String data;
  final String publicKey;
  final String privateKey;

  Nip04Encrypt(
    this.data,
    this.publicKey,
    this.privateKey,
  );
}

class Nip04Decrypt extends AsyncAction {
  final String encryptedData;
  final String publicKey;
  final String privateKey;

  Nip04Decrypt(
    this.encryptedData,
    this.publicKey,
    this.privateKey,
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

class Nip47Connect extends AsyncAction {
  final ConnectUri connectUri;
  final NostrBloc nostrBloc;
  Nip47Connect({
    this.connectUri,
    this.nostrBloc,
  });
}

import 'package:breez/bloc/async_action.dart';
import 'package:breez/utils/nostrConnect.dart';

import 'nostr_bloc.dart';

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
  final String publicKey;

  Nip04Encrypt(
    this.data,
    this.publicKey,
  );
}

class Nip04Decrypt extends AsyncAction {
  final String encryptedData;
  final String publicKey;

  Nip04Decrypt(
    this.encryptedData,
    this.publicKey,
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

class Nip46Connect extends AsyncAction {
  final ConnectUri connectUri;
  final NostrBloc nostrBloc;
  Nip46Connect({
    this.connectUri,
    this.nostrBloc,
  });
}

class Nip46Disconnect extends AsyncAction {
  final ConnectUri connectUri;
  final NostrBloc nostrBloc;
  Nip46Disconnect({
    this.connectUri,
    this.nostrBloc,
  });
}

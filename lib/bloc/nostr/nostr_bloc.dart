import 'dart:async';

import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/nostr/nostr_actions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NostrBloc with AsyncActionsHandler {
  String nostrPublicKey;
  String nostrPrivateKey;

  FlutterSecureStorage _secureStorage;
  SharedPreferences sharedPreferences;

  NostrBloc() {
    _secureStorage = const FlutterSecureStorage();

    initNostr();

    registerAsyncHandlers({
      GetPublicKey: _handleGetPublicKey,
      SignEvent: _handleSignEvent,
      GetRelays: _handleGetRelays,
      Nip04Encrypt: _handleNip04Encrypt,
      Nip04Decrypt: _handleNip04Decrypt,
    });
    listenActions();
  }

  void initNostr() async {
    nostrPublicKey = await _secureStorage.read(key: 'nostrPublicKey');
    nostrPrivateKey = await _secureStorage.read(key: 'nostrPrivateKey');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (nostrPublicKey == null) {
      sharedPreferences.setBool('rememberGetPubKeyChoice', false);
      sharedPreferences.setBool('rememberSignEventChoice', false);
    }
  }

  final StreamController<String> _publicKeyController =
      StreamController<String>.broadcast();
  Stream<String> get publicKeyStream => _publicKeyController.stream;

  final StreamController<Map<String, dynamic>> _eventController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get eventStream => _eventController.stream;

  Future<void> _handleGetPublicKey(GetPublicKey action) async {
    //  to get the public key
    String publicKey = await _fetchPublicKey();
    _publicKeyController.add(publicKey);
    action.resolve(publicKey);
  }

  Future<void> _handleSignEvent(SignEvent action) async {
    //  to sign the event
    Map<String, dynamic> signedEvent =
        await _signEvent(action.eventObject, action.privateKey);

    _eventController.add(signedEvent);
    action.resolve(signedEvent);
  }

  Future<void> _handleGetRelays(GetRelays action) async {
    //  to get the relays
    List<String> relays = await _fetchRelays();
    // Perform any processing on the relays if needed
    action.resolve(relays);
  }

  Future<void> _handleNip04Encrypt(Nip04Encrypt action) async {
    // to encrypt the data`
    String encryptedData = await _encryptData(action.data, action.publicKey);
    action.resolve(encryptedData);
  }

  Future<void> _handleNip04Decrypt(Nip04Decrypt action) async {
    // to decrypt the data
    String decryptedData =
        await _decryptData(action.encryptedData, action.privateKey);
    action.resolve(decryptedData);
  }

  // Methods to simulate the actual logic

  Future<String> _fetchPublicKey() async {
    // check if key pair already exists otherwise generate it

    if (nostrPublicKey == null) {
      final keyGenerator = KeyApi();
      nostrPrivateKey = keyGenerator.generatePrivateKey();
      nostrPublicKey = keyGenerator.getPublicKey(nostrPrivateKey);

      // Write value
      await _secureStorage.write(
          key: 'nostrPrivateKey', value: nostrPrivateKey);
      await _secureStorage.write(key: 'nostrPublicKey', value: nostrPublicKey);

      Future.delayed(const Duration(seconds: 1));
    }

    return nostrPublicKey;
  }

  Future<Map<String, dynamic>> _signEvent(
      Map<String, dynamic> eventObject, String nostrPrivateKey) async {
    final eventApi = EventApi();

    if (eventObject['pubkey'] == null) {
      eventObject['pubkey'] = nostrPublicKey;
    }

    List<dynamic> dynamicList = eventObject['tags'];
    List<List<String>> stringList =
        dynamicList.map((innerList) => List<String>.from(innerList)).toList();

    final event = Event(
      content: eventObject['content'],
      created_at: eventObject['created_at'],
      kind: eventObject['kind'],
      pubkey: eventObject['pubkey'],
      tags: stringList,
    );

    if (eventObject['id'] == null || eventObject['id'] == '') {
      event.id = eventApi.getEventHash(event);
      eventObject['id'] = event.id;
    } else {
      event.id = eventObject['id'];
    }

    event.sig = eventApi.signEvent(event, nostrPrivateKey);

    if (eventApi.verifySignature(event)) {
      eventObject['sig'] = event.sig;
    }
    await Future.delayed(const Duration(seconds: 1));

    return eventObject;
  }

  Future<List<String>> _fetchRelays() async {
    await Future.delayed(const Duration(seconds: 1));
    return ['Relay1', 'Relay2', 'Relay3'];
  }

  Future<String> _encryptData(String data, String publicKey) async {
    // Simulating an encryption operation
    await Future.delayed(const Duration(seconds: 1));
    return 'EncryptedData';
  }

  Future<String> _decryptData(String encryptedData, String privateKey) async {
    // Simulating a decryption operation
    await Future.delayed(const Duration(seconds: 1));
    return 'DecryptedData';
  }

  @override
  Future dispose() {
    // _actionsHandler.dispose();
    _publicKeyController.close();
    return super.dispose();
  }
}

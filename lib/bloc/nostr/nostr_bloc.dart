import 'dart:async';

import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/nostr/nostr_actions.dart';
import 'package:breez/bloc/nostr/nostr_model.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/injector.dart';

class NostrBloc with AsyncActionsHandler {
  BreezBridge _breezLib;
  String nostrPublicKey;
  String nostrPrivateKey;

  final defaultRelaysList = [
    "wss://relay.damus.io",
    "wss://nostr1.tunnelsats.com",
    "wss://nostr-pub.wellorder.net",
    "wss://relay.nostr.info",
    "wss://nostr-relay.wlvs.space",
    "wss://nostr.bitcoiner.social",
    "wss://nostr-01.bolt.observer",
    "wss://relayer.fiatjaf.com",
  ];

  FlutterSecureStorage _secureStorage;
  SharedPreferences sharedPreferences;

  NostrBloc() {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    _secureStorage = const FlutterSecureStorage();

    _initNostr();

    registerAsyncHandlers({
      GetPublicKey: _handleGetPublicKey,
      SignEvent: _handleSignEvent,
      GetRelays: _handleGetRelays,
      Nip04Encrypt: _handleNip04Encrypt,
      Nip04Decrypt: _handleNip04Decrypt,
      StoreImportedPrivateKey: _handleStoreImportedPrivateKey,
      DeleteKey: _handleDeleteKey,
      PublishRelays: _handlePublishRelays,
    });
    listenActions();
  }

  void _initNostr() async {
    nostrPublicKey = await _secureStorage.read(key: "nostrPublicKey");
    nostrPrivateKey = await _secureStorage.read(key: "nostrPrivateKey");
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
    // to encrypt the data
    String encryptedData = await _encryptData(action.data, action.publicKey);
    action.resolve(encryptedData);
  }

  Future<void> _handleNip04Decrypt(Nip04Decrypt action) async {
    // to decrypt the data
    String decryptedData =
        await _decryptData(action.encryptedData, action.privateKey);
    action.resolve(decryptedData);
  }

  Future<void> _handleStoreImportedPrivateKey(
      StoreImportedPrivateKey action) async {
    await _breezLib
        .loginWithImportedNostrKey(action.privateKey)
        .catchError((error) {
      throw error.toString();
    });

    action.resolve(true);
  }

  Future<void> _handleDeleteKey(DeleteKey action) async {
    await _secureStorage.delete(key: "nostrPublicKey");
    await _secureStorage.delete(key: "nostrPrivateKey");

    await _breezLib.deleteNostrKey().catchError((error) {
      throw error.toString();
    });

    action.resolve(true);
  }

  // Methods to simulate the actual logic

  Future<String> _fetchPublicKey() async {
    if (nostrPublicKey == null) {
      // check if key pair already exists otherwise generate it
      String nostrKeyPair;

      try {
        nostrKeyPair = await _breezLib.getNostrKeyPair().catchError((error) {
          throw error.toString();
        });
      } catch (e) {
        throw Exception(e);
      }

      int index = nostrKeyPair.indexOf('_');
      nostrPrivateKey = nostrKeyPair.substring(0, index);
      nostrPublicKey = nostrKeyPair.substring(index + 1);

      // Write value
      await _secureStorage.write(
          key: 'nostrPrivateKey', value: nostrPrivateKey);
      await _secureStorage.write(key: 'nostrPublicKey', value: nostrPublicKey);
      // }
      // }

      // need to fetch relays before publishing thems
      _publishRelays(defaultRelaysList);
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

    return eventObject;
  }

  Future<void> _handlePublishRelays(PublishRelays action) async {
    await _publishRelays(action.userRelayList);
    action.resolve(true);
  }

  Future<void> _publishRelays(List<String> userRelayList) async {
    RelayPoolApi relayPool = RelayPoolApi(relaysList: userRelayList);
    Stream<Message> streamConnect = await relayPool.connect();

    // relayPool.on((event) {
    //   if (event == RelayEvent.connect) {
    //     // if relay is connected add this to _isConnectedController
    //   } else if (event == RelayEvent.error || event == RelayEvent.disconnect) {}
    // });
    // relayPool.sub([
    //   Filter(
    //     authors: [nostrPublicKey],
    //     kinds: [3, 10002],
    //   ),
    // ]);
    // streamConnect.listen((message) {
    //   if (message.type == 'EVENT') {
    //     Event event = message.message as Event;
    //   }
    // });

    Event relayPublishEvent = Event(
      content: null,
      kind: 10002,
      created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      tags: [
        ['r', userRelayList[0]],
        ['r', userRelayList[0]],
        ['r', userRelayList[1]],
        ['r', userRelayList[2]],
        ['r', userRelayList[3]],
        ['r', userRelayList[4]],
        ['r', userRelayList[5]],
        ['r', userRelayList[6]],
        ['r', userRelayList[7]],
      ],
      pubkey: nostrPublicKey,
    );

    Map<String, dynamic> eventObject = eventToMap(relayPublishEvent);
    Map<String, dynamic> signedEventObject =
        await _signEvent(eventObject, nostrPrivateKey);

    Event signedNostrEvent = mapToEvent(signedEventObject);
    try {
      relayPool.publish(signedNostrEvent);
    } catch (e) {
      throw Exception(e);
    }
  }

  // this method is created for future use
  Future<List<String>> _fetchRelays() async {
    return ['Relay1', 'Relay2', 'Relay3'];
  }

  // this method is created for future use
  Future<String> _encryptData(String data, String publicKey) async {
    // Simulating an encryption operation

    throw Exception("HandleNip04Encrypt not supported");
  }

  // this method is created for future use
  Future<String> _decryptData(String encryptedData, String privateKey) async {
    // Simulating a decryption operation
    throw Exception("HandleNip04Decrypt not supported");
  }

  @override
  Future dispose() {
    _publicKeyController.close();
    return super.dispose();
  }
}

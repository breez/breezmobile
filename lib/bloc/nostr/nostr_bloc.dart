import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/nostr/nostr_actions.dart';
import 'package:breez/bloc/nostr/nostr_model.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/injector.dart';

class NostrBloc with AsyncActionsHandler {
  BreezBridge _breezLib;
  String nostrPublicKey;
  String _nostrPrivateKey;

  List<String> defaultRelaysList = [];

  SharedPreferences sharedPreferences;
  SharedPreferences pref;

  NostrBloc() {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;

    _initNostr();
    _listenNostrSettings();

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
  final _nostrSettingsController =
      BehaviorSubject<NostrSettings>.seeded(NostrSettings.initial());
  Stream<NostrSettings> get nostrSettingsStream =>
      _nostrSettingsController.stream;
  Sink<NostrSettings> get nostrSettingsSettingsSink =>
      _nostrSettingsController.sink;

  void _initNostr() async {
    pref = await SharedPreferences.getInstance();

    var nostrSettings =
        pref.getString(NostrSettings.NOSTR_SETTINGS_PREFERENCES_KEY);

    if (nostrSettings != null) {
      Map<String, dynamic> settings = json.decode(nostrSettings);
      _nostrSettingsController.add(NostrSettings.fromJson(settings));
    }
  }

  _listenNostrSettings() async {
    pref = await SharedPreferences.getInstance();
    nostrSettingsStream.listen((settings) async {
      pref.setString(NostrSettings.NOSTR_SETTINGS_PREFERENCES_KEY,
          json.encode(settings.toJson()));
    });
  }

  String get nostrPrivateKey => _nostrPrivateKey;

  final StreamController<String> _encryptDataController =
      StreamController<String>.broadcast();
  Stream<String> get encryptDataStream => _encryptDataController.stream;

  final StreamController<String> _decryptDataController =
      StreamController<String>.broadcast();
  Stream<String> get decryptDataStream => _decryptDataController.stream;

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
    Map<String, dynamic> signedEvent = await _signEvent(action.eventObject);

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
    String encryptedData = await _encryptData(
      action.data,
      action.publicKey,
    );
    _encryptDataController.add(encryptedData);
    action.resolve(encryptedData);
  }

  Future<void> _handleNip04Decrypt(Nip04Decrypt action) async {
    // to decrypt the data
    String decryptedData = await _decryptData(
      action.encryptedData,
      action.publicKey,
    );
    _decryptDataController.add(decryptedData);
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
    nostrPublicKey = null;
    _nostrPrivateKey = null;

    await _breezLib.deleteNostrKey().catchError((error) {
      throw error.toString();
    });

    action.resolve(true);
  }

  // Methods to simulate the actual logic

  Future<List<String>> _fetchDefaultRelayList() async {
    pref = await SharedPreferences.getInstance();

    var nostrSettings =
        pref.getString(NostrSettings.NOSTR_SETTINGS_PREFERENCES_KEY);

    if (nostrSettings != null) {
      Map<String, dynamic> settings = json.decode(nostrSettings);
      var nostrSetttingsModel = NostrSettings.fromJson(settings);
      defaultRelaysList = nostrSetttingsModel.relayList;
    }
    return defaultRelaysList;
  }

  Future<String> _fetchPublicKey() async {
    if (nostrPublicKey == null || _nostrPrivateKey == null) {
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
      _nostrPrivateKey = nostrKeyPair.substring(0, index);
      nostrPublicKey = nostrKeyPair.substring(index + 1);

      // publishing the default relayList when creating the account for the first time
      _fetchDefaultRelayList();
      _publishRelays(defaultRelaysList);
    }

    return nostrPublicKey;
  }

  Future<Map<String, dynamic>> _signEvent(
    Map<String, dynamic> eventObject,
  ) async {
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

    event.sig = eventApi.signEvent(event, _nostrPrivateKey);

    if (eventApi.verifySignature(event)) {
      eventObject['sig'] = event.sig;
    }

    return eventObject;
  }

  Future<void> _handlePublishRelays(PublishRelays action) async {
    await _publishRelays(action.userRelayList);
    action.resolve(true);
  }

  List<List<String>> _formRelayPublishEventTagList(List<String> userRelayList) {
    List<List<String>> tagList = [];

    for (int i = 0; i < userRelayList.length; i++) {
      tagList.add(['r', userRelayList[i]]);
    }

    return tagList;
  }

  Future<void> _publishRelays(List<String> userRelayList) async {
    RelayPoolApi relayPool = RelayPoolApi(relaysList: userRelayList);

    List<List<String>> tagList = _formRelayPublishEventTagList(userRelayList);

    Event relayPublishEvent = Event(
      content: null,
      kind: 10002,
      created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      tags: tagList,
      pubkey: nostrPublicKey,
    );

    Map<String, dynamic> eventObject = eventToMap(relayPublishEvent);

    try {
      Map<String, dynamic> signedEventObject = await _signEvent(eventObject);
      Event signedNostrEvent = mapToEvent(signedEventObject);
      relayPool.publish(signedNostrEvent);
    } catch (e) {
      throw Exception(e);
    }
  }

  // this method is created for future use
  Future<List<String>> _fetchRelays() async {
    return ['Relay1', 'Relay2', 'Relay3'];
  }

  Future<String> _encryptData(String data, String publicKey) async {
    // Simulating an encryption operation
    return Nip04().encrypt(_nostrPrivateKey, publicKey, data);
  }

  Future<String> _decryptData(String encryptedData, String publicKey) async {
    // Simulating a decryption operation
    return Nip04().decrypt(_nostrPrivateKey, publicKey, encryptedData);
  }

  @override
  Future dispose() {
    _publicKeyController.close();
    return super.dispose();
  }
}

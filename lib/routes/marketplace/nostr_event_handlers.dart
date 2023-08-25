import 'dart:async';
import 'dart:convert';
import 'dart:convert' as JSON;

import 'package:breez/bloc/nostr/nostr_actions.dart';
import 'package:breez/bloc/nostr/nostr_bloc.dart';
import 'package:breez/bloc/nostr/nostr_model.dart';
import 'package:breez/widgets/nostr_requests_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NostrEventHandler {
  final NostrBloc _nostrBloc;
  final BuildContext context;
  final String appName;
  String nostrPublicKey, nostrPrivateKey;

  NostrEventHandler(this._nostrBloc, this.context, this.appName);

  Future<String> get initNostrProvider =>
      rootBundle.loadString('src/scripts/nostr-provider.js');

  Future<String> handleNostrEventMessage(postMessage) async {
    Map<String, Future<dynamic> Function(Map<String, dynamic> data)>
        nostrHandlersMapping = {
      "getPublicKey": _getPublicKey,
      "signEvent": _signEvent,
      "getRelays": _getRelays,
      "nip04.encrypt": _nip04Encrypt,
      "nip04.decrypt": _nip04Decrypt,
      "nip26.delegate": _nip26Delegate,
    };

    String type = postMessage['type'];
    var id = postMessage['id'];
    var nostrHandler = nostrHandlersMapping[type];

    if (nostrHandler != null) {
      try {
        var result = await nostrHandler(postMessage);
        if (id != null) {
          var resultData = result == null ? null : JSON.jsonEncode(result);
          return "resolveRequest($id, $resultData)";
        }
      } catch (e) {
        return "rejectRequest($id, '${e.toString()}')";
      }
    }
    return null;
  }

  Future<String> _getPublicKey(postMessage) async {
    // getting prompt choice
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final nostrSettings =
        prefs.getString(NostrSettings.NOSTR_SETTINGS_PREFERENCES_KEY);

    Map<String, dynamic> settings = json.decode(nostrSettings);
    var nostrSettingsModel = NostrSettings.fromJson(settings);

    final rememberChoice = nostrSettingsModel.isRememberPubKey;

    if (rememberChoice == false || rememberChoice == null) {
      final shouldReturnPubkey = await _showDialogWhenKeyPairFound();

      if (!shouldReturnPubkey) {
        return "";
      }
    }

    _nostrBloc.actionsSink.add(GetPublicKey());

    return await _nostrBloc.publicKeyStream.first;
  }

  Future<dynamic> _signEvent(postMessage) async {
    final eventData = postMessage['params']['event'];

    final kind = eventData['kind'];
    String messageKind = eventKind[kind];

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final nostrSettings =
        prefs.getString(NostrSettings.NOSTR_SETTINGS_PREFERENCES_KEY);

    Map<String, dynamic> settings = json.decode(nostrSettings);
    var nostrSettingsModel = NostrSettings.fromJson(settings);

    final rememberChoice = nostrSettingsModel.isRememberSignEvent;

    if (rememberChoice == false || rememberChoice == null) {
      final shouldSignEvent = await _showDialogForSignEvent(
          eventData, eventData['content'], messageKind);

      if (!shouldSignEvent) {
        return;
      }
    }

    _nostrBloc.actionsSink.add(SignEvent(eventData));

    return await _nostrBloc.eventStream.first;
  }

  // these functions are not implemented but kept for future use
  Future<List<String>> _getRelays(postMessage) async {
    return Future(() => null);
  }

  Future<String> _nip04Encrypt(postMessage) async {
    _nostrBloc.actionsSink.add(Nip04Encrypt(
        postMessage["params"]["plaintext"], postMessage["params"]["pubkey"]));
    return await _nostrBloc.encryptDataStream.first;
  }

  Future<String> _nip04Decrypt(postMessage) async {
    _nostrBloc.actionsSink.add(Nip04Decrypt(
        postMessage["params"]["ciphertext"], postMessage["params"]["pubkey"]));
    return await _nostrBloc.decryptDataStream.first;
  }

  Future<dynamic> _nip26Delegate(postMessage) async {
    return Future(() => null);
  }

  Future _showDialogForSignEvent(Map<String, dynamic> eventData,
      String eventContent, String messageKind) async {
    String textContent =
        '$appName requires you to sign this $messageKind with your nostr key.';
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NostrRequestsDialog(
            nostrBloc: _nostrBloc,
            appName: appName,
            choiceType: "SignEvent",
            textContent: textContent,
            messageKind: messageKind,
          );
        });
  }

  Future<dynamic> _showDialogWhenKeyPairFound() async {
    String textContent = 'Allow $appName to use your nostr public key.';
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return NostrRequestsDialog(
          nostrBloc: _nostrBloc,
          appName: appName,
          choiceType: "GetPubKey",
          textContent: textContent,
        );
      },
    );
  }
}

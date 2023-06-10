import 'dart:async';

import 'package:breez/bloc/nostr/nostr_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as JSON;

import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/nostr/nostr_actions.dart';
import '../../bloc/nostr/nostr_model.dart';
import '../../widgets/nostr_get_pubKey_dialog.dart';
import '../../widgets/nostr_sign_event_dialog.dart';

class NostrEventHandler {
  final BuildContext context;
  final String appName;
  String nostrPublicKey, nostrPrivateKey;

  final NostrBloc _nostrBloc = NostrBloc();
  NostrEventHandler(this.context, this.appName);

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
    final rememberChoice = prefs.getBool('rememberGetPubKeyChoice');
    if (rememberChoice == false || rememberChoice == null) {
      final shouldReturnPubkey = await _showDialogWhenKeyPairFound();

      if (!shouldReturnPubkey) {
        return "";
      }
    }

    _nostrBloc.actionsSink.add(GetPublicKey());

    final publicKey = await _nostrBloc.publicKeyStream.first;

    return publicKey;
  }

  Future<dynamic> _signEvent(postMessage) async {
    final eventData = postMessage['params']['event'];

    final kind = eventData['kind'];
    String messageKind = eventKind[kind];

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final rememberChoice = prefs.getBool('rememberSignEventChoice');

    if (rememberChoice == false || rememberChoice == null) {
      final shouldSignEvent = await _showDialogForSignEvent(
          eventData, eventData['content'], messageKind);

      if (!shouldSignEvent) {
        return;
      }
    }

    final nostrPrivateKey = _nostrBloc.nostrPrivateKey;

    _nostrBloc.actionsSink.add(SignEvent(eventData, nostrPrivateKey));

    final Map<String, dynamic> signedEventObject =
        await _nostrBloc.eventStream.first;

    return signedEventObject;
  }

  Future<dynamic> _getRelays(postMessage) {
    return Future(() => null);
  }

  Future<dynamic> _nip04Encrypt(postMessage) async {
    return Future(() => null);
  }

  Future<dynamic> _nip04Decrypt(postMessage) async {
    return Future(() => null);
  }

  Future<dynamic> _nip26Delegate(postMessage) async {
    return Future(() => null);
  }

  Future _showDialogForSignEvent(Map<String, dynamic> eventData,
      String eventContent, String messageKind) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NostrSignEventDialog(
            appName: appName,
            eventData: eventData,
            eventContent: eventContent,
            messageKind: messageKind,
          );
        });
  }

  Future<dynamic> _showDialogWhenKeyPairFound() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return NostrGetPublicKeyDialog(
          appName: appName,
        );
      },
    );
  }
}

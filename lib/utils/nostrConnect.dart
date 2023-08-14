import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:breez/bloc/nostr/nostr_actions.dart';
import 'package:breez/bloc/nostr/nostr_bloc.dart';
import 'package:breez/bloc/nostr/nostr_model.dart';
import 'package:flutter/material.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:uuid/uuid.dart';

import '../widgets/nostr_connect_dialog.dart';
import '../widgets/nostr_requests_dialog.dart';

String _nostrConnectProtocolPrefix = "nostrconnect:";

class ConnectUri {
  final String target;
  final String relay;
  final Map<String, dynamic> metadata;
  ConnectUri({
    this.target,
    this.relay,
    this.metadata,
  });
}

// bool isNostrConnect(String url) {
//   var lower = url.toLowerCase();
//   if (lower.startsWith(_nostrConnectProtocolPrefix)) {
//     ConnectUri nostrConnectUri = fromConnectUri(lower);
//     return true;
//   } else {
//     false;
//   }
// }

ConnectUri fromConnectUri(String url) {
  Uri connectUrl = Uri.parse(url);
  final target = connectUrl.host ?? connectUrl.path.substring(2);
  if (target == null) {
    throw Exception("Invalid connect URI: missing target");
  }

  final relay = connectUrl.queryParameters['relay'];
  if (relay == null) {
    throw Exception("Invalid connect URI: missing relay");
  }

  final metadata = connectUrl.queryParameters['metadata'];

  if (metadata == null) {
    throw Exception("Invalid connect URI: missing metadata");
  }
  try {
    Map<String, dynamic> md = jsonDecode(metadata);
    return ConnectUri(
      target: target,
      relay: relay,
      metadata: md,
    );
  } catch (e) {
    throw Exception("Invalid connect URI: metadata is not valid JSON");
  }
}

class NostrRPCRequest {
  String id;
  String method;
  List<dynamic> params;

  NostrRPCRequest({
    this.id,
    this.method,
    this.params,
  });

  factory NostrRPCRequest.fromJson(Map<String, dynamic> json) {
    return NostrRPCRequest(
      id: json['id'] as String,
      method: json['method'] as String,
      params: List<dynamic>.from(json['params'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'method': method,
      'params': params,
    };
  }
}

class NostrRPCResponse {
  String id;
  dynamic result;
  dynamic error;

  NostrRPCResponse({
    this.id,
    this.result,
    this.error,
  });

  factory NostrRPCResponse.fromJson(Map<String, dynamic> json) {
    return NostrRPCResponse(
      id: json['id'] as String,
      result: json['result'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'result': result,
      'error': error,
    };
  }
}

String prepareRequest(String id, String method, List<dynamic> params) {
  Map<String, dynamic> requestMap = {
    'id': id,
    'method': method,
    'params': params,
  };
  return jsonEncode(requestMap);
}

String prepareResponse(String id, dynamic result, dynamic error) {
  Map<String, dynamic> responseMap = {
    'id': id,
    'result': result,
    'error': error,
  };
  return jsonEncode(responseMap);
}

bool isValidRequest(Map<String, dynamic> payload) {
  if (payload == null) {
    return false;
  }

  final keys = payload.keys.toSet();
  if (!keys.contains('id') ||
      !keys.contains('method') ||
      !keys.contains('params')) {
    return false;
  }

  return true;
}

bool isValidResponse(Map<String, dynamic> payload) {
  if (payload == null) {
    return false;
  }

  final keys = payload.keys.toSet();
  if (!keys.contains('id') ||
      !keys.contains('result') ||
      !keys.contains('error')) {
    return false;
  }

  return true;
}

Future<Map<String, dynamic>> prepareEvent(
  String target,
  String request,
  NostrBloc nostrBloc,
) async {
  nostrBloc.actionsSink
      .add(Nip04Encrypt(request, target, nostrBloc.nostrPrivateKey));
  final cipherText = await nostrBloc.encryptDataStream.first;

  Map<String, dynamic> connectEvent = {
    'kind': 24133,
    'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    'tags': [
      ['p', target]
    ],
    'content': cipherText,
  };
  return connectEvent;
}

String getRandomId() {
  Uuid uuid = const Uuid();
  return uuid.v4(); // Generates a random Version 4 UUID
}

Future<Map<String, dynamic>> getPayload(
  String content,
  NostrBloc nostrBloc,
  String target,
) async {
  nostrBloc.actionsSink
      .add(Nip04Decrypt(content, target, nostrBloc.nostrPrivateKey));
  return jsonDecode(await nostrBloc.decryptDataStream.first);
}

class NostrRpc {
  final String relay;
  final Event event;
  final NostrBloc nostrBloc;

  NostrRpc({
    this.relay,
    this.event,
    this.nostrBloc,
  });

  Future<dynamic> call(
    String target, {
    String id,
    String method,
    List<dynamic> params = const [],
  }) async {
    id ??= getRandomId();
    // id = '1';

    // connect to relay
    final relay = RelayApi(relayUrl: this.relay);
    // final relay = RelayApi(relayUrl: "wss://relay.damus.io");
    final stream = await relay.connect();
    relay.on((event) {
      if (event == RelayEvent.connect) {
        print('[+] connected to ${relay.relayUrl}');
      } else if (event == RelayEvent.error) {
        print('[!] failed to connect to ${relay.relayUrl}');
      }
    });

    final request = prepareRequest(id, method, params);
    Map<String, dynamic> event = await prepareEvent(target, request, nostrBloc);
    nostrBloc.actionsSink.add(SignEvent(event, nostrBloc.nostrPrivateKey));

    event = await nostrBloc.eventStream.first;

    relay.sub([
      Filter(
        kinds: [24133],
        authors: [target],
        p: [nostrBloc.nostrPublicKey],
        limit: 1,
      ),
    ]);

    // publish the event
    try {
      relay.publish(mapToEvent(event));
    } catch (e) {
      throw Exception(e);
    }

    return await _listenToResponse(nostrBloc, target, id, stream);
  }

  Future<dynamic> listenRequest() async {
    final relay = RelayApi(relayUrl: this.relay);
  }
}

Future<dynamic> _listenToResponse(
  NostrBloc nostrBloc,
  String target,
  String id,
  Stream<Message> stream,
) async {
  stream.listen((message) {
    try {
      if (message.type == 'EVENT') {
        Event event = message.message as Event;
        // final String payload = jsonEncode(getPayload(event.content, nostrBloc));
        getPayload(event.content, nostrBloc, target).then((payload) {
          // ignore all the events that are not NostrRPCResponse events
          if (!isValidResponse(payload)) return false;

          // ignore all the events that are not for this request
          if (payload['id'] != id) return false;

          // if the response is an error, reject the promise
          if (payload['error'] != null) {
            if (payload['error'] == "this[method] is not a function" &&
                payload['result'] == null) {
              // its a connect request
              nostrBloc.nip47ConnectController.add(target);
            }
            return false;
          }

          if (payload['method'] != null) {
            if (payload['method'] == 'get_public_key') {
            } else if (payload['method'] == 'sign_event') {
            } else if (payload['method'] == 'disconnect') {
            } else if (payload['method'] == 'connect') {}
          }

          // Resolve the promise with the result if available
          // it will be a connection request
          if (payload['result'] != null) {
            return true;
          }
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  });
  return false;
}

approveConnectModal(BuildContext context, ConnectUri nostrConnectUri) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return NostrConnectDialog(
          metadata: nostrConnectUri.metadata,
        );
      });
}

// Future<bool> approveConnectApp(
//     ConnectUri nostrConnectUri, NostrBloc nostrBloc) async {
//   final rpc = NostrRpc(relay: nostrConnectUri.relay, nostrBloc: nostrBloc);
//   await rpc.call(nostrConnectUri.target,
//       method: 'connect', params: [nostrBloc.nostrPublicKey]);
// }

Future<void> rejectConnectApp(
    ConnectUri nostrConnectUri, NostrBloc nostrBloc) async {
  final rpc = NostrRpc(relay: nostrConnectUri.relay, nostrBloc: nostrBloc);
  bool connect =
      await rpc.call(nostrConnectUri.target, method: 'disconnect', params: []);
}

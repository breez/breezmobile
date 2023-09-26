import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/nostr/nostr_actions.dart';
import 'package:breez/bloc/nostr/nostr_bloc.dart';
import 'package:breez/bloc/nostr/nostr_model.dart';
import 'package:breez/widgets/nostr_connect_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:uuid/uuid.dart';

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
  nostrBloc.actionsSink.add(Nip04Encrypt(request, target));
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
  nostrBloc.actionsSink.add(Nip04Decrypt(content, target));
  return jsonDecode(await nostrBloc.decryptDataStream.first);
}

Future<List<String>> _describe() async {
  return ["describe", "get_public_key", "sign_event"];
}

Future<Map<String, dynamic>> _signEvent(
    List<dynamic> event, NostrBloc nostrBloc) async {
  Map<String, dynamic> requestEvent = event[0];
  nostrBloc.actionsSink.add(SignEvent(requestEvent));
  Map<String, dynamic> signedEvent = await nostrBloc.eventStream.first;
  return signedEvent;
}

Future<Map<String, dynamic>> _handleRequest(
  Map<String, dynamic> payload,
  Event event,
  NostrBloc nostrBloc,
) async {
  // now handle the request according to the method called and return a response

  // handle describe method , get_public_key , sign_event
  var result;
  switch (payload['method']) {
    case "describe":
      result = _describe();
      break;
    case "get_public_key":
      result = nostrBloc.nostrPublicKey;
      break;
    case "sign_event":
      result = await _signEvent(payload['params'], nostrBloc);
      break;
    // case "disconnect":
    //   result = _disconnect();
    //   break;
    // case "connnect":
    //   result = _connect();
    //   break;
  }
  return {
    'id': payload['id'],
    'result': result,
    'error': null,
  };
}

class NostrRpc {
  final String relay;
  final Event event;
  final NostrBloc nostrBloc;
  RelayApi relayConnect;
  NostrRpc({
    this.relay,
    this.event,
    this.nostrBloc,
    this.relayConnect,
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
    relayConnect = RelayApi(relayUrl: relay);
    // final relay = RelayApi(relayUrl: "wss://relay.damus.io");
    final stream = await relayConnect.connect();
    relayConnect.on((event) {
      if (event == RelayEvent.connect) {
        // print('[+] connected to ${relay.relayUrl}');
      } else if (event == RelayEvent.error) {
        // print('[!] failed to connect to ${relay.relayUrl}');
      }
    });

    final request = prepareRequest(id, method, params);
    Map<String, dynamic> event = await prepareEvent(target, request, nostrBloc);
    nostrBloc.actionsSink.add(SignEvent(event));

    event = await nostrBloc.eventStream.first;

    relayConnect.sub([
      Filter(
        kinds: [24133],
        authors: [target],
        p: [nostrBloc.nostrPublicKey],
        limit: 1,
        since: DateTime.now().minute,
      ),
    ]);

    // publish the event
    try {
      relayConnect.publish(mapToEvent(event));
    } catch (e) {
      throw Exception(e);
    }

    return await _listen(nostrBloc, target, id, method, stream);
  }

  // Future<dynamic> listenToRequest(
  //   NostrBloc nostrBloc,
  // ) async {
  //   final relayConnect = RelayApi(relayUrl: relay);

  //   final stream = await relayConnect.connect();

  //   relayConnect.sub([
  //     Filter(
  //       kinds: [24133],
  //       p: [nostrBloc.nostrPublicKey],
  //       limit: 1,
  //       since: DateTime.now() as int,
  //     ),
  //   ]);

  //   stream.listen((message) {
  //     try {
  //       if (message.type == 'EVENT') {
  //         Event event = message.message as Event;
  //         getPayload(event.content, nostrBloc, event.pubkey)
  //             .then((payload) async {
  //           // ignore all the events that are not NostrRPCResponse events
  //           if (!isValidRequest(payload)) return false;

  //           Map<String, dynamic> response =
  //               await _handleRequest(payload, event, nostrBloc);

  //           String responseString = prepareResponse(
  //               response['id'], response['result'], response['error']);

  //           Map<String, dynamic> responseEvent =
  //               await prepareEvent(event.pubkey, responseString, nostrBloc);
  //           nostrBloc.actionsSink
  //               .add(SignEvent(responseEvent, nostrBloc.nostrPrivateKey));
  //           responseEvent = await nostrBloc.eventStream.first;

  //           try {
  //             relayConnect.publish(mapToEvent(responseEvent));
  //           } catch (e) {
  //             throw Exception(e);
  //           }

  //           // switch (payload['method']) {
  //           //   case "get_public_key":
  //           //     return _getPublicKey();
  //           //   case "sign_event":
  //           //     return _signEvent();
  //           //   case "disconnect":
  //           //     return _disconnect();
  //           //   case "connnect":
  //           //     return _connect();
  //           // }

  //           // if (payload['method'] == 'get_public_key') {
  //           // } else if (payload['method'] == 'sign_event') {
  //           // } else if (payload['method'] == 'disconnect') {
  //           // } else if (payload['method'] == 'connect') {}
  //         });
  //       }
  //     } catch (e) {
  //       throw Exception(e);
  //     }
  //   });
  // }

  Future<dynamic> _listen(
    NostrBloc nostrBloc,
    String target,
    String id,
    String method,
    Stream<Message> stream,
  ) async {
    stream.listen((message) {
      try {
        if (message.type == 'EVENT') {
          Event event = message.message as Event;
          getPayload(event.content, nostrBloc, target).then((payload) async {
            // ignore all the events that are not NostrRPCResponse events
            if (isValidResponse(payload)) {
              // ignore all the events that are not for this response
              if (payload['id'] != id) return false;

              // if the response is an error, reject the promise
              if (payload['error'] != null) {
                if (payload['error'] == "this[method] is not a function" &&
                    payload['result'] == null) {
                  // its a connect request
                  if (method == 'connect') {
                    nostrBloc.nip47ConnectController.add(target);
                  } else if (method == 'disconnect') {
                    nostrBloc.nip47DisconnectController.add(target);
                  }
                }
                return false;
              }
            } else if (isValidRequest(payload)) {
              Map<String, dynamic> response =
                  await _handleRequest(payload, event, nostrBloc);

              String responseString = prepareResponse(
                  response['id'], response['result'], response['error']);

              Map<String, dynamic> responseEvent =
                  await prepareEvent(event.pubkey, responseString, nostrBloc);
              nostrBloc.actionsSink.add(SignEvent(responseEvent));
              responseEvent = await nostrBloc.eventStream.first;

              try {
                relayConnect.publish(mapToEvent(responseEvent));
              } catch (e) {
                throw Exception(e);
              }
            }
          });
        }
      } catch (e) {
        throw Exception(e);
      }
    });
    return false;
  }
}

approveConnectDialog(BuildContext context, ConnectUri nostrConnectUri) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return NostrConnectDialog(
          connect: true,
          metadata: nostrConnectUri.metadata,
        );
      });
}

approveDisconnectDialog(BuildContext context, ConnectUri nostrConnectUri) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return NostrConnectDialog(
          connect: false,
          metadata: nostrConnectUri.metadata,
        );
      });
}

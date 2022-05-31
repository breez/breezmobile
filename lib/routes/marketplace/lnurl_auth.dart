import 'dart:convert';

import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_model.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> handleLNUrlAuth(BuildContext context, {VendorModel vendor}) async {
  final LNUrlBloc lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);
  final texts = context.texts();
  Uri endpointURI = Uri.parse(vendor.endpointURI);
  var response = vendor.id == "lnmarkets" ? await http.post(endpointURI) : await http.get(endpointURI);

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(texts.lnurl_webview_error_message(vendor.displayName));
  }
  Map<String, dynamic> decoded = json.decode(response.body);
  String lnUrl = decoded[vendor.responseID] as String;
  Fetch fetchAction = Fetch(lnUrl);
  lnurlBloc.actionsSink.add(fetchAction);
  var fetchResponse = await fetchAction.future;
  if (fetchResponse.runtimeType != AuthFetchResponse) {
    throw texts.lnurl_webview_error_invalid_url;
  }
  AuthFetchResponse authResponse = fetchResponse as AuthFetchResponse;
  var action = Login(authResponse, jwt: true);
  lnurlBloc.actionsSink.add(action);
  return await action.future;
}

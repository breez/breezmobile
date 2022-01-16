
import 'dart:convert';

import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_model.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:http/http.dart' as http;

Future<String> handleLNUrlAuth(VendorModel vendor, LNUrlBloc lnurlBloc, String responsdID) async {
    Uri uri = Uri.parse(vendor.url); 
    var response = await http.get(uri);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to call ${vendor.displayName} API");
    }
    Map<String, dynamic> decoded = json.decode(response.body);
    String lnUrl = decoded[responsdID] as String;
    Fetch fetchAction = Fetch(lnUrl);
    lnurlBloc.actionsSink.add(fetchAction);
    var fetchResponse = await fetchAction.future;
    if (fetchResponse.runtimeType != AuthFetchResponse) {
      throw "Invalid URL";
    }
    AuthFetchResponse authResponse = fetchResponse as AuthFetchResponse;
    var action = Login(authResponse, jwt: true);
    lnurlBloc.actionsSink.add(action);
    return await action.future;    
  }
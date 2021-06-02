import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_model.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/routes/marketplace/vendor_webview.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LNMarketsWebViewPage extends StatefulWidget {
  final AccountBloc accountBloc;
  final LNUrlBloc lnurlBloc;
  final VendorModel lnMarketModel;

  const LNMarketsWebViewPage(
      {Key key, this.accountBloc, this.lnMarketModel, this.lnurlBloc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LNMarketsWebViewPageState();
  }
}

class LNMarketsWebViewPageState extends State<LNMarketsWebViewPage> {
  String jwtToken;

  @override
  void initState() {
    super.initState();
    _handleLNUrlAuth().catchError(
        (err) => promptError(context, "Error", Text(err.toString())));
  }

  Future _handleLNUrlAuth() async {
    Uri uri = Uri.https("api.lnmarkets.com", "lnurl/a/c");
    var response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception("Failed to call LN Markets API");
    }
    Map<String, dynamic> decoded = json.decode(response.body);
    String lnurl = decoded["lnurl"] as String;
    Fetch fetchAction = Fetch(lnurl);
    widget.lnurlBloc.actionsSink.add(fetchAction);
    var fetchResponse = await fetchAction.future;
    if (fetchResponse.runtimeType != AuthFetchResponse) {
      throw "Invalid URL";
    }
    AuthFetchResponse authResponse = fetchResponse as AuthFetchResponse;

    var action = Login(authResponse, jwt: true);
    widget.lnurlBloc.actionsSink.add(action);
    String jwt = await action.future;
    if (this.mounted) {
      setState(() {
        jwtToken = jwt;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (jwtToken == null) {
      return Material(child: Loader());
    }
    return VendorWebViewPage(
        widget.accountBloc,
        widget.lnMarketModel.url + "?token=$jwtToken",
        widget.lnMarketModel.displayName);
  }
}

import 'dart:convert';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_model.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/routes/marketplace/vendor_webview.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:breez_translations/breez_translations_locales.dart';

class LNURLWebViewPage extends StatefulWidget {
  final AccountBloc accountBloc;
  final VendorModel vendorModel;
  final LNUrlBloc lnurlBloc;
  final Uri endpointURI;
  final String responseID;

  const LNURLWebViewPage({
    Key key,
    this.accountBloc,
    this.vendorModel,
    this.lnurlBloc,
    this.endpointURI,
    this.responseID,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LNURLWebViewPageState();
  }
}

class LNURLWebViewPageState extends State<LNURLWebViewPage> {
  String jwtToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleLNUrlAuth().catchError(
            (err) => promptError(
          context,
          BreezTranslations.of(context).lnurl_webview_error_title,
          Text(err.toString()),
          okFunc: () => Navigator.of(context).pop(),
        ),
      );
    });
  }

  Future _handleLNUrlAuth() async {
    final texts = context.texts();
    Uri uri = widget.endpointURI;
    var response = widget.vendorModel.id == "lnmarkets"
        ? await http.post(uri)
        : await http.get(uri);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        texts.lnurl_webview_error_message(widget.vendorModel.displayName),
      );
    }
    Map<String, dynamic> decoded = json.decode(response.body);
    String lnUrl = decoded[widget.responseID] as String;
    Fetch fetchAction = Fetch(lnUrl);
    widget.lnurlBloc.actionsSink.add(fetchAction);
    var fetchResponse = await fetchAction.future;
    if (fetchResponse.runtimeType != AuthFetchResponse) {
      throw texts.lnurl_webview_error_invalid_url;
    }
    AuthFetchResponse authResponse = fetchResponse as AuthFetchResponse;
    var action = Login(authResponse, jwt: true);
    widget.lnurlBloc.actionsSink.add(action);
    String jwt = await action.future;
    if (mounted) {
      setState(() => jwtToken = jwt);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (jwtToken == null) {
      return const Material(child: Loader());
    }
    return VendorWebViewPage(
      widget.accountBloc,
      "${widget.vendorModel.url}?token=$jwtToken",
      widget.vendorModel.displayName,
    );
  }
}

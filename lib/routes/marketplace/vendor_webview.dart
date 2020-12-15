import 'dart:convert' as JSON;
import 'dart:io';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'webln_handlers.dart';

class VendorWebViewPage extends StatefulWidget {
  final AccountBloc accountBloc;
  final String _url;
  final String _title;

  VendorWebViewPage(
    this.accountBloc,
    this._url,
    this._title,
  );

  @override
  State<StatefulWidget> createState() {
    return VendorWebViewPageState();
  }
}

class VendorWebViewPageState extends State<VendorWebViewPage> {
  WeblnHandlers _weblnHandlers;
  InvoiceBloc _invoiceBloc;
  bool _isInit = false;

  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
      _weblnHandlers = WeblnHandlers(context, widget.accountBloc, _invoiceBloc);

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _weblnHandlers?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () => Navigator.pop(context))
        ],
        automaticallyImplyLeading: false,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          widget._title,
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        elevation: 0.0,
      ),
      body: Listener(
        onPointerDown: (_) {
          // hide keyboard on click
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: WebView(
            onWebViewCreated: (WebViewController webViewController) {
              setState(() {
                _webViewController = webViewController;
              });
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: <JavascriptChannel>[
              _breezJavascriptChannel(context),
            ].toSet(),
            onPageFinished: (String url) async {
              // intercept ln link clicks
              _webViewController.evaluateJavascript(await rootBundle
                  .loadString('src/scripts/lightningLinkInterceptor.js'));
              // redirect post messages to javascript channel
              _webViewController.evaluateJavascript(
                  "window.onmessage = (message) => window.BreezWebView.postMessage(message.data);");
              _webViewController
                  .evaluateJavascript(await _weblnHandlers.initWeblnScript);
              print('Page finished loading: $url');
            },
            initialUrl: widget._url),
      ),
    );
  }

  JavascriptChannel _breezJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: "BreezWebView",
      onMessageReceived: (JavascriptMessage message) {
        if (message != null) {
          var postMessage = (widget._title == "ln.pizza")
              ? {"action": "sendPayment", "payReq": message.message}
              : JSON.jsonDecode(message.message);
          // handle lightning links and WebLN payments
          if (postMessage["lightningLink"] != null &&
              postMessage["lightningLink"]
                  .toLowerCase()
                  .startsWith("lightning:")) {
            _invoiceBloc.newLightningLinkSink
                .add(postMessage["lightningLink"].substring(10));
          } else {
            _weblnHandlers.handleMessage(postMessage).then((resScript) {
              if (resScript != null) {
                _webViewController.evaluateJavascript(resScript);
              }
            });
          }
        }
      },
    );
  }
}

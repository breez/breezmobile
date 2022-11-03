import 'dart:convert' as JSON;

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';
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
  WebLNHandlers _weblnHandlers;
  InvoiceBloc _invoiceBloc;
  bool _isInit = false;

  WebViewController _webViewController;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
      _weblnHandlers = WebLNHandlers(context, widget.accountBloc, _invoiceBloc);

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget._title),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () => Navigator.pop(context))
        ],
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
            navigationDelegate: (NavigationRequest request) =>
                _handleNavigationRequest(request),
            onPageFinished: (String url) async {
              // intercept ln link clicks
              _webViewController.runJavascript(await rootBundle
                  .loadString('src/scripts/lightningLinkInterceptor.js'));
              // redirect post messages to javascript channel
              _webViewController.runJavascript(
                  'window.onmessage = (message) => window.BreezWebView.postMessage(message.data);');
              _webViewController
                  .runJavascript(await _weblnHandlers.initWebLNScript);
              print('Page finished loading: $url');
            },
            initialUrl: widget._url),
      ),
    );
  }

  _handleNavigationRequest(NavigationRequest request) {
    if (request.url.startsWith('lightning:')) {
      return NavigationDecision.prevent;
    } else if (request.url.startsWith('tg:') || request.url.startsWith('fold:')) {
      launchUrlString(request.url);
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
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
                _webViewController.runJavascript(resScript);
              }
            });
          }
        }
      },
    );
  }
}

import 'dart:convert' as JSON;

import 'package:breez/utils/webview_controller_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LSPWebViewPage extends StatefulWidget {
  final String _url;
  final String _title;

  const LSPWebViewPage(
    this._url,
    this._title,
  );

  @override
  State<StatefulWidget> createState() {
    return LSPWebViewPageState();
  }
}

class LSPWebViewPageState extends State<LSPWebViewPage> {
  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = setWebViewController(
      url: widget._url,
      onPageFinished: _onPageFinished,
      onMessageReceived: _onMessageReceived,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget._title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: WebViewWidget(controller: _webViewController),
    );
  }

  void _onPageFinished(String url) async {
    // redirect post messages to javascript channel
    _webViewController.runJavaScript(
        'window.onmessage = (message) => window.BreezWebView.postMessage(message.data);');
    _webViewController.runJavaScript(
        await rootBundle.loadString('src/scripts/lightningLinkInterceptor.js'));
  }

  void _onMessageReceived(JavaScriptMessage message) {
    if (message != null) {
      var decodedMsg = JSON.jsonDecode(message.message);
      String lightningLink = decodedMsg["lightningLink"];
      if (lightningLink != null &&
          lightningLink.toLowerCase().startsWith("lightning:lnurl")) {
        Navigator.pop(context, lightningLink.substring(10));
      }
    }
  }
}

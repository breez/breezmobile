import 'dart:convert' as JSON;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LSPWebViewPage extends StatefulWidget {
  final String _url;
  final String _title;

  LSPWebViewPage(
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
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: WebView(
        initialUrl: widget._url,
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
        request.url.startsWith('lightning:')
            ? NavigationDecision.prevent
            : NavigationDecision.navigate,
        onPageFinished: (String url) async {
          // redirect post messages to javascript channel
          _webViewController.evaluateJavascript(
              "window.onmessage = (message) => window.BreezWebView.postMessage(message.data);");
          _webViewController.evaluateJavascript(await rootBundle
              .loadString('src/scripts/lightningLinkInterceptor.js'));
        },
      ),
    );
  }

  JavascriptChannel _breezJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: "BreezWebView",
      onMessageReceived: (JavascriptMessage message) {
        if (message != null) {
          var decodedMsg = JSON.jsonDecode(message.message);
          String lightningLink = decodedMsg["lightningLink"];
          if (lightningLink != null &&
              lightningLink.toLowerCase().startsWith("lightning:lnurl")) {
            Navigator.pop(context, lightningLink.substring(10));
          }
        }
      },
    );
  }
}

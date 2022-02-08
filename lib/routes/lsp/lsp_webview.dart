import 'dart:convert' as JSON;

import 'package:breez/utils/build_context.dart';
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
    ThemeData theme = context.theme;
    IconThemeData iconTheme = theme.iconTheme;
    AppBarTheme appBarTheme = theme.appBarTheme;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
                color: iconTheme.color,
              ),
              onPressed: () => context.pop())
        ],
        automaticallyImplyLeading: false,
        iconTheme: appBarTheme.iconTheme,
        backgroundColor: theme.canvasColor,
        toolbarTextStyle: appBarTheme.toolbarTextStyle,
        titleTextStyle: appBarTheme.titleTextStyle,
        title: Text(widget._title),
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
          _webViewController.runJavascript(
              "window.onmessage = (message) => window.BreezWebView.postMessage(message.data);");
          _webViewController.runJavascript(await rootBundle
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
            context.pop(lightningLink.substring(10));
          }
        }
      },
    );
  }
}

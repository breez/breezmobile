import 'dart:async';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BitrefillPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BitrefillPageState();
  }
}

class BitrefillPageState extends State<BitrefillPage> {
  final Completer<WebViewController> _webViewController =
      Completer<WebViewController>();
  String _bgColor = 'yellow';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: theme.appBarIconTheme,
        textTheme: theme.appBarTextTheme,
        backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
        title: new Text(
          "Bitrefill Widget",
          style: theme.appBarTextStyle,
        ),
        elevation: 0.0,
      ),
      body: Center(
        child: WebView(
          initialUrl: "https://cdn.bitrefill.com/refill-widget.html",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController.complete(webViewController);
          },
        ),
      ),
      floatingActionButton: getCurrentURL(),
    );
  }

  Widget getCurrentURL() {
    return FutureBuilder<WebViewController>(
        future: _webViewController.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              onPressed: () async {
                final String url = await controller.data.currentUrl();
                final String result = await controller.data.evaluateJavascript(
                    "document.body.style.backgroundColor = '$_bgColor'");
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          "Current Page URL: $url and Background is set to $result")),
                );
              },
              child: const Icon(
                Icons.link,
                color: Colors.white,
              ),
              backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
            );
          }
          return Container();
        });
  }
}

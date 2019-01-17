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
  String _bgColor = 'blue';

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
          initialUrl: "file:////data/user/0/com.breez.client/cache/breezmobileAYKCXO/breezmobile/build/flutter_assets/src/web/index.html",
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
                // Use intents
                // Show Soft Keyboard
                //((InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE)).toggleSoftInput(InputMethodManager.SHOW_FORCED, InputMethodManager.HIDE_IMPLICIT_ONLY);
                // Hide Soft Keyboard
                //((InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE)).hideSoftInputFromWindow(_pay_box_helper.getWindowToken(), 0);
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

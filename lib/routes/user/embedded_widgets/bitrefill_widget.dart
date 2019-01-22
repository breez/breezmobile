import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';

const _platform = const MethodChannel('com.breez.client/nfc');

class MyInAppBrowser extends InAppBrowser {
  @override
  void onBrowserCreated() async {
    print("\n\nBrowser Ready!\n\n");
  }

  @override
  void onLoadStart(String url) {
    print("\n\nStarted $url\n\n");
  }

  @override
  Future onLoadStop(String url) async {
    print("\n\nStopped $url\n\n");

    // call a javascript message handler
    await this.webViewController.injectScriptCode("""
    window.flutter_inappbrowser.callHandler('orderHandler', '{"orderId":"5c47a7730dd0de00040a63e5","uri":"lightning:lnbc774u1pwy0fmnpp5x9c0zejf6y4mff0hrz4s9gaw5j4zjd45hu4rcw4llu5j4ngfnnpqdphgf5hgun9ve5kcmpqx43ngdmpxumnxvryvscxgefsxqcrgvrpxcek2dgcqzysxqr8pqfppjg7ewweksfn7fhtup90jcjwtw5p6llcn007w6w9vsn0r85h2urr02ysqd8j0afxk7vpv2ta8yvtj4hma0ndwj62usmn025z8qu0sfuwpvsjlk29k8h26w2c4wx2zxrkprvvd5qvsq7qkanx"}');
    window.addEventListener("message", receiveMessage, false);

    function receiveMessage(event) {
      console.log(event.data);
      window.flutter_inappbrowser.callHandler('orderHandler', event.data);
    }
        
    """);

    // add jquery library and custom javascript
    this.webViewController.injectScriptCode("""
      
    """);

    // add custom css
    this.webViewController.injectStyleCode("""       
    
    """);
  }

  @override
  void onLoadError(String url, int code, String message) {
    print("\n\nCan't load $url.. Error: $message\n\n");
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }

  @override
  void shouldOverrideUrlLoading(String url) {
    print("\n\n override $url\n\n");
    this.webViewController.loadUrl(url);
  }

  @override
  void onLoadResource(
      WebResourceResponse response, WebResourceRequest request) {
    print("Started at: " +
        response.startTime.toString() +
        "ms ---> duration: " +
        response.duration.toString() +
        "ms " +
        response.url);
  }

  @override
  void onConsoleMessage(ConsoleMessage consoleMessage) {
    print("""
    console output:
      sourceURL: ${consoleMessage.sourceURL}
      lineNumber: ${consoleMessage.lineNumber}
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel}
    """);
  }
}

MyInAppBrowser inAppBrowser = new MyInAppBrowser();

class BitrefillPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BitrefillPageState();
  }
}

class BitrefillPageState extends State<BitrefillPage> {
  @override
  void initState() {
    super.initState();
    inAppBrowser.webViewController.addJavaScriptHandler("orderHandler", (arguments) async {
      var response = jsonDecode(arguments.elementAt(0).toString());
      var orderId = response['orderId'];
      var uri = response['uri'];
      print('orderId: $orderId');
      print('uri: $uri');
    });
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
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
      body: StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return StaticLoader();
          }
          var account = snapshot.data;
          return new Center(
            child: new RaisedButton(
                onPressed: () async {
                  await inAppBrowser.open(
                      url:
                          'https://www.bitrefill.com/embed/lightning/?apiKey=&hideQr',
                      options: {
                        "javaScriptEnabled": true,
                        "hideUrlBar": true,
                        "hideTitleBar": true,
                        "supportZoom": false,
                        "closeOnCannotGoBack": false
                      });
                },
                child: Text(
                    "Account Balance: ${account.currency.format(account.balance)}")),
          );
        },
      ),
    );
  }
}

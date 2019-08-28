import 'dart:async';
import 'dart:convert' as JSON;

import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/moonpay_order.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MoonpayWebView extends StatefulWidget {
  final String _url;
  final String redirectURL;
  final String walletAddress;
  final AddFundsBloc addFundsBloc;

  MoonpayWebView(this._url, {this.redirectURL, this.walletAddress, this.addFundsBloc});

  @override
  State<StatefulWidget> createState() {
    return new MoonpayWebViewState();
  }
}

class MoonpayWebViewState extends State<MoonpayWebView> {
  final _widgetWebview = new FlutterWebviewPlugin();
  StreamSubscription _postMessageListener;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _widgetWebview.onDestroy.listen((_) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      String loadedURL;
      _widgetWebview.onStateChanged.listen((state) async {
        if (state.type == WebViewState.finishLoad && loadedURL != state.url) {
          loadedURL = state.url;
          var script = "function getParameterByName(name) {    \n" +
              "    name = name.replace(/[\\[\\]]/g, '\\\\\$&');\n" +
              "    var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|\$)'),\n" +
              "        results = regex.exec(window.location.href);\n" +
              "    if (!results) return null;\n" +
              "    if (!results[2]) return '';\n" +
              "    return decodeURIComponent(results[2].replace(/\\+/g, ' '));\n" +
              "}\n" +
              "\n" +
              "var alertInterval = setInterval(function () {\n" +
              "    if (document.URL.indexOf(\"${widget.redirectURL}\") >= 0 && getParameterByName('transactionId') != null && getParameterByName('addFunds') == 'true') {\n" +
              "        window.postMessage(JSON.stringify({ status: 'completed'}), \"*\");\n" +
              "        clearInterval(alertInterval);\n" +
              "    }\n" +
              "}, 50);";
          _widgetWebview.evalJavascript(script);
        }
      });
      _postMessageListener = _widgetWebview.onPostMessage.listen((msg) {
        if (msg != null) {
          var postMessage = JSON.jsonDecode(msg);
          if (postMessage['status'] == "completed") {
            widget.addFundsBloc.orderSink.add(MoonpayOrder(widget.walletAddress, DateTime.now().millisecondsSinceEpoch));
          }
        }
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _postMessageListener?.cancel();
    _widgetWebview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      appBar: new AppBar(
        actions: <Widget>[IconButton(icon: new Icon(Icons.close), onPressed: () => Navigator.pop(context))],
        automaticallyImplyLeading: false,
        iconTheme: theme.appBarIconTheme,
        textTheme: theme.appBarTextTheme,
        backgroundColor: theme.BreezColors.blue[500],
        title: new Text(
          "MoonPay",
          style: theme.appBarTextStyle,
        ),
        elevation: 0.0,
      ),
      url: widget._url,
      withJavascript: true,
      withZoom: false,
      clearCache: true,
    );
  }
}

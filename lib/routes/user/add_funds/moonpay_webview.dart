import 'dart:async';
import 'dart:convert' as JSON;

import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/moonpay_order.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MoonpayWebView extends StatefulWidget {
  final String _url;
  final String walletAddress;
  final AddFundsBloc addFundsBloc;

  MoonpayWebView(this._url, {this.walletAddress, this.addFundsBloc});

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
      _widgetWebview.onStateChanged.listen((state) async {
        if (state.type == WebViewState.finishLoad) {
          _widgetWebview.evalJavascript(await rootBundle.loadString('src/scripts/moonpay.js'));
        }
      });
      _postMessageListener = _widgetWebview.onPostMessage.listen((msg) {
        if (msg != null) {
          var postMessage = JSON.jsonDecode(msg);
          if (postMessage['status'] == "completed") {
            widget.addFundsBloc.moonPayOrderSink.add(MoonpayOrder(widget.walletAddress, DateTime.now().millisecondsSinceEpoch));
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

import 'dart:async';
import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/loader.dart';

class VendorWebViewPage extends StatefulWidget {
  final String _url;
  final String _title;

  VendorWebViewPage(this._url, this._title);

  @override
  State<StatefulWidget> createState() {
    return new VendorWebViewPageState();
  }
}

class VendorWebViewPageState extends State<VendorWebViewPage> {
  final _widgetWebview = new FlutterWebviewPlugin();
  InvoiceBloc invoiceBloc;
  StreamSubscription _postMessageListener;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _widgetWebview.onStateChanged.listen((state) async {
      if (state.type == WebViewState.finishLoad) {
        String script =
            'window.addEventListener("message", receiveMessage, false);' +
                'function receiveMessage(event) {Android.getPostMessage(event.data);}';
        _widgetWebview.evalJavascript(script);
      }
    });

    _widgetWebview.onDestroy.listen((_) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
      _postMessageListener = _widgetWebview.onPostMessage.listen((postMessage) {
        if (postMessage != null) {
          final order = JSON.jsonDecode(postMessage);
          invoiceBloc.newLightningLinkSink.add(order['uri']);
          _widgetWebview.hide();
          Navigator.of(context).pushNamed("/home");
        }
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _postMessageListener.cancel();
    _widgetWebview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      appBar: new AppBar(
        leading: backBtn.BackButton(),
        automaticallyImplyLeading: false,
        iconTheme: theme.appBarIconTheme,
        textTheme: theme.appBarTextTheme,
        backgroundColor: theme.BreezColors.blue[500],
        title: new Text(
          widget._title,
          style: theme.appBarTextStyle,
        ),
        elevation: 0.0,
      ),
      url: widget._url,
      withJavascript: true,
      withZoom: false,
    );
  }
}

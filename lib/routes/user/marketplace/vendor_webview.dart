import 'dart:async';
import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/loader.dart';

class VendorWebViewPage extends StatefulWidget {
  final AccountBloc accountBloc;
  final String _url;
  final String _title;

  VendorWebViewPage(this.accountBloc, this._url, this._title);

  @override
  State<StatefulWidget> createState() {
    return new VendorWebViewPageState();
  }
}

class VendorWebViewPageState extends State<VendorWebViewPage> {
  final _widgetWebview = new FlutterWebviewPlugin();

  AccountSettings _accountSettings;
  StreamSubscription<AccountSettings> _accountSettingsSubscription;
  StreamSubscription<CompletedPayment> _sentPaymentResultSubscription;

  InvoiceBloc invoiceBloc;
  StreamSubscription _postMessageListener;
  bool _isInit = false;

  Uint8List _screenshotData;

  @override
  void initState() {
    super.initState();
    _listenPaymentsResults();
    _widgetWebview.onDestroy.listen((_) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }

  _listenPaymentsResults() {
    _accountSettingsSubscription = widget.accountBloc.accountSettingsStream.listen((settings) => _accountSettings = settings);

    _sentPaymentResultSubscription = widget.accountBloc.completedPaymentsStream.listen((payment) {
      // If user cancels or fulfills the payment show Webview again.
      _widgetWebview.show();
      setState(() {
        _screenshotData = null;
      });
    }, onError: (_) {
      Navigator.popUntil(context, (route) {
        return route.settings.name == "/home" || route.settings.name == "/";
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
      _postMessageListener = _widgetWebview.onPostMessage.listen((postMessage) {
        if (postMessage != null) {
          final order = JSON.jsonDecode(postMessage);
          if (order.containsKey("uri")) {
            // Hide keyboard
            FocusScope.of(context).requestFocus(FocusNode());
            // Wait for keyboard and screen animations to settle
            Timer(Duration(milliseconds: 750), () {
              // Take screenshot and show payment request dialog
              _takeScreenshot().then((imageData) {
                setState(() {
                  _screenshotData = imageData;
                });
                // Wait for memory image to load
                Timer(Duration(milliseconds: 200), () {
                  // Hide Webview to interact with payment request dialog
                  _widgetWebview.hide();
                  invoiceBloc.newLightningLinkSink.add(order['uri']);
                });
              });
            });
          }
        }
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _accountSettingsSubscription.cancel();
    _sentPaymentResultSubscription.cancel();
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
      initialChild: _screenshotData != null ? Image.memory(_screenshotData) : null,
    );
  }

  Future _takeScreenshot() async {
    Uint8List _imageData = await _widgetWebview.takeScreenshot();
    return _imageData;
  }
}

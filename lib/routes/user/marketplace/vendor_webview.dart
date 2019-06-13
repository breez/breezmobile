import 'dart:async';
import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
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
            invoiceBloc.newLightningLinkSink.add(order['uri']);
            Navigator.popUntil(context, (route) {
              return route.settings.name == "/home" || route.settings.name == "/";
            });
            /* TODO: Instead of going to the home page:
             * Hide Webview to show payment request dialog,
             * If user cancels the payment, destroy Webview and go back to Marketplace page,
             * If the payment is successful, show Webview again.
             */
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
    );
  }
}

import 'dart:async';
import 'dart:convert' as JSON;

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/moonpay_order.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MoonpayWebView extends StatefulWidget {
  final BreezUserModel _user;
  final AccountBloc _accountBloc;

  MoonpayWebView(this._user, this._accountBloc);

  @override
  State<StatefulWidget> createState() {
    return new MoonpayWebViewState();
  }
}

class MoonpayWebViewState extends State<MoonpayWebView> {
  final _widgetWebview = new FlutterWebviewPlugin();
  StreamSubscription _postMessageListener;
  StreamSubscription<AccountModel> _accountSubscription;
  StreamSubscription<String> _urlSubscription;
  AddFundsBloc _addFundsBloc;

  String walletAddress = "";
  String _moonPayURL = "";

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _addFundsBloc = new AddFundsBloc(widget._user.userID);
    _accountSubscription = widget._accountBloc.accountStream.listen((acc) {
      if (!acc.bootstraping) {
        _addFundsBloc.addFundRequestSink.add(null);
        _accountSubscription.cancel();
      }
    });
    _urlSubscription = _addFundsBloc.moonPayUrlStream.listen((moonPayURL) {
      setState(() {
        _moonPayURL = moonPayURL;
      });
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
      _widgetWebview.onStateChanged.listen((state) async {
        if (state.type == WebViewState.finishLoad) {
          _widgetWebview.evalJavascript(await rootBundle.loadString('src/scripts/moonpay.js'));
        }
      });
      _postMessageListener = _widgetWebview.onPostMessage.listen((msg) {
        if (msg != null) {
          var postMessage = JSON.jsonDecode(msg);
          if (postMessage['status'] == "completed") {
            _addFundsBloc.moonPayOrderSink.add(MoonpayOrder(walletAddress, DateTime.now().millisecondsSinceEpoch));
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
    _accountSubscription.cancel();
    _urlSubscription.cancel();
    _widgetWebview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _addFundsBloc.addFundResponseStream,
      builder: (BuildContext context, AsyncSnapshot<AddFundResponse> snapshot) {
        walletAddress = "n4VQ5YdHf7hLQ2gWQYYrcxoE5B7nWuDFNF"; // Will switch to snapshot?.address when we use public apiKey
        _moonPayURL += "&walletAddress=$walletAddress";
        if (snapshot.data != null) {
          String maxQuoteCurrencyAmount = Currency.BTC.format(snapshot.data?.maxAllowedDeposit, includeSymbol: false, fixedDecimals: false);
          _moonPayURL += "&maxQuoteCurrencyAmount=$maxQuoteCurrencyAmount";
        }
        return WebviewScaffold(
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
          url: _moonPayURL,
          withJavascript: true,
          withZoom: false,
          clearCache: true,
        );
      },
    );
  }
}

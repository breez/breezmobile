import 'dart:async';
import 'dart:convert' as JSON;
import 'dart:typed_data';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/moonpay_order.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MoonpayWebView extends StatefulWidget {
  final BreezUserModel _user;
  final AccountBloc _accountBloc;
  final BackupBloc _backupBloc;

  MoonpayWebView(this._user, this._accountBloc, this._backupBloc);

  @override
  State<StatefulWidget> createState() {
    return new MoonpayWebViewState();
  }
}

class MoonpayWebViewState extends State<MoonpayWebView> {
  final _widgetWebview = new FlutterWebviewPlugin();
  StreamSubscription _postMessageListener;
  StreamSubscription<bool> _backupPromptVisibilitySubscription;
  StreamSubscription<BreezUserModel> _userSubscription;
  AddFundsBloc _addFundsBloc;

  String walletAddress = "";
  Uint8List _screenshotData;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _addFundsBloc = new AddFundsBloc(widget._user.userID);
    widget._accountBloc.accountStream.first.then((acc) {
      if (!acc.bootstraping) {
        _addFundsBloc.addFundRequestSink.add(null);
      }
    });
    _backupPromptVisibilitySubscription = widget._backupBloc.backupPromptVisibleStream.listen((isVisible) {
      _hideWebview(isVisible);
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
      UserProfileBloc userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      _userSubscription = userBloc.userStream.listen((user) {
        _hideWebview(user.locked);
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _postMessageListener?.cancel();
    _userSubscription.cancel();
    _backupPromptVisibilitySubscription.cancel();
    _widgetWebview.dispose();
    super.dispose();
  }

  _hideWebview(bool hide) {
    if (hide) {
      _moveWebviewToBackground();
    } else {
      _widgetWebview.show();
      setState(() {
        _screenshotData = null;
      });
    }
  }

  Future _moveWebviewToBackground() {
    if (_screenshotData != null) {
      return Future.value(null);
    }

    Completer beforeCompleter = Completer();
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
          beforeCompleter.complete();
        });
      });
    });

    return beforeCompleter.future;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _addFundsBloc.addFundResponseStream,
      builder: (BuildContext context, AsyncSnapshot<AddFundResponse> response) {
        if (!response.hasData) {
          return _buildLoadingScreen(response);
        }

        return StreamBuilder(
          stream: _addFundsBloc.availableVendorsStream,
          builder: (BuildContext context, AsyncSnapshot<AddFundVendorModel> vendor) {
            if (!vendor.hasData) {
              return _buildLoadingScreen(response);
            }
            walletAddress = "n4VQ5YdHf7hLQ2gWQYYrcxoE5B7nWuDFNF"; // Will switch to response?.address when we use public apiKey
            String maxQuoteCurrencyAmount =
                Currency.BTC.format(response.data?.maxAllowedDeposit, includeSymbol: false, fixedDecimals: false);
            String moonPayURL = vendor.data.url;
            moonPayURL += "&walletAddress=$walletAddress&maxQuoteCurrencyAmount=$maxQuoteCurrencyAmount";
            return WebviewScaffold(
              appBar: AppBar(
                actions: <Widget>[IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context))],
                automaticallyImplyLeading: false,
                iconTheme: theme.appBarIconTheme,
                textTheme: theme.appBarTextTheme,
                backgroundColor: theme.BreezColors.blue[500],
                title: Text(
                  "MoonPay",
                  style: theme.appBarTextStyle,
                ),
                elevation: 0.0,
              ),
              url: moonPayURL,
              withJavascript: true,
              withZoom: false,
              clearCache: true,
              initialChild: _screenshotData != null ? Image.memory(_screenshotData) : null,
            );
          },
        );
      },
    );
  }

  Future _takeScreenshot() async {
    Uint8List _imageData = await _widgetWebview.takeScreenshot();
    return _imageData;
  }

  Widget _buildLoadingScreen(AsyncSnapshot<AddFundResponse> response) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context))],
            automaticallyImplyLeading: false,
            iconTheme: theme.appBarIconTheme,
            textTheme: theme.appBarTextTheme,
            backgroundColor: theme.BreezColors.blue[500],
            title: Text(
              "MoonPay",
              style: theme.appBarTextStyle,
            ),
            elevation: 0.0,
          ),
          body: response.hasError
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
                      child: Text(
                        "Failed to retrieve an address from Breez server\nPlease check your internet connection.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              : Center(child: Loader(color: theme.BreezColors.white[400]))),
    );
  }
}

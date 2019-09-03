import 'dart:async';
import 'dart:convert' as JSON;
import 'dart:typed_data';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/moonpay_order.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MoonpayWebView extends StatefulWidget {  
  final AccountBloc _accountBloc;
  final BackupBloc _backupBloc;  

  MoonpayWebView(this._accountBloc, this._backupBloc);

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
  Uint8List _screenshotData;
  MoonpayOrder _order;
  String _error;
  bool _isInit = false;

  @override
  void didChangeDependencies() {    
    if (!_isInit) {
      _addFundsBloc = BlocProvider.of<AddFundsBloc>(context); 
      _addFundsBloc.addFundRequestSink.add(false);

      _backupPromptVisibilitySubscription = widget._backupBloc.backupPromptVisibleStream.listen((isVisible) {
        _hideWebview(isVisible);
      });

      _addFundsBloc.moonpayNextOrderStream.first
        .then((order) => setState(() => _order = order))
        .catchError((err) => setState(() => _error = err.toString()));

      _widgetWebview.onDestroy.listen((_) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      });

      widget._accountBloc.accountStream.firstWhere((acc) => !acc.bootstraping).then((acc) {
        if (this.mounted) {
          _addFundsBloc.addFundRequestSink.add(true);
        }
      });

      _widgetWebview.onStateChanged.listen((state) async {
        if (state.type == WebViewState.finishLoad) {
          _widgetWebview.evalJavascript(await rootBundle.loadString('src/scripts/moonpay.js'));
        }
      });
      _postMessageListener = _widgetWebview.onPostMessage.listen((msg) {
        if (msg != null) {
          var postMessage = JSON.jsonDecode(msg);
          if (postMessage['status'] == "completed") {
            _addFundsBloc.completedMoonpayOrderSink.add(_order.copyWith(orderTimestamp: DateTime.now().millisecondsSinceEpoch));            
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
    if (_order == null || _error != null) {
      return _buildLoadingScreen();
    }

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
      url: _order.url,
      withJavascript: true,
      withZoom: false,
      clearCache: false,
      initialChild: _screenshotData != null ? Image.memory(_screenshotData) : null,
    );    
  }

  Future _takeScreenshot() async {
    Uint8List _imageData = await _widgetWebview.takeScreenshot();
    return _imageData;
  }

  Widget _buildLoadingScreen() {
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
          body: _error != null
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

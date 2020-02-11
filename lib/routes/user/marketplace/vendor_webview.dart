import 'dart:async';
import 'dart:convert' as JSON;
import 'dart:typed_data';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/user/marketplace/webln_handlers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class VendorWebViewPage extends StatefulWidget {
  final AccountBloc accountBloc;
  final String _url;
  final String _title;

  VendorWebViewPage(
    this.accountBloc,
    this._url,
    this._title,
  );

  @override
  State<StatefulWidget> createState() {
    return VendorWebViewPageState();
  }
}

class VendorWebViewPageState extends State<VendorWebViewPage> {
  final _widgetWebview = FlutterWebviewPlugin();
  StreamSubscription<BreezUserModel> _userSubscription;
  StreamSubscription _postMessageListener;
  WeblnHandlers _weblnHandlers;
  bool _isInit = false;
  Uint8List _screenshotData;

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
      var invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
      var accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      var userBloc = AppBlocsProvider.of<UserProfileBloc>(context);

      _weblnHandlers =
          WeblnHandlers(context, accountBloc, invoiceBloc, onBeforeCallHandler);

      String loadedURL;
      _widgetWebview.onStateChanged.listen((state) async {
        if (state.type == WebViewState.finishLoad && loadedURL != state.url) {
          loadedURL = state.url;
          _widgetWebview.evalJavascript(await _weblnHandlers.initWeblnScript);
        }
      });

      _postMessageListener = _widgetWebview.onPostMessage.listen((msg) {
        if (msg != null) {
          var postMessage = (widget._title == "ln.pizza")
              ? {"action": "sendPayment", "payReq": msg}
              : JSON.jsonDecode(msg);
          _weblnHandlers.handleMessage(postMessage).then((resScript) {
            if (resScript != null) {
              _widgetWebview.evalJavascript(resScript);
              _widgetWebview.show();
              setState(() {
                _screenshotData = null;
              });
            }
          });
        }
      });

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
    _widgetWebview.dispose();
    _weblnHandlers?.dispose();
    _userSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () => Navigator.pop(context))
        ],
        automaticallyImplyLeading: false,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          widget._title,
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
        elevation: 0.0,
      ),
      url: widget._url,
      withJavascript: true,
      withZoom: false,
      clearCache: true,
      initialChild:
          _screenshotData != null ? Image.memory(_screenshotData) : null,
    );
  }

  _hideWebview(bool hide) {
    if (hide) {
      onBeforeCallHandler("lockScreen");
    } else {
      _widgetWebview.show();
      setState(() {
        _screenshotData = null;
      });
    }
  }

  Future onBeforeCallHandler(String handlerName) {
    if (_screenshotData != null ||
        !["makeInvoice", "sendPayment", "lockScreen"].contains(handlerName)) {
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

  Future _takeScreenshot() async {
    Uint8List _imageData = await _widgetWebview.takeScreenshot();
    return _imageData;
  }
}

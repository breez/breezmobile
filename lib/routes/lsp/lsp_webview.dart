import 'dart:async';
import 'dart:convert' as JSON;
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class LSPWebViewPage extends StatefulWidget {
  final AccountBloc accountBloc;
  final String _url;
  final String _title;

  LSPWebViewPage(
    this.accountBloc,
    this._url,
    this._title,
  );

  @override
  State<StatefulWidget> createState() {
    return LSPWebViewPageState();
  }
}

class LSPWebViewPageState extends State<LSPWebViewPage> {
  final _widgetWebview = FlutterWebviewPlugin();
  StreamSubscription<BreezUserModel> _userSubscription;
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
      var userBloc = AppBlocsProvider.of<UserProfileBloc>(context);

      String loadedURL;
      _widgetWebview.onStateChanged.listen((state) async {
        if (state.type == WebViewState.finishLoad && loadedURL != state.url) {
          loadedURL = state.url;
          _widgetWebview.evalJavascript(await rootBundle
              .loadString('src/scripts/lightningLinkInterceptor.js'));
        }
      });

      _userSubscription = userBloc.userStream.listen((user) {
        _hideWebview(user.locked);
      });

      _postMessageListener = _widgetWebview.onPostMessage.listen((msg) {
        if (msg != null) {
          var decodedMsg = JSON.jsonDecode(msg);
          String lightningLink = decodedMsg["lightningLink"];
          if (lightningLink != null &&
              lightningLink.toLowerCase().startsWith("lightning:lnurl")) {
            Navigator.pop(context, lightningLink.substring(10));
          }
        }
      });

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _widgetWebview.dispose();
    _userSubscription?.cancel();
    _postMessageListener?.cancel();
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
      enableAppScheme: true,
      withZoom: false,
      clearCache: true,
      initialChild: null,
    );
  }

  _hideWebview(bool hide) {
    if (hide) {
      _widgetWebview.hide();
    } else {
      _widgetWebview.show();
    }
  }
}

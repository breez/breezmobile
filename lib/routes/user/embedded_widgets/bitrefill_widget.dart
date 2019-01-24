import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/services.dart';

class BitrefillPage extends StatefulWidget {
  final String _title = "Bitrefill";

  @override
  State<StatefulWidget> createState() {
    return new BitrefillPageState();
  }
}

class BitrefillPageState extends State<BitrefillPage> {
  //static const _platform = const MethodChannel('flutter_webview_plugin');
  final widgetWebview = new FlutterWebviewPlugin();


  @override
  void initState() {
    super.initState();
    /*
    _platform.setMethodCallHandler((call) {
      if (call.method == "FlutterJSInterface.parseStringToJSONObject") {
        print("Callback works!");
      }
      if (call.method == "parseStringToJSONObject") {
        print("Callback works!!");
      }
    });
    */

    widgetWebview.onStateChanged.listen((state) async {
      if (state.type == WebViewState.finishLoad) {
        String script = 'window.addEventListener("message", receiveMessage, false);' +
            'function receiveMessage(event) {FlutterJSInterface.parseStringToJSONObject(event.data);}';
        widgetWebview.evalJavascript(script);
      }
    });
    //Todo: Set variable to post message

    widgetWebview.onDestroy.listen((_) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widgetWebview.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return StaticLoader();
          }
          var account = snapshot.data;
          print('Account balance: ${account.currency.format(account.balance)}');
          // set widgets userAccountBalance option to account.balance
          return new WebviewScaffold(
            appBar: new AppBar(
              leading: backBtn.BackButton(),
              automaticallyImplyLeading: false,
              iconTheme: theme.appBarIconTheme,
              textTheme: theme.appBarTextTheme,
              backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
              title: new Text(
                widget._title,
                style: theme.appBarTextStyle,
              ),
              elevation: 0.0,
            ),
            url: 'https://www.bitrefill.com/embed/lightning/?apiKey=&hideQr',
            withJavascript: true,
            withZoom: false,
          );
        });
  }
}

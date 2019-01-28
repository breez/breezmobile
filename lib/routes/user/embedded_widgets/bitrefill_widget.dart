import 'dart:async';
import 'package:ini/ini.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;

class BitrefillPage extends StatefulWidget {
  final String _title = "Bitrefill";

  @override
  State<StatefulWidget> createState() {
    return new BitrefillPageState();
  }
}

class BitrefillPageState extends State<BitrefillPage> {
  final _widgetWebview = new FlutterWebviewPlugin();
  String _lightningLink;
  var _apiKey = "";

  @override
  void initState() {
    super.initState();
    _lightningLink = null;

    _widgetWebview.lightningLinkStream.listen((value) {
      final order = JSON.jsonDecode(value);
      setState(() {
        _lightningLink = order['uri'];
        _widgetWebview.hide();
        Navigator.of(context).pushNamed('/home');
      });
    });

    _getApiKey();
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _widgetWebview.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    if (_lightningLink != null) {
      invoiceBloc.newLightningLinkSink.add(_lightningLink);
    }
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
      url: 'https://www.bitrefill.com/embed/lightning/?apiKey=$_apiKey&hideQr',
      withJavascript: true,
      withZoom: false,
    );
  }

  Future _getApiKey() async {
    String configString = await rootBundle.loadString('conf/breez.conf');
    Config config = Config.fromString(configString);
    setState(() {
      _apiKey = config.get("Application Options", "bitrefillapikey");
    });
  }
}

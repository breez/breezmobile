import 'dart:convert' as JSON;
import 'dart:io';

import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/moonpay_order.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChannels, rootBundle;
import 'package:webview_flutter/webview_flutter.dart';

import 'conditional_deposit.dart';

class MoonpayWebView extends StatefulWidget {
  MoonpayWebView();

  @override
  State<StatefulWidget> createState() {
    return MoonpayWebViewState();
  }
}

class MoonpayWebViewState extends State<MoonpayWebView> {
  WebViewController _webViewController;
  AddFundsBloc _addFundsBloc;
  MoonpayOrder _order;
  String _error;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
      _addFundsBloc.addFundRequestSink.add(false);

      _addFundsBloc.moonpayNextOrderStream.first
          .then((order) => setState(() => _order = order))
          .catchError((err) => setState(() => _error = err.toString()));

      _addFundsBloc.addFundRequestSink.add(true);

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalDeposit(
        title: "MoonPay", enabledChild: _buildWebView(context));
  }

  Widget _buildWebView(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon:
                    Icon(Icons.close, color: Theme.of(context).iconTheme.color),
                onPressed: () => Navigator.pop(context))
          ],
          automaticallyImplyLeading: false,
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          title: Text(
            "MoonPay",
            style: Theme.of(context).appBarTheme.textTheme.headline6,
          ),
          elevation: 0.0,
        ),
        body: (_order == null || _error != null)
            ? _buildLoadingScreen()
            : Listener(
                onPointerDown: (_) {
                  // hide keyboard on click
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                },
                child: WebView(
                  initialUrl: _order.url,
                  onWebViewCreated: (WebViewController webViewController) {
                    setState(() {
                      _webViewController = webViewController;
                    });
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  javascriptChannels: <JavascriptChannel>[
                    _breezJavascriptChannel(context),
                  ].toSet(),
                  navigationDelegate: (NavigationRequest request) =>
                  request.url.startsWith('lightning:')
                      ? NavigationDecision.prevent
                      : NavigationDecision.navigate,
                  onPageFinished: (String url) async {
                    // redirect post messages to javascript channel
                    _webViewController.evaluateJavascript(
                        "window.onmessage = (message) => window.BreezWebView.postMessage(message.data);");
                    _webViewController.evaluateJavascript(
                        await rootBundle.loadString('src/scripts/moonpay.js'));
                  },
                ),
              ),
      ),
    );
  }

  JavascriptChannel _breezJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: "BreezWebView",
      onMessageReceived: (JavascriptMessage message) {
        if (message != null) {
          var postMessage = JSON.jsonDecode(message.message);
          if (postMessage['status'] == "completed") {
            _addFundsBloc.completedMoonpayOrderSink.add(_order.copyWith(
                orderTimestamp: DateTime.now().millisecondsSinceEpoch));
          }
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return _error != null
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
        : Center(
            child: Loader(color: theme.BreezColors.white[400]),
          );
  }
}

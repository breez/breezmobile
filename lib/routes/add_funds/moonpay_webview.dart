import 'dart:convert' as JSON;

import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/add_funds_model.dart';
import 'package:breez/bloc/account/moonpay_order.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChannels, rootBundle;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'conditional_deposit.dart';

class MoonpayWebView extends StatefulWidget {
  const MoonpayWebView();

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
  void didChangeDependencies() {
    if (!_isInit) {
      _addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
      _addFundsBloc.addFundRequestSink.add(AddFundsInfo(false, false));

      _addFundsBloc.moonpayNextOrderStream.first
          .then((order) => setState(() => _order = order))
          .catchError((err) => setState(() => _error = err.toString()));

      _addFundsBloc.addFundRequestSink.add(AddFundsInfo(true, false));

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return ConditionalDeposit(
      title: texts.add_funds_moonpay_title,
      enabledChild: _buildWebView(context),
    );
  }

  Widget _buildWebView(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return Material(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                Icons.close,
                color: themeData.iconTheme.color,
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
          automaticallyImplyLeading: false,
          iconTheme: themeData.appBarTheme.iconTheme,
          textTheme: themeData.appBarTheme.textTheme,
          backgroundColor: themeData.canvasColor,
          title: Text(
            texts.add_funds_moonpay_title,
            style: themeData.appBarTheme.textTheme.headline6,
          ),
          elevation: 0.0,
        ),
        body: (_order == null || _error != null)
            ? _buildLoadingScreen(context)
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
                      "window.onmessage = (message) => window.BreezWebView.postMessage(message.data);",
                    );
                    _webViewController.evaluateJavascript(
                      await rootBundle.loadString('src/scripts/moonpay.js'),
                    );
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
            _addFundsBloc.completedMoonpayOrderSink.add(
              _order.copyWith(
                orderTimestamp: DateTime.now().millisecondsSinceEpoch,
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return _error != null
        ? Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 50.0,
                  left: 30.0,
                  right: 30.0,
                ),
                child: Text(
                  texts.add_funds_moonpay_error_address,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        : Center(
            child: Loader(
              color: theme.BreezColors.white[400],
            ),
          );
  }
}

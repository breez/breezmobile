import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;

class VendorWebViewPage extends StatefulWidget {
  final String _url;
  final String _title;

  VendorWebViewPage(this._url, this._title);

  @override
  State<StatefulWidget> createState() {
    return new VendorWebViewPageState();
  }
}

class VendorWebViewPageState extends State<VendorWebViewPage> {    
  WebViewController _controller;
  String channelScript;

  @override
  void initState() {
    super.initState();
    channelScript = "if (!window.breezReceiveMessage) {" +
                    "window.breezReceiveMessage = function(event) {_breezWallet.postMessage(event.data);};" +
                    "window.addEventListener('message', window.breezReceiveMessage, false);" +
                "}";    
  }

  @override
  Widget build(BuildContext context) {    
    var invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    return new Scaffold(
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
      body:Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: widget._url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller){
            _controller = controller;
          },  
          onPageFinished: (url) async {
            _controller.evaluateJavascript(channelScript);            
          },
          javascriptChannels: <JavascriptChannel>[
            JavascriptChannel(
              name: '_breezWallet',
              onMessageReceived: (JavascriptMessage message) {                
                Map decodedMsg = json.decode(message.message);
                invoiceBloc.newLightningLinkSink.add(decodedMsg['uri'].toString());                    
              })
          ].toSet(),        
        );
      }),     
    );
  }
}

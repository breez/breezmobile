import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeScannerPlaceholder extends StatefulWidget {
  final InvoiceBloc invoiceBloc;

  BarcodeScannerPlaceholder(this.invoiceBloc);

  @override
  State<StatefulWidget> createState() {
    return BarcodeScannerPlaceholderState();
  }
}

class BarcodeScannerPlaceholderState extends State<BarcodeScannerPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context).copyWith(backgroundColor: Colors.red, primaryColor: Colors.yellow, canvasColor: Colors.grey),
      home: Scaffold(
        appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: theme.BreezColors.blue[500],
          title: GestureDetector(
            onTap: () {
              Clipboard.getData("text/plain").then((clipboardData) {
                if (clipboardData != null) {
                  widget.invoiceBloc.decodeInvoiceSink.add(clipboardData.text);
                  Navigator.pop(context);
                }
              });
            },
            child: Row(children: <Widget>[
              Icon(Icons.content_paste),
              Padding(padding: EdgeInsets.only(left: 8.0)),
              Text(
                "PASTE INVOICE",
                style: TextStyle(fontSize: 14.0, letterSpacing: 0.15, fontWeight: FontWeight.w500),
              )
            ]),
          ),
          elevation: 0.0,
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(style: theme.alertStyle.copyWith(color: Colors.white), text: "Please grant Breez ", children: <TextSpan>[
                TextSpan(
                  text: "access to your camera",
                  style: TextStyle(color: Colors.blue),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () async {
                      bool isOpened = await PermissionHandler().openAppSettings();
                      if (isOpened) Navigator.pop(context);
                    },
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

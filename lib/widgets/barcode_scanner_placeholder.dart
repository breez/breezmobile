import 'package:app_settings/app_settings.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/l10n/locales.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';

class BarcodeScannerPlaceholder extends StatefulWidget {
  final InvoiceBloc invoiceBloc;
  final GlobalKey firstPaymentItemKey;

  BarcodeScannerPlaceholder(this.invoiceBloc, this.firstPaymentItemKey);

  @override
  State<StatefulWidget> createState() {
    return BarcodeScannerPlaceholderState();
  }
}

class BarcodeScannerPlaceholderState extends State<BarcodeScannerPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context).copyWith(
          backgroundColor: Colors.red,
          primaryColor: Colors.yellow,
          canvasColor: Colors.grey),
      localizationsDelegates: localizationsDelegates(),
      supportedLocales: supportedLocales(),
      home: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          leading: backBtn.BackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0.0,
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "For QR scan, please grant Breez access to your camera.",
                  style:
                      Theme.of(context).dialogTheme.contentTextStyle.copyWith(
                            color: Colors.white,
                          ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: theme.BreezColors.white[500],
                    elevation: 0.0,
                    shape: const StadiumBorder(),
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: 8.0, right: 12.0, left: 12.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.settings,
                        color: theme.buttonStyle.color,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                      ),
                      Text(
                        "App Settings",
                        style: theme.buttonStyle,
                      )
                    ],
                  ),
                  onPressed: () async {
                    AppSettings.openAppSettings();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

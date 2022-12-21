import 'package:app_settings/app_settings.dart';
import 'package:clovrlabs_wallet/bloc/invoice/invoice_bloc.dart';
import 'package:clovrlabs_wallet/l10n/locales.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BarcodeScannerPlaceholder extends StatelessWidget {
  final InvoiceBloc invoiceBloc;
  final GlobalKey firstPaymentItemKey;

  const BarcodeScannerPlaceholder(
    this.invoiceBloc,
    this.firstPaymentItemKey,
  );

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    return MaterialApp(
      theme: themeData.copyWith(
        backgroundColor: Colors.red,
        primaryColor: Colors.yellow,
        canvasColor: Colors.grey,
      ),
      localizationsDelegates: localizationsDelegates(),
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: themeData.appBarTheme.iconTheme,
          textTheme: themeData.appBarTheme.textTheme,
          backgroundColor: themeData.canvasColor,
          leading: backBtn.BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  texts.barcode_scanner_camera_message,
                  style: themeData.dialogTheme.contentTextStyle.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: theme.ClovrLabsWalletColors.white[500],
                    elevation: 0.0,
                    shape: const StadiumBorder(),
                    padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.settings,
                        color: theme.buttonStyle.color,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                      ),
                      Text(
                        texts.barcode_scanner_app_settings,
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

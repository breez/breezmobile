import 'package:anytime/l10n/L.dart';
import 'package:app_settings/app_settings.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/l10n/locales.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

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
    final texts = context.texts();

    return MaterialApp(
      theme: themeData.copyWith(
        colorScheme: themeData.colorScheme.copyWith(background: Colors.red),
        primaryColor: Colors.yellow,
        canvasColor: Colors.grey,
      ),
      localizationsDelegates: localizationsDelegates().toList()..addAll([
        const LocalisationsDelegate(),
        const AnytimeFallbackLocalizationDelegate(),
      ]),
      supportedLocales: supportedLocales(),
      home: Scaffold(
        appBar: AppBar(
          leading: const backBtn.BackButton(),
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.BreezColors.white[500],
                    elevation: 0.0,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.settings,
                        color: theme.buttonStyle.color,
                      ),
                      const Padding(
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

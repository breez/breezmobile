import 'package:app_settings/app_settings.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';

class BarcodeScannerPlaceholder extends StatelessWidget {
  final InvoiceBloc invoiceBloc;
  final GlobalKey firstPaymentItemKey;

  const BarcodeScannerPlaceholder(
    this.invoiceBloc,
    this.firstPaymentItemKey,
  );

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    ThemeData themeData = context.theme;
    AppBarTheme appBarTheme = themeData.appBarTheme;
    DialogTheme dialogTheme = themeData.dialogTheme;

    return MaterialApp(
      theme: themeData.copyWith(
        backgroundColor: Colors.red,
        primaryColor: Colors.yellow,
        canvasColor: Colors.grey,
      ),
      localizationsDelegates: context.localizationsDelegates(),
      supportedLocales: context.supportedLocales(),
      home: Scaffold(
        appBar: AppBar(
          iconTheme: appBarTheme.iconTheme,
          toolbarTextStyle: appBarTheme.toolbarTextStyle,
          titleTextStyle: appBarTheme.titleTextStyle,
          backgroundColor: themeData.canvasColor,
          leading: backBtn.BackButton(
            onPressed: () => context.pop(),
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
                  l10n.barcode_scanner_camera_message,
                  style: dialogTheme.contentTextStyle
                      .copyWith(color: Colors.white),
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
                        l10n.barcode_scanner_app_settings,
                        style: theme.buttonStyle,
                      )
                    ],
                  ),
                  onPressed: () async {
                    AppSettings.openAppSettings();
                    context.pop();
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

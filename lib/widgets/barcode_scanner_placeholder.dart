import 'dart:async';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/handlers/lnurl_handler.dart';
import 'package:breez/routes/add_funds/fastbitcoins_page.dart';
import 'package:breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:breez/routes/withdraw_funds/reverse_swap_page.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/bip21.dart';
import 'package:breez/utils/btc_address.dart';
import 'package:breez/utils/fastbitcoin.dart';
import 'package:breez/utils/node_id.dart';
import 'package:breez/widgets/route.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../logger.dart';
import 'error_dialog.dart';
import 'flushbar.dart';
import 'loader.dart';

const FORMAT_UNKNOWN = -1;

class BarcodeScannerPlaceholder extends StatefulWidget {
  final AccountModel accountModel;
  final InvoiceBloc invoiceBloc;
  final GlobalKey firstPaymentItemKey;

  BarcodeScannerPlaceholder(
      this.accountModel, this.invoiceBloc, this.firstPaymentItemKey);

  @override
  State<StatefulWidget> createState() {
    return BarcodeScannerPlaceholderState();
  }
}

class BarcodeScannerPlaceholderState extends State<BarcodeScannerPlaceholder> {
  @override
  Widget build(BuildContext context) {
    LNUrlBloc lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);

    return MaterialApp(
      theme: Theme.of(context).copyWith(
          backgroundColor: Colors.red,
          primaryColor: Colors.yellow,
          canvasColor: Colors.grey),
      home: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          title: GestureDetector(
            onTap: () {
              // Open gallery and pick image
              ImagePicker.pickImage(source: ImageSource.gallery)
                  .then((pickedImage) async {
                if (pickedImage != null) {
                  // Detect barcode on selected image
                  final FirebaseVisionImage visionImage =
                      FirebaseVisionImage.fromFile(pickedImage);
                  final BarcodeDetector barcodeDetector =
                      FirebaseVision.instance.barcodeDetector();
                  final List<Barcode> barcodes =
                      await barcodeDetector.detectInImage(visionImage);
                  barcodeDetector.close();
                  if (barcodes.isNotEmpty) {
                    for (Barcode barcode in barcodes) {
                      // Handle barcode found on selected image
                      final String scannedString = barcode.rawValue;
                      if (scannedString != null) {
                        if (barcode.format.value == FORMAT_UNKNOWN ||
                            scannedString.isEmpty) {
                          Navigator.pop(context);
                          showFlushbar(context,
                              message: "QR code wasn't detected.");
                          return;
                        }
                        String lower = scannedString.toLowerCase();

                        // lnurl string
                        if (lower.startsWith("lightning:lnurl") ||
                            lower.startsWith("lnurl")) {
                          await _handleLNUrl(lnurlBloc, context, scannedString);
                          return;
                        }

                        // bip 121
                        String lnInvoice = extractBolt11FromBip21(lower);
                        if (lnInvoice != null) {
                          lower = lnInvoice;
                        }

                        // regular lightning invoice.
                        if (lower.startsWith("lightning:") ||
                            lower.startsWith("ln")) {
                          widget.invoiceBloc.decodeInvoiceSink
                              .add(scannedString);
                          return;
                        }

                        // fast bitcoin
                        if (isFastBitcoinURL(lower)) {
                          Navigator.of(context).push(FadeInRoute(
                            builder: (_) =>
                                FastbitcoinsPage(fastBitcoinUrl: lower),
                          ));
                          return;
                        }

                        // bitcoin
                        BTCAddressInfo btcInvoice =
                            parseBTCAddress(scannedString);

                        if (await _isBTCAddress(btcInvoice.address)) {
                          String requestAmount;
                          if (btcInvoice.satAmount != null) {
                            requestAmount = widget.accountModel.currency.format(
                                btcInvoice.satAmount,
                                userInput: true,
                                includeDisplayName: false,
                                removeTrailingZeros: true);
                          }
                          Navigator.of(context).push(FadeInRoute(
                            builder: (_) => ReverseSwapPage(
                                userAddress: btcInvoice.address,
                                requestAmount: requestAmount),
                          ));
                          return;
                        }
                        var nodeID = parseNodeId(scannedString);
                        if (nodeID != null) {
                          Navigator.of(context).push(FadeInRoute(
                            builder: (_) => SpontaneousPaymentPage(
                                nodeID, widget.firstPaymentItemKey),
                          ));
                          return;
                        }
                        Navigator.pop(context);
                        showFlushbar(context,
                            message: "QR code cannot be processed.");
                      }
                    }
                  } else {
                    Navigator.pop(context);
                    showFlushbar(context, message: "QR code wasn't detected.");
                  }
                }
              }).catchError((err) {
                log.severe(err.toString());
              });
            },
            child: Row(children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 8.0)),
              Text(
                "SELECT IMAGE",
                style: TextStyle(
                    fontSize: 14.0,
                    letterSpacing: 0.15,
                    fontWeight: FontWeight.w500),
              )
            ]),
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
                RaisedButton(
                  padding: EdgeInsets.only(
                      top: 8.0, bottom: 8.0, right: 12.0, left: 12.0),
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
                  color: theme.BreezColors.white[500],
                  elevation: 0.0,
                  shape: const StadiumBorder(),
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

Future<bool> _isBTCAddress(String scannedString) {
  return ServiceInjector()
      .breezBridge
      .validateAddress(scannedString)
      .then((_) => true)
      .catchError((err) => false);
}

Future _handleLNUrl(
    LNUrlBloc lnurlBloc, BuildContext context, String lnurl) async {
  Fetch fetchAction = Fetch(lnurl);
  var cancelCompleter = Completer();
  var loaderRoute = createLoaderRoute(context, onClose: () {
    cancelCompleter.complete();
  });
  Navigator.of(context).push(loaderRoute);

  lnurlBloc.actionsSink.add(fetchAction);
  await Future.any([cancelCompleter.future, fetchAction.future]).then(
    (response) {
      Navigator.of(context).removeRoute(loaderRoute);
      if (cancelCompleter.isCompleted) {
        return;
      }

      LNURLHandler(context, lnurlBloc)
          .executeLNURLResponse(context, lnurlBloc, response);
    },
  ).catchError((err) {
    Navigator.of(context).removeRoute(loaderRoute);
    promptError(
        context,
        "Link Error",
        Text("Failed to process link: " + err.toString(),
            style: Theme.of(context).dialogTheme.contentTextStyle));
  });
}

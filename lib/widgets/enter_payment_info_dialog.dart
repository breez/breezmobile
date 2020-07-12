import 'package:barcode_scan/barcode_scan.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/node_id.dart';
import 'package:breez/utils/qr_scan.dart' as QRScanner;
import 'package:breez/widgets/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flushbar.dart';

class EnterPaymentInfoDialog extends StatefulWidget {
  final BuildContext context;
  final InvoiceBloc invoiceBloc;
  final GlobalKey firstPaymentItemKey;

  EnterPaymentInfoDialog(
      this.context, this.invoiceBloc, this.firstPaymentItemKey);

  @override
  State<StatefulWidget> createState() {
    return EnterPaymentInfoDialogState();
  }
}

class EnterPaymentInfoDialogState extends State<EnterPaymentInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  String _scannerErrorMessage = "";
  TextEditingController _paymentInfoController = TextEditingController();
  final FocusNode _paymentInfoFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _paymentInfoController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
      title: Text("Payee Information",
          style: Theme.of(context).dialogTheme.titleTextStyle),
      contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: _buildPaymentInfoForm(context),
      actions: _buildActions(),
    );
  }

  Theme _buildPaymentInfoForm(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
                enabledBorder:
                    UnderlineInputBorder(borderSide: theme.greyBorderSide)),
            hintColor: Theme.of(context).dialogTheme.contentTextStyle.color,
            accentColor: Theme.of(context).textTheme.button.color,
            primaryColor: Theme.of(context).textTheme.button.color,
            errorColor: theme.themeId == "BLUE"
                ? Colors.red
                : Theme.of(context).errorColor),
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Invoice or Node ID",
                    suffixIcon: IconButton(
                      padding: EdgeInsets.only(top: 21.0),
                      alignment: Alignment.bottomRight,
                      icon: Image(
                        image: AssetImage("src/icon/qr_scan.png"),
                        color: theme.BreezColors.white[500],
                        fit: BoxFit.contain,
                        width: 24.0,
                        height: 24.0,
                      ),
                      tooltip: 'Scan Barcode',
                      onPressed: () => _scanBarcode(),
                    ),
                  ),
                  focusNode: _paymentInfoFocusNode,
                  controller: _paymentInfoController,
                  style: TextStyle(
                      color:
                          Theme.of(context).primaryTextTheme.headline4.color),
                  validator: (value) {
                    if (parseNodeId(value) == null ||
                        decodeInvoice(value) == null) {
                      return "Invalid invoice or node ID";
                    }
                    return null;
                  },
                ),
                _scannerErrorMessage.length > 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _scannerErrorMessage,
                          style: theme.validatorStyle,
                        ),
                      )
                    : SizedBox(),
              ]),
        ));
  }

  List<Widget> _buildActions() {
    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => Navigator.pop(context),
        child: Text("CANCEL", style: Theme.of(context).primaryTextTheme.button),
      )
    ];

    if (_paymentInfoController.text.isNotEmpty) {
      actions.add(SimpleDialogOption(
        onPressed: (() async {
          if (_formKey.currentState.validate()) {
            Navigator.of(context).pop();
            var nodeID = parseNodeId(_paymentInfoController.text);
            if (nodeID != null) {
              Navigator.of(context).push(FadeInRoute(
                builder: (_) =>
                    SpontaneousPaymentPage(nodeID, widget.firstPaymentItemKey),
              ));
              return;
            }
            if (decodeInvoice(_paymentInfoController.text) != null) {
              widget.invoiceBloc.decodeInvoiceSink
                  .add(_paymentInfoController.text);
            }
          }
        }),
        child:
            Text("APPROVE", style: Theme.of(context).primaryTextTheme.button),
      ));
    }
    return actions;
  }

  Future _scanBarcode() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      String barcode = await QRScanner.scan();
      if (barcode.isEmpty) {
        showFlushbar(context, message: "QR code wasn't detected.");
        return;
      }
      setState(() {
        _paymentInfoController.text = barcode;
        _scannerErrorMessage = "";
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._scannerErrorMessage =
              'Please grant Breez camera permission to scan QR codes';
        });
      } else {
        setState(() => this._scannerErrorMessage = '');
      }
    } on FormatException {
      setState(() => this._scannerErrorMessage = '');
    } catch (e) {
      setState(() => this._scannerErrorMessage = '');
    }
  }

  decodeInvoice(String invoiceString) {
    String normalized = invoiceString?.toLowerCase();
    if (normalized == null) {
      return null;
    }
    if (normalized.startsWith("lightning:")) {
      normalized = normalized.substring(10);
    }
    if (normalized.startsWith("ln") && !normalized.startsWith("lnurl")) {
      return invoiceString;
    }
    return null;
  }
}

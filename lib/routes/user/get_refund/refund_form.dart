import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class RefundForm extends StatefulWidget {
  final void Function(String address) _onRefund;

  RefundForm(this._onRefund);

  @override
  State<StatefulWidget> createState() {
    return _RefundFormState();
  }
}

class _RefundFormState extends State<RefundForm> {
  BreezBridge _breezLib = ServiceInjector().breezBridge;
  final TextEditingController _addressController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _addressValidated = false;
  ScrollController _scroller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          hintColor: theme.alertStyle.color,
          accentColor: theme.BreezColors.blue[500],
          primaryColor: theme.BreezColors.blue[500],
          errorColor: Colors.red),
      child: AlertDialog(
        title: Text(
          "Refund Transaction",
          style: theme.alertTitleStyle,
        ),
        titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 8.0),
        content: LayoutBuilder(
          builder: (context, constraints) {
            var form = Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new TextFormField(
                      controller: _addressController,
                      decoration: new InputDecoration(
                        labelStyle: theme.alertStyle,
                        labelText: "BTC Address",
                        suffixIcon: new IconButton(
                          padding: EdgeInsets.only(top: 21.0),
                          alignment: Alignment.bottomRight,
                          icon: new Image(
                            image: new AssetImage("src/icon/qr_scan.png"),
                            color: theme.alertStyle.color,
                            fit: BoxFit.contain,
                            width: 24.0,
                            height: 24.0,
                          ),
                          tooltip: 'Scan Barcode',
                          onPressed: _scanBarcode,
                        ),
                      ),
                      style: theme.alertStyle,
                      validator: (value) {
                        if (!_addressValidated) {
                          return "Please enter a valid BTC Address";
                        }
                      },
                    )
                  ],
                ));
            if (constraints.maxHeight < 400.0) {
              return form;
            }
            return SingleChildScrollView(
              controller: _scroller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                        "Please enter a destination address to receive a refund. Then, broadcast the refund transaction to the Blockchain.",
                        style: theme.alertStyle),
                  ),
                  form
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text("CANCEL", style: theme.buttonStyle)),
          FlatButton(
              onPressed: () {
                _asyncValidate().then((validated) {
                  if (validated) {
                    _formKey.currentState.save();
                    widget._onRefund(_addressController.text);
                  }
                });
              },
              child: new Text("BROADCAST", style: theme.buttonStyle))
        ],
      ),
    );
  }

  Future<bool> _asyncValidate() {
    return _breezLib.validateAddress(_addressController.text).then((data) {
      _addressValidated = true;
      return _formKey.currentState.validate();
    }).catchError((err) {
      _addressValidated = false;
      return _formKey.currentState.validate();
    });
  }

  Future _scanBarcode() async {
    String barcode = await BarcodeScanner.scan();
    setState(() {
      _addressController.text = barcode;
    });
  }
}

import 'dart:async';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';

import 'flushbar.dart';

class SendOnchain extends StatefulWidget {
  final AccountModel _account;
  final Future<String> Function(String address, Int64 fee) _onBroadcast;
  final Int64 _amount;  
  final String _title;
  final String prefixMessage;

  SendOnchain(this._account, this._amount, this._title, this._onBroadcast, {this.prefixMessage});

  @override
  State<StatefulWidget> createState() {
    return new SendOnchainState();
  }
}

class SendOnchainState extends State<SendOnchain> {
  final _formKey = GlobalKey<FormState>();
  String _scannerErrorMessage = "";
  final TextEditingController _addressController = new TextEditingController();  
  final TextEditingController _feeController = new TextEditingController();  

  BreezBridge _breezLib = ServiceInjector().breezBridge;
  String _addressValidated;    
  final FocusNode _feeFocusNode = FocusNode();
  KeyboardDoneAction _doneAction;

  @override
  void initState() {
    super.initState();
    _doneAction = new KeyboardDoneAction(<FocusNode>[_feeFocusNode]);    
  }

  @override void didChangeDependencies() {
    super.didChangeDependencies();
    if (_feeController.text.isEmpty) {
      _feeController.text = widget._account.onChainFeeRate.toString();
    }
  }

  @override
  void dispose() {
    _doneAction.dispose();    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(enabledBorder: UnderlineInputBorder(borderSide: theme.greyBorderSide)),
          hintColor: theme.alertStyle.color,
          accentColor: theme.BreezColors.blue[500],
          primaryColor: theme.BreezColors.blue[500],
          unselectedWidgetColor: Theme.of(context).canvasColor,
          errorColor: Colors.red),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            iconTheme: theme.appBarIconTheme,
            textTheme: theme.appBarTextTheme,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: theme.BreezColors.grey[600]))
            ],
            title: new Text(widget._title,
                style: theme.alertTitleStyle, textAlign: TextAlign.left),
            elevation: 0.0),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[                  
                  FlatButton(
                    onPressed: () {
                      _asyncValidate().then((validated) {
                        if (validated) {
                          _formKey.currentState.save();
                          widget._onBroadcast(_addressValidated, _getFee())
                            .then((msg){
                              Navigator.of(context).pop();
                              if (msg != null) {
                                showFlushbar(context, message: msg);
                              }
                            });
                        }
                      });
                    },
                    child: Text("BROADCAST", style: theme.buttonStyle))
                ]),
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: new Padding(
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 0.0, top: 12.0),
                    child: new Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        widget.prefixMessage != null ? 
                          Text(widget.prefixMessage, 
                            style: new TextStyle(
                                    color: theme.BreezColors.grey[500],
                                    fontSize: 16.0,
                                    height: 1.2)) : 
                          SizedBox(),                        
                        new TextFormField(
                          controller: _addressController,
                          decoration: new InputDecoration(
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
                            if (_addressValidated == null) {
                              return "Please enter a valid BTC Address";
                            }
                          },
                        ),
                        _scannerErrorMessage.length > 0
                            ? new Text(
                                _scannerErrorMessage,
                                style: theme.validatorStyle,
                              )
                            : SizedBox(),                       
                        new TextFormField(
                            focusNode: _feeFocusNode,
                            controller: _feeController,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                                labelText: "Sat Per Byte Fee Rate"),
                            style: theme.alertStyle,
                            validator: (value) {
                              if (_feeController.text.isEmpty) {
                                return "Please enter a valid fee rate";
                              }
                              return null;
                            }),
                        new Container(
                          padding: new EdgeInsets.only(top: 12.0),
                          child: _buildAvailableBTC(widget._account),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _buildAvailableBTC(AccountModel acc) {
    return new Row(
      children: <Widget>[
        new Text("Amount:", style: theme.alertStyle),
        new Padding(
          padding: EdgeInsets.only(left: 3.0),
          child: new Text(acc.currency.format(widget._amount),
              style: theme.alertStyle),
        )
      ],
    );
  }

  Int64 _getFee(){
    return _feeController.text.isNotEmpty
      ? Int64.parseInt(_feeController.text)
      : Int64(0);
  }

  Future _scanBarcode() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      String barcode = await BarcodeScanner.scan();
      setState(() {
        _addressController.text = barcode;
        _scannerErrorMessage = "";
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._scannerErrorMessage =
              'Please grant Breez camera permission to scan QR codes.';
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

  Future<bool> _asyncValidate() {
    return _breezLib.validateAddress(_addressController.text).then((data) {
      _addressValidated = data;
      return _formKey.currentState.validate();
    }).catchError((err) {
      _addressValidated = null;
      return _formKey.currentState.validate();
    });
  }
}

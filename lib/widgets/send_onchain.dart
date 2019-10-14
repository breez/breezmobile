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
          hintColor: Theme.of(context).dialogTheme.contentTextStyle.color,
          accentColor: Theme.of(context).textTheme.button.color,
          primaryColor: Theme.of(context).textTheme.button.color,
          unselectedWidgetColor: Theme.of(context).canvasColor,
          errorColor: theme.themeId == "BLUE" ? Colors.red : Theme.of(context).errorColor),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
            brightness: theme.themeId == "BLUE" ? Brightness.light : Theme.of(context).appBarTheme.brightness,
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
            textTheme: Theme.of(context).appBarTheme.textTheme,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).backgroundColor,
            actions: <Widget>[
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  // Color needs to be changed
                  icon: Icon(Icons.close, color: theme.themeId == "BLUE" ? Theme.of(context).primaryIconTheme.color : Theme.of(context).iconTheme.color))
            ],
            title: new Text(widget._title,
                style: Theme.of(context).dialogTheme.titleTextStyle, textAlign: TextAlign.left),
            elevation: 0.0),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Theme.of(context).backgroundColor,
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
                    child: Text("BROADCAST", style: Theme.of(context).primaryTextTheme.button,),
                  )
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
                                    color: Theme.of(context).dialogTheme.contentTextStyle.color,
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
                                color: Theme.of(context).dialogTheme.contentTextStyle.color,
                                fit: BoxFit.contain,
                                width: 24.0,
                                height: 24.0,
                              ),
                              tooltip: 'Scan Barcode',
                              onPressed: _scanBarcode,
                            ),
                          ),
                          style: Theme.of(context).dialogTheme.contentTextStyle,
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
                            style: Theme.of(context).dialogTheme.contentTextStyle,
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
        new Text("Amount:", style: Theme.of(context).dialogTheme.contentTextStyle),
        new Padding(
          padding: EdgeInsets.only(left: 3.0),
          child: new Text(acc.currency.format(widget._amount),
              style: Theme.of(context).dialogTheme.contentTextStyle),
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

import 'dart:async';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';

class WithdrawFundsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new BlocConnector<AppBlocs>(
        (context, blocs) => _WithdrawFundsPage(blocs.accountBloc));
  }
}

class _WithdrawFundsPage extends StatefulWidget {
  final AccountBloc _accountBloc;

  const _WithdrawFundsPage(this._accountBloc);

  @override
  State<StatefulWidget> createState() {
    return new _WithdrawFundsState();
  }
}

class _WithdrawFundsState extends State<_WithdrawFundsPage> {
  final _formKey = GlobalKey<FormState>();
  String _scannerErrorMessage = "";
  final TextEditingController _addressController = new TextEditingController();
  final TextEditingController _amountController = new TextEditingController();
  StreamSubscription<AccountModel> accountSubscription;
  StreamSubscription<RemoveFundResponseModel> withdrawalResultSubscription;
  Currency _currency = Currency.BTC;
  BreezBridge _breezLib;
  bool _addressValidated = false;
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();

    ServiceInjector injector = new ServiceInjector();
    _breezLib = injector.breezBridge;

    accountSubscription = widget._accountBloc.accountStream.listen((acc) {
      _currency = acc.currency;
    });
    withdrawalResultSubscription =
        widget._accountBloc.withdrawalResultStream.listen((response) {
      setState(() {
        _inProgress = false;
      });
      Navigator.of(context).pop(); //remove the loading dialog
      if (response.errorMessage.isNotEmpty) {
        promptError(context, null,
            Text(response.errorMessage, style: theme.alertStyle));
        return;
      }
      Navigator.of(context).pop(
          "The funds were successfully sent to the address you have specified.");
    }, onError: (err) {
      setState(() {
        _inProgress = false;
      });
      Navigator.of(context).pop(); //remove the loading dialog
      promptError(context, null, Text(err.toString(), style: theme.alertStyle));
    });
  }

  @override
  void dispose() {
    accountSubscription.cancel();
    withdrawalResultSubscription.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_inProgress) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final String _title = "Remove Funds";
    return new Scaffold(
      bottomNavigationBar: new Padding(
          padding: new EdgeInsets.only(bottom: 40.0),
          child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            new SizedBox(
              height: 48.0,
              width: 168.0,
              child: RaisedButton(
                padding: EdgeInsets.only(
                    top: 16.0, bottom: 16.0, right: 39.0, left: 39.0),
                child: new Text(
                  "REMOVE",
                  style: theme.buttonStyle,
                ),
                color: Colors.white,
                elevation: 0.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(42.0)),
                onPressed: () {
                  _asyncValidate().then((validated) {
                    if (validated) {
                      _formKey.currentState.save();
                      _showAlertDialog();
                    }
                  });
                },
              ),
            ),
          ])),
      appBar: new AppBar(
        iconTheme: theme.appBarIconTheme,
        textTheme: theme.appBarTextTheme,
        backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
        leading: backBtn.BackButton(),
        title: new Text(_title, style: theme.appBarTextStyle),
        elevation: 0.0        
      ),
      body: StreamBuilder<AccountModel>(
        stream: widget._accountBloc.accountStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return StaticLoader();
          }
          AccountModel acc = snapshot.data;
          return Form(
            key: _formKey,
            child: new Padding(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new TextFormField(
                    controller: _addressController,
                    decoration: new InputDecoration(
                      labelText: "BTC Address",
                      suffixIcon: new IconButton(
                        padding: EdgeInsets.only(top: 21.0),
                        alignment: Alignment.bottomRight,
                        icon: new Image(
                          image: new AssetImage("src/icon/qr_scan.png"),
                          color: theme.BreezColors.white[500],
                          fit: BoxFit.contain,
                          width: 24.0,
                          height: 24.0,
                        ),
                        tooltip: 'Scan Barcode',
                        onPressed: _scanBarcode,
                      ),
                    ),
                    style: theme.FieldTextStyle.textStyle,
                    validator: (value) {
                      if (!_addressValidated) {
                        return "Please enter a valid BTC Address";
                      }
                    },
                  ),
                  new Text(
                    _scannerErrorMessage,
                    style: theme.validatorStyle,
                  ),
                  new AmountFormField(
                      controller: _amountController,
                      currency: _currency,
                      maxPaymentAmount: acc.maxPaymentAmount,
                      maxAmount: acc.maxAllowedToPay,
                      decoration: new InputDecoration(
                          labelText: _currency.displayName + " Amount"),
                      style: theme.FieldTextStyle.textStyle),
                  new Container(
                    padding: new EdgeInsets.only(top: 36.0),
                    child: _buildAvailableBTC(acc),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvailableBTC(AccountModel acc) {
    return new Row(
      children: <Widget>[
        new Text("Available:", style: theme.textStyle),
        new Padding(
          padding: EdgeInsets.only(left: 3.0),
          child: new Text(_currency.format(acc.balance),
              style: theme.textStyle),
        )
      ],
    );
  }

  void _showAlertDialog() {
    AlertDialog dialog = new AlertDialog(
      content: new Text(
          "Are you sure you want to remove " +
              _currency.format(Int64.parseInt( _amountController.text )) +                            
              " from Breez and send this amount to the address you've specified?",
          style: theme.alertStyle),
      actions: <Widget>[
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: new Text("NO", style: theme.buttonStyle)),
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
              _showLoadingDialog();
              widget._accountBloc.withdrawalSink.add(new RemoveFundRequestModel(
                  Int64.parseInt(_amountController.text),
                  _addressController.text));
            },
            child: new Text("YES", style: theme.buttonStyle))
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  _showLoadingDialog() {
    setState(() {
      _inProgress = true;
    });
    AlertDialog dialog = new AlertDialog(
      title: Text("Removing Funds", style: theme.alertTitleStyle, textAlign: TextAlign.center,),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text("Please wait while Breez is sending the funds to the specified address.", style: theme.alertStyle, textAlign: TextAlign.center,),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: new Image.asset(
              'src/images/breez_loader.gif',
              gaplessPlayback: true,
          ))
        ],
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(onWillPop: _onWillPop, child: dialog));
  }

  Future _scanBarcode() async {
    try {
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
      _addressValidated = true;
      return _formKey.currentState.validate();
    }).catchError((err) {
      _addressValidated = false;
      return _formKey.currentState.validate();
    });
  }
}

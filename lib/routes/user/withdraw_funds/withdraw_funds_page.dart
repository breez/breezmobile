import 'dart:async';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';


class WithdrawFundsPage extends StatelessWidget {
  final bool sendNonDepositable;

  WithdrawFundsPage(this.sendNonDepositable);

  @override
  Widget build(BuildContext context) {
    return new BlocConnector<AppBlocs>((context, blocs) => _WithdrawFundsPage(blocs.accountBloc, blocs.userProfileBloc, this.sendNonDepositable));
  }
}

class _WithdrawFundsPage extends StatefulWidget {
  final AccountBloc _accountBloc;
  final UserProfileBloc _userProfileBloc;
  final bool sendNonDepositable;

  const _WithdrawFundsPage(this._accountBloc, this._userProfileBloc, this.sendNonDepositable);

  @override
  State<StatefulWidget> createState() {
    return new _WithdrawFundsState();
  }
}

class _WithdrawFundsState extends State<_WithdrawFundsPage> {
  final _formKey = GlobalKey<FormState>();
  String _scannerErrorMessage = "";
  String _formattedAmount = "";
  final TextEditingController _addressController = new TextEditingController();
  final TextEditingController _amountController = new TextEditingController();
  StreamSubscription<AccountModel> accountSubscription;
  StreamSubscription<String> withdrawalResultSubscription;
  Currency _currency = Currency.BTC;
  BreezBridge _breezLib;
  bool _addressValidated = false;

  @override
  void initState() {
    super.initState();

    ServiceInjector injector = new ServiceInjector();
    _breezLib = injector.breezBridge;

    accountSubscription = widget._accountBloc.accountStream.listen((acc) {
      _currency = acc.currency;
      if (widget.sendNonDepositable) {
        _amountController.text = acc.currency.format(acc.nonDepositableBalance, includeSymbol: false);
        _formattedAmount = acc.currency.format(acc.nonDepositableBalance, includeSymbol: true, fixedDecimals: false);
      }
    });
    withdrawalResultSubscription = widget._accountBloc.withdrawalResultStream.listen((address) {
      if (address == _addressController.text) {
        Navigator.of(context).pop(_formattedAmount + " were successfully sent to the address you have specified.");
      }
    }, onError: (err) {
      print(err);
      //show error
    });
  }

  @override
  void dispose() {
    accountSubscription.cancel();
    withdrawalResultSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String _title = widget.sendNonDepositable ? "Remove Excess Funds" : "Remove Funds";
    return new Scaffold(
      bottomNavigationBar: new Padding(
          padding: new EdgeInsets.only(bottom: 40.0),
          child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            new SizedBox(
              height: 48.0,
              width: 168.0,
              child: RaisedButton(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0, right: 39.0, left: 39.0),
                child: new Text(
                  "REMOVE",
                  style: theme.buttonStyle,
                ),
                color: Colors.white,
                elevation: 0.0,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(42.0)),
                onPressed: () {
                  _asyncValidate().then((validated){
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
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
            padding: EdgeInsets.only(right: 16.0),
            alignment: Alignment.centerRight,
            icon: new Image(
              image: new AssetImage("src/icon/qr_scan.png"),
              color: theme.BreezColors.white[500],
              fit: BoxFit.contain,
              width: 24.0,
              height: 24.0,
            ),
            onPressed: _scanBarcode,
          )
        ],
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
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
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
                          image: new AssetImage("src/icon/paste.png"),
                          color: theme.BreezColors.white[500],
                          fit: BoxFit.contain,
                          width: 24.0,
                          height: 24.0,
                        ),
                        tooltip: 'Paste clipboard',
                        onPressed: () {
                          Clipboard.getData("text/plain").then((data) {
                            _addressController.text = data.text;
                          });
                        },
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
                      maxAmount: widget.sendNonDepositable ? acc.nonDepositableBalance : acc.balance,
                      decoration: new InputDecoration(labelText: _currency.displayName + " Amount"),
                      enabled: !widget.sendNonDepositable,
                      style: theme.FieldTextStyle.textStyle),
                  new Container(
                    padding: new EdgeInsets.only(top: 36.0),
                    child: widget.sendNonDepositable ? _buildOverCapacityMessage() : _buildAvailableBTC(acc),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool canWithdraw() {
    return _amountController.text.length > 0 && Int64.parseInt(_amountController.text) > 0;
  }

  Widget _buildAvailableBTC(AccountModel acc) {
    return new Row(
      children: <Widget>[
        new Text("Available:", style: theme.textStyle),
        new Padding(
          padding: EdgeInsets.only(left: 3.0),
          child: new Text(_currency.format(acc.balance), style: theme.textStyle),
        )
      ],
    );
  }

  Widget _buildOverCapacityMessage() {
    return new Column(children: <Widget>[
      Text("Funds previously added were above Breez's capacity. Please remove the difference before adding more funds.", style: theme.warningStyle)
    ]);
  }

  void _showAlertDialog() {
    AlertDialog dialog = new AlertDialog(
      content: new Text("Are you sure you want to withdraw " + _amountController.text + " " + _currency.displayName + " from Breez?",
          style: theme.alertStyle),
      actions: <Widget>[
        new FlatButton(onPressed: () => Navigator.pop(context), child: new Text("NO", style: theme.buttonStyle)),
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
              widget._accountBloc.withdrawalSink.add(_addressController.text);
            },
            child: new Text("YES", style: theme.buttonStyle))
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
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
          this._scannerErrorMessage = 'Please grant Breez camera permission to scan QR codes.';
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

import 'dart:async';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/form_keyboard_actions.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';

class WithdrawFundsPage extends StatefulWidget {

  const WithdrawFundsPage();

  @override
  State<StatefulWidget> createState() {
    return WithdrawFundsPageState();
  }
}

class WithdrawFundsPageState extends State<WithdrawFundsPage> {
  final _formKey = GlobalKey<FormState>();
  String _scannerErrorMessage = "";
  final TextEditingController _addressController = new TextEditingController();
  final TextEditingController _amountController = new TextEditingController();  
  
  AccountBloc _accountBloc;
  StreamSubscription<RemoveFundResponseModel> withdrawalResultSubscription;  
  BreezBridge _breezLib;
  String _addressValidated;
  bool _inProgress = false;
  bool _isInit = false;
  final FocusNode _amountFocusNode = FocusNode();
  KeyboardDoneAction _doneAction;

  @override
  void didChangeDependencies() {        
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      registerWithdrawalResult();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();    
    _breezLib = new ServiceInjector().breezBridge;  
    _doneAction = new KeyboardDoneAction(<FocusNode>[_amountFocusNode]);     
  }

  @override
  void dispose() {
    withdrawalResultSubscription.cancel();
    _doneAction.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_inProgress) {
      return false;
    }
    return true;
  }

  void registerWithdrawalResult(){    
    withdrawalResultSubscription = _accountBloc.withdrawalResultStream
      .listen((response) {
          setState(() {
            _inProgress = false;
          });
          Navigator.of(context).pop(); //remove the loading dialog
          if (response.errorMessage?.isNotEmpty == true) {
            promptError(context, null,
                Text(response.errorMessage, style: Theme.of(context).dialogTheme.contentTextStyle));
            return;
          }
          Navigator.of(context).pop(
              "The funds were successfully sent to the address you have specified.");
        }, onError: (err) {
          setState(() {
            _inProgress = false;
          });
          Navigator.of(context).pop(); //remove the loading dialog
          promptError(context, null, Text(err.toString(), style: Theme.of(context).dialogTheme.contentTextStyle));
      });
  }

  @override
  Widget build(BuildContext context) {
    final String _title = "Remove Funds";
    return new Scaffold(
      bottomNavigationBar: StreamBuilder<AccountModel>(
          stream: _accountBloc.accountStream,
          builder: (context, snapshot) {
            AccountModel acc = snapshot.data;
            return new Padding(
                padding: new EdgeInsets.only(bottom: 40.0),
                child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new SizedBox(
                        height: 48.0,
                        width: 168.0,
                        child: RaisedButton(
                          child: new Text(
                            "REMOVE",
                            style: theme.buttonStyle,
                          ),
                          color: Colors.white,
                          elevation: 0.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(42.0)),
                          onPressed: acc == null
                              ? null
                              : () {
                                  _asyncValidate().then((validated) {
                                    if (validated) {
                                      _formKey.currentState.save();
                                      _showAlertDialog(acc.currency);
                                    }
                                  });
                                },
                        ),
                      ),
                    ]));
          }),
      appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: Theme.of(context).canvasColor,
          leading: backBtn.BackButton(),
          title: new Text(_title, style: theme.appBarTextStyle),
          elevation: 0.0),
      body: StreamBuilder<AccountModel>(
        stream: _accountBloc.accountStream,
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
                  new AmountFormField(
                      context: context,
                      accountModel: acc,
                      focusNode: _amountFocusNode,
                      controller: _amountController,
                      validatorFn: acc.validateOutgoingPayment,
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
          child: new Text(acc.currency.format(acc.balance),
              style: theme.textStyle),
        )
      ],
    );
  }

  void _showAlertDialog(Currency currency) {
    AlertDialog dialog = new AlertDialog(
      content: new Text(
          "Are you sure you want to remove " +
              currency.format(currency.parse(_amountController.text)) +
              " from Breez and send this amount to the address you've specified?",
          style: Theme.of(context).dialogTheme.contentTextStyle),
      actions: <Widget>[
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: new Text("NO", style: theme.buttonStyle)),
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
              _showLoadingDialog();
              _accountBloc.withdrawalSink.add(new RemoveFundRequestModel(
                  currency.parse(_amountController.text),
                  _addressValidated                  
                ));
            },
            child: new Text("YES", style: theme.buttonStyle))
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  _showLoadingDialog() {
    setState(() {
      _inProgress = true;
    });
    AlertDialog dialog = new AlertDialog(
      title: Text(
        "Removing Funds",
        style: Theme.of(context).dialogTheme.titleTextStyle,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
            "Please wait while Breez is sending the funds to the specified address.",
            style: Theme.of(context).dialogTheme.contentTextStyle,
            textAlign: TextAlign.center,
          ),
          Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: new Image.asset(
                'src/images/breez_loader.gif',
                gaplessPlayback: true,
              ))
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(onWillPop: _onWillPop, child: dialog));
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

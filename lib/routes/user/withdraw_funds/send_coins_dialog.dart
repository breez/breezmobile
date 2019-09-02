import 'dart:async';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/form_keyboard_actions.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/send_onchain.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';

class SendCoinsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return StreamBuilder(
      stream: accountBloc.accountStream,
      builder: (ctx, snapshot) {
        var acc = snapshot.data;
        if (acc == null) {
          return SizedBox();
        }

        return SendOnchain(acc, acc.walletBalance, "Unexpected Funds", (address, fee){

        });
      });    
  }

  Future<bool> _showAlertDialog(BuildContext context, AccountModel acc) {
    Completer<bool> completer = Completer<bool>();

    AlertDialog dialog = new AlertDialog(
      content: new Text(
          "Are you sure you want to remove " +
              acc.currency.format(acc.walletBalance) +
              " from Breez and send this amount to the address you've specified?",
          style: theme.alertStyle),
      actions: <Widget>[
        new FlatButton(
            onPressed: () { 
              Navigator.pop(context, false);
              completer.complete(false);
            },
            child: new Text("NO", style: theme.buttonStyle)),
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
              _showLoadingDialog();
              accountBloc.withdrawalSink.add(new RemoveFundRequestModel(
                  currency.parse(_amountController.text),
                  _addressValidated,
                  fromWallet: true,
                  satPerByteFee: _feeController.text.isNotEmpty
                      ? Int64.parseInt(_feeController.text)
                      : Int64(0)));
            },
            child: new Text("YES", style: theme.buttonStyle))
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    );
    showDialog(context: context, builder: (_) => dialog);
    return completer.future;
  }

  _showLoadingDialog() {
    setState(() {
      _inProgress = true;
    });
    AlertDialog dialog = new AlertDialog(
      title: Text(
        "Removing Funds",
        style: theme.alertTitleStyle,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
            "Please wait while Breez is sending the funds to the specified address.",
            style: theme.alertStyle,
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
}


class SendWalletFundsDialog extends StatefulWidget {
  final AccountBloc _accountBloc;

  const SendWalletFundsDialog(this._accountBloc);

  @override
  State<StatefulWidget> createState() {
    return new SendWalletFundsDialogState();
  }
}

class SendWalletFundsDialogState extends State<SendWalletFundsDialog> {
  final _formKey = GlobalKey<FormState>();
  String _scannerErrorMessage = "";
  final TextEditingController _addressController = new TextEditingController();
  final TextEditingController _amountController = new TextEditingController();
  final TextEditingController _feeController = new TextEditingController();
  StreamSubscription<RemoveFundResponseModel> withdrawalResultSubscription;

  BreezBridge _breezLib = ServiceInjector().breezBridge;
  String _addressValidated;
  bool _inProgress = false;
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _feeFocusNode = FocusNode();
  KeyboardDoneAction _doneAction;  

  @override
  void initState() {
    super.initState();
    _doneAction = new KeyboardDoneAction(<FocusNode>[_amountFocusNode, _feeFocusNode]);

    withdrawalResultSubscription =
        widget._accountBloc.withdrawalResultStream.listen((response) {
      setState(() {
        _inProgress = false;
      });
      Navigator.of(context).pop();      
      Navigator.of(context).pop();
      showFlushbar(context, message: "The funds were successfully sent to the address you have specified.");
    }, onError: (err) {
      setState(() {
        _inProgress = false;
      });
      Navigator.of(context).pop();
      promptError(context, null, Text(err.toString(), style: theme.alertStyle));
    });

    widget._accountBloc.accountStream.first
        .then((acc) => _feeController.text = acc.onChainFeeRate?.toString());
  }

  @override
  void dispose() {
    _doneAction.dispose();
    withdrawalResultSubscription.cancel();
    super.dispose();
  }

  void _onDismiss(AccountSettings settings) async {
    TextStyle textStyle = TextStyle(color: Colors.black);
    String exitSessionMessage =
        "Dismissing this dialog means you won't be able to to redeem these funds. Are you sure?";
    bool cancel = await promptAreYouSure(
        context, null, Text(exitSessionMessage, style: textStyle),
        textStyle: textStyle);
    if (cancel) {
      widget._accountBloc.accountSettingsSink.add(settings.copyWith(ignoreWalletBalance: true));
      Navigator.pop(context);    
    }
  }

  Future<bool> _onWillPop() async {
    if (_inProgress) {
      return false;
    }
    return true;
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
            title: new Text("Unexpected Funds",
                style: theme.alertTitleStyle, textAlign: TextAlign.left),
            elevation: 0.0),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  StreamBuilder<AccountSettings>(
                      stream: widget._accountBloc.accountSettingsStream,
                      builder: (context, snapshot) {
                        AccountSettings settings = snapshot.data;
                        return FlatButton(
                            onPressed: () {
                              _onDismiss(settings);
                            },
                            child: Text("DISMISS", style: theme.buttonStyle));
                      }),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("LATER", style: theme.buttonStyle)),
                  StreamBuilder<AccountModel>(
                      stream: widget._accountBloc.accountStream,
                      builder: (context, snapshot) {
                        AccountModel acc = snapshot.data;
                        return FlatButton(
                            onPressed: () {
                              _asyncValidate().then((validated) {
                                if (validated) {
                                  _formKey.currentState.save();
                                  _showAlertDialog(acc.currency);
                                }
                              });
                            },
                            child: Text("SEND", style: theme.buttonStyle));
                      })
                ]),
          ),
        ),
        body: StreamBuilder<AccountModel>(
          stream: widget._accountBloc.accountStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return StaticLoader();
            }
            AccountModel acc = snapshot.data;
            return LayoutBuilder(builder: (context, constraints) {
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
                        constraints.maxHeight > 400.0
                            ? Text(
                                "Breez found unexpected funds in its underlying  wallet. These funds cannot be used for Breez payments, so it is highly recommended you send them to an external address as soon as possible.",
                                style: new TextStyle(
                                    color: theme.BreezColors.grey[500],
                                    fontSize: 16.0,
                                    height: 1.2))
                            : SizedBox(),
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
                        new AmountFormField(
                            context: context,
                            accountModel: acc,
                            focusNode: _amountFocusNode,
                            controller: _amountController,
                            validatorFn: acc.validateOutgoingOnChainPayment,
                            style: theme.alertStyle),
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
                            }),
                        new Container(
                          padding: new EdgeInsets.only(top: 12.0),
                          child: _buildAvailableBTC(acc),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildAvailableBTC(AccountModel acc) {
    return new Row(
      children: <Widget>[
        new Text("Available:", style: theme.alertStyle),
        new Padding(
          padding: EdgeInsets.only(left: 3.0),
          child: new Text(acc.currency.format(acc.walletBalance),
              style: theme.alertStyle),
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
                  currency.parse(_amountController.text),
                  _addressValidated,
                  fromWallet: true,
                  satPerByteFee: _feeController.text.isNotEmpty
                      ? Int64.parseInt(_feeController.text)
                      : Int64(0)));
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
        style: theme.alertTitleStyle,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
            "Please wait while Breez is sending the funds to the specified address.",
            style: theme.alertStyle,
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

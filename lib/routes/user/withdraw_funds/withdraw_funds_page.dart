import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/qr_scan.dart' as QRScanner;
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

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
    _breezLib = ServiceInjector().breezBridge;
    _doneAction = KeyboardDoneAction(<FocusNode>[_amountFocusNode]);
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

  void registerWithdrawalResult() {
    withdrawalResultSubscription =
        _accountBloc.withdrawalResultStream.listen((response) {
      setState(() {
        _inProgress = false;
      });
      Navigator.of(context).pop(); //remove the loading dialog
      if (response.errorMessage?.isNotEmpty == true) {
        promptError(
            context,
            null,
            Text(response.errorMessage,
                style: Theme.of(context).dialogTheme.contentTextStyle));
        return;
      }
      Navigator.of(context).pop(
          "The funds were successfully sent to the address you have specified.");
    }, onError: (err) {
      setState(() {
        _inProgress = false;
      });
      Navigator.of(context).pop(); //remove the loading dialog
      promptError(
          context,
          null,
          Text(err.toString(),
              style: Theme.of(context).dialogTheme.contentTextStyle));
    });
  }

  @override
  Widget build(BuildContext context) {
    final String _title = "Remove Funds";
    return Scaffold(
      bottomNavigationBar: StreamBuilder<AccountModel>(
          stream: _accountBloc.accountStream,
          builder: (context, snapshot) {
            AccountModel acc = snapshot.data;
            return Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  SizedBox(
                    height: 48.0,
                    width: 168.0,
                    child: RaisedButton(
                      child: Text(
                        "REMOVE",
                        style: Theme.of(context).textTheme.button,
                      ),
                      color: Theme.of(context).buttonColor,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(42.0)),
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
      appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          leading: backBtn.BackButton(),
          title: Text(_title,
              style: Theme.of(context).appBarTheme.textTheme.title),
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
            child: Padding(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: "BTC Address",
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
                      ? Text(
                          _scannerErrorMessage,
                          style: theme.validatorStyle,
                        )
                      : SizedBox(),
                  AmountFormField(
                      context: context,
                      accountModel: acc,
                      focusNode: _amountFocusNode,
                      controller: _amountController,
                      validatorFn: acc.validateOutgoingPayment,
                      style: theme.FieldTextStyle.textStyle),
                  Container(
                    padding: EdgeInsets.only(top: 36.0),
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
    return Row(
      children: <Widget>[
        Text("Available:", style: theme.textStyle),
        Padding(
          padding: EdgeInsets.only(left: 3.0),
          child: Text(acc.currency.format(acc.balance), style: theme.textStyle),
        )
      ],
    );
  }

  void _showAlertDialog(Currency currency) {
    AlertDialog dialog = AlertDialog(
      content: Text(
          "Are you sure you want to remove " +
              currency.format(currency.parse(_amountController.text)) +
              " from Breez and send this amount to the address you've specified?",
          style: Theme.of(context).dialogTheme.contentTextStyle),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text("NO", style: Theme.of(context).primaryTextTheme.button)),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              _showLoadingDialog();
              _accountBloc.withdrawalSink.add(RemoveFundRequestModel(
                  currency.parse(_amountController.text), _addressValidated));
            },
            child:
                Text("YES", style: Theme.of(context).primaryTextTheme.button))
      ],
    );
    showDialog(
        useRootNavigator: false, context: context, builder: (_) => dialog);
  }

  _showLoadingDialog() {
    setState(() {
      _inProgress = true;
    });
    AlertDialog dialog = AlertDialog(
      title: Text(
        "Removing Funds",
        style: Theme.of(context).dialogTheme.titleTextStyle,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Please wait while Breez is sending the funds to the specified address.",
            style: Theme.of(context).dialogTheme.contentTextStyle,
            textAlign: TextAlign.center,
          ),
          Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Image.asset(
                theme.customData[theme.themeId].loaderAssetPath,
                gaplessPlayback: true,
              ))
        ],
      ),
    );
    showDialog(
        useRootNavigator: false,
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(onWillPop: _onWillPop, child: dialog));
  }

  Future _scanBarcode() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      String barcode = await QRScanner.scan();
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

  Future<String> getClipboardData() async {
    ClipboardData clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    return clipboardData.text;
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

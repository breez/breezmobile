import 'dart:async';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/bloc/pos_profile/pos_profile_bloc.dart';
import 'package:breez/bloc/pos_profile/pos_profile_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/services/countdown.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/routes/user/home/status_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';

var cancellationTimeoutValue;

class POSInvoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new BlocConnector<AppBlocs>((context, appBlocs) =>
        new _POSNumPad(appBlocs.accountBloc, appBlocs.invoicesBloc, appBlocs.posProfileBloc, appBlocs.userProfileBloc));
  }
}

class _POSNumPad extends StatefulWidget {
  final AccountBloc _accountBloc;
  final InvoiceBloc _invoiceBloc;
  final POSProfileBloc _posProfileBloc;
  final UserProfileBloc _userProfileBloc;

  _POSNumPad(this._accountBloc, this._invoiceBloc, this._posProfileBloc, this._userProfileBloc);

  @override
  State<StatefulWidget> createState() {
    return new _PosNumPadState();
  }
}

class _PosNumPadState extends State<_POSNumPad> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _amountController = new TextEditingController();
  TextEditingController _chargeAmountController = new TextEditingController();
  TextEditingController _invoiceDescriptionController = new TextEditingController();

  POSProfileModel _posProfile;
  Currency _currency;
  double itemHeight;
  double itemWidth;
  int _currentAmount;
  int _totalAmount;
  Int64 _maxPaymentAmount;
  Int64 _maxAllowedToReceive;

  StreamSubscription<AccountModel> _accountSubscription;
  StreamSubscription<POSProfileModel> _posProfileSubscription;
  StreamSubscription<String> _invoiceReadyNotificationsSubscription;
  StreamSubscription<String> _invoiceNotificationsSubscription;

  @override
  void initState() {
    super.initState();
    _NfcDialog _nfcDialog = new _NfcDialog(widget._invoiceBloc, _scaffoldKey);
    setState(() {
      _currency = Currency.BTC;
      _currentAmount = 0;
      _totalAmount = 0;
      _invoiceDescriptionController.text = "";
    });
    _accountSubscription = widget._accountBloc.accountStream.listen((acc) {
      setState(() {
        _currency = acc.currency;
        _maxPaymentAmount = acc.maxPaymentAmount;
        _maxAllowedToReceive = acc.maxAllowedToReceive;
        _amountController.text = _currency.format((Int64(_currentAmount)), fixedDecimals: true, includeSymbol: false);
        _chargeAmountController.text =
            _currency.format((Int64(_totalAmount + _currentAmount)), fixedDecimals: true, includeSymbol: true);
      });
    });
    _posProfileSubscription = widget._posProfileBloc.posProfileStream.listen((posProfile) {
      _posProfile = posProfile;
      cancellationTimeoutValue = _posProfile.cancellationTimeoutValue.toStringAsFixed(0);
    });
    _invoiceReadyNotificationsSubscription = widget._invoiceBloc.readyInvoicesStream.listen((invoiceReady) {
      // show the simple dialog with 3 states
      showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return _nfcDialog;
          }).then((result) {
        setState(() {
          _currentAmount = 0;
          _totalAmount = 0;
          _amountController.text = _currency.format((Int64(_currentAmount)), fixedDecimals: true, includeSymbol: false);
          _chargeAmountController.text =
              _currency.format((Int64(_totalAmount + _currentAmount)), fixedDecimals: true, includeSymbol: true);
          _invoiceDescriptionController.text = "";
        });
      });
    },
        onError: (err) => _scaffoldKey.currentState
            .showSnackBar(new SnackBar(duration: new Duration(seconds: 10), content: new Text(err.toString()))));
  }

  @override
  void didChangeDependencies() {
    itemHeight = (MediaQuery.of(context).size.height - kToolbarHeight - 16) / 4;
    itemWidth = (MediaQuery.of(context).size.width) / 2;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _accountSubscription.cancel();
    _posProfileSubscription.cancel();
    _invoiceReadyNotificationsSubscription.cancel();
    _invoiceNotificationsSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new GestureDetector(
        onTap: () {
          // call this method here to hide soft keyboard
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: new Builder(builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new StreamBuilder<AccountModel>(
                          stream: widget._accountBloc.accountStream,
                          builder: (context, snapshot) {
                            return new StatusIndicator(snapshot.data);
                          }),
                      new Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: new ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: double.infinity),
                          child: new RaisedButton(
                            padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
                            child: new Text(
                              "Charge ${_chargeAmountController.text}".toUpperCase(),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: theme.invoiceChargeAmountStyle,
                            ),
                            onPressed: onInvoiceSubmitted,
                          ),
                        ),
                      ),
                      new Container(
                        height: 50.0,
                        child: new Padding(
                          padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
                          child: new TextField(
                            textInputAction: TextInputAction.done,
                            maxLines: 1,
                            enabled: true,
                            textAlign: TextAlign.left,
                            maxLength: 90,
                            maxLengthEnforced: true,
                            controller: _invoiceDescriptionController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Color(0xFFc5cedd),
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Color(0xFFc5cedd),
                                ),
                              ),
                              hintText: 'Add Note',
                              hintStyle: theme.invoiceMemoStyle,
                            ),
                            style: theme.invoiceMemoStyle,
                          ),
                        ),
                      ),
                      Row(children: <Widget>[
                        new Flexible(
                            child: new TextField(
                          enabled: false,
                          controller: _amountController,
                          style: theme.invoiceAmountStyle,
                          textAlign: TextAlign.right,
                        )),
                        new Theme(
                          data: Theme.of(context).copyWith(
                            brightness: Brightness.light,
                            canvasColor: theme.BreezColors.white[500],
                          ),
                          child: new DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: new DropdownButton(
                                onChanged: (value) => changeCurrency(value),
                                value: _currency.displayName,
                                style: theme.invoiceAmountStyle,
                                items: Currency.currencies.map((Currency value) {
                                  return new DropdownMenuItem<String>(
                                    value: value.displayName,
                                    child: new Text(
                                      value.displayName,
                                      textAlign: TextAlign.right,
                                      style: theme.invoiceAmountStyle,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height * 0.29),
              new Expanded(child: _numPad())
            ],
          );
        }),
      ),
    );
  }

  onInvoiceSubmitted() {
    if (_posProfile.invoiceString == null || _posProfile.logo == null) {
      String errorMessage = "Please";
      if (_posProfile.invoiceString == null) errorMessage += " enter your business name";
      if (_posProfile.logo == null && _posProfile.invoiceString == null) errorMessage += " and ";
      if (_posProfile.logo == null) errorMessage += " select a business logo";
      return showDialog<Null>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text(
                "Required Information",
                style: theme.alertTitleStyle,
              ),
              contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
              content: new SingleChildScrollView(
                child: new Text("$errorMessage in the Settings screen.", style: theme.alertStyle),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Go to Settings", style: theme.buttonStyle),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("/settings");
                  },
                ),
              ],
            );
          });
    } else {
      if (_totalAmount == 0 && _currentAmount > 0) {
        _totalAmount = _currentAmount;
      }

      if (_totalAmount == 0) {
        return null;
      } else if (_totalAmount > _maxAllowedToReceive.toInt()) {
        promptError(
            context,
            "You don't have the capacity to receive such payment.",
            Text(
                "Maximum payment size you can receive is ${_currency.format(_maxAllowedToReceive, includeSymbol: true)}. Please enter a smaller value.",
                style: theme.alertStyle));
      } else if (_totalAmount < _maxPaymentAmount.toInt() || _totalAmount < _maxPaymentAmount.toInt()) {
        widget._invoiceBloc.newInvoiceRequestSink.add(new InvoiceRequestModel(
            _posProfile.invoiceString, _invoiceDescriptionController.text, _posProfile.logo, Int64(_totalAmount),
            expiry: Int64(int.parse(cancellationTimeoutValue)), standard: true));
      } else {
        promptError(
            context,
            "You have exceeded the maximum payment size.",
            Text(
                "Maximum payment size on the Lightning Network is ${_currency.format(_maxPaymentAmount, includeSymbol: true)}. Please enter a smaller value or complete the payment in multiple transactions.",
                style: theme.alertStyle));
      }
    }
  }

  onAddition() {
    setState(() {
      _totalAmount += _currentAmount;
      _chargeAmountController.text = _currency.format((Int64(_totalAmount)), fixedDecimals: true, includeSymbol: true);
      _currentAmount = 0;
      _amountController.text = _currency.format((Int64(_currentAmount)), fixedDecimals: true, includeSymbol: false);
    });
  }

  onNumButtonPressed(String numberText) {
    setState(() {
      _currentAmount = (_currentAmount * 10) + int.parse(numberText);
      _amountController.text = _currency.format((Int64(_currentAmount)), fixedDecimals: true, includeSymbol: false);
      _chargeAmountController.text =
          _currency.format((Int64(_totalAmount + _currentAmount)), fixedDecimals: true, includeSymbol: true);
    });
  }

  changeCurrency(value) {
    setState(() {
      _currency = Currency.fromSymbol(value);
      widget._userProfileBloc.currencySink.add(Currency.currencies[Currency.currencies.indexOf(_currency)]);
    });
  }

  onClear() {
    setState(() {
      _currentAmount = 0;
      _amountController.text = _currency.format((Int64(_currentAmount)), fixedDecimals: true, includeSymbol: false);
      _chargeAmountController.text =
          _currency.format((Int64(_totalAmount + _currentAmount)), fixedDecimals: true, includeSymbol: true);
    });
  }

  clearSale() {
    setState(() {
      _currentAmount = 0;
      _totalAmount = 0;
      _amountController.text = _currency.format((Int64(_currentAmount)), fixedDecimals: true, includeSymbol: false);
      _chargeAmountController.text =
          _currency.format((Int64(_totalAmount + _currentAmount)), fixedDecimals: true, includeSymbol: true);
      _invoiceDescriptionController.text = "";
    });
  }

  approveClear() {
    if (_totalAmount + _currentAmount != 0) {
      AlertDialog dialog = new AlertDialog(
        title: new Text(
          "Clear Sale?",
          textAlign: TextAlign.center,
          style: theme.alertTitleStyle,
        ),
        content: new Text("This will clear the current transaction.", style: theme.alertStyle),
        contentPadding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 12.0, top: 24.0),
        actions: <Widget>[
          new FlatButton(onPressed: () => Navigator.pop(context), child: new Text("Cancel", style: theme.buttonStyle)),
          new FlatButton(
              onPressed: () {
                Navigator.pop(context);
                clearSale();
              },
              child: new Text("Clear", style: theme.buttonStyle))
        ],
      );
      showDialog(context: context, builder: (_) => dialog);
    }
  }

  Container _numberButton(String number) {
    return Container(
        decoration: new BoxDecoration(border: new Border.all(color: Colors.white, width: 0.5)),
        child: new FlatButton(
            onPressed: () => onNumButtonPressed(number),
            child: new Text(number, textAlign: TextAlign.center, style: theme.numPadNumberStyle)));
  }

  Widget _numPad() {
    return new GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (itemWidth / itemHeight),
        padding: EdgeInsets.zero,
        children: List<int>.generate(9, (i) => i).map((index) => _numberButton((index + 1).toString())).followedBy([
          Container(
              decoration: new BoxDecoration(border: new Border.all(color: Colors.white, width: 0.5)),
              child: new GestureDetector(
                  onLongPress: approveClear,
                  child: new FlatButton(onPressed: onClear, child: new Text("C", style: theme.numPadNumberStyle)))),
          _numberButton("0"),
          Container(
              decoration: new BoxDecoration(border: new Border.all(color: Colors.white, width: 0.5)),
              child: new FlatButton(onPressed: onAddition, child: new Text("+", style: theme.numPadAdditionStyle))),
        ]).toList());
  }
}

enum _NfcState { WAITING_FOR_NFC, WAITING_FOR_PAYMENT, PAYMENT_RECEIVED }

class _NfcDialogState extends State<_NfcDialog> {
  _NfcState _state = _NfcState.WAITING_FOR_NFC;
  bool _scanQr = false;
  CountDown _paymentTimer;
  StreamSubscription<Duration> _timerSubscription;
  String _countdownString = "3:00";
  String _debugMessage = "";

  StreamSubscription<String> _sentInvoicesSubscription;
  StreamSubscription<bool> _paidInvoicesSubscription;

  @override
  void initState() {
    super.initState();

    _paymentTimer = CountDown(new Duration(seconds: int.parse(cancellationTimeoutValue)));
    _timerSubscription = _paymentTimer.stream.listen(null);
    _timerSubscription.onData((Duration d) {
      setState(() {
        _countdownString =
            d.inMinutes.toRadixString(10) + ":" + (d.inSeconds - (d.inMinutes * 60)).toRadixString(10).padLeft(2, '0');
      });
    });

    _timerSubscription.onDone(() {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(false);
      }
    });

    _sentInvoicesSubscription = widget._invoiceBloc.sentInvoicesStream.listen((message) {
      _debugMessage = message;

      setState(() {
        _state = _NfcState.WAITING_FOR_PAYMENT;
      });
    }, onError: (err) {
      Navigator.of(context).pop(false);
      widget._scaffoldKey.currentState
          .showSnackBar(new SnackBar(duration: new Duration(seconds: 3), content: new Text(err.toString())));
    });

    _paidInvoicesSubscription = widget._invoiceBloc.paidInvoicesStream.listen((paid) {
      setState(() {
        _state = _NfcState.PAYMENT_RECEIVED;
      });
    }, onError: (err) {
      Navigator.of(context).pop(false);
      widget._scaffoldKey.currentState
          .showSnackBar(new SnackBar(duration: new Duration(seconds: 3), content: new Text(err.toString())));
    });
  }

  @override
  void dispose() {
    _timerSubscription?.cancel();
    _paidInvoicesSubscription?.cancel();
    _sentInvoicesSubscription?.cancel();
    super.dispose();
  }

  Widget _cancelButton() {
    return new FlatButton(
      padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: new Text(
        'CANCEL PAYMENT',
        textAlign: TextAlign.center,
        style: theme.cancelButtonStyle,
      ),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(40.0, 28.0, 40.0, 0.0),
      content: new SingleChildScrollView(
          child: _state == _NfcState.WAITING_FOR_NFC
              ? new ListBody(
                  children: <Widget>[
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 200),
                      firstCurve: Cubic(1.0, 2.0, 1.0, 2.0),
                      secondCurve: Cubic(2.0, 1.0, 2.0, 1.0),
                      sizeCurve: Curves.easeInOut,
                      firstChild: _buildDialogBody(
                          'Hold a Breez card closely to process this payment.',
                          'qr_scan',
                          new Padding(
                            padding: EdgeInsets.only(top: 13.0, left: 12.0, right: 12.0),
                            child: new Image.asset('src/images/breez_nfc.png'),
                          )),
                      secondChild: _buildDialogBody(
                          'Scan the QR code to process this payment.',
                          'card',
                          StreamBuilder<String>(
                              stream: widget._invoiceBloc.readyInvoicesStream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container(
                                    height: 200.0,
                                  );
                                }
                                return new QrImage(
                                  version: 20,
                                  data: snapshot.data,
                                );
                              })),
                      crossFadeState: !_scanQr ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    ),
                    new Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: new Text(_countdownString,
                            textAlign: TextAlign.center, style: theme.paymentRequestTitleStyle)),
                    _cancelButton(),
                  ],
                )
              : _state == _NfcState.WAITING_FOR_PAYMENT
                  ? new ListBody(
                      children: <Widget>[
                        new Text(
                          'Payment request was successfully sent.',
                          textAlign: TextAlign.center,
                          style: theme.paymentRequestTitleStyle,
                        ),
                        new Text('DEBUG: ' + _debugMessage),
                        new Text('Waiting for customer approval...',
                            textAlign: TextAlign.center, style: theme.paymentRequestSubtitleStyle),
                        new Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: new Text(_countdownString,
                                textAlign: TextAlign.center, style: theme.paymentRequestTitleStyle)),
                        new Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: new Image.asset(
                              'src/images/breez_loader.gif',
                              gaplessPlayback: true,
                            )),
                        _cancelButton(),
                      ],
                    )
                  : new GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      child: new ListBody(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(bottom: 40.0),
                            child: new Text(
                              'Payment approved!',
                              textAlign: TextAlign.center,
                              style: theme.paymentRequestTitleStyle,
                            ),
                          ),
                          new Padding(
                              padding: EdgeInsets.only(bottom: 40.0),
                              child: ImageIcon(
                                AssetImage("src/icon/ic_done.png"),
                                size: 48.0,
                                color: Color.fromRGBO(0, 133, 251, 1.0),
                              )),
                        ],
                      ),
                    )),
    );
  }

  ListBody _buildDialogBody(String title, String iconName, Widget body) {
    return new ListBody(children: <Widget>[
      new Text(
        title,
        textAlign: TextAlign.center,
        style: theme.paymentRequestTitleStyle,
      ),
      new IconButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        alignment: Alignment.bottomRight,
        icon: Image(
          image: AssetImage("src/icon/$iconName.png"),
          color: theme.BreezColors.blue[500],
          width: 24.0,
          height: 24.0,
        ),
        onPressed: () {
          setState(() {
            _scanQr = !_scanQr;
          });
        },
      ),
      body
    ]);
  }
}

class _NfcDialog extends StatefulWidget {
  final InvoiceBloc _invoiceBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  _NfcDialog(this._invoiceBloc, this._scaffoldKey);

  @override
  _NfcDialogState createState() {
    return _NfcDialogState();
  }
}

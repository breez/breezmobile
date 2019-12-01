import 'dart:async';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_profile/pos_profile_bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/bloc/pos_profile/pos_profile_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/routes/user/home/status_indicator.dart';
import 'package:breez/widgets/pos_payment_dialog.dart';
import 'package:breez/widgets/breez_dropdown.dart';

var cancellationTimeoutValue;

class POSInvoice extends StatefulWidget {
  POSInvoice();

  @override
  State<StatefulWidget> createState() {
    return POSInvoiceState();
  }
}

class POSInvoiceState extends State<POSInvoice> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _amountController = TextEditingController();
  TextEditingController _chargeAmountController = TextEditingController();
  TextEditingController _invoiceDescriptionController = TextEditingController();

  POSProfileModel _posProfile;
  Currency _currency = Currency.BTC;
  double itemHeight;
  double itemWidth;
  int _currentAmount = 0;
  int _totalAmount = 0;
  Int64 _maxPaymentAmount;
  Int64 _maxAllowedToReceive;
  bool _isButtonDisabled = false;

  AccountBloc _accountBloc;
  InvoiceBloc _invoiceBloc;
  UserProfileBloc _userProfileBloc;
  POSProfileBloc _posProfileBloc;

  StreamSubscription<AccountModel> _accountSubscription;
  StreamSubscription<POSProfileModel> _posProfileSubscription;
  StreamSubscription<String> _invoiceReadyNotificationsSubscription;
  StreamSubscription<String> _invoiceNotificationsSubscription;

  FocusNode _focusNode;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      _invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
      _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      _posProfileBloc = AppBlocsProvider.of<POSProfileBloc>(context);
      registerListeners();
      _isInit = true;
    }
    itemHeight = (MediaQuery.of(context).size.height - kToolbarHeight - 16) / 4;
    itemWidth = (MediaQuery.of(context).size.width) / 2;
    super.didChangeDependencies();
  }

  void registerListeners() {
    _focusNode = FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
    _invoiceDescriptionController.text = "";
    _accountSubscription = _accountBloc.accountStream.listen((acc) {
      setState(() {
        _currency = acc.currency;
        _maxPaymentAmount = acc.maxPaymentAmount;
        _maxAllowedToReceive = acc.maxAllowedToReceive;
        _amountController.text = _currency.format((Int64(_currentAmount)),
            fixedDecimals: true, includeSymbol: false);
        _chargeAmountController.text = _currency.format(
            (Int64(_totalAmount + _currentAmount)),
            fixedDecimals: true,
            includeSymbol: true);
      });
    });
    _posProfileSubscription =
        _posProfileBloc.posProfileStream.listen((posProfile) {
      _posProfile = posProfile;
      cancellationTimeoutValue =
          _posProfile.cancellationTimeoutValue.toStringAsFixed(0);
    });
    _invoiceReadyNotificationsSubscription = _invoiceBloc.readyInvoicesStream
        .listen((invoiceReady) {
      // show the simple dialog with 3 states
      if (invoiceReady != null) {
        showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return PosPaymentDialog(
                  _invoiceBloc, _posProfileBloc, _scaffoldKey);
            }).then((result) {
          setState(() {
            _currentAmount = 0;
            _totalAmount = 0;
            _amountController.text = _currency.format((Int64(_currentAmount)),
                fixedDecimals: true, includeSymbol: false);
            _chargeAmountController.text = _currency.format(
                (Int64(_totalAmount + _currentAmount)),
                fixedDecimals: true,
                includeSymbol: true);
            _invoiceDescriptionController.text = "";
          });
        });
      }
    },
            onError: (err) => _scaffoldKey.currentState.showSnackBar(SnackBar(
                duration: Duration(seconds: 10),
                content: Text(err.toString()))));
  }

  @override
  void dispose() {
    closeListeners();
    _focusNode?.dispose();
    super.dispose();
  }

  void closeListeners() {
    _accountSubscription?.cancel();
    _posProfileSubscription?.cancel();
    _invoiceReadyNotificationsSubscription?.cancel();
    _invoiceNotificationsSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        onTap: () {
          // call this method here to hide soft keyboard
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            _isButtonDisabled = false;
          });
        },
        child: Builder(builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      StreamBuilder<AccountSettings>(
                          stream: _accountBloc.accountSettingsStream,
                          builder: (settingCtx, settingSnapshot) {
                            return StreamBuilder<AccountModel>(
                                stream: _accountBloc.accountStream,
                                builder: (context, snapshot) {
                                  AccountModel acc = snapshot.data;
                                  AccountSettings settings =
                                      settingSnapshot.data;
                                  if (settings?.showConnectProgress == true ||
                                      acc?.isInitialBootstrap == true) {
                                    return StatusIndicator(
                                        context, snapshot.data);
                                  }
                                  return SizedBox();
                                });
                          }),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
                        child: ConstrainedBox(
                          constraints:
                              const BoxConstraints(minWidth: double.infinity),
                          child: IgnorePointer(
                            ignoring: _isButtonDisabled,
                            child: RaisedButton(
                              color: Theme.of(context).primaryColorLight,
                              padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
                              child: Text(
                                "Charge ${_chargeAmountController.text}"
                                    .toUpperCase(),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: theme.invoiceChargeAmountStyle,
                              ),
                              onPressed: () => onInvoiceSubmitted(),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 80.0,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 0.0),
                          child: TextField(
                            focusNode: _focusNode,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
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
                              counterStyle:
                                  Theme.of(context).primaryTextTheme.caption,
                              hintText: 'Add Note',
                              hintStyle: theme.invoiceMemoStyle.copyWith(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .display1
                                      .color),
                            ),
                            style: theme.invoiceMemoStyle.copyWith(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .display1
                                    .color),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Row(children: <Widget>[
                          Flexible(
                              child: TextField(
                            decoration: InputDecoration.collapsed(hintText: ''),
                            enabled: false,
                            controller: _amountController,
                            style: theme.invoiceAmountStyle.copyWith(
                                color:
                                    Theme.of(context).textTheme.headline.color),
                            textAlign: TextAlign.right,
                          )),
                          Theme(
                            data: Theme.of(context).copyWith(
                                canvasColor: Theme.of(context).backgroundColor),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: BreezDropdownButton(
                                  onChanged: (value) => changeCurrency(value),
                                  iconEnabledColor: Theme.of(context)
                                      .textTheme
                                      .headline
                                      .color,
                                  value: _currency.displayName,
                                  style: theme.invoiceAmountStyle.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline
                                          .color),
                                  items:
                                      Currency.currencies.map((Currency value) {
                                    return DropdownMenuItem<String>(
                                      value: value.displayName,
                                      child: Text(
                                        value.displayName,
                                        textAlign: TextAlign.right,
                                        style: theme.invoiceAmountStyle
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline
                                                    .color),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                  ),
                  height: MediaQuery.of(context).size.height * 0.29),
              Expanded(child: _numPad())
            ],
          );
        }),
      ),
    );
  }

  _onOnFocusNodeEvent() {
    setState(() {
      _isButtonDisabled = true;
    });
  }

  onInvoiceSubmitted() {
    if (_posProfile.invoiceString == null || _posProfile.logo == null) {
      String errorMessage = "Please";
      if (_posProfile.invoiceString == null)
        errorMessage += " enter your business name";
      if (_posProfile.logo == null && _posProfile.invoiceString == null)
        errorMessage += " and ";
      if (_posProfile.logo == null) errorMessage += " select a business logo";
      return showDialog<Null>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Required Information",
                style: Theme.of(context).dialogTheme.titleTextStyle,
              ),
              contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
              content: SingleChildScrollView(
                child: Text("$errorMessage in the Settings screen.",
                    style: Theme.of(context).dialogTheme.contentTextStyle),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Go to Settings", style: theme.buttonStyle),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("/settings");
                  },
                ),
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
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
                style: Theme.of(context).dialogTheme.contentTextStyle));
      } else if (_totalAmount < _maxPaymentAmount.toInt() ||
          _totalAmount < _maxPaymentAmount.toInt()) {
        _invoiceBloc.newInvoiceRequestSink.add(InvoiceRequestModel(
            _posProfile.invoiceString,
            _invoiceDescriptionController.text,
            _posProfile.logo,
            Int64(_totalAmount),
            expiry: Int64(int.parse(cancellationTimeoutValue))));
      } else {
        promptError(
            context,
            "You have exceeded the maximum payment size.",
            Text(
                "Maximum payment size on the Lightning Network is ${_currency.format(_maxPaymentAmount, includeSymbol: true)}. Please enter a smaller value or complete the payment in multiple transactions.",
                style: Theme.of(context).dialogTheme.contentTextStyle));
      }
    }
  }

  onAddition() {
    setState(() {
      _totalAmount += _currentAmount;
      _chargeAmountController.text = _currency.format((Int64(_totalAmount)),
          fixedDecimals: true, includeSymbol: true);
      _currentAmount = 0;
      _amountController.text = _currency.format((Int64(_currentAmount)),
          fixedDecimals: true, includeSymbol: false);
    });
  }

  onNumButtonPressed(String numberText) {
    setState(() {
      _currentAmount = (_currentAmount * 10) + int.parse(numberText);
      _amountController.text = _currency.format((Int64(_currentAmount)),
          fixedDecimals: true, includeSymbol: false);
      _chargeAmountController.text = _currency.format(
          (Int64(_totalAmount + _currentAmount)),
          fixedDecimals: true,
          includeSymbol: true);
    });
  }

  changeCurrency(value) {
    setState(() {
      _currency = Currency.fromSymbol(value);
      _userProfileBloc.currencySink
          .add(Currency.currencies[Currency.currencies.indexOf(_currency)]);
    });
  }

  onClear() {
    setState(() {
      _currentAmount = 0;
      _amountController.text = _currency.format((Int64(_currentAmount)),
          fixedDecimals: true, includeSymbol: false);
      _chargeAmountController.text = _currency.format(
          (Int64(_totalAmount + _currentAmount)),
          fixedDecimals: true,
          includeSymbol: true);
    });
  }

  clearSale() {
    setState(() {
      _currentAmount = 0;
      _totalAmount = 0;
      _amountController.text = _currency.format((Int64(_currentAmount)),
          fixedDecimals: true, includeSymbol: false);
      _chargeAmountController.text = _currency.format(
          (Int64(_totalAmount + _currentAmount)),
          fixedDecimals: true,
          includeSymbol: true);
      _invoiceDescriptionController.text = "";
    });
  }

  approveClear() {
    if (_totalAmount + _currentAmount != 0) {
      AlertDialog dialog = AlertDialog(
        title: Text(
          "Clear Sale?",
          textAlign: TextAlign.center,
          style: Theme.of(context).dialogTheme.titleTextStyle,
        ),
        content: Text("This will clear the current transaction.",
            style: Theme.of(context).dialogTheme.contentTextStyle),
        contentPadding:
            EdgeInsets.only(left: 24.0, right: 24.0, bottom: 12.0, top: 24.0),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: theme.buttonStyle)),
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
                clearSale();
              },
              child: Text("Clear", style: theme.buttonStyle))
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
      );
      showDialog(context: context, builder: (_) => dialog);
    }
  }

  Container _numberButton(String number) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).backgroundColor, width: 0.5)),
        child: IgnorePointer(
            ignoring: _isButtonDisabled,
            child: FlatButton(
                onPressed: () => onNumButtonPressed(number),
                child: Text(number,
                    textAlign: TextAlign.center,
                    style: theme.numPadNumberStyle))));
  }

  Widget _numPad() {
    return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (itemWidth / itemHeight),
        padding: EdgeInsets.zero,
        children: List<int>.generate(9, (i) => i)
            .map((index) => _numberButton((index + 1).toString()))
            .followedBy([
          Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).backgroundColor, width: 0.5)),
              child: GestureDetector(
                  onLongPress: approveClear,
                  child: FlatButton(
                      onPressed: onClear,
                      child: Text("C", style: theme.numPadNumberStyle)))),
          _numberButton("0"),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).backgroundColor, width: 0.5)),
              child: FlatButton(
                  onPressed: onAddition,
                  child: Text("+", style: theme.numPadAdditionStyle))),
        ]).toList());
  }
}

import 'dart:math';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/actions.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/breez_dropdown.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/pos_payment_dialog.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import '../status_indicator.dart';

class POSInvoice extends StatefulWidget {
  POSInvoice();

  @override
  State<StatefulWidget> createState() {
    return POSInvoiceState();
  }
}

class POSInvoiceState extends State<POSInvoice> {
  TextEditingController _invoiceDescriptionController = TextEditingController();
  double itemHeight;
  double itemWidth;

  double amount = 0;
  double currentAmount = 0;
  bool _useFiat = false;

  bool _isButtonDisabled = false;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
  }

  @override
  void didChangeDependencies() {
    itemHeight = (MediaQuery.of(context).size.height - kToolbarHeight - 16) / 4;
    itemWidth = (MediaQuery.of(context).size.width) / 2;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    UserProfileBloc userProfileBloc =
        AppBlocsProvider.of<UserProfileBloc>(context);

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
          return StreamBuilder<BreezUserModel>(
              stream: userProfileBloc.userStream,
              builder: (context, snapshot) {
                var userProfile = snapshot.data;
                if (userProfile == null) {
                  return Loader();
                }
                return StreamBuilder<AccountModel>(
                    stream: accountBloc.accountStream,
                    builder: (context, snapshot) {
                      var accountModel = snapshot.data;
                      if (accountModel == null) {
                        return Loader();
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  StreamBuilder<AccountSettings>(
                                      stream: accountBloc.accountSettingsStream,
                                      builder: (settingCtx, settingSnapshot) {
                                        AccountSettings settings =
                                            settingSnapshot.data;
                                        if (settings?.showConnectProgress ==
                                                true ||
                                            accountModel.isInitialBootstrap ==
                                                true) {
                                          return StatusIndicator(
                                              context, snapshot.data);
                                        }
                                        return SizedBox();
                                      }),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 0.0, left: 16.0, right: 16.0),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          minWidth: double.infinity),
                                      child: IgnorePointer(
                                        ignoring: _isButtonDisabled,
                                        child: RaisedButton(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          padding: EdgeInsets.only(
                                              top: 14.0, bottom: 14.0),
                                          child: Text(
                                            "Charge ${_formattedTotalCharge(accountModel)}"
                                                .toUpperCase(),
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style:
                                                theme.invoiceChargeAmountStyle,
                                          ),
                                          onPressed: () => onInvoiceSubmitted(
                                              invoiceBloc,
                                              userProfile,
                                              accountModel),
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
                                        controller:
                                            _invoiceDescriptionController,
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
                                          counterStyle: Theme.of(context)
                                              .primaryTextTheme
                                              .caption,
                                          hintText: 'Add Note',
                                          hintStyle: theme.invoiceMemoStyle
                                              .copyWith(
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
                                    padding: EdgeInsets.only(
                                        left: 16.0, right: 16.0),
                                    child: Row(children: <Widget>[
                                      Expanded(
                                          child: Text(
                                        _formattedCurrentCharge(accountModel),
                                        style: theme.invoiceAmountStyle
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline
                                                    .color),
                                        textAlign: TextAlign.right,
                                      )),
                                      Theme(
                                          data: Theme.of(context).copyWith(
                                              canvasColor: Theme.of(context)
                                                  .backgroundColor),
                                          child:
                                              new StreamBuilder<
                                                      AccountSettings>(
                                                  stream: accountBloc
                                                      .accountSettingsStream,
                                                  builder: (settingCtx,
                                                      settingSnapshot) {
                                                    return StreamBuilder<
                                                            AccountModel>(
                                                        stream: accountBloc
                                                            .accountStream,
                                                        builder: (context,
                                                            snapshot) {
                                                          return DropdownButtonHideUnderline(
                                                            child: ButtonTheme(
                                                              alignedDropdown:
                                                                  true,
                                                              child:
                                                                  BreezDropdownButton(
                                                                      onChanged: (value) => changeCurrency(
                                                                        accountModel,
                                                                          value,
                                                                          userProfileBloc),
                                                                      iconEnabledColor: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline
                                                                          .color,
                                                                      value: _currencySymbol(
                                                                          accountModel),
                                                                      style: theme.invoiceAmountStyle.copyWith(
                                                                          color: Theme.of(context)
                                                                              .textTheme
                                                                              .headline
                                                                              .color),
                                                                      items: Currency
                                                                          .currencies
                                                                          .map((Currency
                                                                              value) {
                                                                        return DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              value.symbol,
                                                                          child:
                                                                              Text(
                                                                            value.displayName,
                                                                            textAlign:
                                                                                TextAlign.right,
                                                                            style:
                                                                                theme.invoiceAmountStyle.copyWith(color: Theme.of(context).textTheme.headline.color),
                                                                          ),
                                                                        );
                                                                      }).toList()
                                                                            ..addAll(
                                                                              accountModel.fiatConversionList.map((FiatConversion fiat) {
                                                                                return new DropdownMenuItem<String>(
                                                                                  value: fiat.currencyData.shortName,
                                                                                  child: new Text(
                                                                                    fiat.currencyData.shortName,
                                                                                    textAlign: TextAlign.right,
                                                                                    style: theme.invoiceAmountStyle.copyWith(color: Theme.of(context).textTheme.headline.color),
                                                                                  ),
                                                                                );
                                                                              }).toList(),
                                                                            )),
                                                            ),
                                                          );
                                                        });
                                                  })),
                                    ]),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                              ),
                              height:
                                  MediaQuery.of(context).size.height * 0.29),
                          Expanded(child: _numPad(accountModel))
                        ],
                      );
                    });
              });
        }),
      ),
    );
  }

  _onOnFocusNodeEvent() {
    setState(() {
      _isButtonDisabled = true;
    });
  }

  onInvoiceSubmitted(
      InvoiceBloc invoiceBloc, BreezUserModel user, AccountModel account) {
    if (user.name == null || user.avatarURL == null) {
      String errorMessage = "Please";
      if (user.name == null) errorMessage += " enter your business name";
      if (user.avatarURL == null && user.name == null) errorMessage += " and ";
      if (user.avatarURL == null) errorMessage += " select a business logo";
      return showDialog<Null>(
          useRootNavigator: false,
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
      var satAmount = _satAmount(account, amount + currentAmount);
      if (satAmount == 0) {
        return null;
      } else if (satAmount > account.maxAllowedToReceive) {
        promptError(
            context,
            "You don't have the capacity to receive such payment.",
            Text(
                "Maximum payment size you can receive is ${account.currency.format(account.maxAllowedToReceive, includeSymbol: true)}. Please enter a smaller value.",
                style: Theme.of(context).dialogTheme.contentTextStyle));
      } else if (satAmount < account.maxPaymentAmount) {
        var newInvoiceAction = NewInvoice(InvoiceRequestModel(user.name,
            _invoiceDescriptionController.text, user.avatarURL, satAmount,
            expiry: Int64(user.cancellationTimeoutValue.toInt())));
        invoiceBloc.actionsSink.add(newInvoiceAction);
        newInvoiceAction.future.then((value) {
          return showPaymentDialog(invoiceBloc, user, value as String);
        }).catchError((error) {
          showFlushbar(context,
              message: error.toString(), duration: Duration(seconds: 10));
        });
      } else {
        promptError(
            context,
            "You have exceeded the maximum payment size.",
            Text(
                "Maximum payment size on the Lightning Network is ${account.currency.format(account.maxPaymentAmount, includeSymbol: true)}. Please enter a smaller value or complete the payment in multiple transactions.",
                style: Theme.of(context).dialogTheme.contentTextStyle));
      }
    }
  }

  Future showPaymentDialog(
      InvoiceBloc invoiceBloc, BreezUserModel user, String payReq) {
    return showDialog<bool>(
        useRootNavigator: false,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PosPaymentDialog(invoiceBloc, user, payReq);
        }).then((result) {
      setState(() {
        clearSale();
      });
    });
  }

  onAddition() {
    setState(() {
      amount += currentAmount;
      currentAmount = 0;
    });
  }

  onNumButtonPressed(AccountModel accountModel, String numberText) {
    setState(() {
      double addition = int.parse(numberText).toDouble();
      if (_useFiat) {
        addition = addition / pow(10, accountModel.fiatCurrency.currencyData.fractionSize);
      }
      currentAmount = currentAmount * 10 + addition;
    });
  }

  changeCurrency(AccountModel accountModel, value, UserProfileBloc userProfileBloc) {
    setState(() {
      Currency currency = Currency.fromSymbol(value);
      if (currency != null) {
        userProfileBloc.currencySink.add(currency);
      } else {
        userProfileBloc.fiatConversionSink.add(value);
      }

      bool flipFiat = _useFiat == (currency != null);
      if (flipFiat) {
        _useFiat = !_useFiat;
        _clearAmounts(clearTotal: true);
      }
    });
  }

  _clearAmounts({bool clearTotal = false}) {
    setState(() {
      amount = currentAmount = 0;
    });
  }

  clearSale() {
    setState(() {
      _clearAmounts(clearTotal: true);
      _invoiceDescriptionController.text = "";
    });
  }

  approveClear() {
    if (amount > 0 || currentAmount > 0) {
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
      showDialog(
          useRootNavigator: false, context: context, builder: (_) => dialog);
    }
  }

  Container _numberButton(AccountModel accountModel, String number) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).backgroundColor, width: 0.5)),
        child: IgnorePointer(
            ignoring: _isButtonDisabled,
            child: FlatButton(
                onPressed: () => onNumButtonPressed(accountModel, number),
                child: Text(number,
                    textAlign: TextAlign.center,
                    style: theme.numPadNumberStyle))));
  }

  Widget _numPad(AccountModel accountModel) {
    return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (itemWidth / itemHeight),
        padding: EdgeInsets.zero,
        children: List<int>.generate(9, (i) => i)
            .map((index) => _numberButton(accountModel, (index + 1).toString()))
            .followedBy([
          Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).backgroundColor, width: 0.5)),
              child: GestureDetector(
                  onLongPress: approveClear,
                  child: FlatButton(
                      onPressed: _clearAmounts,
                      child: Text("C", style: theme.numPadNumberStyle)))),
          _numberButton(accountModel, "0"),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).backgroundColor, width: 0.5)),
              child: FlatButton(
                  onPressed: onAddition,
                  child: Text("+", style: theme.numPadAdditionStyle))),
        ]).toList());
  }

  String _formattedTotalCharge(AccountModel acc) {
    var satoshies = Int64((amount + currentAmount).toInt());
    if (_useFiat) {
      satoshies = _satAmount(acc, amount + currentAmount);
    }
    return acc.currency.format(satoshies, includeSymbol: true);
  }

  String _formattedCurrentCharge(AccountModel acc) {
    return _formattedCharge(acc, currentAmount);
  }

  String _currencySymbol(AccountModel accountModel) {
    return _useFiat
        ? accountModel.fiatCurrency.currencyData.shortName
        : accountModel.currency.symbol;
  }

  String _formattedCharge(AccountModel acc, double charge) {
    if (_useFiat) {
      return (charge)
          .toStringAsFixed(acc.fiatCurrency.currencyData.fractionSize);
    }
    return acc.currency.format(Int64((charge).toInt()),
        fixedDecimals: true, includeSymbol: false);
  }

  Int64 _satAmount(AccountModel acc, double nativeAmount) {
    if (_useFiat) {
      return acc.fiatCurrency.fiatToSat(nativeAmount);
    }
    return acc.currency.toSats(nativeAmount);
  }
}

import 'dart:math';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/actions.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
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
import 'items/items_list.dart';

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
  bool _isKeypadView = true;

  @override
  void didChangeDependencies() {
    itemHeight = (MediaQuery.of(context).size.height - kToolbarHeight - 16) / 4;
    itemWidth = (MediaQuery.of(context).size.width) / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    UserProfileBloc userProfileBloc =
        AppBlocsProvider.of<UserProfileBloc>(context);
    PosCatalogBloc posCatalogBloc =
        AppBlocsProvider.of<PosCatalogBloc>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        onTap: () {
          // call this method here to hide soft keyboard
          FocusScope.of(context).requestFocus(FocusNode());
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
                                        ignoring: false,
                                        child: RaisedButton(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          padding: EdgeInsets.only(
                                              top: 14.0, bottom: 14.0),
                                          child: Text(
                                            "Charge ${_formattedCharge(accountModel, amount + currentAmount)} "
                                                    .toUpperCase() +
                                                _currencySymbol(accountModel,
                                                    showDisplayName: true),
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
                                    padding:
                                        EdgeInsets.only(left: 0.0, right: 16.0),
                                    child: Row(children: <Widget>[
                                      _buildViewSwitch(context),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                _formattedCharge(accountModel,
                                                    currentAmount),
                                                maxLines: 1,
                                                style: theme.invoiceAmountStyle
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline
                                                            .color),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
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
                          Expanded(
                              child: _isKeypadView
                                  ? _numPad(accountModel)
                                  : _itemsView(accountModel, posCatalogBloc))
                        ],
                      );
                    });
              });
        }),
      ),
    );
  }

  GestureDetector _buildViewSwitch(BuildContext context) {
    return GestureDetector(
      onTap: _changeView,
      child: Container(
        padding: EdgeInsets.zero,
        width: itemWidth / 1.5,
        color: Theme.of(context).backgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.dialpad,
                    color: Theme.of(context)
                        .primaryTextTheme
                        .button
                        .color
                        .withOpacity(_isKeypadView ? 1 : 0.5)),
              ),
            ),
            Container(
              height: 20,
              width: 8,
              child: VerticalDivider(
                color: Theme.of(context).primaryTextTheme.button.color,
              ),
            ),
            Expanded(
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.playlist_add,
                    color: Theme.of(context)
                        .primaryTextTheme
                        .button
                        .color
                        .withOpacity(_isKeypadView ? 0.5 : 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _changeView() {
    setState(() {
      _isKeypadView = !_isKeypadView;
    });
  }

  _itemsView(AccountModel accountModel, PosCatalogBloc posCatalogBloc) {
    return StreamBuilder(
      stream: posCatalogBloc.itemsStream,
      builder: (context, snapshot) {
        var posCatalog = snapshot.data;
        if (posCatalog == null) {
          return Loader();
        }
        return Scaffold(
          body: _buildCatalogContent(accountModel, posCatalogBloc, posCatalog),
          floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              backgroundColor: Theme.of(context).buttonColor,
              foregroundColor: Theme.of(context).textTheme.button.color,
              onPressed: () => Navigator.of(context).pushNamed("/create_item")),
        );
      },
    );
  }

  _buildCatalogContent(AccountModel accountModel, PosCatalogBloc posCatalogBloc,
      List<Item> catalogItems) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ListView(
        primary: false,
        shrinkWrap: true,
        children: <Widget>[
/*        TextField(
            onChanged: (value) {},
            enabled: catalogItems != null,
            decoration: InputDecoration(
                hintText: "Search Items",
                prefixIcon: Icon(Icons.search),
                border: UnderlineInputBorder()),
          ),*/
          catalogItems?.length == 0
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.only(top: 160.0),
                  child: Text("Please add items to use catalog"),
                ))
              : ItemsList(accountModel, posCatalogBloc, catalogItems, _addItem)
        ],
      ),
    );
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
                  child: Text("Go to Settings",
                      style: Theme.of(context).primaryTextTheme.button),
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
      }

      if (satAmount > account.maxAllowedToReceive) {
        promptError(
            context,
            "You don't have the capacity to receive such payment.",
            Text(
                "Maximum payment size you can receive is ${account.currency.format(account.maxAllowedToReceive, includeSymbol: true)}. Please enter a smaller value.",
                style: Theme.of(context).dialogTheme.contentTextStyle));
        return;
      }

      if (satAmount > account.maxPaymentAmount) {
        promptError(
            context,
            "You have exceeded the maximum payment size.",
            Text(
                "Maximum payment size on the Lightning Network is ${account.currency.format(account.maxPaymentAmount, includeSymbol: true)}. Please enter a smaller value or complete the payment in multiple transactions.",
                style: Theme.of(context).dialogTheme.contentTextStyle));
        return;
      }

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

  _addItem(AccountModel accountModel, String symbol, Int64 itemPriceInSat) {
    var itemPrice = _useFiat
        ? accountModel.fiatCurrency.satToFiat(itemPriceInSat)
        : itemPriceInSat.toDouble();
    setState(() {
      amount += itemPrice;
    });
  }

  onNumButtonPressed(AccountModel accountModel, String numberText) {
    setState(() {
      double addition = int.parse(numberText).toDouble();
      if (_useFiat) {
        addition = addition /
            pow(10, accountModel.fiatCurrency.currencyData.fractionSize);
      }
      currentAmount = currentAmount * 10 + addition;
    });
  }

  changeCurrency(
      AccountModel accountModel, value, UserProfileBloc userProfileBloc) {
    setState(() {
      Currency currency = Currency.fromSymbol(value);
      if (currency != null) {
        userProfileBloc.currencySink.add(currency);
      } else {
        userProfileBloc.fiatConversionSink.add(value);
      }

      bool flipFiat = _useFiat == (currency != null);
      Int64 oldSatAmount = _satAmount(accountModel, amount);
      if (flipFiat) {
        _useFiat = !_useFiat;
        _clearAmounts();
      }
      amount = oldSatAmount.toDouble();

      // We need to convert only in case we use fiat.
      if (_useFiat) {
        amount = accountModel
            .getFiatCurrencyByShortName(value)
            .satToFiat(oldSatAmount);
      }
    });
  }

  _clearAmounts({bool clearTotal = false}) {
    setState(() {
      clearTotal ? amount = currentAmount = 0 : currentAmount = 0;
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
              child: Text("Cancel",
                  style: Theme.of(context).primaryTextTheme.button)),
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
                clearSale();
              },
              child: Text("Clear",
                  style: Theme.of(context).primaryTextTheme.button))
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
        child: FlatButton(
            onPressed: () => onNumButtonPressed(accountModel, number),
            child: Text(number,
                textAlign: TextAlign.center, style: theme.numPadNumberStyle)));
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
                      onPressed: () {
                        _clearAmounts();
                      },
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

  String _formattedCharge(AccountModel acc, double nativeAmount,
      {bool userInput = false}) {
    return _useFiat
        ? (nativeAmount)
            .toStringAsFixed(acc.fiatCurrency.currencyData.fractionSize)
        : acc.currency.format(Int64((nativeAmount).toInt()),
            includeSymbol: false, userInput: userInput);
  }

  String _currencySymbol(AccountModel accountModel,
      {bool showDisplayName = false}) {
    return _useFiat
        ? accountModel.fiatCurrency.currencyData.shortName
        : showDisplayName
            ? accountModel.currency.displayName
            : accountModel.currency.symbol;
  }

  Int64 _satAmount(AccountModel acc, double nativeAmount) {
    return _useFiat
        ? acc.fiatCurrency.fiatToSat(nativeAmount)
        : acc.currency
            .parse(_formattedCharge(acc, nativeAmount, userInput: true));
  }
}

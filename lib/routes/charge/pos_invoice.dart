import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/actions.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/routes/charge/sale_view.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/breez_dropdown.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/pos_payment_dialog.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../status_indicator.dart';
import 'items/item_avatar.dart';
import 'items/items_list.dart';

class POSInvoice extends StatefulWidget {
  POSInvoice();

  @override
  State<StatefulWidget> createState() {
    return POSInvoiceState();
  }
}

class POSInvoiceState extends State<POSInvoice> with TickerProviderStateMixin {
  final GlobalKey badgeKey = GlobalKey();

  TextEditingController _invoiceDescriptionController = TextEditingController();
  TextEditingController _itemFilterController = TextEditingController();

  double itemHeight;
  double itemWidth;
  bool _useFiat = false;
  CurrencyWrapper currentCurrency;
  bool _isKeypadView = true;
  SaleLine currentPendingItem;
  StreamSubscription accountSubscription;
  StreamSubscription<Sale> currentSaleSubscription;
  Animation<RelativeRect> _transitionAnimation;
  Animation<double> _scaleTransition;
  Animation<double> _opacityTransition;
  Item _itemInTransition;
  Future _fetchRatesActionFuture;

  double get currentAmount => currentPendingItem?.total ?? 0;

  @override
  void didChangeDependencies() {
    PosCatalogBloc posCatalogBloc =
        AppBlocsProvider.of<PosCatalogBloc>(context);
    itemHeight = (MediaQuery.of(context).size.height - kToolbarHeight - 16) / 4;
    itemWidth = (MediaQuery.of(context).size.width) / 2;
    if (accountSubscription == null) {
      AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      accountSubscription = accountBloc.accountStream.listen((acc) {
        currentCurrency =
            CurrencyWrapper.fromShortName(acc.posCurrencyShortName, acc) ??
                CurrencyWrapper.fromBTC(Currency.BTC);
      });

      FetchRates fetchRatesAction = FetchRates();
      accountBloc.userActionsSink.add(fetchRatesAction);
      setState(() {
        _fetchRatesActionFuture = fetchRatesAction.future;
      });
      _fetchRatesActionFuture.catchError((err) {
        if (this.mounted) {
          setState(() {
            showFlushbar(context,
                message: "Failed to retrieve fiat exchange rates.");
          });
        }
      });

      _itemFilterController.addListener(
        () {
          FilterItems filterItems = FilterItems(_itemFilterController.text);
          posCatalogBloc.actionsSink.add(filterItems);
        },
      );

      currentSaleSubscription = posCatalogBloc.currentSaleStream.listen((s) {
        if (currentPendingItem == null || !this.mounted) {
          return;
        }

        // if the current pending item does not exist, then it was removed.
        if (s.saleLines.firstWhere(
                (s) => s.isCustom && s.itemName == currentPendingItem.itemName,
                orElse: () => null) ==
            null) {
          setState(() {
            currentPendingItem = null;
          });
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    accountSubscription.cancel();
    currentSaleSubscription?.cancel();
    super.dispose();
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
      body: StreamBuilder<Sale>(
          stream: posCatalogBloc.currentSaleStream,
          builder: (context, saleSnapshot) {
            var currentSale = saleSnapshot.data;
            return GestureDetector(
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
                        return Center(child: Loader());
                      }
                      return StreamBuilder<AccountModel>(
                          stream: accountBloc.accountStream,
                          builder: (context, snapshot) {
                            var accountModel = snapshot.data;
                            if (accountModel == null) {
                              return Container();
                            }

                            return FutureBuilder(
                              initialData: "Loading",
                              future: _fetchRatesActionFuture,
                              builder: (context, snapshot) {
                                if (snapshot.data == "Loading") {
                                  return Center(child: Loader());
                                }

                                double totalAmount =
                                    currentSale.totalChargeSat /
                                        currentCurrency.satConversionRate;
                                return Stack(
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                StreamBuilder<AccountSettings>(
                                                    stream: accountBloc
                                                        .accountSettingsStream,
                                                    builder: (settingCtx,
                                                        settingSnapshot) {
                                                      AccountSettings settings =
                                                          settingSnapshot.data;
                                                      if (settings?.showConnectProgress ==
                                                              true ||
                                                          accountModel
                                                                  .isInitialBootstrap ==
                                                              true) {
                                                        return StatusIndicator(
                                                            context,
                                                            snapshot.data);
                                                      }
                                                      return SizedBox();
                                                    }),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 0.0,
                                                      left: 16.0,
                                                      right: 16.0,
                                                      bottom: 24.0),
                                                  child: ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints(
                                                            minWidth: double
                                                                .infinity),
                                                    child: IgnorePointer(
                                                      ignoring: false,
                                                      child: RaisedButton(
                                                        color: Theme.of(context)
                                                            .primaryColorLight,
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 14.0,
                                                                bottom: 14.0),
                                                        child: Text(
                                                          "Charge ${currentCurrency.format(totalAmount)} ${currentCurrency.shortName}"
                                                              .toUpperCase(),
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: theme
                                                              .invoiceChargeAmountStyle,
                                                        ),
                                                        onPressed: () {
                                                          onInvoiceSubmitted(
                                                              currentSale,
                                                              invoiceBloc,
                                                              userProfile,
                                                              accountModel);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 24),
                                                  child:
                                                      _buildViewSwitch(context),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 0.0, right: 16.0),
                                                  child: Row(children: <Widget>[
                                                    Expanded(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child:
                                                                GestureDetector(
                                                                    behavior:
                                                                        HitTestBehavior
                                                                            .translucent,
                                                                    onTap: () {
                                                                      var currentSaleRoute = CupertinoPageRoute(
                                                                          fullscreenDialog: true,
                                                                          builder: (_) => SaleView(
                                                                                onCharge: (accModel, sale) {
                                                                                  onInvoiceSubmitted(sale, invoiceBloc, userProfile, accModel);
                                                                                },
                                                                                onDeleteSale: () => approveClear(currentSale),
                                                                              ));
                                                                      Navigator.of(
                                                                              context)
                                                                          .push(
                                                                              currentSaleRoute);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      width:
                                                                          80.0,
                                                                      child:
                                                                          Badge(
                                                                        key:
                                                                            badgeKey,
                                                                        position: BadgePosition.topRight(
                                                                            top:
                                                                                5,
                                                                            right:
                                                                                -10),
                                                                        animationType:
                                                                            BadgeAnimationType.scale,
                                                                        badgeColor: Theme.of(context)
                                                                            .floatingActionButtonTheme
                                                                            .backgroundColor,
                                                                        badgeContent:
                                                                            Text(
                                                                          currentSale
                                                                              .totalNumOfItems
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 20.0,
                                                                              bottom: 8.0,
                                                                              right: 4.0,
                                                                              top: 20.0),
                                                                          child:
                                                                              Image.asset(
                                                                            "src/icon/cart.png",
                                                                            width:
                                                                                24.0,
                                                                            color:
                                                                                Theme.of(context).primaryTextTheme.button.color,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )))),
                                                    Expanded(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            8.0),
                                                                child: Text(
                                                                  _isKeypadView
                                                                      ? currentCurrency
                                                                          .format(
                                                                              currentAmount)
                                                                      : "",
                                                                  maxLines: 1,
                                                                  style: theme
                                                                      .invoiceAmountStyle
                                                                      .copyWith(
                                                                          color: Theme.of(context)
                                                                              .textTheme
                                                                              .headline
                                                                              .color),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                ),
                                                              ),
                                                            ))),
                                                    Theme(
                                                        data: Theme.of(context).copyWith(
                                                            canvasColor: Theme
                                                                    .of(context)
                                                                .backgroundColor),
                                                        child: new StreamBuilder<
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
                                                                    List<CurrencyWrapper>
                                                                        currencies =
                                                                        Currency
                                                                            .currencies
                                                                            .map((c) =>
                                                                                CurrencyWrapper.fromBTC(c))
                                                                            .toList();
                                                                    currencies
                                                                      ..addAll(accountModel
                                                                          .fiatConversionList
                                                                          .map((f) =>
                                                                              CurrencyWrapper.fromFiat(f)));

                                                                    return DropdownButtonHideUnderline(
                                                                      child:
                                                                          ButtonTheme(
                                                                        alignedDropdown:
                                                                            true,
                                                                        child: BreezDropdownButton(
                                                                            onChanged: (value) => changeCurrency(currentSale, value, userProfileBloc, accountModel),
                                                                            iconEnabledColor: Theme.of(context).textTheme.headline.color,
                                                                            value: currentCurrency.shortName,
                                                                            style: theme.invoiceAmountStyle.copyWith(color: Theme.of(context).textTheme.headline.color),
                                                                            items: Currency.currencies.map((Currency value) {
                                                                              return DropdownMenuItem<String>(
                                                                                value: value.tickerSymbol,
                                                                                child: Material(
                                                                                  child: Text(
                                                                                    value.tickerSymbol.toUpperCase(),
                                                                                    textAlign: TextAlign.right,
                                                                                    style: theme.invoiceAmountStyle.copyWith(color: Theme.of(context).textTheme.headline.color),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }).toList()
                                                                              ..addAll(
                                                                                accountModel.fiatConversionList.map((FiatConversion fiat) {
                                                                                  return new DropdownMenuItem<String>(
                                                                                    value: fiat.currencyData.shortName,
                                                                                    child: Material(
                                                                                      child: new Text(
                                                                                        fiat.currencyData.shortName,
                                                                                        textAlign: TextAlign.right,
                                                                                        style: theme.invoiceAmountStyle.copyWith(color: Theme.of(context).textTheme.headline.color),
                                                                                      ),
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
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.29),
                                        Expanded(
                                            child: _isKeypadView
                                                ? _numPad(
                                                    posCatalogBloc, currentSale)
                                                : _itemsView(
                                                    currentSale,
                                                    accountModel,
                                                    posCatalogBloc))
                                      ],
                                    ),
                                    _itemInTransition != null
                                        ? Positioned(
                                            child: ScaleTransition(
                                              scale: _scaleTransition,
                                              child: Opacity(
                                                opacity:
                                                    _opacityTransition.value,
                                                child: ItemAvatar(
                                                    _itemInTransition.imageURL),
                                              ),
                                            ),
                                            left:
                                                _transitionAnimation.value.left,
                                            top: _transitionAnimation.value.top)
                                        : SizedBox()
                                  ],
                                );
                              },
                            );
                          });
                    });
              }),
            );
          }),
    );
  }

  Widget _buildViewSwitch(BuildContext context) {
    // This method is a work-around to center align the buttons
    // Use Align to stick items to center and set padding to give equal distance
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => _changeView(true),
                child: Padding(
                  padding: EdgeInsets.only(right: itemWidth / 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.dialpad,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .button
                                .color
                                .withOpacity(_isKeypadView ? 1 : 0.5)),
                      ),
                      Text(
                        "Keypad",
                        style: Theme.of(context).textTheme.button.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .button
                                .color
                                .withOpacity(_isKeypadView ? 1 : 0.5)),
                      )
                    ],
                  ),
                )),
          ),
        ),
        Container(
          height: 20,
          child: VerticalDivider(
            color: Theme.of(context).primaryTextTheme.button.color,
          ),
        ),
        Flexible(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => _changeView(false),
                child: Padding(
                  padding: EdgeInsets.only(left: itemWidth / 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.playlist_add,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .button
                                .color
                                .withOpacity(!_isKeypadView ? 1 : 0.5)),
                      ),
                      Text(
                        "Items",
                        style: Theme.of(context).textTheme.button.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .button
                                .color
                                .withOpacity(!_isKeypadView ? 1 : 0.5)),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ],
    );
  }

  _changeView(bool isKeypadView) {
    setState(() {
      _isKeypadView = isKeypadView;
    });
  }

  _itemsView(Sale currentSale, AccountModel accountModel,
      PosCatalogBloc posCatalogBloc) {
    return StreamBuilder(
      stream: posCatalogBloc.itemsStream,
      builder: (context, snapshot) {
        var posCatalog = snapshot.data;
        if (posCatalog == null) {
          return Loader();
        }
        return Scaffold(
          body: _buildCatalogContent(
              currentSale, accountModel, posCatalogBloc, posCatalog),
          floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              backgroundColor: Theme.of(context).buttonColor,
              foregroundColor: Theme.of(context).textTheme.button.color,
              onPressed: () => Navigator.of(context).pushNamed("/add_item")),
        );
      },
    );
  }

  _buildCatalogContent(Sale currentSale, AccountModel accountModel,
      PosCatalogBloc posCatalogBloc, List<Item> catalogItems) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 0,
          child: TextField(
            controller: _itemFilterController,
            enabled: catalogItems != null,
            decoration: InputDecoration(
                hintText: "Search for name or SKU",
                contentPadding: const EdgeInsets.only(top: 16, left: 16),
                suffixIcon: IconButton(
                  icon: Icon(
                    _itemFilterController.text.isEmpty
                        ? Icons.search
                        : Icons.close,
                    size: 20,
                  ),
                  onPressed: _itemFilterController.text.isEmpty
                      ? null
                      : () {
                          _itemFilterController.text = "";
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                  padding: EdgeInsets.only(right: 24, top: 4),
                ),
                border: UnderlineInputBorder()),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListView(
              primary: false,
              shrinkWrap: true,
              children: <Widget>[
                catalogItems?.length == 0
                    ? Padding(
                        padding: const EdgeInsets.only(
                            top: 180.0, left: 40.0, right: 40.0),
                        child: AutoSizeText(
                          _itemFilterController.text.isNotEmpty
                              ? "No matching items found."
                              : "No items to display.\nAdd items to this view using the '+' button.",
                          textAlign: TextAlign.center,
                          minFontSize: MinFontSize(context).minFontSize,
                          stepGranularity: 0.1,
                        ),
                      )
                    : ItemsList(
                        accountModel,
                        posCatalogBloc,
                        catalogItems,
                        (item, avatarKey) => _addItem(posCatalogBloc,
                            currentSale, accountModel, item, avatarKey))
              ],
            ),
          ),
        ),
      ],
    );
  }

  onInvoiceSubmitted(Sale currentSale, InvoiceBloc invoiceBloc,
      BreezUserModel user, AccountModel account) {
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
      var satAmount = currentSale.totalChargeSat;
      if (satAmount == 0) {
        return null;
      }

      if (satAmount > account.maxAllowedToReceive.toDouble()) {
        promptError(
            context,
            "You don't have the capacity to receive such payment.",
            Text(
                "Maximum payment size you can receive is ${account.currency.format(account.maxAllowedToReceive, includeDisplayName: true)}. Please enter a smaller value.",
                style: Theme.of(context).dialogTheme.contentTextStyle));
        return;
      }

      if (satAmount > account.maxPaymentAmount.toDouble()) {
        promptError(
            context,
            "You have exceeded the maximum payment size.",
            Text(
                "Maximum payment size on the Lightning Network is ${account.currency.format(account.maxPaymentAmount, includeDisplayName: true)}. Please enter a smaller value or complete the payment in multiple transactions.",
                style: Theme.of(context).dialogTheme.contentTextStyle));
        return;
      }
      PosCatalogBloc posCatalogBloc =
          AppBlocsProvider.of<PosCatalogBloc>(context);
      var lockSale = SetCurrentSale(currentSale.copyWith(priceLocked: true));
      posCatalogBloc.actionsSink.add(lockSale);
      lockSale.future.then((value) {
        var newInvoiceAction = NewInvoice(InvoiceRequestModel(
            user.name,
            _invoiceDescriptionController.text,
            user.avatarURL,
            Int64(satAmount.toInt()),
            expiry: Int64(user.cancellationTimeoutValue.toInt())));
        invoiceBloc.actionsSink.add(newInvoiceAction);
        newInvoiceAction.future.then((value) {
          var payReq = value as PaymentRequestModel;
          var addSaleAction = SubmitCurrentSale(payReq.paymentHash);
          posCatalogBloc.actionsSink.add(addSaleAction);
          return addSaleAction.future.then((value) {
            return showPaymentDialog(invoiceBloc, user, payReq.rawPayReq);
          });
        }).then((cleared) {
          if (!cleared) {
            var unLockSale =
                SetCurrentSale(currentSale.copyWith(priceLocked: false));
            posCatalogBloc.actionsSink.add(unLockSale);
          }
        }).catchError((error) {
          showFlushbar(context,
              message: error.toString(), duration: Duration(seconds: 10));
        });
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
        }).then((clear) {
      if (clear == true) {
        clearSale();
        return true;
      }
      return false;
    });
  }

  onAddition(PosCatalogBloc posCatalogBloc, Sale currentSale,
      double satConversionRate) {
    setState(() {
      currentPendingItem = null;
    });
  }

  _addItem(PosCatalogBloc posCatalogBloc, Sale currentSale,
      AccountModel account, Item item, GlobalKey avatarKey) {
    var itemCurrency = CurrencyWrapper.fromShortName(item.currency, account);

    setState(() {
      var newSale = currentSale.addItem(item, itemCurrency.satConversionRate);
      posCatalogBloc.actionsSink.add(SetCurrentSale(newSale));
      currentPendingItem = null;
      _animateAddItem(item, avatarKey);
    });
  }

  void _animateAddItem(Item item, GlobalKey avatarKey) {
    // start position
    RenderBox avatarPos = avatarKey.currentContext.findRenderObject();
    var startPos = avatarPos.localToGlobal(Offset.zero,
        ancestor: this.context.findRenderObject());
    var begin = RelativeRect.fromLTRB(startPos.dx, startPos.dy, 0, 0);

    // end position
    RenderBox cartBox = badgeKey.currentContext.findRenderObject();
    var endPos = cartBox.localToGlobal(Offset.zero,
        ancestor: this.context.findRenderObject());
    var end = RelativeRect.fromLTRB(startPos.dx, endPos.dy, 0, 0);

    var tween = RelativeRectTween(begin: begin, end: end);

    var controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));

    //CurveTween(curve: Curves.easeInOut).
    _transitionAnimation =
        tween.chain(CurveTween(curve: Curves.easeOutCubic)).animate(controller);
    _itemInTransition = item;

    // handle scale animation.
    var scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _scaleTransition = CurvedAnimation(
        parent: scaleController, curve: Curves.easeInExpo.flipped);

    // handle opcity animation.
    var opacityController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _opacityTransition =
        CurvedAnimation(parent: opacityController, curve: Curves.easeInExpo);

    controller.addListener(() {
      setState(() {
        if (controller.status == AnimationStatus.completed) {
          controller.dispose();
          scaleController.dispose();
          opacityController.dispose();
          if (_itemInTransition == item) {
            _itemInTransition = null;
          }
        }
      });
    });

    scaleController.reverse(from: 1.0);
    opacityController.forward(from: 0.7);
    controller.forward();
  }

  onNumButtonPressed(Sale currentSale, String numberText) {
    PosCatalogBloc posCatalogBloc =
        AppBlocsProvider.of<PosCatalogBloc>(context);
    setState(() {
      double addition = int.parse(numberText).toDouble() /
          pow(10, currentCurrency.fractionSize);
      var newSale = currentSale;
      var newPrice = currentAmount * 10 + addition;
      if (currentPendingItem == null) {
        newSale = currentSale.addCustomItem(newPrice, currentCurrency.shortName,
            currentCurrency.satConversionRate);
        currentPendingItem = newSale.saleLines.last;
      } else {
        currentPendingItem =
            currentPendingItem.copywith(pricePerItem: newPrice);
        newSale = currentSale.updateItems((sl) {
          if (sl.isCustom && sl.itemName == currentPendingItem.itemName) {
            return currentPendingItem;
          }
          return sl;
        });
      }
      posCatalogBloc.actionsSink.add(SetCurrentSale(newSale));
    });
  }

  changeCurrency(Sale currentSale, String value,
      UserProfileBloc userProfileBloc, AccountModel accountModel) {
    setState(() {
      Currency currency = Currency.fromTickerSymbol(value);

      bool flipFiat = _useFiat == (currency != null);
      if (flipFiat) {
        _useFiat = !_useFiat;
      }
      _clearAmounts(currentSale);

      if (currency != null) {
        userProfileBloc.currencySink.add(currency);
      } else {
        userProfileBloc.fiatConversionSink.add(value);
      }
      SetPOSCurrency setPOSCurrency = SetPOSCurrency(value);
      userProfileBloc.userActionsSink.add(setPOSCurrency);
    });
  }

  _clearAmounts(Sale currentSale) {
    PosCatalogBloc posCatalogBloc =
        AppBlocsProvider.of<PosCatalogBloc>(context);
    setState(() {
      if (currentPendingItem != null) {
        currentSale = currentSale.removeItem(
            (sl) => sl.isCustom && sl.itemName == currentPendingItem.itemName);
        currentPendingItem = null;
        posCatalogBloc.actionsSink.add(SetCurrentSale(currentSale));
      }
    });
  }

  clearSale() {
    PosCatalogBloc posCatalogBloc =
        AppBlocsProvider.of<PosCatalogBloc>(context);
    setState(() {
      currentPendingItem = null;
      _invoiceDescriptionController.text = "";
      posCatalogBloc.actionsSink.add(SetCurrentSale(Sale(saleLines: [])));
    });
  }

  approveClear(Sale currentSale) {
    if (currentSale.totalChargeSat > 0 || currentAmount > 0) {
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

  Container _numberButton(Sale currentSale, String number) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).backgroundColor, width: 0.5)),
        child: FlatButton(
            onPressed: () => onNumButtonPressed(currentSale, number),
            child: Text(number,
                textAlign: TextAlign.center, style: theme.numPadNumberStyle)));
  }

  Widget _numPad(PosCatalogBloc posCatalogBloc, Sale currentSale) {
    return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (itemWidth / itemHeight),
        padding: EdgeInsets.zero,
        children: List<int>.generate(9, (i) => i)
            .map((index) => _numberButton(currentSale, (index + 1).toString()))
            .followedBy([
          Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).backgroundColor, width: 0.5)),
              child: GestureDetector(
                  onLongPress: () => approveClear(currentSale),
                  child: FlatButton(
                      onPressed: () {
                        _clearAmounts(currentSale);
                      },
                      child: Text("C", style: theme.numPadNumberStyle)))),
          _numberButton(currentSale, "0"),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).backgroundColor, width: 0.5)),
              child: FlatButton(
                  onPressed: () => onAddition(posCatalogBloc, currentSale,
                      currentCurrency.satConversionRate),
                  child: Text("+", style: theme.numPadAdditionStyle))),
        ]).toList());
  }
}

import 'dart:async';
import 'dart:math';

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
import 'package:breez/routes/charge/pos_invoice_cart_bar.dart';
import 'package:breez/routes/charge/pos_invoice_items_view.dart';
import 'package:breez/routes/charge/pos_invoice_num_pad.dart';
import 'package:breez/routes/charge/successful_payment.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/print_pdf.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/print_parameters.dart';
import 'package:breez/widgets/transparent_page_route.dart';
import 'package:breez/widgets/view_switch.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../sync_progress_dialog.dart';
import 'items/item_avatar.dart';
import 'pos_payment_dialog.dart';

class POSInvoice extends StatefulWidget {
  POSInvoice();

  @override
  State<StatefulWidget> createState() {
    return POSInvoiceState();
  }
}

class POSInvoiceState extends State<POSInvoice> with TickerProviderStateMixin {
  final GlobalKey badgeKey = GlobalKey();

  TextEditingController _itemFilterController = TextEditingController();

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

  double get currentAmount => currentPendingItem?.totalFiat ?? 0;

  @override
  void didChangeDependencies() {
    final texts = AppLocalizations.of(context);
    final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);

    if (accountSubscription == null) {
      AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      accountSubscription = accountBloc.accountStream.listen((acc) {
        currentCurrency =
            CurrencyWrapper.fromShortName(acc.posCurrencyShortName, acc) ??
                CurrencyWrapper.fromBTC(Currency.SAT);
      });

      FetchRates fetchRatesAction = FetchRates();
      accountBloc.userActionsSink.add(fetchRatesAction);
      _fetchRatesActionFuture = fetchRatesAction.future;
      _fetchRatesActionFuture.catchError((err) {
        if (this.mounted) {
          setState(() {
            showFlushbar(
              context,
              message: texts.pos_invoice_error_fiat_exchange_rates,
            );
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

      posCatalogBloc.selectedPosTabStream.listen((tab) {
        _changeView(tab == "KEYPAD");
      });

      super.didChangeDependencies();
    }
  }

  @override
  void dispose() {
    accountSubscription.cancel();
    currentSaleSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    final invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);

    return Scaffold(
      body: StreamBuilder<Sale>(
        stream: posCatalogBloc.currentSaleStream,
        builder: (context, saleSnapshot) {
          var currentSale = saleSnapshot.data;
          return GestureDetector(
            onTap: () {
              // call this method here to hide soft keyboard
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Builder(
              builder: (BuildContext context) {
                return StreamBuilder<BreezUserModel>(
                  stream: userProfileBloc.userStream,
                  builder: (context, snapshot) {
                    final userProfile = snapshot.data;
                    if (userProfile == null) {
                      return Center(child: Loader());
                    }

                    return StreamBuilder<AccountModel>(
                      stream: accountBloc.accountStream,
                      builder: (context, snapshot) {
                        final accountModel = snapshot.data;
                        if (accountModel == null) {
                          return Container();
                        }

                        return FutureBuilder(
                          initialData: [],
                          future: _fetchRatesActionFuture,
                          builder: (context, snapshot) {
                            List<FiatConversion> rates = [];
                            if (snapshot.hasData) {
                              final data = snapshot.data;
                              if (data is List<FiatConversion>) {
                                rates.addAll(data);
                              }
                            }

                            return _body(
                              context,
                              accountBloc,
                              userProfileBloc,
                              posCatalogBloc,
                              invoiceBloc,
                              userProfile,
                              accountModel,
                              currentSale,
                              rates,
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _body(
    BuildContext context,
    AccountBloc accountBloc,
    UserProfileBloc userProfileBloc,
    PosCatalogBloc posCatalogBloc,
    InvoiceBloc invoiceBloc,
    BreezUserModel userProfile,
    AccountModel accountModel,
    Sale currentSale,
    List<FiatConversion> rates,
  ) {
    final persistedCurrency = CurrencyWrapper.fromShortName(
      accountModel.posCurrencyShortName,
      accountModel,
    );
    if (persistedCurrency == null && rates.isEmpty) {
      return Center(child: Loader());
    }
    final totalAmount =
        currentSale.totalChargeSat / currentCurrency.satConversionRate;

    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _chargeButton(
                    context,
                    invoiceBloc,
                    userProfile,
                    accountModel,
                    currentSale,
                    totalAmount,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildViewSwitch(context),
                  ),
                  PosInvoiceCartBar(
                    badgeKey: badgeKey,
                    currentSale: currentSale,
                    accountModel: accountModel,
                    currentCurrency: currentCurrency,
                    isKeypadView: _isKeypadView,
                    currentAmount: currentAmount,
                    onInvoiceSubmit: () => _onInvoiceSubmitted(
                      context,
                      currentSale,
                      invoiceBloc,
                      userProfile,
                      accountModel,
                    ),
                    approveClear: () => _approveClear(
                      context,
                      currentSale,
                    ),
                    changeCurrency: (currency) => _changeCurrency(
                      currentSale,
                      currency,
                      userProfileBloc,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              height: max(184.0, MediaQuery.of(context).size.height * 0.3),
            ),
            _tabBody(
              context,
              posCatalogBloc,
              accountModel,
              currentSale,
            ),
          ],
        ),
        _itemInTransition != null
            ? Positioned(
                child: ScaleTransition(
                  scale: _scaleTransition,
                  child: Opacity(
                    opacity: _opacityTransition.value,
                    child: ItemAvatar(
                      _itemInTransition.imageURL,
                      itemName: _itemInTransition.name,
                    ),
                  ),
                ),
                left: _transitionAnimation.value.left,
                top: _transitionAnimation.value.top,
              )
            : SizedBox(),
      ],
    );
  }

  Widget _chargeButton(
    BuildContext context,
    InvoiceBloc invoiceBloc,
    BreezUserModel userProfile,
    AccountModel accountModel,
    Sale currentSale,
    double totalAmount,
  ) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    final amount = currentCurrency.format(totalAmount).toUpperCase();
    final currencyName = currentCurrency.shortName.toUpperCase();

    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
        ),
        child: IgnorePointer(
          ignoring: false,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: themeData.primaryColorLight,
              padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
            ),
            child: Text(
              texts.pos_invoice_charge_label(amount, currencyName),
              maxLines: 1,
              textAlign: TextAlign.center,
              style: theme.invoiceChargeAmountStyle,
            ),
            onPressed: () => _onInvoiceSubmitted(
              context,
              currentSale,
              invoiceBloc,
              userProfile,
              accountModel,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewSwitch(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    return ViewSwitch(
      selected: _isKeypadView ? 0 : 1,
      tint: themeData.primaryTextTheme.button.color,
      textTint: themeData.textTheme.button.color,
      items: [
        ViewSwitchItem(
          texts.pos_invoice_tab_keypad,
          () => AppBlocsProvider.of<PosCatalogBloc>(context)
              .actionsSink
              .add(UpdatePosSelectedTab("KEYPAD")),
          iconData: Icons.dialpad,
        ),
        ViewSwitchItem(
          texts.pos_invoice_tab_items,
          () => AppBlocsProvider.of<PosCatalogBloc>(context)
              .actionsSink
              .add(UpdatePosSelectedTab("ITEMS")),
          iconData: Icons.playlist_add,
        ),
      ],
    );
  }

  Widget _tabBody(
    BuildContext context,
    PosCatalogBloc posCatalogBloc,
    AccountModel accountModel,
    Sale currentSale,
  ) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;
          return Container(
            height: constraints.maxHeight,
            child: _isKeypadView
                ? PosInvoiceNumPad(
                    currentSale: currentSale,
                    approveClear: () => _approveClear(context, currentSale),
                    clearAmounts: () => _clearAmounts(currentSale),
                    onAddition: () => setState(() {
                      currentPendingItem = null;
                    }),
                    onNumberPressed: (number) => _onNumButtonPressed(
                      currentSale,
                      number,
                    ),
                    width: width,
                    height: height,
                  )
                : PosInvoiceItemsView(
                    currentSale: currentSale,
                    accountModel: accountModel,
                    itemFilterController: _itemFilterController,
                    addItem: (item, avatarKey) => _addItem(
                      posCatalogBloc,
                      currentSale,
                      accountModel,
                      item,
                      avatarKey,
                    ),
                  ),
          );
        },
      ),
    );
  }

  void _changeView(bool isKeypadView) {
    setState(() {
      _isKeypadView = isKeypadView;
    });
  }

  _onInvoiceSubmitted(
    BuildContext context,
    Sale currentSale,
    InvoiceBloc invoiceBloc,
    BreezUserModel user,
    AccountModel account,
  ) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    final errorName = user.name == null;
    final errorAvatar = user.avatarURL == null;
    String errorMessage;
    if (errorName || errorAvatar) {
      errorMessage = texts.pos_invoice_error_submit_name_avatar;
    } else if (errorName) {
      errorMessage = texts.pos_invoice_error_submit_name_only;
    } else if (errorAvatar) {
      errorMessage = texts.pos_invoice_error_submit_avatar_only;
    } else {
      errorMessage = null;
    }

    if (errorMessage != null) {
      return showDialog<Null>(
        useRootNavigator: false,
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              texts.pos_invoice_error_submit_header,
              style: themeData.dialogTheme.titleTextStyle,
            ),
            contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
            content: SingleChildScrollView(
              child: Text(
                errorMessage,
                style: themeData.dialogTheme.contentTextStyle,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  texts.pos_invoice_error_fix_action,
                  style: themeData.primaryTextTheme.button,
                ),
                onPressed: () {
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  navigator.pushNamed("/settings");
                },
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
          );
        },
      );
    } else {
      final satAmount = currentSale.totalChargeSat;
      if (satAmount == 0) {
        return null;
      }

      final maxAllowed = account.maxAllowedToReceive;
      if (satAmount > maxAllowed.toDouble()) {
        promptError(
          context,
          texts.pos_invoice_error_capacity_header,
          Text(
            texts.pos_invoice_error_capacity_message(
              account.currency.format(
                maxAllowed,
                includeDisplayName: true,
              ),
            ),
            style: themeData.dialogTheme.contentTextStyle,
          ),
        );
        return;
      }

      final maxPaymentAmount = account.maxPaymentAmount;
      if (satAmount > maxPaymentAmount.toDouble()) {
        promptError(
          context,
          texts.pos_invoice_error_payment_size_header,
          Text(
            texts.pos_invoice_error_payment_size_message(
              account.currency.format(
                maxPaymentAmount,
                includeDisplayName: true,
              ),
            ),
            style: themeData.dialogTheme.contentTextStyle,
          ),
        );
        return;
      }

      final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
      final lockSale = SetCurrentSale(currentSale.copyWith(priceLocked: true));
      posCatalogBloc.actionsSink.add(lockSale);
      waitForSync(context).then((value) {
        if (!value) {
          return;
        }
        lockSale.future.then((value) {
          final newInvoiceAction = NewInvoice(
            InvoiceRequestModel(
              user.name,
              lockSale.currentSale.note,
              user.avatarURL,
              Int64(satAmount.toInt()),
              expiry: Int64(user.cancellationTimeoutValue.toInt()),
            ),
          );
          invoiceBloc.actionsSink.add(newInvoiceAction);
          newInvoiceAction.future.then((value) {
            final payReq = value as PaymentRequestModel;
            final addSaleAction = SubmitCurrentSale(payReq.paymentHash);
            posCatalogBloc.actionsSink.add(addSaleAction);
            return addSaleAction.future.then((submittedSale) {
              return _showPaymentDialog(
                invoiceBloc,
                user,
                payReq,
                satAmount,
                account,
                submittedSale,
              ).then((cleared) {
                if (!cleared) {
                  final unLockSale = SetCurrentSale(
                    submittedSale.copyWith(priceLocked: false),
                  );
                  posCatalogBloc.actionsSink.add(unLockSale);
                }
              });
            });
          }).catchError((error) {
            showFlushbar(
              context,
              message: error.toString(),
              duration: Duration(seconds: 10),
            );
          });
        });
      });
    }
  }

  Future<bool> waitForSync(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) => AlertDialog(
        content: SyncProgressDialog(closeOnSync: true),
        actions: <Widget>[
          TextButton(
            onPressed: (() {
              Navigator.pop(context, false);
            }),
            child: Text(
              texts.pos_invoice_close,
              style: Theme.of(context).primaryTextTheme.button,
            ),
          ),
        ],
      ),
    );
  }

  Future _showPaymentDialog(
    InvoiceBloc invoiceBloc,
    BreezUserModel user,
    PaymentRequestModel payReq,
    double satAmount,
    AccountModel account,
    Sale submittedSale,
  ) {
    return showDialog<PosPaymentResult>(
        useRootNavigator: false,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PosPaymentDialog(invoiceBloc, user, payReq, satAmount);
        }).then((res) {
      if (res?.paid == true) {
        Navigator.of(context).push(TransparentPageRoute((context) {
          return SuccessfulPaymentRoute(
            onPrint: () async {
              PaymentInfo paymentInfo = await _findPayment(payReq.paymentHash);
              PrintParameters printParameters = PrintParameters(
                currentUser: user,
                account: account,
                submittedSale: submittedSale,
                paymentInfo: paymentInfo,
              );
              return PrintService(printParameters).printAsPDF(context);
            },
          );
        }));
      }
      if (res?.clearSale == true) {
        _clearSale();
        return true;
      }
      return false;
    });
  }

  Future<PaymentInfo> _findPayment(String paymentHash) async {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    PaymentsModel paymentsModel = await accountBloc.paymentsStream
        .firstWhere((paymentsModel) => paymentsModel != null);
    return paymentsModel.paymentsList
        .firstWhere((paymentInfo) => paymentInfo.paymentHash == paymentHash);
  }

  void _addItem(
    PosCatalogBloc posCatalogBloc,
    Sale currentSale,
    AccountModel account,
    Item item,
    GlobalKey avatarKey,
  ) {
    final itemCurrency = CurrencyWrapper.fromShortName(item.currency, account);

    setState(() {
      final newSale = currentSale.addItem(item, itemCurrency.satConversionRate);
      posCatalogBloc.actionsSink.add(SetCurrentSale(newSale));
      currentPendingItem = null;
      _animateAddItem(item, avatarKey);
    });
  }

  void _animateAddItem(Item item, GlobalKey avatarKey) {
    // start position
    RenderBox avatarPos = avatarKey.currentContext.findRenderObject();
    final startPos = avatarPos.localToGlobal(
      Offset.zero,
      ancestor: this.context.findRenderObject(),
    );
    final begin = RelativeRect.fromLTRB(startPos.dx, startPos.dy, 0, 0);

    // end position
    RenderBox cartBox = badgeKey.currentContext.findRenderObject();
    final endPos = cartBox.localToGlobal(
      Offset.zero,
      ancestor: this.context.findRenderObject(),
    );
    final end = RelativeRect.fromLTRB(startPos.dx, endPos.dy, 0, 0);

    final tween = RelativeRectTween(begin: begin, end: end);

    final controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    _transitionAnimation = tween
        .chain(
          CurveTween(curve: Curves.easeOutCubic),
        )
        .animate(controller);
    _itemInTransition = item;

    // handle scale animation.
    final scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _scaleTransition = CurvedAnimation(
      parent: scaleController,
      curve: Curves.easeInExpo.flipped,
    );

    // handle opacity animation.
    final opacityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _opacityTransition = CurvedAnimation(
      parent: opacityController,
      curve: Curves.easeInExpo,
    );

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

  void _onNumButtonPressed(Sale currentSale, String numberText) {
    final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
    setState(() {
      final normalizeFactor = pow(10, currentCurrency.fractionSize);
      var newSale = currentSale;

      //better to do calculations on integers to avoid precision lose.
      final addition = int.parse(numberText);
      // Double can hold precision up to 17 digits, using toInt() truncates the fraction digits
      // That's why we use round to get the nearest number
      // e.g. (0.29*100 should be 29, but it returns 28.999999999999996
      int intAmount = (currentAmount * normalizeFactor).round();
      intAmount = intAmount * 10 + addition;
      final newPrice = intAmount / normalizeFactor;

      if (currentPendingItem == null) {
        newSale = currentSale.addCustomItem(
          newPrice,
          currentCurrency.shortName,
          currentCurrency.satConversionRate,
        );
        currentPendingItem = newSale.saleLines.last;
      } else {
        currentPendingItem = currentPendingItem.copyWith(
          pricePerItem: newPrice,
        );
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

  void _changeCurrency(
    Sale currentSale,
    String value,
    UserProfileBloc userProfileBloc,
  ) {
    print(">> _changeCurrency $value");
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

  void _clearAmounts(Sale currentSale) {
    final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
    setState(() {
      if (currentPendingItem != null) {
        currentSale = currentSale.removeItem(
          (sl) => sl.isCustom && sl.itemName == currentPendingItem.itemName,
        );
        currentPendingItem = null;
        posCatalogBloc.actionsSink.add(SetCurrentSale(currentSale));
      }
    });
  }

  void _clearSale() {
    final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
    setState(() {
      currentPendingItem = null;
      posCatalogBloc.actionsSink.add(SetCurrentSale(Sale(
        saleLines: [],
        date: DateTime.now(),
      )));
    });
  }

  void _approveClear(BuildContext context, Sale currentSale) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    if (currentSale.totalChargeSat > 0 || currentAmount > 0) {
      AlertDialog dialog = AlertDialog(
        title: Text(
          texts.pos_invoice_clear_sale_header,
          textAlign: TextAlign.center,
          style: themeData.dialogTheme.titleTextStyle,
        ),
        content: Text(
          texts.pos_invoice_clear_sale_message,
          style: themeData.dialogTheme.contentTextStyle,
        ),
        contentPadding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12.0),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              texts.pos_invoice_clear_sale_cancel,
              style: themeData.primaryTextTheme.button,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearSale();
            },
            child: Text(
              texts.pos_invoice_clear_sale_confirm,
              style: themeData.primaryTextTheme.button,
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
      );
      showDialog(
        useRootNavigator: false,
        context: context,
        builder: (_) => dialog,
      );
    }
  }
}

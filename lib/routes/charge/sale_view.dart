import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/utils/print_pdf.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/payment_details_dialog.dart';
import 'package:flutter/material.dart';

import 'items/item_avatar.dart';

class SaleView extends StatefulWidget {
  final CurrencyWrapper saleCurrency;
  final Function() onDeleteSale;
  final Function(AccountModel, Sale) onCharge;
  final PaymentInfo salePayment;
  final Sale readOnlySale;

  const SaleView(
      {Key key,
      this.saleCurrency,
      this.onDeleteSale,
      this.onCharge,
      this.salePayment,
      this.readOnlySale})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SaleViewState();
  }

  bool get readOnly => readOnlySale != null;
}

class SaleViewState extends State<SaleView> {
  StreamSubscription<Sale> _currentSaleSubscription;
  ScrollController _scrollController = new ScrollController();
  TextEditingController _noteController = new TextEditingController();
  FocusNode _noteFocus = new FocusNode();
  Sale saleInProgress;

  Sale get currentSale => widget.readOnlySale ?? saleInProgress;

  @override
  void didChangeDependencies() {
    if (_currentSaleSubscription == null) {
      if (!widget.readOnly) {
        PosCatalogBloc posCatalogBloc =
            AppBlocsProvider.of<PosCatalogBloc>(context);
        _currentSaleSubscription =
            posCatalogBloc.currentSaleStream.listen((sale) {
          setState(() {
            bool updateNote = saleInProgress == null;
            saleInProgress = sale;
            if (updateNote) {
              _noteController.text = sale.note;
            }
            var thisRoute = ModalRoute.of(context);
            if (saleInProgress.saleLines.length == 0) {
              if (thisRoute.isCurrent) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).removeRoute(thisRoute);
              }
            }
          });
        });

        _noteController.addListener(() {
          posCatalogBloc.actionsSink.add(SetCurrentSale(
              saleInProgress.copyWith(note: _noteController.text)));
        });
      } else {
        _noteController.text = widget.readOnlySale.note;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _currentSaleSubscription?.cancel();
    super.dispose();
  }

  bool get showNote =>
      !widget.readOnly || widget.readOnlySale.note?.isNotEmpty == true;

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, accSnapshot) {
          var accModel = accSnapshot.data;
          if (accModel == null) {
            return Loader();
          }

          CurrencyWrapper saleCurrency =
              widget.saleCurrency ?? CurrencyWrapper.fromBTC(Currency.SAT);
          String title = "Current Sale";
          if (widget.salePayment != null) {
            title = DateUtils.formatYearMonthDayHourMinute(
                DateTime.fromMillisecondsSinceEpoch(
                    widget.salePayment.creationTimestamp.toInt() * 1000));
          }
          return Scaffold(
            appBar: AppBar(
              iconTheme: Theme.of(context).appBarTheme.iconTheme,
              textTheme: Theme.of(context).appBarTheme.textTheme,
              backgroundColor: Theme.of(context).canvasColor,
              leading: backBtn.BackButton(),
              title: Text(title),
              actions: widget.readOnly
                  ? _buildActions(account: accModel, saleCurrency: saleCurrency)
                  : _buildActions(),
              elevation: 0.0,
            ),
            extendBody: false,
            backgroundColor: Theme.of(context).backgroundColor,
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      !showNote
                          ? SizedBox()
                          : Container(
                              color: Theme.of(context).canvasColor,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, bottom: 8.0),
                                child: TextField(
                                  enabled: !widget.readOnly,
                                  keyboardType: TextInputType.multiline,
                                  maxLength: 90,
                                  maxLengthEnforced: true,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) {
                                    _noteFocus.requestFocus();
                                  },
                                  buildCounter: (BuildContext ctx,
                                          {int currentLength,
                                          bool isFocused,
                                          int maxLength}) =>
                                      SizedBox(),
                                  controller: _noteController,
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
                                      hintStyle: TextStyle(fontSize: 14.0)),
                                ),
                              )),
                      Expanded(
                        child: SaleLinesList(
                            saleCurrency: saleCurrency,
                            readOnly: widget.readOnly,
                            scrollController: _scrollController,
                            accountModel: accModel,
                            currentSale: currentSale),
                      ),
                    ],
                  )
                ],
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: theme.themeId == "BLUE"
                    ? Theme.of(context).backgroundColor
                    : Theme.of(context).canvasColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(0.5, 0.5),
                      blurRadius: 5.0),
                  BoxShadow(color: Theme.of(context).backgroundColor)
                ],
              ),
              //color: Theme.of(context).canvasColor,
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: Container(
                    child: _TotalSaleCharge(
                  salePayment: widget.salePayment,
                  onCharge: widget.onCharge,
                  accountModel: accModel,
                  currentSale: currentSale,
                  saleCurrency: saleCurrency,
                )),
              ),
            ),
          );
        });
  }

  _buildActions({AccountModel account, CurrencyWrapper saleCurrency}) {
    if (account != null) {
      UserProfileBloc userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      return <Widget>[
        StreamBuilder<BreezUserModel>(
            stream: userBloc.userStream,
            builder: (context, snapshot) {
              var user = snapshot.data;
              if (user == null) {
                return Loader();
              }
              return Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: IconButton(
                  alignment: Alignment.center,
                  tooltip: "Print",
                  iconSize: 24.0,
                  color: Theme.of(context).iconTheme.color,
                  icon: Icon(Icons.local_print_shop_outlined),
                  onPressed: () => PrintService(
                          user, saleCurrency, account, widget.readOnlySale)
                      .printAsPDF(),
                ),
              );
            })
      ];
    }
    return <Widget>[
      IconButton(
        icon: Icon(
          Icons.delete_forever,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () {
          widget.onDeleteSale();
        },
      )
    ];
  }
}

class _TotalSaleCharge extends StatelessWidget {
  final AccountModel accountModel;
  final Sale currentSale;
  final CurrencyWrapper saleCurrency;
  final Function(AccountModel accModel, Sale sale) onCharge;
  final PaymentInfo salePayment;

  const _TotalSaleCharge(
      {Key key,
      this.accountModel,
      this.currentSale,
      this.onCharge,
      this.salePayment,
      this.saleCurrency})
      : super(key: key);

  bool get readOnly => salePayment != null;

  @override
  Widget build(BuildContext context) {
    var totalAmount =
        currentSale.totalChargeSat / saleCurrency.satConversionRate;

    return RaisedButton(
      color: Theme.of(context).primaryColorLight,
      padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
      child: Text(
        "${readOnly ? '' : 'Charge '}${saleCurrency.format(totalAmount)} ${saleCurrency.shortName}"
            .toUpperCase(),
        maxLines: 1,
        textAlign: TextAlign.center,
        style: theme.invoiceChargeAmountStyle,
      ),
      onPressed: () {
        if (readOnly) {
          showPaymentDetailsDialog(context, salePayment);
        } else {
          onCharge(accountModel, currentSale);
        }
      },
    );
  }
}

class SaleLinesList extends StatelessWidget {
  final Sale currentSale;
  final CurrencyWrapper saleCurrency;
  final AccountModel accountModel;
  final ScrollController scrollController;
  final bool readOnly;

  const SaleLinesList(
      {Key key,
      this.currentSale,
      this.accountModel,
      this.scrollController,
      this.readOnly,
      this.saleCurrency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PosCatalogBloc posCatalogBloc =
        AppBlocsProvider.of<PosCatalogBloc>(context);
    return SingleChildScrollView(
      child: ListView.builder(
          itemCount: currentSale.saleLines.length,
          shrinkWrap: true,
          controller: scrollController,
          //primary: false,
          itemBuilder: (BuildContext context, int index) {
            return ListTileTheme(
              textColor: theme.themeId == "BLUE"
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).textTheme.subtitle1.color,
              iconColor: theme.themeId == "BLUE"
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).textTheme.subtitle1.color,
              child: Column(children: [
                SaleLineWidget(
                    saleCurrency: saleCurrency,
                    onDelete: readOnly
                        ? null
                        : () {
                            var newSale = currentSale.copyWith(
                                saleLines: currentSale.saleLines
                                  ..removeAt(index));
                            posCatalogBloc.actionsSink
                                .add(SetCurrentSale(newSale));
                          },
                    onChangeQuantity: readOnly
                        ? null
                        : (int delta) {
                            var saleLines = currentSale.saleLines.toList();
                            var saleLine = currentSale.saleLines[index];
                            var newQuantity = saleLine.quantity + delta;
                            if (saleLine.quantity == 0) {
                              saleLines.removeAt(index);
                            } else {
                              saleLines = saleLines.map((sl) {
                                if (sl != saleLine) {
                                  return sl;
                                }
                                return sl.copyWith(quantity: newQuantity);
                              }).toList();
                            }
                            var newSale =
                                currentSale.copyWith(saleLines: saleLines);
                            posCatalogBloc.actionsSink
                                .add(SetCurrentSale(newSale));
                          },
                    accountModel: accountModel,
                    saleLine: currentSale.saleLines[index]),
                Divider(
                  height: 0.0,
                  color: index == currentSale.saleLines.length - 1
                      ? Colors.white.withOpacity(0.0)
                      : (theme.themeId == "BLUE"
                              ? Theme.of(context).canvasColor
                              : Theme.of(context).textTheme.subtitle1.color)
                          .withOpacity(0.5),
                  indent: 72.0,
                )
              ]),
            );
          }),
    );
  }
}

class SaleLineWidget extends StatelessWidget {
  final CurrencyWrapper saleCurrency;
  final SaleLine saleLine;
  final AccountModel accountModel;
  final Function(int delta) onChangeQuantity;
  final Function() onDelete;

  const SaleLineWidget(
      {Key key,
      this.saleLine,
      this.accountModel,
      this.onChangeQuantity,
      this.onDelete,
      this.saleCurrency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currency =
        CurrencyWrapper.fromShortName(saleLine.currency, accountModel);
    double priceInFiat = saleLine.pricePerItem * saleLine.quantity;
    double priceInSats = currency.satConversionRate * priceInFiat;
    String priceInSaleCurrency = "";
    if (saleCurrency.symbol != currency.symbol) {
      String salePrice = saleCurrency.format(
          priceInSats / saleCurrency.satConversionRate,
          includeCurrencySymbol: true,
          removeTrailingZeros: true);
      // compensate for empty character added for rtl symbols
      priceInSaleCurrency = (currency.rtl ? "" : " ") + "($salePrice)";
    }

    var iconColor = theme.themeId == "BLUE"
        ? Colors.black.withOpacity(0.3)
        : ListTileTheme.of(context).iconColor.withOpacity(0.5);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: ListTile(
          leading: ItemAvatar(saleLine.itemImageURL, itemName: saleLine.itemName),
          title: Text(
            saleLine.itemName,
            //style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              "${currency.format(priceInFiat, removeTrailingZeros: true, includeCurrencySymbol: true)}$priceInSaleCurrency",
              style: TextStyle(
                  color: ListTileTheme.of(context)
                      .textColor
                      .withOpacity(theme.themeId == "BLUE" ? 0.75 : 0.5))),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              onChangeQuantity == null
                  ? SizedBox()
                  : IconButton(
                      iconSize: 22.0,
                      color: iconColor,
                      icon: Icon(Icons.add),
                      onPressed: () => onChangeQuantity(1)),
              Container(
                width: 40.0,
                child: Center(
                  child: Text(saleLine.quantity.toString(),
                      style: TextStyle(
                          color: theme.themeId == "BLUE"
                              ? Colors.black.withOpacity(0.7)
                              : ListTileTheme.of(context).textColor,
                          fontSize: 18.0)),
                ),
              ),
              onDelete == null
                  ? SizedBox()
                  : IconButton(
                      iconSize: 22.0,
                      color: iconColor,
                      icon: Icon(saleLine.quantity == 1
                          ? Icons.delete_outline
                          : Icons.remove),
                      onPressed: () => saleLine.quantity == 1
                          ? onDelete()
                          : onChangeQuantity(-1)),
            ],
          )),
    );
  }
}

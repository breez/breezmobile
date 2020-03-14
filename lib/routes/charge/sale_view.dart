import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';

import 'items/item_avatar.dart';

class SaleView extends StatefulWidget {
  final bool useFiat;
  final Function() onDeleteSale;
  final Function() onCharge;

  const SaleView({Key key, this.useFiat, this.onDeleteSale, this.onCharge})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SaleViewState();
  }
}

class SaleViewState extends State<SaleView> {
  StreamSubscription<Sale> _currentSaleSubscrription;
  ScrollController _scrollController = new ScrollController();
  FocusNode _noteFocus = new FocusNode();

  @override
  void didChangeDependencies() {
    if (_currentSaleSubscrription == null) {
      PosCatalogBloc posCatalogBloc =
          AppBlocsProvider.of<PosCatalogBloc>(context);
      _currentSaleSubscrription =
          posCatalogBloc.currentSaleStream.listen((sale) {
        if (sale.saleLines.length == 0) {
          Navigator.of(context).pop();
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _currentSaleSubscrription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PosCatalogBloc posCatalogBloc =
        AppBlocsProvider.of<PosCatalogBloc>(context);
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return StreamBuilder<Sale>(
        stream: posCatalogBloc.currentSaleStream,
        builder: (context, saleSnapshot) {
          var currentSale = saleSnapshot.data;
          return StreamBuilder<AccountModel>(
              stream: accountBloc.accountStream,
              builder: (context, accSnapshot) {
                var accModel = accSnapshot.data;
                if (accModel == null) {
                  return Loader();
                }
                return Scaffold(
                  appBar: AppBar(
                    iconTheme: Theme.of(context).appBarTheme.iconTheme,
                    textTheme: Theme.of(context).appBarTheme.textTheme,
                    backgroundColor: Theme.of(context).canvasColor,
                    leading: backBtn.BackButton(),
                    title: Text("Current Sale"),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.delete_forever,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onPressed: () {
                          widget.onDeleteSale();
                        },
                      )
                    ],
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
                            Container(
                                color: Theme.of(context).canvasColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0, bottom: 8.0),
                                  child: TextField(
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
                                    // controller:
                                    //     _invoiceDescriptionController,
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
                        onCharge: widget.onCharge,
                        accountModel: accModel,
                        currentSale: currentSale,
                        useFiat: widget.useFiat,
                      )),
                    ),
                  ),
                );
              });
        });
  }
}

class _TotalSaleCharge extends StatelessWidget {
  final AccountModel accountModel;
  final Sale currentSale;
  final bool useFiat;
  final Function() onCharge;

  const _TotalSaleCharge(
      {Key key,
      this.accountModel,
      this.currentSale,
      this.useFiat,
      this.onCharge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrencyWrapper currentCurrency;
    if (useFiat) {
      currentCurrency = CurrencyWrapper.fromFiat(accountModel.fiatCurrency);
    } else {
      currentCurrency = CurrencyWrapper.fromBTC(accountModel.currency);
    }
    var totalAmount =
        currentCurrency.satConversionRate * currentSale.totalChargeSat.toInt();

    return RaisedButton(
      color: Theme.of(context).primaryColorLight,
      padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
      child: Text(
        "Charge ${currentCurrency.format(totalAmount)} ${currentCurrency.shortName}"
            .toUpperCase(),
        maxLines: 1,
        textAlign: TextAlign.center,
        style: theme.invoiceChargeAmountStyle,
      ),
      onPressed: () {
        onCharge();
      },
    );
  }
}

class SaleLinesList extends StatelessWidget {
  final Sale currentSale;
  final AccountModel accountModel;
  final ScrollController scrollController;

  const SaleLinesList(
      {Key key, this.currentSale, this.accountModel, this.scrollController})
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
                    onDelete: () {
                      var newSale = currentSale.copyWith(
                          saleLines: currentSale.saleLines..removeAt(index));
                      posCatalogBloc.actionsSink.add(SetCurrentSale(newSale));
                    },
                    onChangeQuantity: (int delta) {
                      var saleLine = currentSale.saleLines[index];
                      var saleLines = currentSale.saleLines.toList();
                      var newQuantity = saleLine.quantity + delta;
                      if (saleLine.quantity == 0) {
                        saleLines.removeAt(index);
                      } else {
                        saleLines = saleLines.map((sl) {
                          if (sl != saleLine) {
                            return sl;
                          }
                          return sl.copywith(quantity: newQuantity);
                        }).toList();
                      }
                      var newSale = currentSale.copyWith(saleLines: saleLines);
                      posCatalogBloc.actionsSink.add(SetCurrentSale(newSale));
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
  //final Sale sale;
  final SaleLine saleLine;
  final AccountModel accountModel;
  final Function(int delta) onChangeQuantity;
  final Function() onDelete;

  const SaleLineWidget(
      {Key key,
      this.saleLine,
      this.accountModel,
      this.onChangeQuantity,
      this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currrency =
        CurrencyWrapper.fromShortName(saleLine.currency, accountModel);
    var iconColor = theme.themeId == "BLUE"
        ? Colors.black.withOpacity(0.3)
        : ListTileTheme.of(context).iconColor.withOpacity(0.5);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: ListTile(
          leading: ItemAvatar(saleLine.itemImageURL),
          title: Text(
            saleLine.itemName,
            //style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              currrency.symbol +
                  currrency.format(saleLine.pricePerItem * saleLine.quantity,
                      removeTrailingZeros: true),
              style: TextStyle(
                  color: ListTileTheme.of(context)
                      .textColor
                      .withOpacity(theme.themeId == "BLUE" ? 0.75 : 0.5))),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
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
              IconButton(
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

import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;

import 'items/item_avatar.dart';

class SaleView extends StatefulWidget {
  final bool useFiat;

  const SaleView({Key key, this.useFiat}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SaleViewState();
  }
}

class SaleViewState extends State<SaleView> {

  StreamSubscription<Sale> _currentSaleSubscrription;

  @override void didChangeDependencies() {
    if (_currentSaleSubscrription == null) {
      PosCatalogBloc posCatalogBloc =
        AppBlocsProvider.of<PosCatalogBloc>(context);
      _currentSaleSubscrription = posCatalogBloc.currentSaleStream.listen((sale) {
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
                    leading: backBtn.BackButton(iconData: Icons.close),
                    title: _TotalSaleCharge(
                      accountModel: accModel,
                      currentSale: currentSale,
                      useFiat: widget.useFiat,
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.note_add,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onPressed: () {},
                      )
                    ],
                    elevation: 0.0,
                  ),
                  body: SaleLinesList(
                      accountModel: accModel, currentSale: currentSale),
                  bottomNavigationBar: SingleButtonBottomBar(
                    text: "Clear Sale",
                    onPressed: () {
                      posCatalogBloc.actionsSink
                          .add(SetCurrentSale(Sale(saleLines: [])));
                    },
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

  const _TotalSaleCharge(
      {Key key, this.accountModel, this.currentSale, this.useFiat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var totalSats = currentSale.totalChargeSat;
    String formattedCharge;
    if (useFiat) {
      var fiatValue = accountModel.fiatCurrency.satToFiat(totalSats);
      formattedCharge = accountModel.fiatCurrency.formatFiat(fiatValue, allowBelowMin: true, removeTrailingZeros: true);
    } else {
      formattedCharge = accountModel.currency.format(totalSats, removeTrailingZeros: true);
    }
    return Text(
      "Total: $formattedCharge",
      style: Theme.of(context).appBarTheme.textTheme.title,
    );
  }
}

class SaleLinesList extends StatelessWidget {
  final Sale currentSale;
  final AccountModel accountModel;

  const SaleLinesList({Key key, this.currentSale, this.accountModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PosCatalogBloc posCatalogBloc =
        AppBlocsProvider.of<PosCatalogBloc>(context);
    return ListView.builder(
        itemCount: currentSale.saleLines.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              SaleLineWidget(
                  onDelete: (){
                    var newSale = currentSale.copyWith(saleLines: currentSale.saleLines..removeAt(index));
                    posCatalogBloc.actionsSink.add(SetCurrentSale(newSale));
                  },
                  onChangeQuantity: (int delta) {
                    var saleLine = currentSale.saleLines[index];
                    var newSale = currentSale.incrementQuantity(
                        saleLine.itemID, saleLine.satConversionRate,
                        quantity: delta);
                    posCatalogBloc.actionsSink.add(SetCurrentSale(newSale));
                  },
                  accountModel: accountModel,
                  saleLine: currentSale.saleLines[index]),
              Divider(
                height: 0.0,
                color: index == currentSale.saleLines.length - 1
                    ? Color.fromRGBO(255, 255, 255, 0.0)
                    : Color.fromRGBO(255, 255, 255, 0.12),
                indent: 72.0,
              )
            ],
          );
        });
  }
}

class SaleLineWidget extends StatelessWidget {
  //final Sale sale;
  final SaleLine saleLine;
  final AccountModel accountModel;
  final Function(int delta) onChangeQuantity;
  final Function() onDelete;

  const SaleLineWidget(
      {Key key, this.saleLine, this.accountModel, this.onChangeQuantity, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currrency =
        CurrencyWrapper.fromShortName(saleLine.currency, accountModel);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: ListTile(
          leading: ItemAvatar(saleLine.itemImageURL),
          title: Text(saleLine.itemName),
          subtitle: Text(currrency.format(
              saleLine.pricePerItem * saleLine.quantity,
              includeCurencySuffix: true, removeTrailingZeros: true)),
          trailing: saleLine.itemID == null
              ? IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: () => onDelete())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(saleLine.quantity == 1
                            ? Icons.delete_forever
                            : Icons.remove),
                        onPressed: () => onChangeQuantity(-1)),
                    Text(saleLine.quantity.toString()),
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => onChangeQuantity(1)),
                  ],
                )),
    );
  }
}

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/flushbar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'item_avatar.dart';

class CatalogItem extends StatelessWidget {
  final AccountModel accountModel;
  final PosCatalogBloc posCatalogBloc;
  final Item _itemInfo;
  final bool _lastItem;
  final Function(AccountModel accountModel, String symbol, Int64 itemPriceInSat)
      _addItem;

  CatalogItem(this.accountModel, this.posCatalogBloc, this._itemInfo,
      this._lastItem, this._addItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete_forever,
              onTap: () {
                DeleteItem deleteItem = DeleteItem(_itemInfo.id);
                posCatalogBloc.actionsSink.add(deleteItem);
                deleteItem.future.then((_) {},
                    onError: (err) => showFlushbar(context,
                        message: "Failed to delete ${_itemInfo.name}"));
              },
            ),
          ],
          key: Key(_itemInfo.id.toString()),
          child: ListTile(
            leading: _buildCatalogItemAvatar(),
            title: Text(
              _itemInfo.name,
              style: theme.transactionTitleStyle,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        _formattedPrice(),
                        style: theme.transactionAmountStyle,
                      )
                    ]),
              ],
            ),
            onTap: () {
              _addItem(accountModel, _itemInfo.currency, _itemPriceInSat());
            },
          ),
        ),
        Divider(
          height: 0.0,
          color: _lastItem
              ? Color.fromRGBO(255, 255, 255, 0.0)
              : Color.fromRGBO(255, 255, 255, 0.12),
          indent: 72.0,
        ),
      ]),
    );
  }

  String _formattedPrice({bool userInput = false, bool includeSymbol = true}) {
    RegExp removeTrailingZeros = RegExp(r"([.]0*)(?!.*\d)");
    if (Currency.fromSymbol(_itemInfo.currency) != null) {
      var currency = Currency.fromSymbol(_itemInfo.currency);
      return currency
          .format(currency.toSats(_itemInfo.price),
              fixedDecimals: false, useSymbol: true)
          .replaceAll(removeTrailingZeros, "");
    } else {
      return accountModel
          .getFiatCurrencyByShortName(_itemInfo.currency)
          .formatFiat(_itemInfo.price)
          .replaceAll(removeTrailingZeros, "");
    }
  }

  Int64 _itemPriceInSat() {
    return Currency.fromSymbol(_itemInfo.currency) != null
        ? Currency.fromSymbol(_itemInfo.currency).toSats(_itemInfo.price)
        : accountModel
            .getFiatCurrencyByShortName(_itemInfo.currency)
            .fiatToSat(_itemInfo.price);
  }

  Widget _buildCatalogItemAvatar() {
    return ItemAvatar(_itemInfo.imageURL);
  }
}

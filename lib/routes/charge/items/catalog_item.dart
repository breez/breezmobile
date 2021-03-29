import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/theme_data.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

import 'item_avatar.dart';
import 'item_page.dart';

class CatalogItem extends StatelessWidget {
  final AccountModel accountModel;
  final PosCatalogBloc posCatalogBloc;
  final Item _itemInfo;
  final bool _lastItem;
  final Function(Item item, GlobalKey avatarKey) _addItem;
  final GlobalKey _avatarKey = GlobalKey();
  final GlobalKey _menuKey = new GlobalKey();

  CatalogItem(this.accountModel, this.posCatalogBloc, this._itemInfo,
      this._lastItem, this._addItem);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
        child: PopupMenuButton(
          key: _menuKey,
          color: Theme.of(context).highlightColor,
          offset: Offset(12, 24),
          itemBuilder: (_) => <PopupMenuItem>[
            PopupMenuItem(
              child: TextButton.icon(
                label: Text(
                  "Edit Item",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                icon: Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(FadeInRoute(
                      builder: (_) =>
                          ItemPage(posCatalogBloc, item: _itemInfo)));
                },
              ),
            ),
            PopupMenuItem(
              child: TextButton.icon(
                label: Text(
                  "Delete Item",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                icon: Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  DeleteItem deleteItem = DeleteItem(_itemInfo.id);
                  posCatalogBloc.actionsSink.add(deleteItem);
                  deleteItem.future.catchError((err) => showFlushbar(context,
                      message: "Failed to delete ${_itemInfo.name}"));
                },
              ),
            ),
          ],
          child: ListTile(
            leading: ItemAvatar(_itemInfo.imageURL,
                itemName: _itemInfo.name, key: _avatarKey),
            title: Text(
              _itemInfo.name,
              style: Theme.of(context).textTheme.itemTitleStyle,
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
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.itemPriceStyle,
                          children: <InlineSpan>[
                            TextSpan(
                              text: _getSymbol(),
                              /*style: _itemInfo.currency == "SAT"
                                  ? TextStyle(fontSize: 13.4, fontFamily: 'SAT')
                                  : null,*/
                            ),
                            TextSpan(
                              text: _formattedPrice(), // Price
                            ),
                          ],
                        ),
                      ),
                    ]),
              ],
            ),
            onTap: () {
              _addItem(_itemInfo, _avatarKey);
            },
            onLongPress: () {
              dynamic popUpMenuState = _menuKey.currentState;
              popUpMenuState.showButtonMenu();
            },
          ),
        ),
      ),
      Divider(
        height: 0.0,
        color: _lastItem
            ? Color.fromRGBO(255, 255, 255, 0.0)
            : Color.fromRGBO(255, 255, 255, 0.12),
        indent: 72.0,
      ),
    ]);
  }

  String _getSymbol() {
    return CurrencyWrapper.fromShortName(_itemInfo.currency, accountModel)
        ?.symbol;
  }

  String _formattedPrice() {
    var formatter =
        CurrencyWrapper.fromShortName(_itemInfo.currency, accountModel);
    return formatter?.format(_itemInfo.price, removeTrailingZeros: true);
  }
}

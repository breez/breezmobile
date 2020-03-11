import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:flutter/material.dart';

import 'catalog_item.dart';

class ItemsList extends StatelessWidget {
  final AccountModel accountModel;
  final PosCatalogBloc posCatalogBloc;
  final List<Item> _items;
  final Function(Item item)
      _addItem;

  ItemsList(this.accountModel, this.posCatalogBloc, this._items, this._addItem);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _items.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (BuildContext context, int index) {
          return CatalogItem(accountModel, posCatalogBloc, _items[index],
              _items.length - 1 == index, _addItem);
        });
  }
}

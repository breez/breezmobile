import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:flutter/material.dart';

import 'catalog_item.dart';

class ItemsList extends StatelessWidget {
  final AccountModel accountModel;
  final PosCatalogBloc posCatalogBloc;
  final List<Item> _items;
  final Function(Item item) _addItem;
  final String _filter;

  ItemsList(this.accountModel, this.posCatalogBloc, this._items, this._addItem,
      this._filter);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _items.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (BuildContext context, int index) {
          return _filter.isNotEmpty && _containsItem(index) || _filter.isEmpty
              ? CatalogItem(accountModel, posCatalogBloc, _items[index],
                  _items.length - 1 == index, _addItem)
              : Container();
        });
  }

  _containsItem(int index) {
    // items that contains the filtered text in their name or sku, case insensitive
    return _items[index].name.toLowerCase().contains(_filter.toLowerCase());
    //|| _items[index].sku.toLowerCase().contains(_filter.toLowerCase());
  }
}

import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:flutter/material.dart';

import 'catalog_item.dart';

class ItemsList extends StatelessWidget {
  final PosCatalogBloc posCatalogBloc;
  final List<Item> _items;

  ItemsList(this.posCatalogBloc, this._items);

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: 72.0,
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return CatalogItem(posCatalogBloc, _items[index], _items.length - 1 == index);
      }, childCount: _items.length),
    );
  }
}

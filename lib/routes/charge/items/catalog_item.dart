import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

import 'item_avatar.dart';

class CatalogItem extends StatelessWidget {
  final PosCatalogBloc posCatalogBloc;
  final Item _itemInfo;
  final bool _lastItem;

  CatalogItem(this.posCatalogBloc, this._itemInfo, this._lastItem);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      ListTile(
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
                    Currency.fromSymbol(_itemInfo.currency).displayName +
                        _itemInfo.price.toString(),
                    style: theme.transactionAmountStyle,
                  )
                ]),
          ],
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

  Widget _buildCatalogItemAvatar() {
    return ItemAvatar(_itemInfo.imageURL);
  }
}

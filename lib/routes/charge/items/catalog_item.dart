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
  final PosCatalogBloc posCatalogBloc;
  final Item _itemInfo;
  final bool _lastItem;

  CatalogItem(this.posCatalogBloc, this._itemInfo, this._lastItem);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
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
              deleteItem.future.then((_) => showFlushbar(context,
                  message: "${_itemInfo.name} is successfully deleted"));
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
                      Currency.fromSymbol(_itemInfo.currency)
                          .format(Int64(_itemInfo.price.toInt())),
                      style: theme.transactionAmountStyle,
                    )
                  ]),
            ],
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

  Widget _buildCatalogItemAvatar() {
    return ItemAvatar(_itemInfo.imageURL);
  }
}

import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';

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
        onTap: () => showAddToCatalogPage,
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

  showAddToCatalogPage(BuildContext context) {
    // Show add to catalog page with the given item
    // return AddItemToCatalog(_itemInfo);
  }

  Widget _buildCatalogItemAvatar() {
    if (_itemInfo.imageURL != null) {
      return CatalogItemAvatar(_itemInfo.imageURL);
    } else {
      return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          width: 32.0,
          height: 32.0,
          child: Icon(Icons.close, color: theme.BreezColors.blue[500]));
    }
  }

  // Separate this to it's own class
  Widget CatalogItemAvatar(String avatarURL) {
    return BreezAvatar(avatarURL);
  }
}

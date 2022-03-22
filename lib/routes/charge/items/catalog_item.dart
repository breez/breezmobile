import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/theme_data.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'item_avatar.dart';
import 'item_page.dart';

class CatalogItem extends StatelessWidget {
  final AccountModel accountModel;
  final PosCatalogBloc posCatalogBloc;
  final Item _itemInfo;
  final bool _lastItem;
  final Function(Item item, GlobalKey avatarKey) _addItem;
  final GlobalKey _avatarKey = GlobalKey();
  final GlobalKey _menuKey = GlobalKey();

  CatalogItem(
    this.accountModel,
    this.posCatalogBloc,
    this._itemInfo,
    this._lastItem,
    this._addItem,
  );

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          child: PopupMenuButton(
            key: _menuKey,
            color: themeData.highlightColor,
            offset: Offset(12, 24),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: TextButton.icon(
                  label: Text(
                    texts.catalog_item_action_edit,
                    style: themeData.textTheme.subtitle1,
                  ),
                  icon: Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final navigatorState = Navigator.of(context);
                    navigatorState.pop();
                    navigatorState.push(FadeInRoute(
                      builder: (_) => ItemPage(
                        posCatalogBloc,
                        item: _itemInfo,
                      ),
                    ));
                  },
                ),
              ),
              PopupMenuItem(
                child: TextButton.icon(
                  label: Text(
                    texts.catalog_item_action_delete,
                    style: themeData.textTheme.subtitle1,
                  ),
                  icon: Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    DeleteItem deleteItem = DeleteItem(_itemInfo.id);
                    posCatalogBloc.actionsSink.add(deleteItem);
                    deleteItem.future.catchError(
                      (err) => showFlushbar(
                        context,
                        message: texts.catalog_item_error_delete(
                          _itemInfo.name,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            child: ListTile(
              leading: ItemAvatar(
                _itemInfo.imageURL,
                itemName: _itemInfo.name,
                key: _avatarKey,
              ),
              title: Text(
                _itemInfo.name,
                style: themeData.textTheme.itemTitleStyle,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: themeData.textTheme.itemPriceStyle,
                          children: [
                            TextSpan(
                              text: _getSymbol(),
                            ),
                            TextSpan(
                              text: _formattedPrice(), // Price
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () => _addItem(_itemInfo, _avatarKey),
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
      ],
    );
  }

  String _getSymbol() =>
      CurrencyWrapper.fromShortName(
        _itemInfo.currency,
        accountModel,
      )?.symbol ??
      "";

  String _formattedPrice() =>
      CurrencyWrapper.fromShortName(
        _itemInfo.currency,
        accountModel,
      )?.format(
        _itemInfo.price,
        removeTrailingZeros: true,
      ) ??
      "";
}

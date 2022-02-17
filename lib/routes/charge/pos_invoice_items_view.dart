import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/routes/charge/items/items_list.dart';
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';

import '../../theme_data.dart';

class PosInvoiceItemsView extends StatelessWidget {
  final Sale currentSale;
  final AccountModel accountModel;
  final TextEditingController itemFilterController;
  final Function(Item, GlobalKey) addItem;

  const PosInvoiceItemsView({
    Key key,
    this.currentSale,
    this.accountModel,
    this.itemFilterController,
    this.addItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);

    return StreamBuilder(
        stream: posCatalogBloc.posItemSort,
        initialData: PosCatalogItemSort.NONE,
        builder: (context, snapshot) {
          final sort = snapshot.data ?? PosCatalogItemSort.NONE;

          return StreamBuilder(
            stream: posCatalogBloc.itemsStream,
            builder: (context, snapshot) {
              final posCatalog = snapshot.data;
              if (posCatalog == null) return Loader();

              return Scaffold(
                body: _buildCatalogContent(
                    context, posCatalogBloc, posCatalog, sort),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: (themeId == "BLUE")
                      ? Colors.white
                      : context.primaryColorLight,
                  foregroundColor: context.textTheme.button.color,
                  onPressed: () => context.pushNamed("/add_item"),
                ),
              );
            },
          );
        });
  }

  Widget _buildCatalogContent(
    BuildContext context,
    PosCatalogBloc posCatalogBloc,
    List<Item> catalogItems,
    PosCatalogItemSort sort,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            _searchBar(context, catalogItems),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 24.0, 0.0),
              child: _dropDownButton(context, posCatalogBloc, sort),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListView(
              primary: false,
              shrinkWrap: true,
              children: catalogItems?.length == 0
                  ? _emptyCatalog(context)
                  : _filledCatalog(context, catalogItems),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropDownButton(
    BuildContext context,
    PosCatalogBloc posCatalogBloc,
    PosCatalogItemSort sort,
  ) {
    final items = [
      PosCatalogItemSort.NONE,
      sort == PosCatalogItemSort.ALPHABETICALLY_Z_A
          ? PosCatalogItemSort.ALPHABETICALLY_Z_A
          : PosCatalogItemSort.ALPHABETICALLY_A_Z,
      sort == PosCatalogItemSort.PRICE_BIG_TO_SMALL
          ? PosCatalogItemSort.PRICE_BIG_TO_SMALL
          : PosCatalogItemSort.PRICE_SMALL_TO_BIG,
    ];

    TapDownDetails _details;
    return GestureDetector(
      onTapDown: (details) {
        _details = details;
      },
      onTap: () async {
        final offset = _details?.globalPosition;
        if (offset == null) return;
        final newOption = await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
          items: items.map((e) => _dropdownItem(context, e, sort)).toList(),
        );
        if (newOption != null) {
          var upstream = newOption;
          if (sort == PosCatalogItemSort.ALPHABETICALLY_Z_A ||
              sort == PosCatalogItemSort.ALPHABETICALLY_A_Z) {
            if (newOption == PosCatalogItemSort.ALPHABETICALLY_Z_A) {
              upstream = PosCatalogItemSort.ALPHABETICALLY_A_Z;
            } else if (newOption == PosCatalogItemSort.ALPHABETICALLY_A_Z) {
              upstream = PosCatalogItemSort.ALPHABETICALLY_Z_A;
            }
          } else if (sort == PosCatalogItemSort.PRICE_BIG_TO_SMALL ||
              sort == PosCatalogItemSort.PRICE_SMALL_TO_BIG) {
            if (newOption == PosCatalogItemSort.PRICE_BIG_TO_SMALL) {
              upstream = PosCatalogItemSort.PRICE_SMALL_TO_BIG;
            } else if (newOption == PosCatalogItemSort.PRICE_SMALL_TO_BIG) {
              upstream = PosCatalogItemSort.PRICE_BIG_TO_SMALL;
            }
          }
          posCatalogBloc.actionsSink.add(UpdatePosCatalogItemSort(upstream));
        }
      },
      child: _dropdownHandler(context, sort),
    );
  }

  _SortMenuItemHelper _dropDownItemData(
    BuildContext context,
    PosCatalogItemSort value,
  ) {
    final l10n = context.l10n;
    String text;
    Widget icon;
    Widget handler;
    switch (value) {
      case PosCatalogItemSort.NONE:
        text = l10n.pos_invoice_sort_none;
        icon = SizedBox(width: 24, height: 24);
        handler = Icon(Icons.sort);
        break;
      case PosCatalogItemSort.ALPHABETICALLY_A_Z:
        text = l10n.pos_invoice_sort_alphabetically;
        icon = Icon(Icons.arrow_downward);
        handler = Icon(Icons.sort_by_alpha);
        break;
      case PosCatalogItemSort.ALPHABETICALLY_Z_A:
        text = l10n.pos_invoice_sort_alphabetically;
        icon = Icon(Icons.arrow_upward);
        handler = Icon(Icons.sort_by_alpha);
        break;
      case PosCatalogItemSort.PRICE_SMALL_TO_BIG:
        text = l10n.pos_invoice_sort_price;
        icon = Icon(Icons.arrow_downward);
        handler = Icon(Icons.filter_list);
        break;
      case PosCatalogItemSort.PRICE_BIG_TO_SMALL:
        text = l10n.pos_invoice_sort_price;
        icon = Icon(Icons.arrow_upward);
        handler = Icon(Icons.filter_list);
        break;
    }
    return _SortMenuItemHelper(text, icon, handler);
  }

  Widget _dropdownHandler(
    BuildContext context,
    PosCatalogItemSort sort,
  ) {
    final helper = _dropDownItemData(context, sort);
    return SizedBox(
      width: 48,
      height: 48,
      child: sort == PosCatalogItemSort.NONE
          ? Center(
              child: helper.handler,
            )
          : Row(
              children: [
                helper.handler,
                helper.icon,
              ],
            ),
    );
  }

  PopupMenuEntry<PosCatalogItemSort> _dropdownItem(
    BuildContext context,
    PosCatalogItemSort value,
    PosCatalogItemSort selected,
  ) {
    final helper = _dropDownItemData(context, value);
    return PopupMenuItem<PosCatalogItemSort>(
      value: value,
      child: Row(
        children: [
          Expanded(
            child: Text(
              helper.text,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: _fontWeight(value, selected),
              ),
            ),
          ),
          SizedBox(width: 32),
          helper.icon,
        ],
      ),
    );
  }

  FontWeight _fontWeight(
    PosCatalogItemSort value,
    PosCatalogItemSort selected,
  ) {
    switch (selected) {
      case PosCatalogItemSort.NONE:
        if (value == PosCatalogItemSort.NONE) {
          return FontWeight.bold;
        } else {
          return FontWeight.normal;
        }
        break;
      case PosCatalogItemSort.ALPHABETICALLY_A_Z:
      case PosCatalogItemSort.ALPHABETICALLY_Z_A:
        if (value == PosCatalogItemSort.ALPHABETICALLY_A_Z ||
            value == PosCatalogItemSort.ALPHABETICALLY_Z_A) {
          return FontWeight.bold;
        } else {
          return FontWeight.normal;
        }
        break;
      case PosCatalogItemSort.PRICE_SMALL_TO_BIG:
      case PosCatalogItemSort.PRICE_BIG_TO_SMALL:
        if (value == PosCatalogItemSort.PRICE_SMALL_TO_BIG ||
            value == PosCatalogItemSort.PRICE_BIG_TO_SMALL) {
          return FontWeight.bold;
        } else {
          return FontWeight.normal;
        }
        break;
    }
    return FontWeight.normal;
  }

  Widget _searchBar(
    BuildContext context,
    List<Item> catalogItems,
  ) {
    return Expanded(
      flex: 1,
      child: TextField(
        controller: itemFilterController,
        enabled: catalogItems != null,
        decoration: InputDecoration(
          hintText: context.l10n.pos_invoice_search_hint,
          contentPadding: const EdgeInsets.only(top: 16, left: 16),
          suffixIcon: IconButton(
            icon: Icon(
              itemFilterController.text.isEmpty ? Icons.search : Icons.close,
              size: 20,
            ),
            onPressed: itemFilterController.text.isEmpty
                ? null
                : () {
                    itemFilterController.text = "";
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
            padding: EdgeInsets.only(right: 24, top: 4),
          ),
          border: UnderlineInputBorder(),
        ),
      ),
    );
  }

  List<Widget> _emptyCatalog(BuildContext context) {
    var l10n = context.l10n;
    return [
      Padding(
        padding: const EdgeInsets.only(
          top: 180.0,
          left: 40.0,
          right: 40.0,
        ),
        child: AutoSizeText(
          itemFilterController.text.isNotEmpty
              ? l10n.pos_invoice_search_empty
              : l10n.pos_invoice_search_no_items,
          textAlign: TextAlign.center,
          minFontSize: context.minFontSize,
          stepGranularity: 0.1,
        ),
      ),
    ];
  }

  List<Widget> _filledCatalog(
    BuildContext context,
    List<Item> catalogItems,
  ) {
    final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
    return [
      ItemsList(
        accountModel,
        posCatalogBloc,
        catalogItems,
        (item, avatarKey) => addItem(item, avatarKey),
      ),
      Container(height: 80.0),
    ];
  }
}

class _SortMenuItemHelper {
  final String text;
  final Widget icon;
  final Widget handler;

  _SortMenuItemHelper(
    this.text,
    this.icon,
    this.handler,
  );
}

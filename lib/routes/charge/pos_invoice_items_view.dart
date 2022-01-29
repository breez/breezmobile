import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
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
      stream: posCatalogBloc.itemsStream,
      builder: (context, snapshot) {
        var posCatalog = snapshot.data;
        if (posCatalog == null) return Loader();

        return Scaffold(
          body: _buildCatalogContent(
            context,
            posCatalog,
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
            ),
            backgroundColor:
                (themeId == "BLUE") ? Colors.white : context.primaryColorLight,
            foregroundColor: context.textTheme.button.color,
            onPressed: () => context.pushNamed("/add_item"),
          ),
        );
      },
    );
  }

  Widget _buildCatalogContent(
    BuildContext context,
    List<Item> catalogItems,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 0,
          child: TextField(
            controller: itemFilterController,
            enabled: catalogItems != null,
            decoration: InputDecoration(
              hintText: context.l10n.pos_invoice_search_hint,
              contentPadding: const EdgeInsets.only(top: 16, left: 16),
              suffixIcon: IconButton(
                icon: Icon(
                  itemFilterController.text.isEmpty
                      ? Icons.search
                      : Icons.close,
                  size: 20,
                ),
                onPressed: itemFilterController.text.isEmpty
                    ? null
                    : () {
                        itemFilterController.text = "";
                        context.hideKeyboard();
                      },
                padding: EdgeInsets.only(right: 24, top: 4),
              ),
              border: UnderlineInputBorder(),
            ),
          ),
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

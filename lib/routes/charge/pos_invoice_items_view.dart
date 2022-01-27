import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/routes/charge/items/items_list.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final themeData = Theme.of(context);
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
            backgroundColor: themeData.buttonColor,
            foregroundColor: themeData.textTheme.button.color,
            onPressed: () => Navigator.of(context).pushNamed("/add_item"),
          ),
        );
      },
    );
  }

  Widget _buildCatalogContent(
    BuildContext context,
    List<Item> catalogItems,
  ) {
    final texts = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 0,
          child: TextField(
            controller: itemFilterController,
            enabled: catalogItems != null,
            decoration: InputDecoration(
              hintText: texts.pos_invoice_search_hint,
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
                        FocusScope.of(context).requestFocus(FocusNode());
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
    final texts = AppLocalizations.of(context);
    return [
      Padding(
        padding: const EdgeInsets.only(
          top: 180.0,
          left: 40.0,
          right: 40.0,
        ),
        child: AutoSizeText(
          itemFilterController.text.isNotEmpty
              ? texts.pos_invoice_search_empty
              : texts.pos_invoice_search_no_items,
          textAlign: TextAlign.center,
          minFontSize: MinFontSize(context).minFontSize,
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

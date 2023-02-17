import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/marketplace/marketplace_bloc.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/routes/marketplace/vendor_row.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter/material.dart';

class MarketplacePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MarketplacePageState();
  }
}

class MarketplacePageState extends State<MarketplacePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final marketplaceBloc = AppBlocsProvider.of<MarketplaceBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.themeId == "BLUE"
          ? Theme.of(context).colorScheme.background
          : Theme.of(context).canvasColor,
      body: StreamBuilder(
        stream: marketplaceBloc.vendorsStream,
        builder: (context, snapshot) {
          List<VendorModel> vendorsModel = snapshot.data;

          if (vendorsModel == null || vendorsModel.isEmpty) {
            return _buildNoVendorsMessage(context);
          }

          return _buildVendors(vendorsModel);
        },
      ),
    );
  }

  Center _buildNoVendorsMessage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          BreezTranslations.of(context).market_place_no_vendors,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium.copyWith(
                color: theme.themeId == "BLUE"
                    ? Theme.of(context).canvasColor
                    : Colors.white,
              ),
        ),
      ),
    );
  }

  Widget _buildVendors(List<VendorModel> vendorModel) {
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height -
          kToolbarHeight -
          MediaQuery.of(context).padding.top,
      child: ListView.builder(
        itemBuilder: (context, i) => VendorRow(accountBloc, vendorModel[i]),
        itemCount: vendorModel.length,
        itemExtent: 200.0,
      ),
    );
  }
}

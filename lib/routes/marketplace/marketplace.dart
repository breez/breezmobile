import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/marketplace/marketplace_bloc.dart';
import 'package:clovrlabs_wallet/bloc/marketplace/vendor_model.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'vendor_row.dart';

class MarketplacePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MarketplacePageState();
  }
}

class MarketplacePageState extends State<MarketplacePage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final marketplaceBloc = AppBlocsProvider.of<MarketplaceBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.themeId == "WHITE"
          ? Theme.of(context).backgroundColor
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
          AppLocalizations.of(context).market_place_no_vendors,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4.copyWith(
                color: theme.themeId == "WHITE"
                    ? Theme.of(context).canvasColor
                    : Colors.white,
              ),
        ),
      ),
    );
  }

  Widget _buildVendors(List<VendorModel> vendorModel) {
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return Container(
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

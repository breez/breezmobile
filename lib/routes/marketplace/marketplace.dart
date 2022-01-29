import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/marketplace/marketplace_bloc.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: theme.themeId == "BLUE"
          ? context.backgroundColor
          : context.canvasColor,
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
          context.l10n.market_place_no_vendors,
          textAlign: TextAlign.center,
          style: context.textTheme.headline4.copyWith(
            color: theme.themeId == "BLUE" ? context.canvasColor : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildVendors(List<VendorModel> vendorModel) {
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return Container(
      height: context.mediaQuerySize.height -
          kToolbarHeight -
          context.mediaQueryPadding.top,
      child: ListView.builder(
        itemBuilder: (context, i) => VendorRow(accountBloc, vendorModel[i]),
        itemCount: vendorModel.length,
        itemExtent: 200.0,
      ),
    );
  }
}

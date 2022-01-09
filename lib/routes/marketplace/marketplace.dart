import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/marketplace/marketplace_bloc.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'vendor_row.dart';

class MarketplacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    final marketplaceBloc = AppBlocsProvider.of<MarketplaceBloc>(context);

    return StreamBuilder(
      stream: marketplaceBloc.vendorsStream,
      builder: (context, snapshot) {
        List<VendorModel> vendorsModel = snapshot.data;

        if (vendorsModel == null || vendorsModel.isEmpty) {
          return _buildScaffold(
            context,
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  texts.market_place_no_vendors,
                  textAlign: TextAlign.center,
                  style: themeData.textTheme.headline4.copyWith(
                    color: theme.themeId == "BLUE"
                        ? themeData.canvasColor
                        : Colors.white,
                  ),
                ),
              ),
            ),
          );
        }

        return _buildScaffold(
          context,
          _buildVendors(accountBloc, vendorsModel),
        );
      },
    );
  }

  Widget _buildScaffold(BuildContext context, Widget body) {
    final themeData = Theme.of(context);
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      backgroundColor: theme.themeId == "BLUE"
          ? themeData.backgroundColor
          : themeData.canvasColor,
      body: body,
    );
  }

  Widget _buildVendors(AccountBloc accountBloc, List<VendorModel> vendorModel) {
    return ListView.builder(
      itemBuilder: (context, i) => VendorRow(accountBloc, vendorModel[i]),
      itemCount: vendorModel.length,
      itemExtent: 200.0,
    );
  }
}

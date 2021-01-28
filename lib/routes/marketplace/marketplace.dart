import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/marketplace/marketplace_bloc.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:flutter/material.dart';

import 'vendor_row.dart';

class MarketplacePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MarketplacePageState();
  }
}

class MarketplacePageState extends State<MarketplacePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AccountBloc _accountBloc;
  MarketplaceBloc _marketplaceBloc;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      _marketplaceBloc = AppBlocsProvider.of<MarketplaceBloc>(context);
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _marketplaceBloc.vendorsStream,
        builder: (context, snapshot) {
          List<VendorModel> vendorsModel = snapshot.data;

          if (vendorsModel == null) {
            return _buildScaffold(Center(
                child: Text("There are no available vendors at the moment.")));
          }

          return _buildScaffold(_buildVendors(vendorsModel));
        });
  }

  Widget _buildScaffold(Widget body) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: body,
    );
  }

  Widget _buildVendors(List<VendorModel> vendorModel) {
    return ListView.builder(
      itemBuilder: (context, index) =>
          VendorRow(_accountBloc, vendorModel[index]),
      itemCount: vendorModel.length,
      itemExtent: 200.0,
    );
  }
}

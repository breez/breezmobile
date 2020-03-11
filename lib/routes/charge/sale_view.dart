import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:fixnum/fixnum.dart';

class SaleView extends StatelessWidget {
  final bool useFiat;

  const SaleView({Key key, this.useFiat = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PosCatalogBloc posCatalogBloc =
        AppBlocsProvider.of<PosCatalogBloc>(context);
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return StreamBuilder<Sale>(
        stream: posCatalogBloc.currentSaleStream,
        builder: (context, saleSnapshot) {
          var currentSale = saleSnapshot.data;
          return StreamBuilder<AccountModel>(
              stream: accountBloc.accountStream,
              builder: (context, accSnapshot) {
                var accModel = accSnapshot.data;
                if (accModel == null) {
                  return Loader();
                }
                return Scaffold(
                    appBar: AppBar(
                      iconTheme: Theme.of(context).appBarTheme.iconTheme,
                      textTheme: Theme.of(context).appBarTheme.textTheme,
                      backgroundColor: Theme.of(context).canvasColor,
                      leading: backBtn.BackButton(iconData: Icons.close),
                      title: _TotalSaleCharge(
                        accountModel: accModel,
                        currentSale: currentSale,
                        useFiat: useFiat,
                      ),
                      elevation: 0.0,
                    ),
                    body: SaleLinesList(currentSale: currentSale));
              });
        });
  }
}

class _TotalSaleCharge extends StatelessWidget {
  final AccountModel accountModel;
  final Sale currentSale;
  final bool useFiat;

  const _TotalSaleCharge(
      {Key key, this.accountModel, this.currentSale, this.useFiat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var totalSats = currentSale.totalChargeSat;
    String formattedCharge;
    print(totalSats);
    if (useFiat) {
      formattedCharge =
          accountModel.fiatCurrency.format(Int64(totalSats.round()));
    } else {
      formattedCharge = accountModel.currency.format(Int64(totalSats.round()));
    }
    return Text(
      "Total: $formattedCharge",
      style: Theme.of(context).appBarTheme.textTheme.title,
    );
  }
}

class SaleLinesList extends StatelessWidget {
  final Sale currentSale;

  const SaleLinesList({Key key, this.currentSale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: currentSale.saleLines.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (BuildContext context, int index) {
          return SaleLineWidget(saleLine: currentSale.saleLines[index]);
        });
  }
}

class SaleLineWidget extends StatelessWidget {
  final SaleLine saleLine;

  const SaleLineWidget({Key key, this.saleLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(saleLine.itemName));
  }
}

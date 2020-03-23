import 'package:breez/bloc/fastbitcoins/fastbitcoins_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class FastBitcoinsConfirmWidget extends StatelessWidget {
  final ValidateRequestModel request;
  final ValidateResponseModel response;
  final BreezUserModel user;

  const FastBitcoinsConfirmWidget(
      {Key key, this.user, this.request, this.response})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String btcReceived = user.currency.format(Int64(response.satoshiAmount));
    String comissionRate =
        (response.commissionTotal / response.value * 100).toStringAsFixed(2) +
            "%";

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          ConfirmationItem(
              title: "Voucher value",
              details:
                  '${response.value.toStringAsFixed(2)} ${request.currency}'),
          ConfirmationItem(
              title: "Exchange rate",
              details:
                  '${response.exchangeRate.toStringAsFixed(2)} ${request.currency}'),
          ConfirmationItem(title: "Commission rate", details: comissionRate),
          ConfirmationItem(
              title: "Commission total",
              details:
                  '${response.commissionTotal.toStringAsFixed(2)} ${request.currency}'),
          ConfirmationItem(title: "Bitcoins received", details: btcReceived),
        ],
      ),
    );
  }
}

class ConfirmationItem extends StatelessWidget {
  final String title;
  final String details;

  const ConfirmationItem({Key key, this.title, this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).primaryTextTheme.headline4,
          textAlign: TextAlign.left,
        ),
        trailing: Text(
          details,
          style: Theme.of(context).primaryTextTheme.headline3,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}

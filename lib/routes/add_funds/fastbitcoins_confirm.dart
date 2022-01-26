import 'package:breez/bloc/fastbitcoins/fastbitcoins_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/l10n/locales.dart';

class FastBitcoinsConfirmWidget extends StatelessWidget {
  final ValidateRequestModel request;
  final ValidateResponseModel response;
  final BreezUserModel user;

  const FastBitcoinsConfirmWidget({
    Key key,
    this.user,
    this.request,
    this.response,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          ConfirmationItem(
            title: context.l10n.add_funds_item_voucher_title,
            details: context.l10n.add_funds_item_voucher_message(
              response.value.toStringAsFixed(2),
              request.currency,
            ),
          ),
          ConfirmationItem(
            title: context.l10n.add_funds_item_exchange_rate_title,
            details: context.l10n.add_funds_item_exchange_rate_message(
              response.exchangeRate.toStringAsFixed(2),
              request.currency,
            ),
          ),
          ConfirmationItem(
            title: context.l10n.add_funds_item_commission_rate_title,
            details: context.l10n.add_funds_item_commission_rate_message(
              (response.commissionTotal / response.value * 100)
                  .toStringAsFixed(2),
            ),
          ),
          ConfirmationItem(
            title: context.l10n.add_funds_item_commission_total_title,
            details: context.l10n.add_funds_item_commission_total_message(
              response.commissionTotal.toStringAsFixed(2),
              request.currency,
            ),
          ),
          ConfirmationItem(
            title: context.l10n.add_funds_item_bitcoins_received_title,
            details: user.currency.format(Int64(response.satoshiAmount)),
          ),
        ],
      ),
    );
  }
}

class ConfirmationItem extends StatelessWidget {
  final String title;
  final String details;

  const ConfirmationItem({
    Key key,
    this.title,
    this.details,
  }) : super(key: key);

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

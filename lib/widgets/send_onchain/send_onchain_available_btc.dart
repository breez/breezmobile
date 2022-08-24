import 'package:breez/bloc/account/account_model.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendOnchainAvailableBTC extends StatelessWidget {
  final Int64 amount;
  final AccountModel account;

  const SendOnchainAvailableBTC(
    this.amount,
    this.account, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    return Row(
      children: [
        Text(
          texts.send_on_chain_amount,
          style: themeData.dialogTheme.contentTextStyle,
        ),
        Padding(
          padding: EdgeInsets.only(left: 3.0),
          child: Text(
            account.currency.format(amount),
            style: themeData.dialogTheme.contentTextStyle,
          ),
        ),
      ],
    );
  }
}

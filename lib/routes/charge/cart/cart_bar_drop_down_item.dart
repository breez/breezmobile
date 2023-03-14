import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class CartBarDropDownItem extends DropdownMenuItem<String> {
  CartBarDropDownItem(
    BuildContext context,
    CurrencyWrapper currency, {
    Key key,
  }) : super(
          key: key,
          value: currency.shortName,
          child: Text(
            currency.shortName.toUpperCase(),
            textAlign: TextAlign.right,
            style: theme.invoiceAmountStyle.copyWith(
              color: Theme.of(context).textTheme.headlineSmall.color,
            ),
          ),
        );
}

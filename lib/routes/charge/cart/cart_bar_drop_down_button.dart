import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/charge/cart/cart_bar_drop_down_item.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class CartBarDropDownButton extends StatelessWidget {
  final String value;
  final AccountModel accountModel;
  final ValueChanged<String> onChanged;

  const CartBarDropDownButton(
    this.value,
    this.accountModel,
    this.onChanged, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DropdownButtonHideUnderline(
      key: key,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton(
          onChanged: onChanged,
          iconEnabledColor: textTheme.headlineSmall.color,
          value: value,
          style: theme.invoiceAmountStyle.copyWith(
            color: textTheme.headlineSmall.color,
          ),
          items: _items(context, accountModel),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _items(
    BuildContext context,
    AccountModel accountModel,
  ) {
    log.info("Building the cart drop down items");
    List<CurrencyWrapper> currencies = [];
    currencies.addAll(
      Currency.currencies.map((c) => CurrencyWrapper.fromBTC(c)),
    );
    log.info('Currencies after first addition: [${_fold(currencies)}]');
    currencies.addAll(
      accountModel.preferredFiatConversionList.map((f) => CurrencyWrapper.fromFiat(f)),
    );
    log.info('Currencies after second addition: [${_fold(currencies)}]');
    final dropDownItems = currencies.map(
      (currency) => CartBarDropDownItem(context, currency),
    );
    log.info('Drop down items: [${dropDownItems.fold("", (p, e) => p.isEmpty ? e.value : "$p, ${e.value}")}]');
    return dropDownItems.toList();
  }

  String _fold(List<CurrencyWrapper> currencies) {
    return currencies.fold("", (p, e) => p.isEmpty ? e.shortName : "$p, ${e.shortName}");
  }
}

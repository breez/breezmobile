import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/charge/cart/cart_bar_drop_down_item.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

final _log = FimberLog("CartBarDropDownButton");

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
          iconEnabledColor: textTheme.headline5.color,
          value: value,
          style: theme.invoiceAmountStyle.copyWith(
            color: textTheme.headline5.color,
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
    _log.v("Building the cart drop down items");
    List<CurrencyWrapper> currencies = [];
    currencies.addAll(
      Currency.currencies.map((c) => CurrencyWrapper.fromBTC(c)),
    );
    _log.v('Currencies after first addition: [${_fold(currencies)}]');
    currencies.addAll(
      accountModel.preferredFiatConversionList.map((f) => CurrencyWrapper.fromFiat(f)),
    );
    _log.v('Currencies after second addition: [${_fold(currencies)}]');
    final dropDownItems = currencies.map(
      (currency) => CartBarDropDownItem(context, currency),
    );
    _log.v('Drop down items: [${dropDownItems.fold("", (p, e) => p.isEmpty ? e.value : "$p, ${e.value}")}]');
    return dropDownItems.toList();
  }

  String _fold(List<CurrencyWrapper> currencies) {
    return currencies.fold("", (p, e) => p.isEmpty ? e.shortName : "$p, ${e.shortName}");
  }
}

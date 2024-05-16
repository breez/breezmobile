import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/charge/cart/cart_bar_drop_down_item.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _log = Logger("CartBarDropDownButton");

class CartBarDropDownButton extends StatefulWidget {
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
  State<CartBarDropDownButton> createState() => _CartBarDropDownButtonState();
}

class _CartBarDropDownButtonState extends State<CartBarDropDownButton> {
  List<CurrencyWrapper> currencyList = [];

  @override
  void initState() {
    super.initState();
    _updateCurrencyList(_generateCurrencyList());
  }

  @override
  void didUpdateWidget(CartBarDropDownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    List<CurrencyWrapper> newCurrencyList = _generateCurrencyList();
    if (_isCurrencyListDifferent(currencyList, newCurrencyList)) {
      _updateCurrencyList(newCurrencyList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DropdownButtonHideUnderline(
      key: widget.key,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton(
          onChanged: widget.onChanged,
          iconEnabledColor: textTheme.headlineSmall.color,
          value: widget.value,
          style: theme.invoiceAmountStyle.copyWith(
            color: textTheme.headlineSmall.color,
          ),
          items: currencyList.map((currency) => CartBarDropDownItem(context, currency)).toList(),
        ),
      ),
    );
  }

  List<CurrencyWrapper> _generateCurrencyList() {
    List<CurrencyWrapper> newCurrencyList = [
      ...Currency.currencies.map((c) => CurrencyWrapper.fromBTC(c)),
      ...widget.accountModel.preferredFiatConversionList.map((f) => CurrencyWrapper.fromFiat(f)),
    ];
    return newCurrencyList;
  }

  bool _isCurrencyListDifferent(List<CurrencyWrapper> oldList, List<CurrencyWrapper> newList) {
    // We compare currency names instead of the entire CurrencyWrapper list
    // because we're interested in changes in the currency selection,
    // not in their properties(i.e. changes in exchange rates).
    return !listEquals(
      oldList.map((e) => e.shortName).toList(),
      newList.map((e) => e.shortName).toList(),
    );
  }

  void _updateCurrencyList(List<CurrencyWrapper> newCurrencyList) {
    _log.info('POS Currency list: [${_fold(newCurrencyList)}]');
    setState(() {
      currencyList = newCurrencyList;
    });
  }

  String _fold(List<CurrencyWrapper> currencies) {
    return currencies.map((e) => e.shortName).join(", ");
  }
}

import 'package:badges/badges.dart';
import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/currency.dart';
import 'package:clovrlabs_wallet/routes/charge/currency_wrapper.dart';
import 'package:clovrlabs_wallet/routes/charge/sale_view.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/widgets/breez_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PosInvoiceCartBar extends StatefulWidget {
  final GlobalKey badgeKey;
  final int totalNumOfItems;
  final AccountModel accountModel;
  final CurrencyWrapper currentCurrency;
  final bool isKeypadView;
  final double currentAmount;
  final VoidCallback onInvoiceSubmit;
  final VoidCallback approveClear;
  final Function(String) changeCurrency;

  const PosInvoiceCartBar({
    Key key,
    this.badgeKey,
    this.totalNumOfItems,
    this.accountModel,
    this.currentCurrency,
    this.isKeypadView,
    this.currentAmount,
    this.onInvoiceSubmit,
    this.approveClear,
    this.changeCurrency,
  }) : super(key: key);

  @override
  State<PosInvoiceCartBar> createState() => _PosInvoiceCartBarState();
}

class _PosInvoiceCartBarState extends State<PosInvoiceCartBar> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final badgeColor = themeData.floatingActionButtonTheme.backgroundColor;

    return Padding(
      padding: EdgeInsets.only(left: 0.0, right: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.of(context).push(
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => SaleView(
                      onCharge: () => widget.onInvoiceSubmit(),
                      onDeleteSale: widget.approveClear,
                      saleCurrency: widget.currentCurrency,
                    ),
                  ),
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: 80.0,
                  child: Badge(
                    key: widget.badgeKey,
                    position: BadgePosition.topEnd(top: 5, end: -10),
                    animationType: BadgeAnimationType.scale,
                    badgeColor: badgeColor,
                    badgeContent: Text(
                      "${widget.totalNumOfItems}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 4.0, 8.0),
                      child: Image.asset(
                        "src/icon/cart.png",
                        width: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.isKeypadView
                        ? widget.currentCurrency.format(widget.currentAmount)
                        : "",
                    maxLines: 1,
                    style: theme.invoiceAmountStyle.copyWith(
                      color: themeData.textTheme.headline5.color,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
          ),
          Theme(
            data: themeData.copyWith(
              canvasColor: themeData.backgroundColor,
            ),
            child: _dropDown(context),
          ),
        ],
      ),
    );
  }

  Widget _dropDown(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    List<CurrencyWrapper> currencies = [];
    currencies.addAll(
      Currency.currencies.map((c) => CurrencyWrapper.fromBTC(c)),
    );
    currencies.addAll(
      widget.accountModel.preferredFiatConversionList
          .map((f) => CurrencyWrapper.fromFiat(f)),
    );
    final dropDownItems = currencies.map(
      (value) => DropdownMenuItem<String>(
        value: value.shortName,
        child: Material(
          child: Text(
            value.shortName.toUpperCase(),
            textAlign: TextAlign.right,
            style: theme.invoiceAmountStyle.copyWith(
              color: textTheme.headline5.color,
            ),
          ),
        ),
      ),
    );

    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: BreezDropdownButton(
          onChanged: widget.changeCurrency,
          iconEnabledColor: textTheme.headline5.color,
          value: widget.currentCurrency.shortName,
          style: theme.invoiceAmountStyle.copyWith(
            color: textTheme.headline5.color,
          ),
          items: dropDownItems.toList(),
        ),
      ),
    );
  }
}

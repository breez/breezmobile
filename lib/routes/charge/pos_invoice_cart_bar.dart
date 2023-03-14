import 'package:badges/badges.dart' as badges;
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/charge/cart/cart_bar_drop_down_button.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/routes/charge/sale_view.dart';
import 'package:breez/theme_data.dart' as theme;
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
      padding: const EdgeInsets.only(left: 0.0, right: 16.0),
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
                  child: badges.Badge(
                    key: widget.badgeKey,
                    position: badges.BadgePosition.topEnd(top: 5, end: -10),
                    badgeAnimation: const badges.BadgeAnimation.scale(),
                    badgeStyle: badges.BadgeStyle(badgeColor: badgeColor),
                    badgeContent: Text(
                      "${widget.totalNumOfItems}",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 4.0, 8.0),
                      child: Image.asset(
                        "src/icon/cart.png",
                        width: 24.0,
                        color: themeData.primaryTextTheme.labelLarge.color,
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
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.isKeypadView
                        ? widget.currentCurrency.format(widget.currentAmount)
                        : "",
                    maxLines: 1,
                    style: theme.invoiceAmountStyle.copyWith(
                      color: themeData.textTheme.headlineSmall.color,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
          ),
          Theme(
            data: themeData.copyWith(
              canvasColor: themeData.colorScheme.background,
            ),
            child: CartBarDropDownButton(
              widget.currentCurrency.shortName,
              widget.accountModel,
              widget.changeCurrency,
            ),
          ),
        ],
      ),
    );
  }
}

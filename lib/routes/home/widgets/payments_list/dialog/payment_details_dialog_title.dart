import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/home/payment_item_avatar.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class PaymentDetailsDialogTitle extends StatelessWidget {
  final PaymentInfo paymentInfo;

  const PaymentDetailsDialogTitle({
    Key key,
    this.paymentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Stack(
      children: <Widget>[
        Container(
          decoration: ShapeDecoration(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
            ),
            color: theme.themeId == "BLUE"
                ? themeData.primaryColorDark
                : themeData.canvasColor,
          ),
          height: 64.0,
          width: mediaQuery.size.width,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Center(
            child: PaymentItemAvatar(
              paymentInfo,
              radius: 32.0,
            ),
          ),
        ),
      ],
    );
  }
}

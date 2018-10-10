import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class PaymentItemAvatar extends StatelessWidget {
  final PaymentInfo paymentItem;
  final double radius;

  PaymentItemAvatar(this.paymentItem, {this.radius = 20.0});

  @override
  Widget build(BuildContext context) {
    if (paymentItem.type == PaymentType.DEPOSIT) {
      return Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.all(new Radius.circular(radius))),
          width: radius * 2,
          height: radius * 2,
          child: Icon(Icons.add, color: theme.BreezColors.blue[500]));
    } else {
      return BreezAvatar(paymentItem.imageURL, radius: radius);
    }
  }
}

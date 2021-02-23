import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';

class PaymentItemAvatar extends StatelessWidget {
  final PaymentInfo paymentItem;
  final double radius;

  PaymentItemAvatar(this.paymentItem, {this.radius = 20.0});

  @override
  Widget build(BuildContext context) {
    if (_shouldShowLeadingIcon) {
      IconData icon = [PaymentType.DEPOSIT, PaymentType.RECEIVED]
                  .indexOf(paymentItem.type) >=
              0
          ? Icons.add
          : Icons.remove;
      Widget child = Icon(icon, color: theme.BreezColors.blue[500]);
      if (paymentItem is StreamedPaymentInfo) {
        child = Image(
          image: AssetImage("src/icon/podcast.png"),
          color: theme.BreezColors.blue[500],
        );
      }
      return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(radius))),
          width: radius * 2,
          height: radius * 2,
          child: child);
    } else {
      return BreezAvatar(paymentItem.imageURL, radius: radius);
    }
  }

  bool get _shouldShowLeadingIcon =>
      paymentItem.imageURL == null && paymentItem.containsPaymentInfo ||
      paymentItem.isTransferRequest ||
      paymentItem.keySend ||
      paymentItem.type == PaymentType.CLOSED_CHANNEL;
}

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
      if (paymentItem is StreamedPaymentInfo) {
        return CircleAvatar(
            radius: radius,
            backgroundColor: Colors.white,
            child: ImageIcon(
              AssetImage("src/icon/podcast.png"),
              color: theme.BreezColors.blue[500],
              size: 0.6 * radius * 2,
            ));
      }

      IconData icon = [PaymentType.DEPOSIT, PaymentType.RECEIVED]
                  .indexOf(paymentItem.type) >=
              0
          ? Icons.add_rounded
          : Icons.remove_rounded;
      Widget child = Icon(icon, color: Color(0xb3303234));
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: child,
      );
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

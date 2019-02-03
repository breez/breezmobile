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
    if (paymentItem.description.startsWith("Bitrefill")) {
      return Container(
        decoration: ShapeDecoration(color: Colors.white,
            shape: CircleBorder(side: BorderSide(color: Colors.white)),
            image: DecorationImage(
                image: AssetImage("src/icon/vendors/bitrefill_logo.png"),
                colorFilter: ColorFilter.mode(
                    Color(0xFF3e99fa), BlendMode.color))),
        width: radius * 2,
        height: radius * 2,
      );
    } else if (_shouldShowLeadingIcon) {
      IconData icon = [PaymentType.DEPOSIT, PaymentType.RECEIVED].indexOf(
          paymentItem.type) >= 0 ? Icons.add : Icons.remove;
      return Container(
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: new BorderRadius.all(new Radius.circular(radius))),
          width: radius * 2,
          height: radius * 2,
          child: Icon(icon, color: theme.BreezColors.blue[500]));
    } else {
      return BreezAvatar(paymentItem.imageURL, radius: radius);
    }
  }

  bool get _shouldShowLeadingIcon => paymentItem.imageURL == null &&  paymentItem.containsPaymentInfo || paymentItem.isTransferRequest;
}

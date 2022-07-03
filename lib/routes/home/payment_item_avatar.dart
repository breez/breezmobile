import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/lnurl_metadata_extension.dart';
import 'package:breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';

class PaymentItemAvatar extends StatelessWidget {
  final PaymentInfo paymentItem;
  final double radius;

  const PaymentItemAvatar(
    this.paymentItem, {
    this.radius = 20.0,
  });

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
          ),
        );
      }

      final metadataImage = _metadataImage();
      if (metadataImage != null) return metadataImage;

      IconData icon = paymentItem.type == PaymentType.RECEIVED
          ? Icons.add_rounded
          : Icons.remove_rounded;
      Widget child = Icon(icon, color: Color(0xb3303234));
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: child,
      );
    } else {
      final metadataImage = _metadataImage();
      if (metadataImage != null) return metadataImage;

      return BreezAvatar(paymentItem.imageURL, radius: radius);
    }
  }

  Widget _metadataImage() {
    final metadata = paymentItem.metadata;
    if (metadata != null) {
      final image = metadata.metadataImage();
      if (image != null) {
        final size = 0.6 * radius * 2;
        return CircleAvatar(
          radius: radius,
          backgroundColor: Colors.white,
          child: Container(
            width: size,
            height: size,
            child: image,
          ),
        );
      }
    }
    return null;
  }

  bool get _shouldShowLeadingIcon =>
      paymentItem.imageURL == null && paymentItem.containsPaymentInfo ||
      paymentItem.isTransferRequest ||
      paymentItem.keySend ||
      paymentItem.type == PaymentType.CLOSED_CHANNEL;
}

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/shareable_payment_row.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class PaymentDetailsPreimage extends StatelessWidget {
  final PaymentInfo paymentInfo;

  const PaymentDetailsPreimage({
    Key key,
    this.paymentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final preimage = paymentInfo.preimage?.trim();

    if (preimage == null || preimage.isEmpty) {
      return Container();
    }

    return ShareablePaymentRow(
      title: texts.payment_details_dialog_single_info_pre_image,
      sharedValue: preimage,
    );
  }
}

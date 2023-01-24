import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/shareable_payment_row.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class PaymentDetailsNodeId extends StatelessWidget {
  final PaymentInfo paymentInfo;

  const PaymentDetailsNodeId({
    Key key,
    this.paymentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final destination = paymentInfo.destination?.trim();

    if (destination == null || destination.isEmpty) {
      return Container();
    }

    return ShareablePaymentRow(
      title: texts.payment_details_dialog_single_info_node_id,
      sharedValue: destination,
    );
  }
}

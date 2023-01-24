import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/shareable_payment_row.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogLnurlUrl extends StatelessWidget {
  final PaymentInfo paymentInfo;
  final AutoSizeGroup labelAutoSizeGroup;
  final AutoSizeGroup valueAutoSizeGroup;

  const PaymentDetailsDialogLnurlUrl({
    Key key,
    this.paymentInfo,
    this.labelAutoSizeGroup,
    this.valueAutoSizeGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final action = paymentInfo.lnurlPayInfo?.successAction;
    final url = action?.url?.trim();

    if (paymentInfo.type != PaymentType.SENT || action?.tag != "url" || url == null || url.isEmpty) {
      return Container();
    }

    return ShareablePaymentRow(
      title: texts.payment_details_dialog_action_for_payment_url,
      sharedValue: url,
      labelAutoSizeGroup: labelAutoSizeGroup,
      valueAutoSizeGroup: valueAutoSizeGroup,
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogAmount extends StatelessWidget {
  final PaymentInfo paymentInfo;
  final AutoSizeGroup labelAutoSizeGroup;
  final AutoSizeGroup valueAutoSizeGroup;

  const PaymentDetailsDialogAmount({
    Key key,
    this.paymentInfo,
    this.labelAutoSizeGroup,
    this.valueAutoSizeGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    if (paymentInfo.amount == null) {
      return Container();
    }

    final type = paymentInfo.type;
    final amount = paymentInfo.currency.format(paymentInfo.amount);
    final text = (type == PaymentType.SENT || type == PaymentType.WITHDRAWAL)
        ? texts.payment_details_dialog_amount_negative(amount)
        : texts.payment_details_dialog_amount_positive(amount);

    return Container(
      height: 36.0,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AutoSizeText(
              texts.payment_details_dialog_amount_title,
              style: themeData.primaryTextTheme.headlineMedium,
              textAlign: TextAlign.left,
              maxLines: 1,
              group: labelAutoSizeGroup,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: AutoSizeText(
                text,
                style: themeData.primaryTextTheme.displaySmall,
                textAlign: TextAlign.right,
                maxLines: 1,
                group: valueAutoSizeGroup,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

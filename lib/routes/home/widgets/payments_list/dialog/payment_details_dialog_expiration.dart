import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/utils/date.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogExpiration extends StatelessWidget {
  final PaymentInfo paymentInfo;
  final AutoSizeGroup labelAutoSizeGroup;
  final AutoSizeGroup valueAutoSizeGroup;

  const PaymentDetailsDialogExpiration({
    Key key,
    this.paymentInfo,
    this.labelAutoSizeGroup,
    this.valueAutoSizeGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    if (!paymentInfo.pending ||
        paymentInfo.type == PaymentType.CLOSED_CHANNEL) {
      return Container();
    }

    return Container(
      height: 36.0,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AutoSizeText(
              texts.payment_details_dialog_expiration,
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
              padding: const EdgeInsets.only(left: 8.0),
              child: AutoSizeText(
                BreezDateUtils.formatYearMonthDayHourMinute(
                  DateTime.fromMillisecondsSinceEpoch(
                    paymentInfo.pendingExpirationTimestamp.toInt() * 1000,
                  ),
                ),
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

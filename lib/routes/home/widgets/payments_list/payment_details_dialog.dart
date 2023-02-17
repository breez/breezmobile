import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_closed_channel_dialog.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_amount.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_content_title.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_date.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_description.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_destination.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_expiration.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_lnurl_address.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_lnurl_comment.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_lnurl_description.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_lnurl_message.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_lnurl_url.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_nodeid.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_preimage.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_title.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_txid.dart';
import 'package:collection/collection.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

final AutoSizeGroup _labelGroup = AutoSizeGroup();
final AutoSizeGroup _valueGroup = AutoSizeGroup();

Future<void> showPaymentDetailsDialog(
  BuildContext context,
  PaymentInfo paymentInfo,
) {
  log.info("showPaymentDetailsDialog: ${paymentInfo.paymentHash}");

  if (paymentInfo.type == PaymentType.CLOSED_CHANNEL) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => PaymentDetailsDialogClosedChannelDialog(
        paymentInfo: paymentInfo,
      ),
    );
  }

  return showDialog<void>(
    useRootNavigator: false,
    context: context,
    builder: (_) => AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: PaymentDetailsDialogTitle(
        paymentInfo: paymentInfo,
      ),
      contentPadding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PaymentDetailsDialogContentTitle(
                paymentInfo: paymentInfo,
              ),
              PaymentDetailsDialogDescription(
                paymentInfo: paymentInfo,
              ),
              PaymentDetailsDialogAmount(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogDate(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogExpiration(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogLnurlComment(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogLnurlAddress(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogLnurlDescription(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogLnurlUrl(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogLnurlMessage(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              ..._getPaymentInfoDetails(paymentInfo),
            ],
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(12.0),
          top: Radius.circular(13.0),
        ),
      ),
    ),
  );
}

List<Widget> _getPaymentInfoDetails(
  PaymentInfo paymentInfo,
) {
  if (paymentInfo is StreamedPaymentInfo) {
    return groupBy<PaymentInfo, String>(paymentInfo.singlePayments, (p) => p.title)
        .entries
        .map((ent) => PaymentDetailsDialogDestination(
              title: ent.key,
              amount: ent.value.fold(
                Int64(0),
                (previousValue, element) => element.amount + previousValue,
              ),
              currency: ent.value[0].currency,
              labelAutoSizeGroup: _labelGroup,
              valueAutoSizeGroup: _valueGroup,
            ))
        .toList();
  } else {
    return [
      PaymentDetailsPreimage(
        paymentInfo: paymentInfo,
      ),
      PaymentDetailsNodeId(
        paymentInfo: paymentInfo,
      ),
      PaymentDetailsTxId(
        paymentInfo: paymentInfo,
      ),
    ];
  }
}

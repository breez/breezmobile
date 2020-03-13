import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/payment_details_dialog.dart';
import 'package:flutter/material.dart';

class PosPaymentItem extends StatelessWidget {
  final PaymentInfo _paymentInfo;
  final bool _lastItem;

  PosPaymentItem(this._paymentInfo, this._lastItem);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: ListTile(
          title: Text(
            DateUtils.formatYearMonthDayHourMinute(
                DateTime.fromMillisecondsSinceEpoch(
                    _paymentInfo.creationTimestamp.toInt() * 1000)),
            style: _paymentInfo.type == PaymentType.SENT
                ? theme.posWithdrawalTransactionTitleStyle
                : theme.posTransactionTitleStyle,
          ),
          trailing: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    (_paymentInfo.type == PaymentType.SENT ||
                                _paymentInfo.type == PaymentType.WITHDRAWAL
                            ? "- "
                            : "") +
                        _paymentInfo.currency.format(_paymentInfo.amount,
                            includeDisplayName: false),
                    style: _paymentInfo.type == PaymentType.SENT
                        ? theme.posWithdrawalTransactionAmountStyle
                        : theme.transactionAmountStyle),
              ]),
          onTap: () => showPaymentDetailsDialog(context, _paymentInfo),
        ),
      ),
      Divider(
        height: 0.0,
        color: _lastItem
            ? Color.fromRGBO(255, 255, 255, 0.0)
            : Color.fromRGBO(255, 255, 255, 0.12),
        indent: 16.0,
      ),
    ]);
  }
}

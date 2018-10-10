import 'package:intl/intl.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/theme_data.dart' as theme;

class PosPaymentItem extends StatelessWidget {
  final PaymentInfo _paymentInfo;
  final bool _lastItem;

  PosPaymentItem(this._paymentInfo, this._lastItem);

  @override
  Widget build(BuildContext context) {
    return new Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      new Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: ListTile(
            title: Text(
              _formatTransactionDate(_paymentInfo.creationTimestamp),
              style: _paymentInfo.type == PaymentType.SENT
                  ? theme.posWithdrawalTransactionTitleStyle
                  : theme.posTransactionTitleStyle,
            ),
            trailing:
                Row(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(
                  (_paymentInfo.type == PaymentType.SENT || _paymentInfo.type == PaymentType.WITHDRAWAL ? "- " : "") +
                      _paymentInfo.currency.format(_paymentInfo.amount, includeSymbol: false),
                  style: _paymentInfo.type == PaymentType.SENT
                      ? theme.posWithdrawalTransactionAmountStyle
                      : theme.transactionAmountStyle),
            ])),
      ),
      new Divider(
        height: 0.0,
        color: _lastItem ? Color.fromRGBO(255, 255, 255, 0.0) : Color.fromRGBO(255, 255, 255, 0.12),
        indent: 16.0,
      ),
    ]);
  }

  String _formatTransactionDate(Int64 timestamp) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000);
    var formatter = new DateFormat('MM/dd/yyyy hh:mm');
    String formattedDate = formatter.format(date);
    return formattedDate;
  }
}

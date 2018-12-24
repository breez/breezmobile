import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/user/home/payment_item_avatar.dart';
import 'package:breez/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:breez/widgets/payment_details_dialog.dart';
import 'package:breez/theme_data.dart' as theme;

class PaymentItem extends StatelessWidget {
  static const int MAX_TITLE_LENGTH = 22;
  final PaymentInfo _paymentInfo;
  final bool _lastItem;

  PaymentItem(this._paymentInfo, this._lastItem);

  @override
  Widget build(BuildContext context) {
    String title = _paymentInfo.title;
    if (title.length > MAX_TITLE_LENGTH) {
      title = title.substring(0, MAX_TITLE_LENGTH) + "...";
    }
    return new Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      ListTile(
          leading: PaymentItemAvatar(_paymentInfo),
          title: Text(
            title,
            style: theme.transactionTitleStyle,
          ),
          subtitle: Text(
            DateUtils.formatMonthDate(DateTime.fromMillisecondsSinceEpoch(_paymentInfo.creationTimestamp.toInt() * 1000)),
            style: theme.transactionSubtitleStyle,
          ),
          trailing: Row(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
            Text(
              (_paymentInfo.type == PaymentType.SENT || _paymentInfo.type == PaymentType.WITHDRAWAL ? "- " : "+ ") +
                  _paymentInfo.currency.format(_paymentInfo.amount, includeSymbol: false),
              style: theme.transactionAmountStyle,
            ),
          ]),onTap: () => showPaymentDetailsDialog(context, _paymentInfo),),
      new Divider(
        height: 0.0,
        color: _lastItem ? Color.fromRGBO(255, 255, 255, 0.0) : Color.fromRGBO(255, 255, 255, 0.12),
        indent: 72.0,
      ),
    ]);
  }
}

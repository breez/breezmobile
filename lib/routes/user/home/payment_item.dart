import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/user/home/flip_transition.dart';
import 'package:breez/routes/user/home/payment_item_avatar.dart';
import 'package:breez/routes/user/home/success_avatar.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/payment_details_dialog.dart';
import 'package:flutter/material.dart';

class PaymentItem extends StatelessWidget {
  final PaymentInfo _paymentInfo;
  final bool _lastItem;
  final bool _firstItem;
  final GlobalKey firstPaymentItemKey;

  PaymentItem(this._paymentInfo, this._lastItem, this._firstItem, this.firstPaymentItemKey);

  @override
  Widget build(BuildContext context) {
    return new Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      ListTile(
        leading: _buildPaymentItemAvatar(),
        key: _firstItem ? firstPaymentItemKey : null,
        title: Text(
          _paymentInfo.title,
          style: theme.transactionTitleStyle,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                DateUtils.formatMonthDate(DateTime.fromMillisecondsSinceEpoch(
                    _paymentInfo.creationTimestamp.toInt() * 1000)),
                style: theme.transactionSubtitleStyle,
              ),
              _paymentInfo.pending
                  ? Text(" (Pending)",
                      style: theme.transactionTitleStyle
                          .copyWith(color: theme.warningStyle.color))
                  : SizedBox()
            ]),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    (_paymentInfo.type == PaymentType.SENT ||
                                _paymentInfo.type == PaymentType.WITHDRAWAL
                            ? "- "
                            : "+ ") +
                        _paymentInfo.currency
                            .format(_paymentInfo.amount, includeSymbol: false),
                    style: theme.transactionAmountStyle,
                  )
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _paymentInfo.fee == 0
                      ? SizedBox()
                      : Text(
                          "FEE " +
                              _paymentInfo.currency.format(_paymentInfo.fee,
                                  includeSymbol: false),
                          style: theme.transactionSubtitleStyle)
                ]),
          ],
        ),
        onTap: () => showPaymentDetailsDialog(context, _paymentInfo),
      ),
      new Divider(
        height: 0.0,
        color: _lastItem
            ? Color.fromRGBO(255, 255, 255, 0.0)
            : Color.fromRGBO(255, 255, 255, 0.12),
        indent: 72.0,
      ),
    ]);
  }

  Widget _buildPaymentItemAvatar() {
    // Show Flip Transition if the payment item is created within last 10 seconds
    if (_createdWithin(Duration(seconds: 10))) {
      return PaymentItemAvatar(_paymentInfo);
    } else {
      return FlipTransition(PaymentItemAvatar(_paymentInfo), SuccessAvatar());
    }
  }

  bool _createdWithin(Duration duration) {
    return DateTime.fromMillisecondsSinceEpoch(
        _paymentInfo.creationTimestamp.toInt() * 1000)
        .difference(DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch)) <
        - duration;
  }
}

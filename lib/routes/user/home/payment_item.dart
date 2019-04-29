import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/user/home/payment_item_avatar.dart';
import 'package:breez/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:breez/routes/user/home/flip_transition.dart';
import 'package:breez/widgets/payment_details_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'dart:math';

class PaymentItem extends StatelessWidget {
  final PaymentInfo _paymentInfo;
  final bool _lastItem;

  PaymentItem(this._paymentInfo, this._lastItem);

  @override
  Widget build(BuildContext context) {
    return new Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      ListTile(
        leading: DateTime.fromMillisecondsSinceEpoch(
            _paymentInfo.creationTimestamp.toInt() * 1000).difference(
            DateTime.fromMillisecondsSinceEpoch(DateTime
                .now()
                .millisecondsSinceEpoch)) < -Duration(seconds: 10)
            ? PaymentItemAvatar(
            _paymentInfo)
            : FlipTransition(
            PaymentItemAvatar(_paymentInfo),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(20.0))),
                width: 20.0 * 2,
                height: 20.0 * 2,
                alignment: FractionalOffset.center,
                child: Transform(
                    transform: Matrix4.identity()
                      ..rotateY(pi),
                    alignment: Alignment.center,
                    child: Icon(Icons.check,
                        color: theme.BreezColors.blue[500]))),
            PaymentItemAvatar(_paymentInfo)),
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
}

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/payment_details_dialog.dart';
import 'package:flutter/material.dart';

import 'flip_transition.dart';
import 'payment_item_avatar.dart';
import 'success_avatar.dart';

const DASHBOARD_MAX_HEIGHT = 176.25;
const DASHBOARD_MIN_HEIGHT = 70.0;
const FILTER_MAX_SIZE = 56.0;
const PAYMENT_LIST_ITEM_HEIGHT = 72.0;
const AVATAR_DIAMETER = 40.0;

class PaymentItem extends StatelessWidget {
  final PaymentInfo _paymentInfo;
  final int _itemIndex;
  final bool _firstItem;
  final GlobalKey firstPaymentItemKey;
  final ScrollController _scrollController;

  PaymentItem(this._paymentInfo, this._itemIndex, this._firstItem,
      this.firstPaymentItemKey, this._scrollController);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      ListTile(
        tileColor: (_itemIndex % 2 == 0)
            ? theme.customData[theme.themeId].paymentListBgColor
            : theme.customData[theme.themeId].paymentListAlternateBgColor,
        leading: Opacity(
          // when the transaction list is fully expanded
          // set opacity the avatar of the item that's
          // no longer visible to transparent
          opacity: (_scrollController.offset -
                      (DASHBOARD_MAX_HEIGHT - DASHBOARD_MIN_HEIGHT) -
                      (PAYMENT_LIST_ITEM_HEIGHT * (_itemIndex + 1) -
                          FILTER_MAX_SIZE +
                          AVATAR_DIAMETER) >
                  0)
              ? 0.0
              : 1.0,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0.5, 0.5),
                      blurRadius: 5.0),
                ],
              ),
              child: _buildPaymentItemAvatar()),
        ),
        key: _firstItem ? firstPaymentItemKey : null,
        title: Opacity(
          // set title text to transparent when it leaves viewport
          opacity: (_scrollController.offset -
                      (DASHBOARD_MAX_HEIGHT - DASHBOARD_MIN_HEIGHT) -
                      (PAYMENT_LIST_ITEM_HEIGHT * (_itemIndex + 1) -
                          FILTER_MAX_SIZE +
                          AVATAR_DIAMETER / 2) >
                  0)
              ? 0.0
              : 1.0,
          child: Text(
            _paymentInfo.title,
            style: Theme.of(context).accentTextTheme.subtitle2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                DateUtils.formatMonthDate(DateTime.fromMillisecondsSinceEpoch(
                    _paymentInfo.creationTimestamp.toInt() * 1000)),
                style: Theme.of(context).accentTextTheme.caption,
              ),
              _paymentInfo.pending
                  ? Text(" (Pending)",
                      style: Theme.of(context).accentTextTheme.caption.copyWith(
                          color:
                              theme.customData[theme.themeId].pendingTextColor))
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
                  Opacity(
                    // set amount text to transparent when it leaves viewport
                    opacity: (_scrollController.offset -
                                (DASHBOARD_MAX_HEIGHT - DASHBOARD_MIN_HEIGHT) -
                                (PAYMENT_LIST_ITEM_HEIGHT * (_itemIndex + 1) -
                                    FILTER_MAX_SIZE +
                                    AVATAR_DIAMETER / 2) >
                            0)
                        ? 0.0
                        : 1.0,
                    child: Text(
                      (_paymentInfo.type == PaymentType.SENT ||
                                  _paymentInfo.type == PaymentType.WITHDRAWAL ||
                                  _paymentInfo.type ==
                                      PaymentType.CLOSED_CHANNEL
                              ? "- "
                              : "+ ") +
                          _paymentInfo.currency.format(_paymentInfo.amount,
                              addCurrencySuffix: false),
                      style: Theme.of(context).accentTextTheme.headline6,
                    ),
                  )
                ]),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _paymentInfo.fee == 0 || _paymentInfo.pending
                        ? SizedBox()
                        : Text(
                            "FEE " +
                                _paymentInfo.currency.format(_paymentInfo.fee,
                                    addCurrencySuffix: false),
                            style: Theme.of(context).accentTextTheme.caption)
                  ]),
            ),
          ],
        ),
        onTap: () => showPaymentDetailsDialog(context, _paymentInfo),
      ),
      Opacity(
        // set bottom divider to transparent when it leaves viewport
        opacity: (_scrollController.offset -
                    (DASHBOARD_MAX_HEIGHT - DASHBOARD_MIN_HEIGHT) -
                    (PAYMENT_LIST_ITEM_HEIGHT * (_itemIndex + 1) -
                        FILTER_MAX_SIZE +
                        AVATAR_DIAMETER +
                        16) >
                0)
            ? 0.0
            : 1.0,
        child: Divider(
          height: 0.0,
          thickness: 1,
          color: theme.customData[theme.themeId].paymentListDividerColor,
          indent: 72.0,
        ),
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
        -duration;
  }
}

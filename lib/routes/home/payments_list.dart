import 'package:breez/bloc/account/account_model.dart';
import 'package:flutter/material.dart';

import 'payment_item.dart';

const BOTTOM_PADDING = 8.0;

class PaymentsList extends StatelessWidget {
  final List<PaymentInfo> _payments;
  final double _itemHeight;
  final GlobalKey firstPaymentItemKey;

  PaymentsList(this._payments, this._itemHeight, this.firstPaymentItemKey);

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: _itemHeight + BOTTOM_PADDING,
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return PaymentItem(_payments[index], 0 == index, firstPaymentItemKey, _itemHeight);
      }, childCount: _payments.length),
    );
  }
}

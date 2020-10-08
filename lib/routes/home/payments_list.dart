import 'package:breez/bloc/account/account_model.dart';
import 'package:flutter/material.dart';

import 'payment_item.dart';

class PaymentsList extends StatelessWidget {
  final List<PaymentInfo> _payments;
  final double _itemHeight;
  final GlobalKey firstPaymentItemKey;

  PaymentsList(this._payments, this._itemHeight, this.firstPaymentItemKey);

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: _itemHeight,
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return PaymentItem(
            _payments[index], index, 0 == index, firstPaymentItemKey);
      }, childCount: _payments.length),
    );
  }
}

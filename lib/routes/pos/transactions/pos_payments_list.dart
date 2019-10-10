import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/pos/transactions/pos_payment_item.dart';
import 'package:flutter/material.dart';

class PosPaymentsList extends StatelessWidget {
  final List<PaymentInfo> _payments;
  final double _itemHeight;

  PosPaymentsList(this._payments, this._itemHeight);

  @override
  Widget build(BuildContext context) {
    return new SliverFixedExtentList(
      itemExtent: _itemHeight,
      delegate: new SliverChildBuilderDelegate((BuildContext context, int index) {
        return PosPaymentItem(_payments[index], _payments.length - 1 == index);
      }, childCount: _payments.length),
    );
  }
}

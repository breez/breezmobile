import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/transactions/pos_payment_item.dart';
import 'package:flutter/material.dart';

class PosPaymentsList extends StatelessWidget {
  final List<PaymentInfo> _payments;
  final AccountModel _account;
  final double _itemHeight;

  const PosPaymentsList(
    this._payments,
    this._account,
    this._itemHeight,
  );

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: _itemHeight,
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final paymentInfo = _payments[index];
          return PosPaymentItem(
            paymentInfo,
            _account,
            paymentInfo is SinglePaymentInfo ? paymentInfo.saleSummary : null,
            _payments.length - 1 == index,
          );
        },
        childCount: _payments.length,
      ),
    );
  }
}

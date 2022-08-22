import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:flutter/material.dart';

import 'payment_item.dart';

const BOTTOM_PADDING = 8.0;

class PaymentsList extends StatelessWidget {
  final BreezUserModel _userModel;
  final List<PaymentInfo> _payments;
  final double _itemHeight;
  final GlobalKey firstPaymentItemKey;

  const PaymentsList(
    this._userModel,
    this._payments,
    this._itemHeight,
    this.firstPaymentItemKey,
  );

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: _itemHeight + BOTTOM_PADDING,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final payment = _payments[index];
          return PaymentItem(
            payment,
            0 == index,
            _userModel.hideBalance,
            firstPaymentItemKey,
          );
        },
        childCount: _payments.length,
      ),
    );
  }
}

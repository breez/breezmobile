import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart' show LNUrlPayInfo;
import 'package:flutter/material.dart';

import 'payment_item.dart';

const BOTTOM_PADDING = 8.0;

class PaymentsList extends StatefulWidget {
  final List<PaymentInfo> _payments;
  final List<LNUrlPayInfo> _lnurlPayInfos;
  final double _itemHeight;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;

  PaymentsList(this._payments, this._lnurlPayInfos, this._itemHeight,
      this.firstPaymentItemKey, this.scrollController);

  @override
  State<StatefulWidget> createState() {
    return PaymentsListState();
  }
}

class PaymentsListState extends State<PaymentsList> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(onScroll);
    super.dispose();
  }

  void onScroll() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: widget._itemHeight + BOTTOM_PADDING,
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        final payment = widget._payments[index];

        final lnurlPayInfo = widget._lnurlPayInfos?.firstWhere(
            (it) => it.paymentHash == payment.paymentHash,
            orElse: () => null);
        payment.lnurlPaySuccessAction = lnurlPayInfo?.successAction;

        return PaymentItem(payment, index, 0 == index,
            widget.firstPaymentItemKey, widget.scrollController);
      }, childCount: widget._payments.length),
    );
  }
}

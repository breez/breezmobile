import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/get_refund/widget/get_refund_action.dart';
import 'package:breez/routes/get_refund/widget/get_refund_title.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/theme_data.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GetRefundList extends StatelessWidget {
  final List<RefundableAddress> refundableAddresses;
  final Currency currency;
  final bool allowRebroadcastRefunds;
  final Function(RefundableAddress) onRefundPressed;

  const GetRefundList({
    @required this.refundableAddresses,
    @required this.currency,
    @required this.allowRebroadcastRefunds,
    @required this.onRefundPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: refundableAddresses.map((item) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              GetRefundTitle(
                currency: currency,
                amount: item.confirmedAmount,
              ),
              GetRefundAction(
                refundTxId: item.lastRefundTxID,
                allowRebroadcastRefunds: allowRebroadcastRefunds,
                onActionPressed: () => onRefundPressed(item),
              ),
              const Divider(
                height: 0.0,
                color: Color.fromRGBO(255, 255, 255, 0.52),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: blueTheme,
    home: Scaffold(
      body: SafeArea(
        child: GetRefundList(
          refundableAddresses: [
            RefundableAddress(SwapAddressInfo(
              address: "an address",
              paymentHash: "a payment hash",
              confirmedAmount: Int64(456),
              confirmedTransactionIds: ["a confirmed transaction id"],
              paidAmount: Int64(123),
              lockHeight: 789,
              errorMessage: "a errorMessage",
              lastRefundTxID: "a lastRefundTxID",
              swapError: null,
              fundingTxID: "a fundingTxID",
              hoursToUnlock: null,
              nonBlocking: null,
            )),
            RefundableAddress(SwapAddressInfo(
              address: "an address",
              paymentHash: "a payment hash",
              confirmedAmount: Int64(456),
              confirmedTransactionIds: ["a confirmed transaction id"],
              paidAmount: Int64(123),
              lockHeight: 789,
              errorMessage: "a errorMessage",
              lastRefundTxID: "",
              swapError: null,
              fundingTxID: "a fundingTxID",
              hoursToUnlock: null,
              nonBlocking: null,
            )),
          ],
          currency: Currency.BTC,
          allowRebroadcastRefunds: true,
          onRefundPressed: (item) {
            if (kDebugMode) {
              print("onRefundPressed $item");
            }
          },
        ),
      ),
    ),
  ));
}

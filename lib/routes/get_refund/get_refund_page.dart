import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/dev/dev.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/send_onchain.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import 'wait_broadcast_dialog.dart';

class GetRefundPage extends StatelessWidget {
  static const String TITLE = "Get Refund";

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return Scaffold(
        appBar: AppBar(
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
            textTheme: Theme.of(context).appBarTheme.textTheme,
            backgroundColor: Theme.of(context).canvasColor,
            leading: backBtn.BackButton(),
            title: Text(TITLE,
                style: Theme.of(context).appBarTheme.textTheme.headline6),
            elevation: 0.0),
        body: StreamBuilder<AccountModel>(
            stream: accountBloc.accountStream,
            builder: (context, accSnapshot) {
              if (!accSnapshot.hasData || !accSnapshot.hasData) {
                return Loader();
              }
              if (accSnapshot.hasError) {
                return Text(accSnapshot.error.toString());
              }
              var account = accSnapshot.data;
              return ListView(
                  children: account.swapFundsStatus.maturedRefundableAddresses
                      .map((item) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                                "Amount: " +
                                    account.currency
                                        .format(item.confirmedAmount),
                                textAlign: TextAlign.left))
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                                height: 36.0,
                                width: 145.0,
                                child: SubmitButton(
                                    item.lastRefundTxID.isNotEmpty
                                        ? "BROADCASTED"
                                        : "CONTINUE",
                                    item.lastRefundTxID.isNotEmpty &&
                                            !allowRebroadcastRefunds
                                        ? null
                                        : () =>
                                            onRefund(context, account, item))),
                          )
                        ]),
                    Divider(
                        height: 0.0, color: Color.fromRGBO(255, 255, 255, 0.52))
                  ]),
                );
              }).toList());
            }));
  }

  onRefund(BuildContext context, AccountModel account, RefundableAddress item) {
    String originalTransaction;
    if (item.confirmedTransactionIds.length > 0) {
      originalTransaction =
          item.confirmedTransactionIds[item.confirmedTransactionIds.length - 1];
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => SendOnchain(
                  account,
                  item.confirmedAmount,
                  "Refund Transaction",
                  (destAddress, feeRate) {
                    return broadcastAndWait(
                            context, item.address, destAddress, feeRate)
                        .then((str) {
                      Navigator.of(context).pop();
                      return str;
                    });
                  },
                  originalTransaction: originalTransaction,
                )));
  }

  Future<String> broadcastAndWait(BuildContext context, String fromAddress,
      String toAddress, Int64 feeRate) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return showDialog<bool>(
        useRootNavigator: false,
        context: context,
        barrierDismissible: false,
        builder: (_) => WaitBroadcastDialog(
            accountBloc, fromAddress, toAddress, feeRate)).then((ok) {
      return ok ? null : Future.error("failed");
    });
  }
}

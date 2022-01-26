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
import 'package:breez/l10n/locales.dart';

import 'wait_broadcast_dialog.dart';

class GetRefundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(),
        title: Text(
          context.l10n.get_refund_title,
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        elevation: 0.0,
      ),
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
            children: _children(context, account),
          );
        },
      ),
    );
  }

  List<Widget> _children(BuildContext context, AccountModel account) {
    return account.swapFundsStatus.maturedRefundableAddresses.map((item) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    context.l10n.get_refund_amount(
                      account.currency.format(item.confirmedAmount),
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
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
                          ? context.l10n.get_refund_action_broadcasted
                          : context.l10n.get_refund_action_continue,
                      item.lastRefundTxID.isNotEmpty && !allowRebroadcastRefunds
                          ? null
                          : () => onRefund(context, account, item),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: 0.0,
              color: Color.fromRGBO(255, 255, 255, 0.52),
            ),
          ],
        ),
      );
    }).toList();
  }

  void onRefund(
    BuildContext context,
    AccountModel account,
    RefundableAddress item,
  ) {
    final ids = item.confirmedTransactionIds;
    String originalTransaction;
    if (ids.length > 0) {
      originalTransaction = ids[ids.length - 1];
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => SendOnchain(
          account,
          item.confirmedAmount,
          context.l10n.get_refund_transaction,
          (destAddress, feeRate) {
            return broadcastAndWait(
              context,
              item.address,
              destAddress,
              feeRate,
            ).then((str) {
              Navigator.of(context).pop();
              return str;
            });
          },
          originalTransaction: originalTransaction,
        ),
      ),
    );
  }

  Future<String> broadcastAndWait(
    BuildContext context,
    String fromAddress,
    String toAddress,
    Int64 feeRate,
  ) {
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return showDialog<bool>(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => WaitBroadcastDialog(
        accountBloc,
        fromAddress,
        toAddress,
        feeRate,
      ),
    ).then((ok) {
      return ok ? null : Future.error(context.l10n.get_refund_failed);
    });
  }
}

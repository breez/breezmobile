import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/dev/dev.dart';
import 'package:breez/routes/get_refund/wait_broadcast_dialog.dart';
import 'package:breez/routes/get_refund/widget/get_refund_list.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/send_onchain.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class GetRefundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return Scaffold(
      appBar: AppBar(
        leading: const backBtn.BackButton(),
        title: Text(texts.get_refund_title),
      ),
      body: StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, accSnapshot) {
          if (!accSnapshot.hasData || !accSnapshot.hasData) {
            return const Loader();
          }
          if (accSnapshot.hasError) {
            return Text(accSnapshot.error.toString());
          }
          var account = accSnapshot.data;
          return GetRefundList(
            refundableAddresses: account.swapFundsStatus.maturedRefundableAddresses,
            currency: account.currency,
            allowRebroadcastRefunds: allowRebroadcastRefunds,
            onRefundPressed: (item) => onRefund(context, account, item),
          );
        },
      ),
    );
  }

  void onRefund(
    BuildContext context,
    AccountModel account,
    RefundableAddress item,
  ) {
    final texts = context.texts();

    final ids = item.confirmedTransactionIds;
    String originalTransaction;
    if (ids.isNotEmpty) {
      originalTransaction = ids[ids.length - 1];
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => SendOnchain(
          account,
          item.confirmedAmount,
          texts.get_refund_transaction,
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
    final texts = context.texts();
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
      return ok ? null : Future.error(texts.get_refund_failed);
    });
  }
}

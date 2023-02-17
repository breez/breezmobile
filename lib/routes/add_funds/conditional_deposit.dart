import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/link_launcher.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class ConditionalDeposit extends StatelessWidget {
  final Widget enabledChild;
  final String title;

  const ConditionalDeposit({
    Key key,
    this.enabledChild,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (ctx, snapshot) {
        final account = snapshot.data;
        if (account == null) {
          return const SizedBox();
        }

        final unconfirmedTxID = account.swapFundsStatus.unconfirmedTxID;
        bool waitingDepositConfirmation = unconfirmedTxID?.isNotEmpty == true;
        String errorMessage;

        if (unconfirmedTxID?.isNotEmpty == true) {
          if (waitingDepositConfirmation || account.processingConnection) {
            errorMessage = texts.add_funds_error_deposit;
          } else {
            errorMessage = texts.add_funds_error_withdraw;
          }
        }

        if (errorMessage == null) {
          return enabledChild;
        }

        return Scaffold(
          appBar: AppBar(
            leading: const backBtn.BackButton(),
            title: Text(title),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 50.0,
                  left: 30.0,
                  right: 30.0,
                ),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                ),
              ),
              waitingDepositConfirmation
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 30.0,
                            left: 30.0,
                            right: 30.0,
                          ),
                          child: _linkLauncher(context, unconfirmedTxID),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }

  Widget _linkLauncher(BuildContext context, String unconfirmedTxID) {
    final texts = context.texts();
    return LinkLauncher(
      linkName: unconfirmedTxID,
      linkAddress: "https://blockstream.info/tx/$unconfirmedTxID",
      onCopy: () {
        ServiceInjector().device.setClipboardText(unconfirmedTxID);
        showFlushbar(
          context,
          message: texts.add_funds_transaction_id_copied,
          duration: const Duration(seconds: 3),
        );
      },
    );
  }
}

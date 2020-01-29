import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/link_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;

class ConditionalDeposit extends StatelessWidget {
  final Widget enabledChild;
  final String title;

  const ConditionalDeposit({Key key, this.enabledChild, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (ctx, snapshot) {
        var account = snapshot.data;
        if (account == null) {
          return SizedBox();
        }
        var isBootstrap = account.isInitialBootstrap;
        var unconfirmedTxID = account.swapFundsStatus.unconfirmedTxID;
        bool waitingDepositConfirmation = unconfirmedTxID?.isNotEmpty == true;
        String errorMessage;

        if (isBootstrap) {
          errorMessage =
              'You\'ll be able to add funds after Breez is finished bootstrapping.';
        } else if (unconfirmedTxID?.isNotEmpty == true ||
            account.closingConnection) {
          errorMessage =
              'Breez is processing your previous ${waitingDepositConfirmation || account.processingConnection ? "deposit" : "withdrawal"}. You will be able to add more funds once this operation is completed.';
        }

        if (errorMessage == null) {
          return enabledChild;
        }

        return Scaffold(
            appBar: AppBar(
              iconTheme: Theme.of(context).appBarTheme.iconTheme,
              textTheme: Theme.of(context).appBarTheme.textTheme,
              backgroundColor: Theme.of(context).canvasColor,
              leading: backBtn.BackButton(),
              title: Text(
                title,
                style: Theme.of(context).appBarTheme.textTheme.title,
              ),
              elevation: 0.0,
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
                  child: Text(errorMessage, textAlign: TextAlign.center),
                ),
                waitingDepositConfirmation
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 30.0, left: 30.0, right: 30.0),
                              child: LinkLauncher(
                                linkName: unconfirmedTxID,
                                linkAddress:
                                    "https://blockstream.info/tx/$unconfirmedTxID",
                                onCopy: () {
                                  Clipboard.setData(
                                      ClipboardData(text: unconfirmedTxID));
                                  showFlushbar(context,
                                      message:
                                          "Transaction ID was copied to your clipboard.",
                                      duration: Duration(seconds: 3));
                                },
                              ),
                            ),
                          ])
                    : SizedBox()
              ],
            ));
      },
    );
  }
}

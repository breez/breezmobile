import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/link_launcher.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:breez/l10n/locales.dart';

class SwapInProgress extends StatelessWidget {
  final InProgressReverseSwaps swapInProgress;

  const SwapInProgress({
    Key key,
    this.swapInProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(onPressed: () {
          Navigator.of(context).pop();
        }),
        title: Text(
          context.l10n.swap_in_progress_title,
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        elevation: 0.0,
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    if (swapInProgress == null) return Center(child: Loader());

    final txId = swapInProgress.claimTxId;

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
          child: Text(
            txId.isEmpty
                ? context.l10n.swap_in_progress_message_processing_previous_request
                : context.l10n.swap_in_progress_message_waiting_confirmation,
            textAlign: TextAlign.center,
          ),
        ),
        txId.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                    child: LinkLauncher(
                      linkName: txId,
                      linkAddress: "https://blockstream.info/tx/$txId",
                      onCopy: () {
                        ServiceInjector().device.setClipboardText(txId);
                        showFlushbar(
                          context,
                          message: context.l10n.swap_in_progress_transaction_id_copied,
                          duration: Duration(seconds: 3),
                        );
                      },
                    ),
                  ),
                ],
              )
            : SizedBox(),
      ],
    );
  }
}

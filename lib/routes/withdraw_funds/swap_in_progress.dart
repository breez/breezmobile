import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/link_launcher.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SwapInProgress extends StatelessWidget {
  final InProgressReverseSwaps swapInProgress;

  const SwapInProgress({
    Key key,
    this.swapInProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: themeData.appBarTheme.iconTheme,
        textTheme: themeData.appBarTheme.textTheme,
        backgroundColor: themeData.canvasColor,
        leading: backBtn.BackButton(onPressed: () {
          Navigator.of(context).pop();
        }),
        title: Text(
          texts.swap_in_progress_title,
          style: themeData.appBarTheme.textTheme.headline6,
        ),
        elevation: 0.0,
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    if (swapInProgress == null) return Center(child: Loader());

    final texts = AppLocalizations.of(context);
    final txId = swapInProgress.claimTxId;

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
          child: Text(
            txId.isEmpty
                ? texts.swap_in_progress_message_processing_previous_request
                : texts.swap_in_progress_message_waiting_confirmation,
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
                          message: texts.swap_in_progress_transaction_id_copied,
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

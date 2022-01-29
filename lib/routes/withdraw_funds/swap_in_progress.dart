import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/link_launcher.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';

class SwapInProgress extends StatelessWidget {
  final InProgressReverseSwaps swapInProgress;

  const SwapInProgress({
    Key key,
    this.swapInProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = context.theme;
    AppBarTheme appBarTheme = theme.appBarTheme;
    return Scaffold(
      appBar: AppBar(
        iconTheme: appBarTheme.iconTheme,
        toolbarTextStyle: appBarTheme.toolbarTextStyle,
        titleTextStyle: appBarTheme.titleTextStyle,
        backgroundColor: theme.canvasColor,
        leading: backBtn.BackButton(onPressed: () {
          context.pop();
        }),
        title: Text(context.l10n.swap_in_progress_title),
        elevation: 0.0,
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    var l10n = context.l10n;
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
                ? l10n.swap_in_progress_message_processing_previous_request
                : l10n.swap_in_progress_message_waiting_confirmation,
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
                          message: l10n.swap_in_progress_transaction_id_copied,
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

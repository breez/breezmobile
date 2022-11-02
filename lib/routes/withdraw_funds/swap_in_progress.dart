import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/payment_details_dialog.dart';
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
    final txId = swapInProgress.claimTxId ?? swapInProgress.lockTxID;

    return Scaffold(
      appBar: AppBar(
        iconTheme: themeData.appBarTheme.iconTheme,
        textTheme: themeData.appBarTheme.textTheme,
        backgroundColor: themeData.canvasColor,
        leading: backBtn.BackButton(),
        title: Text(
          texts.swap_in_progress_title,
          style: themeData.appBarTheme.textTheme.headline6,
        ),
        elevation: 0.0,
      ),
      body: (swapInProgress == null)
          ? Center(child: Loader())
          : Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
                  child: Text(
                    txId.isEmpty
                        ? texts
                            .swap_in_progress_message_processing_previous_request
                        : texts.swap_in_progress_message_waiting_confirmation,
                    textAlign: TextAlign.center,
                  ),
                ),
                txId.isNotEmpty
                    ? TxWidget(
                        txID: txId,
                        txURL: "https://blockstream.info/tx/$txId",
                        padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                      )
                    : SizedBox(),
              ],
            ),
    );
  }
}

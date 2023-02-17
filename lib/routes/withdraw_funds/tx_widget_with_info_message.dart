import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/tx_widget.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class TxWidgetWithInfoMsg extends StatelessWidget {
  const TxWidgetWithInfoMsg({
    Key key,
    @required this.swapInProgress,
  }) : super(key: key);

  final InProgressReverseSwaps swapInProgress;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    final txId = swapInProgress.lockTxID;

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
          child: Text(
            txId.isEmpty
                ? texts.swap_in_progress_message_processing_previous_request
                : texts.swap_in_progress_message_waiting_confirmation,
            textAlign: TextAlign.center,
          ),
        ),
        if (txId.isNotEmpty) ...[
          TxWidget(
            txID: txId,
            txURL: "https://blockstream.info/tx/$txId",
            padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
          )
        ]
      ],
    );
  }
}

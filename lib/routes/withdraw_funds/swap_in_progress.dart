import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/routes/withdraw_funds/tx_widget_with_info_message.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class SwapInProgress extends StatelessWidget {
  final InProgressReverseSwaps swapInProgress;

  const SwapInProgress({
    Key key,
    this.swapInProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Scaffold(
      appBar: AppBar(
        leading: backBtn.BackButton(onPressed: () {
          Navigator.of(context).pop();
        }),
        title: Text(texts.swap_in_progress_title),
      ),
      body: TxWidgetWithInfoMsg(swapInProgress: swapInProgress),
    );
  }
}

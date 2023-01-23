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
    final themeData = Theme.of(context);

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
      body: TxWidgetWithInfoMsg(swapInProgress: swapInProgress),
    );
  }
}

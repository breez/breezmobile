import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/link_launcher.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:breez/utils/i18n.dart';

class SwapInProgress extends StatelessWidget {
  final InProgressReverseSwaps swapInProgress;

  const SwapInProgress({Key key, this.swapInProgress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget body = Center(child: Loader());
    if (swapInProgress != null) {
      String message = "Breez is waiting for your transaction to be confirmed.";
      if (swapInProgress.claimTxId.isEmpty) {
        message =
            "Breez is currently processing your previous request. You'll be notified once processing is completed to send your funds to the address you've specified.";
      }
      body = Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
            child: Text(message, textAlign: TextAlign.center),
          ),
          swapInProgress.claimTxId.isNotEmpty
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                    child: LinkLauncher(
                      linkName: swapInProgress.claimTxId,
                      linkAddress:
                          "https://blockstream.info/tx/${swapInProgress.claimTxId}",
                      onCopy: () {
                        ServiceInjector()
                            .device
                            .setClipboardText(swapInProgress.claimTxId);
                        showFlushbar(context,
                            message: I18N.t(
                                context, "text_was_copied_to_your_clipboard",
                                translationParams: {
                                  "text": I18N.t(context, "transaction_id")
                                }),
                            duration: Duration(seconds: 3));
                      },
                    ),
                  ),
                ])
              : SizedBox()
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          leading: backBtn.BackButton(onPressed: () {
            Navigator.of(context).pop();
          }),
          title: Text(I18N.t(context, "send_to_btc_address"),
              style: Theme.of(context).appBarTheme.textTheme.headline6),
          elevation: 0.0),
      body: body,
    );
  }
}

import 'package:breez/services/injector.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/link_launcher.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class TxWidget extends StatelessWidget {
  final String txURL;
  final String txID;
  final String txLabel;
  final EdgeInsets padding;

  const TxWidget({
    Key key,
    this.txURL,
    this.txID,
    this.txLabel,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.txURL == null) {
      return SizedBox();
    }

    final texts = context.texts();
    var textStyle = DefaultTextStyle.of(context).style;
    textStyle = textStyle.copyWith(
      fontSize: textStyle.fontSize * 0.8,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding ?? EdgeInsets.only(top: 20.0),
          child: LinkLauncher(
            linkTitle: txLabel ?? texts.payment_details_dialog_transaction_label_default,
            textStyle: textStyle,
            linkName: this.txID,
            linkAddress: this.txURL,
            onCopy: () {
              ServiceInjector().device.setClipboardText(this.txID);
              showFlushbar(
                context,
                message: texts.payment_details_dialog_transaction_id_copied,
                duration: Duration(seconds: 3),
              );
            },
          ),
        ),
      ],
    );
  }
}

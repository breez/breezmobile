import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogContentTitle extends StatelessWidget {
  final PaymentInfo paymentInfo;

  const PaymentDetailsDialogContentTitle({
    Key key,
    this.paymentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final title = paymentInfo.dialogTitle?.replaceAll("\n", " ")?.trim();
    final description = paymentInfo.description?.trim();

    if (title == null || title.isEmpty) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: (description == null || description.isEmpty) ? 16 : 8,
      ),
      child: AutoSizeText(
        title,
        style: themeData.primaryTextTheme.headlineSmall,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogDescription extends StatelessWidget {
  final PaymentInfo paymentInfo;

  const PaymentDetailsDialogDescription({
    Key key,
    this.paymentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final description = paymentInfo.description;
    if (description == null || description == "") {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 54,
          minWidth: double.infinity,
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: AutoSizeText(
              description,
              style: themeData.primaryTextTheme.headlineMedium,
              textAlign: description.length > 40 && !description.contains("\n") ? TextAlign.start : TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

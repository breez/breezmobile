import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/user/home/payment_item_avatar.dart';
import 'package:breez/theme_data.dart' as theme;

class PaymentDetailsDialog extends StatelessWidget {
  final BuildContext context;
  final PaymentInfo paymentInfo;

  PaymentDetailsDialog(this.context, this.paymentInfo);

  @override
  Widget build(BuildContext context) {
    return showPaymentDetailsDialog();
  }

  Widget showPaymentDetailsDialog() {
    return new SimpleDialog(
      contentPadding: EdgeInsets.all(24.0),
      children: <Widget>[
        //Text((paymentInfo.type == PaymentType.SENT || paymentInfo.type == PaymentType.WITHDRAWAL ? "Recipient: " : "Sender: "),style: theme.paymentRequestTitleStyle,textAlign: TextAlign.left,),
        Center(child:PaymentItemAvatar(paymentInfo,radius: 32.0),),
        Text(
          paymentInfo.title,
          style: theme.paymentRequestTitleStyle,
          textAlign: TextAlign.center,
        ),
        Text(
          "Amount: " + (paymentInfo.type == PaymentType.SENT || paymentInfo.type == PaymentType.WITHDRAWAL ? "-" : "+") + paymentInfo.currency.format(paymentInfo.amount),
          style: theme.invoiceMemoStyle,
          textAlign: TextAlign.left,
        ),
        Text(
          "Date: ${DateTime.fromMillisecondsSinceEpoch(paymentInfo.creationTimestamp.toInt() * 1000)}",
          style: theme.invoiceMemoStyle,
          textAlign: TextAlign.left,
        ),
        Text(
          "Hash: ${paymentInfo.hashCode}",
          style: theme.invoiceMemoStyle,
          textAlign: TextAlign.left,
        ),
        new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SimpleDialogOption(
              onPressed: (() {
                Navigator.pop(context);
              }),
              child: new Text("COPY HASH", style: theme.buttonStyle),
            ),
          ],
        ),
      ],
    );
  }
}

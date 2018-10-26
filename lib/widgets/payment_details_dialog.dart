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
      contentPadding: EdgeInsets.fromLTRB(16.0,32.0,16.0,16.0),
      children: <Widget>[
        //Text((paymentInfo.type == PaymentType.SENT || paymentInfo.type == PaymentType.WITHDRAWAL ? "Recipient: " : "Sender: "),style: theme.paymentRequestTitleStyle,textAlign: TextAlign.left,),
        Center(
          child: PaymentItemAvatar(paymentInfo, radius: 32.0),
        ),
        Padding(padding: EdgeInsets.only(top: 8.0),),
        Text(
          paymentInfo.title,
          style: theme.paymentRequestAmountStyle,
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.only(top: 16.0),),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[Text(
            "Amount:",
            style: theme.paymentDetailsTitleStyle,
            textAlign: TextAlign.left,
          ),
          Text(
            "Date:",
            style: theme.paymentDetailsTitleStyle,
            textAlign: TextAlign.left,
          ),
          Text(
            "Hash:",
            style: theme.paymentDetailsTitleStyle,
            textAlign: TextAlign.left,
          ),],),
          Column(crossAxisAlignment: CrossAxisAlignment.end,children: <Widget>[Text(
            (paymentInfo.type == PaymentType.SENT || paymentInfo.type == PaymentType.WITHDRAWAL ? "-" : "+") +
                paymentInfo.currency.format(paymentInfo.amount),
            style: theme.paymentDetailsSubtitleStyle,
            textAlign: TextAlign.left,
          ),
          Text(
            DateTime.fromMillisecondsSinceEpoch(paymentInfo.creationTimestamp.toInt() * 1000).toString(),
            style: theme.paymentDetailsSubtitleStyle,
            textAlign: TextAlign.left,
          ),
          Text(
            paymentInfo.hashCode.toString(),
            style: theme.paymentDetailsSubtitleStyle,
            textAlign: TextAlign.left,
          ),],)
        ]),
        Padding(padding: EdgeInsets.only(top: 16.0),),
        Row(
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/user/home/payment_item_avatar.dart';
import 'package:breez/utils/date.dart';
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
    final tooltipKey = new GlobalKey();
    return new SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
      children: <Widget>[
        //Text((paymentInfo.type == PaymentType.SENT || paymentInfo.type == PaymentType.WITHDRAWAL ? "Recipient: " : "Sender: "),style: theme.paymentRequestTitleStyle,textAlign: TextAlign.left,),
        Center(
          child: PaymentItemAvatar(paymentInfo, radius: 32.0),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
        ),
        Text(
          paymentInfo.title,
          style: theme.paymentRequestAmountStyle,
          textAlign: TextAlign.center,
        ),
        Container(
          height: 36.0,
          child: ListTile(
            title: Text(
              "Amount",
              style: theme.paymentDetailsTitleStyle,
              textAlign: TextAlign.left,
            ),
            trailing: Text(
              (paymentInfo.type == PaymentType.SENT || paymentInfo.type == PaymentType.WITHDRAWAL ? "-" : "+") +
                  paymentInfo.currency.format(paymentInfo.amount),
              style: theme.paymentDetailsSubtitleStyle,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Container(
          height: 36.0,
          child: ListTile(
            title: Text(
              "Date",
              style: theme.paymentDetailsTitleStyle,
              textAlign: TextAlign.left,
            ),
            trailing: Text(
              DateUtils.formatYearMonthDayHourMinuteSecond(
                  DateTime.fromMillisecondsSinceEpoch(paymentInfo.creationTimestamp.toInt() * 1000)),
              style: theme.paymentDetailsSubtitleStyle,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.0),
        ),
        Container(
          height: 72.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Node ID",
                  style: theme.paymentDetailsTitleStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: 154.0,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Text('${paymentInfo.nodeId}',
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.clip,
                      maxLines: 3,
                      style: theme.paymentDetailsSubtitleStyle),
                ),
              ),
              /*
              IconButton(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 14.0, 8.0),
                tooltip: "Copy node id",
                iconSize: 24.0,
                color: Colors.blue,
                icon: Icon(
                  IconData(0xe90b, fontFamily: 'icomoon'),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: paymentInfo.nodeId));
                  Navigator.pop(context);
                  Scaffold.of(context).showSnackBar(_buildSnackBar("Node Id"));
                },
              ),
              */
            ],
          ),
        ),
        Container(
          height: 36.0,
          child: ListTile(
            leading: Text(
              "Hash",
              style: theme.paymentDetailsTitleStyle,
              textAlign: TextAlign.left,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  paymentInfo.hashCode.toString(),
                  style: theme.paymentDetailsSubtitleStyle,
                  textAlign: TextAlign.right,
                ),
                /*
                IconButton(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                  tooltip: "Copy hashcode",
                  iconSize: 24.0,
                  color: Colors.blue,
                  icon: Icon(
                    IconData(0xe90b, fontFamily: 'icomoon'),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: paymentInfo.hashCode.toString()));
                    Navigator.pop(context);
                    Scaffold.of(context).showSnackBar(_buildSnackBar("Hash code"));
                  },
                ),
                */
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.0),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SimpleDialogOption(
              onPressed: () {
                final dynamic tooltip = tooltipKey.currentState;
                tooltip.ensureTooltipVisible();
              },
              child: new Tooltip(
                  key: tooltipKey,
                  message: "Long press values to copy them",
                  preferBelow: false,
                  child: new Icon(
                    Icons.info_outline,
                    color: theme.BreezColors.blue[500],
                  )),
              //child: new Text("CLOSE", style: theme.buttonStyle),
            ),
          ],
        ),
      ],
    );
  }
}

_buildSnackBar(String item) {
  final snackBar = new SnackBar(
    content: new Text(
      '$item is copied to your clipboard.',
      style: theme.snackBarStyle,
    ),
    backgroundColor: theme.snackBarBackgroundColor,
    duration: new Duration(seconds: 4),
  );
  return snackBar;
}

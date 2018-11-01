import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
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
    final _expansionTileTheme = Theme.of(context)
        .copyWith(unselectedWidgetColor: Theme.of(context).canvasColor, accentColor: Theme.of(context).canvasColor);
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
        Theme(
          data: _expansionTileTheme,
          child: ExpansionTile(
              title: Text(
                "Node ID",
                style: theme.paymentDetailsTitleStyle,
              ),
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 0.0),
                        child: Text('${paymentInfo.destination}',
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.clip,
                            maxLines: 4,
                            style: theme.paymentDetailsSubtitleStyle),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Padding(
                          padding: EdgeInsets.zero,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                alignment: Alignment.centerRight,
                                tooltip: "Copy Node ID",
                                iconSize: 19.0,
                                color: theme.BreezColors.blue[500],
                                icon: Icon(
                                  IconData(0xe90b, fontFamily: 'icomoon'),
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: paymentInfo.destination));
                                  Navigator.pop(context);
                                  Scaffold.of(context).showSnackBar(_buildSnackBar("Node Id"));
                                },
                              ),
                              IconButton(
                                padding: EdgeInsets.only(right: 8.0),
                                tooltip: "Share Node ID",
                                iconSize: 19.0,
                                color: theme.BreezColors.blue[500],
                                icon: Icon(Icons.share),
                                onPressed: () {
                                  Share.share(paymentInfo.destination);
                                },
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ]),
        ),
        Theme(
          data: _expansionTileTheme,
          child: ExpansionTile(
              title: Text(
                "Hash",
                style: theme.paymentDetailsTitleStyle,
              ),
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 0.0),
                        child: Text('${paymentInfo.paymentHash}',
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.clip,
                            maxLines: 4,
                            style: theme.paymentDetailsSubtitleStyle),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Padding(
                          padding: EdgeInsets.zero,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                alignment: Alignment.centerRight,
                                tooltip: "Copy Hash Code",
                                iconSize: 19.0,
                                color: theme.BreezColors.blue[500],
                                icon: Icon(
                                  IconData(0xe90b, fontFamily: 'icomoon'),
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: paymentInfo.paymentHash));
                                  Navigator.pop(context);
                                  Scaffold.of(context).showSnackBar(_buildSnackBar("Hash code"));
                                },
                              ),
                              IconButton(
                                padding: EdgeInsets.only(right: 8.0),
                                tooltip: "Share Hash Code",
                                iconSize: 19.0,
                                color: theme.BreezColors.blue[500],
                                icon: Icon(Icons.share),
                                onPressed: () {
                                  Share.share(paymentInfo.paymentHash);
                                },
                              ),
                            ],
                          )),
                    ),
                  ],
                )
              ]),
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

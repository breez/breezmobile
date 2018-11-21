import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/user/home/payment_item_avatar.dart';
import 'package:breez/utils/date.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:auto_size_text/auto_size_text.dart';

Future<Null> showPaymentDetailsDialog(BuildContext context, PaymentInfo paymentInfo) {
  final _expansionTileTheme = Theme.of(context)
      .copyWith(unselectedWidgetColor: Theme.of(context).canvasColor, accentColor: Theme.of(context).canvasColor);
  AlertDialog _paymentDetailsDialog = new AlertDialog(
    titlePadding: EdgeInsets.zero,
    title: new Stack(children: <Widget>[
      Container(
        color: theme.BreezColors.blue[900],
        height: 64.0,
      ),
      Padding(
        padding: EdgeInsets.only(top: 32.0),
        child: Center(
          child: PaymentItemAvatar(paymentInfo, radius: 32.0),
        ),
      ),
    ]),
    contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        paymentInfo.title == null || paymentInfo.title.isEmpty
            ? Container()
            : Padding(padding: EdgeInsets.only(left: 16.0,right: 16.0),child:AutoSizeText(
                paymentInfo.title,
                style: theme.paymentRequestAmountStyle,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),),
        paymentInfo.description == null || paymentInfo.description.isEmpty
            ? Container()
            : Padding(padding: EdgeInsets.only(left: 16.0,right: 16.0),child:AutoSizeText(
          paymentInfo.description,
          style: theme.paymentDetailsTitleStyle,
          textAlign: paymentInfo.description.length > 40 ? TextAlign.justify : TextAlign.center,
          maxLines: 3,
        ),),
        paymentInfo.amount == null
            ? Container()
            : Container(
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
        paymentInfo.creationTimestamp == null
            ? Container()
            : Container(
                height: 36.0,
                child: ListTile(
                  title: Text(
                    "Date & Time",
                    style: theme.paymentDetailsTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                  trailing: Text(
                    DateUtils.formatYearMonthDayHourMinute(
                        DateTime.fromMillisecondsSinceEpoch(paymentInfo.creationTimestamp.toInt() * 1000)),
                    style: theme.paymentDetailsSubtitleStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
        Padding(padding: EdgeInsets.only(top: 8.0)),
        paymentInfo.destination == null || paymentInfo.destination.isEmpty
            ? Container()
            : Theme(
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
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.clip,
                                  maxLines: 4,
                                  style: theme.paymentDetailsNodeIdStyle),
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Padding(
                                padding: EdgeInsets.zero,
                                child: new Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                      alignment: Alignment.centerRight,
                                      tooltip: "Copy Node ID",
                                      iconSize: 16.0,
                                      color: theme.BreezColors.blue[500],
                                      icon: Icon(
                                        IconData(0xe90b, fontFamily: 'icomoon'),
                                      ),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: paymentInfo.destination));
                                        Navigator.pop(context);
                                        Scaffold.of(context).showSnackBar(_buildSnackBar("Node ID"));
                                      },
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.only(right: 8.0),
                                      tooltip: "Share Node ID",
                                      iconSize: 16.0,
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
        paymentInfo.paymentHash == null || paymentInfo.paymentHash.isEmpty
            ? Container()
            : Theme(
                data: _expansionTileTheme,
                child: ExpansionTile(
                    title: Text(
                      "Transaction Hash",
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
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.clip,
                                  maxLines: 4,
                                  style: theme.paymentDetailsNodeIdStyle),
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Padding(
                                padding: EdgeInsets.zero,
                                child: new Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: 8.0),
                                      tooltip: "Copy Transaction Hash",
                                      iconSize: 16.0,
                                      color: theme.BreezColors.blue[500],
                                      icon: Icon(
                                        IconData(0xe90b, fontFamily: 'icomoon'),
                                      ),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: paymentInfo.paymentHash));
                                        Navigator.pop(context);
                                        Scaffold.of(context).showSnackBar(_buildSnackBar("Transaction Hash"));
                                      },
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.only(right: 8.0),
                                      tooltip: "Share Transaction Hash",
                                      iconSize: 16.0,
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
    ),
  );
  return showDialog<Null>(
    context: context,
    builder: (_) => _paymentDetailsDialog,
  );
}

_buildSnackBar(String item) {
  final snackBar = new SnackBar(
    content: new Text(
      '$item was copied to your clipboard.',
      style: theme.snackBarStyle,
    ),
    backgroundColor: theme.snackBarBackgroundColor,
    duration: new Duration(seconds: 4),
  );
  return snackBar;
}

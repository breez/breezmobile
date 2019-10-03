import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/user/home/payment_item_avatar.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_extend/share_extend.dart';

final AutoSizeGroup _labelGroup = AutoSizeGroup();
final AutoSizeGroup _valueGroup = AutoSizeGroup();

Future<Null> showPaymentDetailsDialog(BuildContext context, PaymentInfo paymentInfo) {
  AlertDialog _paymentDetailsDialog = new AlertDialog(
    titlePadding: EdgeInsets.zero,
    title: new Stack(children: <Widget>[
      Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
          color: Theme.of(context).primaryColorDark,
        ),
        height: 64.0,
        width: MediaQuery.of(context).size.width,
      ),
      Padding(
        padding: EdgeInsets.only(top: 32.0),
        child: Center(
          child: PaymentItemAvatar(paymentInfo, radius: 32.0),
        ),
      ),
    ]),
    contentPadding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
    content: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          paymentInfo.title == null || paymentInfo.title.isEmpty
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: (paymentInfo.description == null || paymentInfo.description.isEmpty) ? 16 : 8),
                  child: AutoSizeText(
                    paymentInfo.title,
                    style: Theme.of(context).primaryTextTheme.headline,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
          paymentInfo.description == null || paymentInfo.description.isEmpty
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: AutoSizeText(
                    paymentInfo.description,
                    style: Theme.of(context).primaryTextTheme.display1,
                    textAlign: paymentInfo.description.length > 40 ? TextAlign.justify : TextAlign.center,
                    maxLines: 3,
                  ),
                ),
          paymentInfo.amount == null
              ? Container()
              : Container(
                  height: 36.0,
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: AutoSizeText(
                          "Amount",
                          style: Theme.of(context).primaryTextTheme.display1,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          group: _labelGroup,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: AutoSizeText(
                            (paymentInfo.type == PaymentType.SENT || paymentInfo.type == PaymentType.WITHDRAWAL ? "-" : "+") +
                                paymentInfo.currency.format(paymentInfo.amount),
                            style: Theme.of(context).primaryTextTheme.display2,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            group: _valueGroup,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          paymentInfo.creationTimestamp == null
              ? Container()
              : Container(
                  height: 36.0,
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: AutoSizeText(
                          "Date & Time",
                          style: Theme.of(context).primaryTextTheme.display1,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          group: _labelGroup,
                        ),
                      ),
                      Expanded(
                        child: new SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          padding: EdgeInsets.only(left: 8.0),
                          child: AutoSizeText(
                            DateUtils.formatYearMonthDayHourMinute(
                                DateTime.fromMillisecondsSinceEpoch(paymentInfo.creationTimestamp.toInt() * 1000)),
                            style: Theme.of(context).primaryTextTheme.display2,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            group: _valueGroup,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          !paymentInfo.pending
              ? Container()
              : Container(
                  height: 36.0,
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: AutoSizeText(
                          "Expiration",
                          style: Theme.of(context).primaryTextTheme.display1,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          group: _labelGroup,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          padding: EdgeInsets.only(left: 8.0),
                          child: AutoSizeText(
                            DateUtils.formatYearMonthDayHourMinute(
                                DateTime.fromMillisecondsSinceEpoch(paymentInfo.pendingExpirationTimestamp.toInt() * 1000)),
                            style: Theme.of(context).primaryTextTheme.display2,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            group: _valueGroup,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          paymentInfo.preimage == null || paymentInfo.preimage.isEmpty
              ? Container()
              : ShareablePaymentRow(title: "Payment Preimage", sharedValue: paymentInfo.preimage),
          paymentInfo.destination == null || paymentInfo.destination.isEmpty
              ? Container()
              : ShareablePaymentRow(title: "Node ID", sharedValue: paymentInfo.destination),
          paymentInfo.paymentHash == null || paymentInfo.paymentHash.isEmpty
              ? Container()
              : ShareablePaymentRow(title: "Transaction Hash", sharedValue: paymentInfo.paymentHash),
        ],
      ),
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.0), top: Radius.circular(13.0))),
  );
  return showDialog<Null>(
    context: context,
    builder: (_) => _paymentDetailsDialog,
  );
}

class ShareablePaymentRow extends StatelessWidget {
  final String title;
  final String sharedValue;

  const ShareablePaymentRow({Key key, this.title, this.sharedValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _expansionTileTheme =
        Theme.of(context).copyWith(unselectedWidgetColor: Theme.of(context).canvasColor, accentColor: Theme.of(context).canvasColor, dividerColor: Theme.of(context).backgroundColor);
    return Theme(
      data: _expansionTileTheme,
      child: ExpansionTile(
          title: AutoSizeText(
            title,
            style: Theme.of(context).primaryTextTheme.display1,
            maxLines: 1,
            group: _labelGroup,
          ),
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 0.0),
                    child: Text('$sharedValue',
                        textAlign: TextAlign.left, overflow: TextOverflow.clip, maxLines: 4, style: theme.paymentDetailsNodeIdStyle),
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
                            tooltip: "Copy $title",
                            iconSize: 16.0,
                            color: Theme.of(context).canvasColor,
                            icon: Icon(
                              IconData(0xe90b, fontFamily: 'icomoon'),
                            ),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: sharedValue));
                              Navigator.pop(context);
                              Scaffold.of(context).showSnackBar(_buildSnackBar(title));
                            },
                          ),
                          IconButton(
                            padding: EdgeInsets.only(right: 8.0),
                            tooltip: "Share Transaction Hash",
                            iconSize: 16.0,
                            color: Theme.of(context).canvasColor,
                            icon: Icon(Icons.share),
                            onPressed: () {
                              ShareExtend.share(sharedValue, "text");
                            },
                          ),
                        ],
                      )),
                ),
              ],
            )
          ]),
    );
  }
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

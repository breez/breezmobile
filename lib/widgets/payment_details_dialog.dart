import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/user/home/payment_item_avatar.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';

import 'flushbar.dart';
import 'link_launcher.dart';

final AutoSizeGroup _labelGroup = AutoSizeGroup();
final AutoSizeGroup _valueGroup = AutoSizeGroup();

Future<Null> showPaymentDetailsDialog(
    BuildContext context, PaymentInfo paymentInfo) {
  if (paymentInfo.type == PaymentType.CLOSED_CHANNEL) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
            title: Text(
              (paymentInfo.pending ? "Pending " : "") + "Closed Channel",
              style: Theme.of(context).dialogTheme.titleTextStyle,
            ),
            contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
            content: ClosedChannelPaymentDetails(closedChannel: paymentInfo),
            actions: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx),
                child: Text("OK",
                    style: Theme.of(context).primaryTextTheme.button),
              )
            ],
          );
        });
  }
  AlertDialog _paymentDetailsDialog = AlertDialog(
    titlePadding: EdgeInsets.zero,
    title: Stack(children: <Widget>[
      Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
          color: theme.themeId == "BLUE"
              ? Theme.of(context).primaryColorDark
              : Theme.of(context).canvasColor,
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
          paymentInfo.dialogTitle == null || paymentInfo.dialogTitle.isEmpty
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: (paymentInfo.description == null ||
                              paymentInfo.description.isEmpty)
                          ? 16
                          : 8),
                  child: AutoSizeText(
                    paymentInfo.dialogTitle,
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
                    textAlign: paymentInfo.description.length > 40
                        ? TextAlign.justify
                        : TextAlign.center,
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
                        padding: const EdgeInsets.only(right: 8.0),
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
                            (paymentInfo.type == PaymentType.SENT ||
                                        paymentInfo.type ==
                                            PaymentType.WITHDRAWAL
                                    ? "-"
                                    : "+") +
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
                        padding: const EdgeInsets.only(right: 8.0),
                        child: AutoSizeText(
                          "Date & Time",
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
                                DateTime.fromMillisecondsSinceEpoch(
                                    paymentInfo.creationTimestamp.toInt() *
                                        1000)),
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
          !paymentInfo.pending || paymentInfo.type == PaymentType.CLOSED_CHANNEL
              ? Container()
              : Container(
                  height: 36.0,
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
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
                                DateTime.fromMillisecondsSinceEpoch(paymentInfo
                                        .pendingExpirationTimestamp
                                        .toInt() *
                                    1000)),
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
              : ShareablePaymentRow(
                  title: "Payment Preimage", sharedValue: paymentInfo.preimage),
          paymentInfo.destination == null || paymentInfo.destination.isEmpty
              ? Container()
              : ShareablePaymentRow(
                  title: "Node ID", sharedValue: paymentInfo.destination),
          paymentInfo.paymentHash == null || paymentInfo.paymentHash.isEmpty
              ? Container()
              : ShareablePaymentRow(
                  title: "Transaction Hash",
                  sharedValue: paymentInfo.paymentHash),
        ],
      ),
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12.0), top: Radius.circular(13.0))),
  );
  return showDialog<Null>(
    useRootNavigator: false,
    context: context,
    builder: (_) => _paymentDetailsDialog,
  );
}

class ShareablePaymentRow extends StatelessWidget {
  final String title;
  final String sharedValue;

  const ShareablePaymentRow({Key key, this.title, this.sharedValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _expansionTileTheme = Theme.of(context).copyWith(
        unselectedWidgetColor: Theme.of(context).primaryTextTheme.button.color,
        accentColor: Theme.of(context).primaryTextTheme.button.color,
        dividerColor: Theme.of(context).backgroundColor);
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
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                        maxLines: 4,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .display2
                            .copyWith(fontSize: 10)),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Padding(
                      padding: EdgeInsets.zero,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 8.0),
                            tooltip: "Copy $title",
                            iconSize: 16.0,
                            color:
                                Theme.of(context).primaryTextTheme.button.color,
                            icon: Icon(
                              IconData(0xe90b, fontFamily: 'icomoon'),
                            ),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: sharedValue));
                              Navigator.pop(context);
                              Scaffold.of(context)
                                  .showSnackBar(_buildSnackBar(title));
                            },
                          ),
                          IconButton(
                            padding: EdgeInsets.only(right: 8.0),
                            tooltip: "Share Transaction Hash",
                            iconSize: 16.0,
                            color:
                                Theme.of(context).primaryTextTheme.button.color,
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
  final snackBar = SnackBar(
    content: Text(
      '$item was copied to your clipboard.',
      style: theme.snackBarStyle,
    ),
    backgroundColor: theme.snackBarBackgroundColor,
    duration: Duration(seconds: 4),
  );
  return snackBar;
}

class ClosedChannelPaymentDetails extends StatelessWidget {
  final PaymentInfo closedChannel;

  const ClosedChannelPaymentDetails({Key key, this.closedChannel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!closedChannel.pending) {
      return RichText(
          text: TextSpan(
              style: Theme.of(context).dialogTheme.contentTextStyle,
              text: "Transfer to local wallet due to ",
              children: [
            _LinkTextSpan(
                text: "closed channel",
                url: closedChannel.closeChannelTxUrl,
                style: Theme.of(context).dialogTheme.contentTextStyle.copyWith(
                    decoration: TextDecoration.underline,
                    color: theme.blueLinkStyle.color)),
            TextSpan(
                style: Theme.of(context).dialogTheme.contentTextStyle,
                text: ".")
          ]));
    }

    int lockHeight = closedChannel.pendingExpirationHeight;
    double hoursToUnlock = closedChannel.hoursToExpire;

    int roundedHoursToUnlock = hoursToUnlock.round();
    String hoursToUnlockStr = roundedHoursToUnlock > 1
        ? "~${roundedHoursToUnlock.toString()} hours"
        : "in about an hour";
    String estimation = lockHeight > 0 && hoursToUnlock > 0
        ? " in block $lockHeight ($hoursToUnlockStr)"
        : "";
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RichText(
            text: TextSpan(
                style: Theme.of(context).dialogTheme.contentTextStyle,
                text:
                    "Waiting for closed channel funds to be transferred to your local wallet$estimation",
                children: [
              TextSpan(
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                  text: closedChannel.channelCloseConfirmed
                      ? "."
                      : " (closing transaction is expected to be confirmed within an hour).")
            ])),
        _TxWidget(
          txURL: closedChannel.closeChannelTxUrl,
          txID: closedChannel.closeChannelTx,
        )
      ],
    );
  }
}

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(url, forceSafariVC: false);
              });
}

class _TxWidget extends StatelessWidget {
  final String txURL;
  final String txID;

  const _TxWidget({Key key, this.txURL, this.txID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.txURL == null) {
      return SizedBox();
    }
    var textStyle = DefaultTextStyle.of(context).style;
    textStyle = textStyle.copyWith(fontSize: textStyle.fontSize * 0.8);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: LinkLauncher(
              textStyle: textStyle,
              linkName: this.txID,
              linkAddress: this.txURL,
              onCopy: () {
                Clipboard.setData(ClipboardData(text: this.txID));
                showFlushbar(context,
                    message: "Transaction ID was copied to your clipboard.",
                    duration: Duration(seconds: 3));
              },
            ),
          ),
        ]);
  }
}

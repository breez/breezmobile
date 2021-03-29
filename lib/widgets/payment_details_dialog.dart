import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/home/payment_item_avatar.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/loader.dart';
import 'package:collection/collection.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_extend/share_extend.dart';

import 'error_dialog.dart';
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
          LSPBloc lspBloc = AppBlocsProvider.of<LSPBloc>(context);
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
            title: Text(
              (paymentInfo.pending ? "Pending " : "") + "Closed Channel",
              style: Theme.of(context).dialogTheme.titleTextStyle,
            ),
            contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
            content: StreamBuilder<LSPStatus>(
                stream: lspBloc.lspStatusStream,
                builder: (context, snapshot) {
                  return ClosedChannelPaymentDetails(
                      accountBloc: AppBlocsProvider.of<AccountBloc>(context),
                      lsp: snapshot.data,
                      closedChannel: paymentInfo);
                }),
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
                    paymentInfo.dialogTitle.replaceAll("\n", " "),
                    style: Theme.of(context).primaryTextTheme.headline5,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
          paymentInfo.description == null || paymentInfo.description.isEmpty
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    constraints: BoxConstraints(
                        maxHeight: 54, minWidth: double.infinity),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: AutoSizeText(
                          paymentInfo.description,
                          style: Theme.of(context).primaryTextTheme.headline4,
                          textAlign: paymentInfo.description.length > 40 &&
                                  !paymentInfo.description.contains("\n")
                              ? TextAlign.start
                              : TextAlign.center,
                        ),
                      ),
                    ),
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
                          style: Theme.of(context).primaryTextTheme.headline4,
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
                            style: Theme.of(context).primaryTextTheme.headline3,
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
                          style: Theme.of(context).primaryTextTheme.headline4,
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
                            BreezDateUtils.formatYearMonthDayHourMinute(
                                DateTime.fromMillisecondsSinceEpoch(
                                    paymentInfo.creationTimestamp.toInt() *
                                        1000)),
                            style: Theme.of(context).primaryTextTheme.headline3,
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
                          style: Theme.of(context).primaryTextTheme.headline4,
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
                            BreezDateUtils.formatYearMonthDayHourMinute(
                                DateTime.fromMillisecondsSinceEpoch(paymentInfo
                                        .pendingExpirationTimestamp
                                        .toInt() *
                                    1000)),
                            style: Theme.of(context).primaryTextTheme.headline3,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            group: _valueGroup,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ..._getPaymentInfoDetails(paymentInfo),
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

List<Widget> _getPaymentInfoDetails(PaymentInfo paymentInfo) {
  if (paymentInfo is StreamedPaymentInfo) {
    return _getStreamedPaymentInfoDetails(paymentInfo);
  }
  return _getSinglePaymentInfoDetails(paymentInfo);
}

List<Widget> _getStreamedPaymentInfoDetails(StreamedPaymentInfo paymentInfo) {
  return groupBy<PaymentInfo, String>(
      paymentInfo.singlePayments, (p) => p.title).entries.map((ent) {
    String title = ent.key;
    Int64 amount = ent.value.fold(
        Int64(0), (previousValue, element) => element.amount + previousValue);
    return _Destination(title, amount, ent.value[0].currency);
  }).toList();
}

List<Widget> _getSinglePaymentInfoDetails(PaymentInfo paymentInfo) {
  return List<Widget>.from({
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
            title: "Transaction Hash", sharedValue: paymentInfo.paymentHash),
    paymentInfo.redeemTxID == null || paymentInfo.redeemTxID.isEmpty
        ? Container()
        : ShareablePaymentRow(
            title: "On-chain Transaction", sharedValue: paymentInfo.redeemTxID),
  });
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
            style: Theme.of(context).primaryTextTheme.headline4,
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
                            .headline3
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
                              ServiceInjector()
                                  .device
                                  .setClipboardText(sharedValue);
                              Navigator.pop(context);
                              showFlushbar(context,
                                  message:
                                      "$title was copied to your clipboard.",
                                  duration: Duration(seconds: 4));
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

/*_buildSnackBar(String item) {
  final snackBar = SnackBar(
    content: Text(
      '$item was copied to your clipboard.',
      style: theme.snackBarStyle,
    ),
    backgroundColor: theme.snackBarBackgroundColor,
    duration: Duration(seconds: 4),
  );
  return snackBar;
}*/

class ClosedChannelPaymentDetails extends StatefulWidget {
  final SinglePaymentInfo closedChannel;
  final LSPStatus lsp;
  final AccountBloc accountBloc;

  const ClosedChannelPaymentDetails(
      {Key key, this.closedChannel, this.lsp, this.accountBloc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ClosedChannelPaymentDetailsState();
  }
}

class ClosedChannelPaymentDetailsState
    extends State<ClosedChannelPaymentDetails> {
  bool showRefreshChainButton = false;
  bool mismatchChecked = false;
  bool mismatchedLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkMismatch();
  }

  @override
  void didUpdateWidget(ClosedChannelPaymentDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    checkMismatch();
  }

  void checkMismatch() {
    if (!mismatchChecked &&
        widget.closedChannel.pending &&
        widget.lsp != null &&
        widget.lsp.currentLSP != null) {
      mismatchChecked = true;
      setState(() {
        mismatchedLoading = true;
      });
      var checkChannels = CheckClosedChannelMismatchAction(
          widget.lsp.currentLSP.raw, widget.closedChannel.closedChannelPoint);
      widget.accountBloc.userActionsSink.add(checkChannels);
      checkChannels.future.then((value) {
        var response = value as CheckLSPClosedChannelMismatchResponse;
        if (response.mismatch && this.mounted) {
          setState(() {
            showRefreshChainButton = true;
          });
        }
      }).whenComplete(() {
        if (this.mounted) {
          setState(() {
            mismatchedLoading = false;
          });
        }
      });
    }
  }

  Future _resetClosedChannelChainInfo(Int64 blockHeight) {
    var resetChannelAction = ResetClosedChannelChainInfoAction(
        widget.closedChannel.closedChannelPoint, blockHeight);
    widget.accountBloc.userActionsSink.add(resetChannelAction);
    return resetChannelAction.future;
  }

  Future _onResetChainInfoPressed() async {
    int localConfirmHeight = await _getTXConfirmationHeight(
        widget.closedChannel.localCloseChannelTx);
    if (localConfirmHeight > 0) {
      await _resetClosedChannelChainInfo(Int64(localConfirmHeight));
      return;
    }
    int remoteConfirmHeight = await _getTXConfirmationHeight(
        widget.closedChannel.remoteCloseChannelTx);
    if (remoteConfirmHeight > 0) {
      await _resetClosedChannelChainInfo(Int64(remoteConfirmHeight));
      return;
    }
  }

  Future<int> _getTXConfirmationHeight(String chanPoint) async {
    String txUrl = "https://blockstream.info/api/tx/${chanPoint.split(":")[0]}";
    var response = await http.get(txUrl);
    if (response.statusCode == 200) {
      Map<String, dynamic> userData = json.decode(response.body);
      var status = userData["status"];
      if (status != null && status is Map<String, dynamic>) {
        if (status["confirmed"] == true) {
          var height = status["block_height"];
          if (height is int) {
            return height;
          }
        }
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.closedChannel.pending) {
      return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        RichText(
            text: TextSpan(
          style: Theme.of(context).dialogTheme.contentTextStyle,
          text: "Transfer to local wallet due to closed channel.",
        )),
        TxWidget(
          txURL: widget.closedChannel.closeChannelTxUrl,
          txID: widget.closedChannel.closeChannelTx,
        )
      ]);
    }

    int lockHeight = widget.closedChannel.pendingExpirationHeight;
    double hoursToUnlock = widget.closedChannel.hoursToExpire;

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
              "Waiting for closed channel funds to be transferred to your local wallet$estimation.",
        )),
        TxWidget(
          txURL: widget.closedChannel.closeChannelTxUrl,
          txID: widget.closedChannel.closeChannelTx,
        ),
        TxWidget(
          txURL: widget.closedChannel.remoteCloseChannelTxUrl,
          txID: widget.closedChannel.remoteCloseChannelTx,
        ),
        mismatchedLoading
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Loader(),
                    )
                  ])
            : SizedBox(),
        showRefreshChainButton
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextButton(
                        onPressed: () {
                          _onResetChainInfoPressed().then((_) {
                            _promptForRestart();
                          }).catchError((err) {
                            promptError(
                                context,
                                "Internal Error",
                                Text(
                                  err.toString(),
                                  style: Theme.of(context)
                                      .dialogTheme
                                      .contentTextStyle,
                                ));
                          });
                        },
                        child: Text("Refresh Information",
                            style: Theme.of(context).primaryTextTheme.button),
                      ),
                    )
                  ])
            : SizedBox(),
      ],
    );
  }

  Future<bool> _promptForRestart() {
    return promptAreYouSure(
            context,
            null,
            Text(
                "Please restart Breez to reset chain information for this channel.",
                style: Theme.of(context).dialogTheme.contentTextStyle),
            cancelText: "CANCEL",
            okText: "EXIT BREEZ")
        .then((shouldExit) {
      if (shouldExit) {
        exit(0);
      }
      return true;
    });
  }
}

class TxWidget extends StatelessWidget {
  final String txURL;
  final String txID;
  final String txLabel;

  const TxWidget(
      {Key key, this.txURL, this.txID, this.txLabel = "Transaction ID:"})
      : super(key: key);

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
              linkTitle: txLabel,
              textStyle: textStyle,
              linkName: this.txID,
              linkAddress: this.txURL,
              onCopy: () {
                ServiceInjector().device.setClipboardText(this.txID);
                showFlushbar(context,
                    message: "Transaction ID was copied to your clipboard.",
                    duration: Duration(seconds: 3));
              },
            ),
          ),
        ]);
  }
}

class _Destination extends StatelessWidget {
  final String title;
  final Int64 amount;
  final Currency currency;

  const _Destination(this.title, this.amount, this.currency);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0,
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AutoSizeText(
              title,
              style: Theme.of(context).primaryTextTheme.headline4,
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
                (amount < 0 ? "-" : "+") + currency.format(amount),
                style: Theme.of(context).primaryTextTheme.headline3,
                textAlign: TextAlign.right,
                maxLines: 1,
                group: _valueGroup,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

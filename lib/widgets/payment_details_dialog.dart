import 'dart:convert';
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
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/link_launcher.dart';
import 'package:breez/widgets/loader.dart';
import 'package:collection/collection.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

final AutoSizeGroup _labelGroup = AutoSizeGroup();
final AutoSizeGroup _valueGroup = AutoSizeGroup();

Future<Null> showPaymentDetailsDialog(
  BuildContext context,
  PaymentInfo paymentInfo,
) {
  final themeData = Theme.of(context);
  var mediaQuery = MediaQuery.of(context);
  final texts = AppLocalizations.of(context);

  if (paymentInfo.type == PaymentType.CLOSED_CHANNEL) {
    final lspBloc = AppBlocsProvider.of<LSPBloc>(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
          title: Text(
            paymentInfo.pending
                ? texts.payment_details_dialog_closed_channel_title_pending
                : texts.payment_details_dialog_closed_channel_title,
            style: themeData.dialogTheme.titleTextStyle,
          ),
          contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
          content: StreamBuilder<LSPStatus>(
            stream: lspBloc.lspStatusStream,
            builder: (context, snapshot) {
              return ClosedChannelPaymentDetails(
                accountBloc: accountBloc,
                lsp: snapshot.data,
                closedChannel: paymentInfo,
              );
            },
          ),
          actions: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                texts.payment_details_dialog_closed_channel_ok,
                style: themeData.primaryTextTheme.button,
              ),
            ),
          ],
        );
      },
    );
  }

  AlertDialog _paymentDetailsDialog = AlertDialog(
    titlePadding: EdgeInsets.zero,
    title: Stack(
      children: <Widget>[
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
            ),
            color: theme.themeId == "BLUE"
                ? themeData.primaryColorDark
                : themeData.canvasColor,
          ),
          height: 64.0,
          width: mediaQuery.size.width,
        ),
        Padding(
          padding: EdgeInsets.only(top: 32.0),
          child: Center(
            child: PaymentItemAvatar(
              paymentInfo,
              radius: 32.0,
            ),
          ),
        ),
      ],
    ),
    contentPadding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
    content: SingleChildScrollView(
      child: Container(
        width: mediaQuery.size.width,
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
                          : 8,
                    ),
                    child: AutoSizeText(
                      paymentInfo.dialogTitle.replaceAll("\n", " "),
                      style: themeData.primaryTextTheme.headline5,
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
                        maxHeight: 54,
                        minWidth: double.infinity,
                      ),
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: AutoSizeText(
                            paymentInfo.description,
                            style: themeData.primaryTextTheme.headline4,
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
                            texts.payment_details_dialog_amount_title,
                            style: themeData.primaryTextTheme.headline4,
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            group: _labelGroup,
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: _amountText(
                              paymentInfo,
                              texts,
                              themeData,
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
                            texts.payment_details_dialog_date_and_time,
                            style: themeData.primaryTextTheme.headline4,
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
                                  paymentInfo.creationTimestamp.toInt() * 1000,
                                ),
                              ),
                              style: themeData.primaryTextTheme.headline3,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              group: _valueGroup,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            !paymentInfo.pending ||
                    paymentInfo.type == PaymentType.CLOSED_CHANNEL
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
                            texts.payment_details_dialog_expiration,
                            style: themeData.primaryTextTheme.headline4,
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
                                  paymentInfo.pendingExpirationTimestamp
                                          .toInt() *
                                      1000,
                                ),
                              ),
                              style: themeData.primaryTextTheme.headline3,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              group: _valueGroup,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            if (paymentInfo.lnurlPayInfo != null &&
                paymentInfo.lnurlPayInfo.comment != '')
              ShareablePaymentRow(
                title: texts.payment_details_dialog_share_comment,
                sharedValue: paymentInfo.lnurlPayInfo.comment,
              ),
            if (paymentInfo.type == PaymentType.SENT &&
                paymentInfo.lnurlPayInfo != null) ...<Widget>[
              if (paymentInfo.lnurlPayInfo.lightningAddress.isNotEmpty)
                ShareablePaymentRow(
                  title: texts.payment_details_dialog_share_lightning_address,
                  sharedValue: paymentInfo.lnurlPayInfo.lightningAddress,
                ),
              ..._getLNUrlSuccessActionForPayment(
                context,
                paymentInfo.lnurlPayInfo?.successAction,
                texts,
              )
            ],
            ..._getPaymentInfoDetails(
              paymentInfo,
              texts,
            ),
          ],
        ),
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(12.0),
        top: Radius.circular(13.0),
      ),
    ),
  );
  return showDialog<Null>(
    useRootNavigator: false,
    context: context,
    builder: (_) => _paymentDetailsDialog,
  );
}

Widget _amountText(
  PaymentInfo paymentInfo,
  AppLocalizations texts,
  ThemeData themeData,
) {
  final amount = paymentInfo.currency.format(paymentInfo.amount);
  final text = (paymentInfo.type == PaymentType.SENT ||
          paymentInfo.type == PaymentType.WITHDRAWAL)
      ? texts.payment_details_dialog_amount_negative(amount)
      : texts.payment_details_dialog_amount_positive(amount);
  return AutoSizeText(
    text,
    style: themeData.primaryTextTheme.headline3,
    textAlign: TextAlign.right,
    maxLines: 1,
    group: _valueGroup,
  );
}

List<Widget> _getPaymentInfoDetails(
  PaymentInfo paymentInfo,
  AppLocalizations texts,
) {
  if (paymentInfo is StreamedPaymentInfo) {
    return _getStreamedPaymentInfoDetails(paymentInfo);
  }
  return _getSinglePaymentInfoDetails(paymentInfo, texts);
}

List<Widget> _getStreamedPaymentInfoDetails(StreamedPaymentInfo paymentInfo) {
  return groupBy<PaymentInfo, String>(
    paymentInfo.singlePayments,
    (p) => p.title,
  ).entries.map((ent) {
    String title = ent.key;
    Int64 amount = ent.value.fold(
      Int64(0),
      (previousValue, element) => element.amount + previousValue,
    );
    return _Destination(
      title,
      amount,
      ent.value[0].currency,
    );
  }).toList();
}

List<Widget> _getLNUrlSuccessActionForPayment(
  BuildContext context,
  SuccessAction sa,
  AppLocalizations texts,
) {
  return <Widget>[
    if (sa.tag == 'url') ...[
      ShareablePaymentRow(
        title: texts.payment_details_dialog_action_for_payment_description,
        sharedValue: sa.description,
      ),
      ShareablePaymentRow(
        title: texts.payment_details_dialog_action_for_payment_url,
        sharedValue: sa.url, // TODO Hyperlink.
      ),
    ],
    if (sa.tag == 'message' || sa.tag == 'aes')
      ShareablePaymentRow(
        title: texts.payment_details_dialog_action_for_payment_message,
        sharedValue: sa.message,
      ),
  ];
}

List<Widget> _getSinglePaymentInfoDetails(
  PaymentInfo paymentInfo,
  AppLocalizations texts,
) {
  return List<Widget>.from({
    paymentInfo.preimage == null || paymentInfo.preimage.isEmpty
        ? Container()
        : ShareablePaymentRow(
            title: texts.payment_details_dialog_single_info_pre_image,
            sharedValue: paymentInfo.preimage,
          ),
    paymentInfo.destination == null || paymentInfo.destination.isEmpty
        ? Container()
        : ShareablePaymentRow(
            title: texts.payment_details_dialog_single_info_node_id,
            sharedValue: paymentInfo.destination,
          ),
    paymentInfo.redeemTxID == null || paymentInfo.redeemTxID.isEmpty
        ? Container()
        : ShareablePaymentRow(
            title: texts.payment_details_dialog_single_info_on_chain,
            sharedValue: paymentInfo.redeemTxID,
          ),
  });
}

class ShareablePaymentRow extends StatelessWidget {
  final String title;
  final String sharedValue;

  const ShareablePaymentRow({
    Key key,
    this.title,
    this.sharedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    final _expansionTileTheme =
        themeData.copyWith(dividerColor: themeData.backgroundColor);
    return Theme(
      data: _expansionTileTheme,
      child: ExpansionTile(
        iconColor: themeData.primaryTextTheme.button.color,
        collapsedIconColor: themeData.primaryTextTheme.button.color,
        title: AutoSizeText(
          title,
          style: themeData.primaryTextTheme.headline4,
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
                  child: Text(
                    '$sharedValue',
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    maxLines: 4,
                    style: themeData.primaryTextTheme.headline3
                        .copyWith(fontSize: 10),
                  ),
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
                        tooltip: texts.payment_details_dialog_copy_action(
                          title,
                        ),
                        iconSize: 16.0,
                        color: themeData.primaryTextTheme.button.color,
                        icon: Icon(
                          IconData(0xe90b, fontFamily: 'icomoon'),
                        ),
                        onPressed: () {
                          ServiceInjector()
                              .device
                              .setClipboardText(sharedValue);
                          Navigator.pop(context);
                          showFlushbar(
                            context,
                            message: texts.payment_details_dialog_copied(
                              title,
                            ),
                            duration: Duration(seconds: 4),
                          );
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.only(right: 8.0),
                        tooltip: texts.payment_details_dialog_share_transaction,
                        iconSize: 16.0,
                        color: themeData.primaryTextTheme.button.color,
                        icon: Icon(Icons.share),
                        onPressed: () {
                          Share.share(sharedValue);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ClosedChannelPaymentDetails extends StatefulWidget {
  final SinglePaymentInfo closedChannel;
  final LSPStatus lsp;
  final AccountBloc accountBloc;

  const ClosedChannelPaymentDetails({
    Key key,
    this.closedChannel,
    this.lsp,
    this.accountBloc,
  }) : super(key: key);

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
        widget.lsp.currentLSP.raw,
        widget.closedChannel.closedChannelPoint,
      );
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
      widget.closedChannel.closedChannelPoint,
      blockHeight,
    );
    widget.accountBloc.userActionsSink.add(resetChannelAction);
    return resetChannelAction.future;
  }

  Future _onResetChainInfoPressed() async {
    int localConfirmHeight = await _getTXConfirmationHeight(
      widget.closedChannel.localCloseChannelTx,
    );
    if (localConfirmHeight > 0) {
      await _resetClosedChannelChainInfo(Int64(localConfirmHeight));
      return;
    }
    int remoteConfirmHeight = await _getTXConfirmationHeight(
      widget.closedChannel.remoteCloseChannelTx,
    );
    if (remoteConfirmHeight > 0) {
      await _resetClosedChannelChainInfo(Int64(remoteConfirmHeight));
      return;
    }
  }

  Future<int> _getTXConfirmationHeight(String chanPoint) async {
    Uri txUri = Uri.https(
      "blockstream.info",
      "api/tx/${chanPoint.split(":")[0]}",
    );
    var response = await http.get(txUri);
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
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    if (!widget.closedChannel.pending) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: themeData.dialogTheme.contentTextStyle,
              text: texts.payment_details_dialog_closed_channel_local_wallet,
            ),
          ),
          TxWidget(
            txURL: widget.closedChannel.closeChannelTxUrl,
            txID: widget.closedChannel.closeChannelTx,
          )
        ],
      );
    }

    int lockHeight = widget.closedChannel.pendingExpirationHeight;
    double hoursToUnlock = widget.closedChannel.hoursToExpire;

    int roundedHoursToUnlock = hoursToUnlock.round();
    String hoursToUnlockStr = roundedHoursToUnlock > 1
        ? texts.payment_details_dialog_closed_channel_about_hours(
            roundedHoursToUnlock.toString(),
          )
        : texts.payment_details_dialog_closed_channel_about_hour;
    String estimation = lockHeight > 0 && hoursToUnlock > 0
        ? texts.payment_details_dialog_closed_channel_transfer_estimation(
            lockHeight,
            hoursToUnlockStr,
          )
        : texts.payment_details_dialog_closed_channel_transfer_no_estimation;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: themeData.dialogTheme.contentTextStyle,
            text: estimation,
          ),
        ),
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
                ],
              )
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
                            texts.payment_details_dialog_internal_error,
                            Text(
                              err.toString(),
                              style: themeData.dialogTheme.contentTextStyle,
                            ),
                          );
                        });
                      },
                      child: Text(
                        texts.payment_details_dialog_refresh_information,
                        style: themeData.primaryTextTheme.button,
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox(),
      ],
    );
  }

  Future<bool> _promptForRestart() {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    return promptAreYouSure(
      context,
      null,
      Text(
        texts.payment_details_dialog_restart_text,
        style: themeData.dialogTheme.contentTextStyle,
      ),
      cancelText: texts.payment_details_dialog_restart_cancel,
      okText: texts.payment_details_dialog_restart_exit_breez,
    ).then((shouldExit) {
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
  final EdgeInsets padding;

  const TxWidget({
    Key key,
    this.txURL,
    this.txID,
    this.txLabel,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.txURL == null) {
      return SizedBox();
    }
    final texts = AppLocalizations.of(context);
    var textStyle = DefaultTextStyle.of(context).style;
    textStyle = textStyle.copyWith(
      fontSize: textStyle.fontSize * 0.8,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding ?? EdgeInsets.only(top: 20.0),
          child: LinkLauncher(
            linkTitle: txLabel ??
                texts.payment_details_dialog_transaction_label_default,
            textStyle: textStyle,
            linkName: this.txID,
            linkAddress: this.txURL,
            onCopy: () {
              ServiceInjector().device.setClipboardText(this.txID);
              showFlushbar(
                context,
                message: texts.payment_details_dialog_transaction_id_copied,
                duration: Duration(seconds: 3),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Destination extends StatelessWidget {
  final String title;
  final Int64 amount;
  final Currency currency;

  const _Destination(
    this.title,
    this.amount,
    this.currency,
  );

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Theme(
      data: themeData.copyWith(
        dividerColor: themeData.backgroundColor,
      ),
      child: ExpansionTile(
        iconColor: themeData.primaryTextTheme.button.color,
        collapsedIconColor: themeData.primaryTextTheme.button.color,
        title: AutoSizeText(
          title,
          style: themeData.primaryTextTheme.headline4,
          textAlign: TextAlign.left,
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
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: AutoSizeText(
                    currency.format(amount),
                    style: themeData.primaryTextTheme.headline3,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    group: _valueGroup,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

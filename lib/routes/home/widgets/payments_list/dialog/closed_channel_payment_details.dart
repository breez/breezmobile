import 'dart:convert';
import 'dart:io';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/tx_widget.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    final channel = widget.closedChannel;
    final lsp = widget.lsp;
    if (!mismatchChecked &&
        channel.pending &&
        lsp != null &&
        lsp.currentLSP != null) {
      mismatchChecked = true;
      setState(() {
        mismatchedLoading = true;
      });
      var checkChannels = CheckClosedChannelMismatchAction(
        lsp.currentLSP.raw,
        channel.closedChannelPoint,
      );
      widget.accountBloc.userActionsSink.add(checkChannels);
      checkChannels.future.then((value) {
        var response = value as CheckLSPClosedChannelMismatchResponse;
        if (response.mismatch && mounted) {
          setState(() {
            showRefreshChainButton = true;
          });
        }
      }).whenComplete(() {
        if (mounted) {
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
    final texts = context.texts();
    if (!widget.closedChannel.pending) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
      children: [
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
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Loader(),
                  )
                ],
              )
            : const SizedBox(),
        showRefreshChainButton
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
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
                        style: themeData.primaryTextTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  Future<bool> _promptForRestart() {
    final themeData = Theme.of(context);
    final texts = context.texts();
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

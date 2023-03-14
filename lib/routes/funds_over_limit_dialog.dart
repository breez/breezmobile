import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/loader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class SwapRefundDialog extends StatefulWidget {
  final AccountBloc accountBloc;

  const SwapRefundDialog({
    Key key,
    this.accountBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SwapRefundDialogState();
  }
}

class SwapRefundDialogState extends State<SwapRefundDialog> {
  Future _fetchFuture;

  @override
  void initState() {
    super.initState();
    var fetchAction = FetchSwapFundStatus();
    _fetchFuture = fetchAction.future;
    widget.accountBloc.userActionsSink.add(fetchAction);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 16.0),
      title: AutoSizeText(
        texts.funds_over_limit_dialog_on_chain_transaction,
        style: themeData.dialogTheme.titleTextStyle,
        maxLines: 1,
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: FutureBuilder(
        future: _fetchFuture,
        initialData: "loading",
        builder: (ctx, loadingSnapshot) {
          if (loadingSnapshot.data == "loading") {
            return const Loader();
          }

          return StreamBuilder<AccountModel>(
            stream: widget.accountBloc.accountStream,
            builder: (ctx, snapshot) {
              final swapStatus = snapshot?.data?.swapFundsStatus;
              if (swapStatus == null) {
                return const Loader();
              }

              return _build(context, swapStatus);
            },
          );
        },
      ),
      actions: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: Text(
            texts.funds_over_limit_dialog_action_ok,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        )
      ],
    );
  }

  Widget _build(
    BuildContext context,
    SwapFundStatus swapStatus,
  ) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    RefundableAddress swapAddress = swapStatus.waitingRefundAddresses[0];
    int lockHeight = swapAddress.lockHeight;
    double hoursToUnlock = swapAddress.hoursToUnlock;

    String reason;
    if (swapAddress.refundableError != null) {
      reason = texts.funds_over_limit_dialog_transfer_fail_with_reason(
        swapAddress.refundableError,
      );
    } else {
      reason = texts.funds_over_limit_dialog_transfer_fail_no_reason_know;
    }

    List<TextSpan> redeemText = <TextSpan>[];
    if (hoursToUnlock > 0) {
      redeemText.add(
        TextSpan(
          text: texts.funds_over_limit_dialog_redeem_hours(
            lockHeight.toString(),
            _getHoursToUnlockString(hoursToUnlock),
          ),
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
    } else {
      redeemText.addAll(
        [
          TextSpan(
            text: texts.funds_over_limit_dialog_refund_begin,
            style: themeData.dialogTheme.contentTextStyle,
          ),
          TextSpan(
            text: texts.funds_over_limit_dialog_refund_link,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/get_refund");
              },
            style: theme.blueLinkStyle,
          ),
          TextSpan(
            text: texts.funds_over_limit_dialog_refund_end,
            style: themeData.dialogTheme.contentTextStyle,
          ),
        ],
      );
    }

    return RichText(
      text: TextSpan(
        style: themeData.dialogTheme.contentTextStyle,
        text: reason,
        children: redeemText,
      ),
    );
  }

  String _getHoursToUnlockString(double hoursToUnlock) {
    final texts = context.texts();
    int roundedValue = hoursToUnlock.ceil();
    if (roundedValue <= 0) return '';
    if (roundedValue <= 1) return texts.approximately_an_hour;
    return texts.approximate_hours(roundedValue.toString());
  }
}
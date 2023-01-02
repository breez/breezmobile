import 'package:auto_size_text/auto_size_text.dart';
import 'package:clovrlabs_wallet/bloc/account/account_actions.dart';
import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/widgets/loader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final texts = AppLocalizations.of(context);

    return AlertDialog(
      title: AutoSizeText(
        texts.funds_over_limit_dialog_on_chain_transaction,
        style: themeData.dialogTheme.titleTextStyle,
        maxLines: 1,
      ),
      content: FutureBuilder(
        future: this._fetchFuture,
        initialData: "loading",
        builder: (ctx, loadingSnapshot) {
          if (loadingSnapshot.data == "loading") {
            return Loader();
          }

          return StreamBuilder<AccountModel>(
            stream: widget.accountBloc.accountStream,
            builder: (ctx, snapshot) {
              final swapStatus = snapshot?.data?.swapFundsStatus;
              if (swapStatus == null) {
                return Loader();
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
            style: themeData.primaryTextTheme.button,
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
    final texts = AppLocalizations.of(context);

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
    final texts = AppLocalizations.of(context);
    int roundedValue = hoursToUnlock.ceil();
    if (roundedValue <= 0) return '';
    if (roundedValue <= 1) return texts.approximately_an_hour;
    return texts.approximate_hours(roundedValue.toString());
  }
}
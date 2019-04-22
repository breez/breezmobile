import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class OverLimitFundsDialog extends StatefulWidget {
  final AccountBloc accountBloc;

  const OverLimitFundsDialog({Key key, this.accountBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OverLimitFundsDialogState();
  }
}

class OverLimitFundsDialogState extends State<OverLimitFundsDialog> {
  @override
  void initState() {
    super.initState();
    widget.accountBloc.userActionsSink.add(FetchSwapFundStatus());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
        title: new Text(
          "On-chain Transaction",
          style: theme.alertTitleStyle,
        ),
        contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
        content: StreamBuilder<AccountModel>(
            stream: widget.accountBloc.accountStream,
            builder: (ctx, snapshot) {
              var swapStatus = snapshot?.data?.swapFundsStatus;
              if (swapStatus == null) {
                return Loader();
              }

              String hoursToUnlock = swapStatus.hoursToUnlock > 1
                  ? "~${swapStatus.hoursToUnlock.toInt().toString()} hours"
                  : "in about an hour";
              List<TextSpan> redeemText = List<TextSpan>();
              if (swapStatus.hoursToUnlock > 0) {
                redeemText.add(TextSpan(
                    text:
                        "You will be able to redeem your funds in block ${swapStatus.lockHeight} ($hoursToUnlock).",
                    style: theme.dialogGrayStyle));
              } else {
                redeemText.addAll([
                  TextSpan(text: "You can ", style: theme.dialogGrayStyle),
                  TextSpan(
                      text: "get a refund ",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "/get_refund");
                        },
                      style: theme.blueLinkStyle),
                  TextSpan(text: "now.", style: theme.dialogGrayStyle),
                ]);
              }

              return RichText(
                  text: TextSpan(
                      style: theme.dialogGrayStyle,
                      text:
                          "Breez was not able to transfer the funds to your balance since the executed transaction was above the specified limit.\n",
                      children: redeemText));
            }),
        actions: [
            new SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: new Text("OK", style: theme.buttonStyle),
            )            
          ]  
      );
  }
}

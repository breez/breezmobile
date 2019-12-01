import 'dart:async';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/send_onchain.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class SendCoinsDialog extends StatelessWidget {
  final AccountBloc accountBloc;

  const SendCoinsDialog({Key key, this.accountBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: accountBloc.accountStream,
        builder: (ctx, snapshot) {
          var acc = snapshot.data;
          if (acc == null) {
            return SizedBox();
          }

          return SendOnchain(acc, acc.walletBalance, "Unexpected Funds",
              (address, fee) {
            return promptAreYouSure(
                    context,
                    null,
                    Text(
                        "Are you sure you want to remove " +
                            acc.currency.format(acc.walletBalance) +
                            " from Breez and send this amount to the address you've specified?",
                        style: Theme.of(context).dialogTheme.contentTextStyle))
                .then((sure) {
              if (!sure) {
                return Future.error("User canceled");
              }
              return _sendAndWait(context, SendCoins(fee.toInt(), address));
            });
          },
              prefixMessage:
                  "Breez found unexpected funds in its underlying  wallet. These funds cannot be used for Breez payments, so it is highly recommended you send them to an external address as soon as possible.");
        });
  }

  Future<String> _sendAndWait(BuildContext context, SendCoins action) {
    accountBloc.userActionsSink.add(action);

    AlertDialog dialog = AlertDialog(
      title: Text(
        "Removing Funds",
        style: Theme.of(context).dialogTheme.titleTextStyle,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Please wait while Breez is sending the funds to the specified address.",
            style: Theme.of(context).dialogTheme.contentTextStyle,
            textAlign: TextAlign.center,
          ),
          Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Image.asset(
                theme.customData[theme.themeId].loaderAssetPath,
                gaplessPlayback: true,
              ))
        ],
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
            onWillPop: () =>
                action.future.whenComplete(() => Future.value(null)),
            child: dialog));

    return action.future.then((_) {
      Navigator.of(context).pop();
      return "The funds were successfully sent to the address you have specified.";
    }).catchError((err) {
      Navigator.of(context).pop();
      return promptError(
              context,
              null,
              Text(err.toString(),
                  style: Theme.of(context).dialogTheme.contentTextStyle))
          .whenComplete(() {
        return Future.error(err);
      });
    });
  }
}

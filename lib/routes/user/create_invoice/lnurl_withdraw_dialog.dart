import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

import '../sync_progress_dialog.dart';

class LNURlWidthrawDialog extends StatefulWidget {
  final InvoiceBloc invoiceBloc;
  final AccountBloc accountBloc;

  const LNURlWidthrawDialog(this.invoiceBloc, this.accountBloc);

  @override
  State<StatefulWidget> createState() {
    return LNUrlWithdrawDialogState();
  }
}

class LNUrlWithdrawDialogState extends State<LNURlWidthrawDialog> {
  String _error;
  StreamSubscription<bool> _paidInvoicesSubscription;
  LNUrlBloc lnurlBloc;

  @override
  void initState() {
    super.initState();
    lnurlBloc = LNUrlBloc();
    _paidInvoicesSubscription =
        widget.invoiceBloc.paidInvoicesStream.listen((paid) {
      Navigator.pop(context);
      showFlushbar(context, message: "Payment was successfuly received!");
    });

    widget.invoiceBloc.readyInvoicesStream.first.then((bolt11) {
      return widget.accountBloc.accountStream
          .firstWhere((a) => a != null && a.syncedToChain == true)
          .then((_) {
        if (this.mounted) {
          Withdraw withdrawAction = Withdraw(bolt11);
          lnurlBloc.actionsSink.add(withdrawAction);
          return withdrawAction.future;
        }
        return null;
      });
    }).catchError((err) {
      setState(() {
        _error = err.toString();
      });
    });
  }

  @override
  void dispose() {
    _paidInvoicesSubscription.cancel();
    lnurlBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[];
    if (_error != null) {
      actions.add(FlatButton(
          child:
              Text("CLOSE", style: Theme.of(context).primaryTextTheme.button),
          onPressed: () {
            Navigator.of(context).pop();
          }));
    }
    return AlertDialog(
      title: Text("Receive Funds",
          style: Theme.of(context).dialogTheme.titleTextStyle,
          textAlign: TextAlign.center),
      content: StreamBuilder<AccountModel>(
          stream: widget.accountBloc.accountStream,
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _error != null
                    ? Text("Failed to receive funds: $_error",
                        style: Theme.of(context).dialogTheme.contentTextStyle,
                        textAlign: TextAlign.center)
                    : snapshot.hasData && snapshot.data.syncedToChain != true
                        ? SizedBox()
                        : LoadingAnimatedText(
                            'Please wait while your payment is being processed',
                            textStyle:
                                Theme.of(context).dialogTheme.contentTextStyle,
                            textAlign: TextAlign.center,
                          ),
                _error != null
                    ? SizedBox(height: 16.0)
                    : snapshot.hasData && snapshot.data.syncedToChain != true
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: SyncProgressDialog(closeOnSync: false),
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Image.asset(
                              theme.customData[theme.themeId].loaderAssetPath,
                              gaplessPlayback: true,
                            )),
                FlatButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  child: Text("CLOSE",
                      style: Theme.of(context).primaryTextTheme.button),
                )
              ],
            );
          }),
    );
  }
}

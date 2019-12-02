import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

import '../sync_progress_dialog.dart';

class LNURlWidthrawDialog extends StatefulWidget {
  final InvoiceBloc invoiceBloc;
  final LNUrlBloc lnurlBloc;
  final AccountBloc accountBloc;

  const LNURlWidthrawDialog(this.invoiceBloc, this.lnurlBloc, this.accountBloc);

  @override
  State<StatefulWidget> createState() {
    return LNUrlWithdrawDialogState();
  }
}

class LNUrlWithdrawDialogState extends State<LNURlWidthrawDialog> {
  String _error;

  @override
  void initState() {
    super.initState();
    widget.invoiceBloc.readyInvoicesStream.first.then((bolt11) {
      widget.accountBloc.accountStream
          .firstWhere((a) => a != null && a.syncedToChain == true)
          .then((_) {
        if (this.mounted) {
          Withdraw withdrawAction = Withdraw(bolt11);
          widget.lnurlBloc.actionsSink.add(withdrawAction);
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
      titlePadding: EdgeInsets.zero,
      contentPadding:
          EdgeInsets.fromLTRB(24.0, 20.0, 24.0, _error != null ? 24.0 : 0.0),
      title: Row(
        children: <Widget>[
          Container(width: 50.0),
          Expanded(
              flex: 1,
              child: Text("Receive Funds",
                  style: Theme.of(context).dialogTheme.titleTextStyle,
                  textAlign: TextAlign.center)),
          Container(
            width: 50.0,
            child: IconButton(
                iconSize: 24.0,
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close,
                    color: Theme.of(context).dialogTheme.titleTextStyle.color)),
          )
        ],
      ),
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
                    ? SizedBox()
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
                            ))
              ],
            );
          }),
    );
  }
}

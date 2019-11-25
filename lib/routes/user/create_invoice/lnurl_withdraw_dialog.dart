import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class LNURlWidthrawDialog extends StatefulWidget {
  final String lnurl;
  final InvoiceBloc invoiceBloc;
  final LNUrlBloc lnurlBloc;

  const LNURlWidthrawDialog(this.lnurl, this.invoiceBloc, this.lnurlBloc);
  
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
      Withdraw withdrawAction = Withdraw(widget.lnurl, bolt11);
      widget.lnurlBloc.actionsSink.add(withdrawAction);
      return withdrawAction.future;
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
          child: new Text("CLOSE",
              style: Theme.of(context).primaryTextTheme.button),
          onPressed: () {
            Navigator.of(context).pop();
          }));
    }
    return AlertDialog(
      title: Text(
        "Withdraw Funds",
        style: Theme.of(context).dialogTheme.titleTextStyle,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
            _error ?? "Please wait while Breez is withdrawing your funds.",
            style: Theme.of(context).dialogTheme.contentTextStyle,
            textAlign: TextAlign.center,
          ),
          _error != null
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: new Image.asset(
                    theme.customData[theme.themeId].loaderAssetPath,
                    gaplessPlayback: true,
                  ))
        ],
      ),
      actions: actions,
    );
  }
}

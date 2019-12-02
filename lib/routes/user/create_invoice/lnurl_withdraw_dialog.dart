import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class LNURlWidthrawDialog extends StatefulWidget {
  final InvoiceBloc invoiceBloc;
  final LNUrlBloc lnurlBloc;

  const LNURlWidthrawDialog(this.invoiceBloc, this.lnurlBloc);

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
      Withdraw withdrawAction = Withdraw(bolt11);
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
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _error != null
              ? Text("Failed to receive funds: $_error",
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                  textAlign: TextAlign.center)
              : LoadingAnimatedText(
                  'Please wait while your payment is being processed',
                  textStyle: Theme.of(context).dialogTheme.contentTextStyle,
                  textAlign: TextAlign.center,
                ),
          _error != null
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Image.asset(
                    theme.customData[theme.themeId].loaderAssetPath,
                    gaplessPlayback: true,
                  ))
        ],
      ),
    );
  }
}

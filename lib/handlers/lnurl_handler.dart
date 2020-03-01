import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_model.dart';
import 'package:breez/routes/sync_progress_dialog.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

import '../routes/create_invoice/create_invoice_page.dart';

class LNURLHandler {
  final BuildContext _context;
  final LNUrlBloc lnurlBloc;

  LNURLHandler(this._context, this.lnurlBloc) {
    lnurlBloc.lnurlStream.listen((response) async {
      if (response.runtimeType == ChannelFetchResponse) {
        _openLNURLChannel(response);
      }
      if (response.runtimeType == WithdrawFetchResponse) {
        Navigator.of(_context).push(FadeInRoute(
          builder: (_) => CreateInvoicePage(lnurlWithdraw: response),
        ));
      }
    }).onError((err) async {
      promptError(
          this._context,
          "Link Error",
          Text("Failed to process link: " + err.toString(),
              style: Theme.of(this._context).dialogTheme.contentTextStyle));
    });
  }

  void _openLNURLChannel(ChannelFetchResponse response) {
    var host = Uri.parse(response.callback).host;
    promptAreYouSure(this._context, "Open Channel",
            Text("Are you sure you want to open a channel with $host?"))
        .then((value) async {
      if (value) {
        var synced = await showDialog(
            context: this._context,
            useRootNavigator: false,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: SyncProgressDialog(closeOnSync: true),
                actions: <Widget>[
                  FlatButton(
                    child: Text("CANCEL",
                        style: Theme.of(context).primaryTextTheme.button),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              );
            });
        if (synced == true) {
          var loaderRoute = createLoaderRoute(this._context);
          Navigator.of(this._context).push(loaderRoute);
          var action =
              OpenChannel(response.uri, response.callback, response.k1);
          this.lnurlBloc.actionsSink.add(action);
          action.future.catchError((err) {
            promptError(this._context, "Open Channel Error",
                Text("Failed to open channel.\n" + err.toString()));
          }).whenComplete(
              () => Navigator.of(this._context).removeRoute(loaderRoute));
        }
      }
    });
  }
}

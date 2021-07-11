import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_model.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/routes/sync_progress_dialog.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

import '../routes/lnurl_fetch_invoice_page.dart';
import '../routes/create_invoice/create_invoice_page.dart';

class LNURLHandler {
  final BuildContext _context;
  final LNUrlBloc lnurlBloc;
  ModalRoute _loaderRoute;

  LNURLHandler(this._context, this.lnurlBloc) {
    lnurlBloc.listenLNUrl().listen((response) {
      if (response.runtimeType == fetchLNUrlState) {
        _setLoading(response == fetchLNUrlState.started);
      } else {
        return executeLNURLResponse(this._context, this.lnurlBloc, response);
      }
    }).onError((err) async {
      var errorMessage = _getErrorMessage(err.toString());
      promptError(
          this._context,
          "Link Error",
          Text("Failed to process link: " + errorMessage,
              style: Theme.of(this._context).dialogTheme.contentTextStyle));
    });
  }

  String _getErrorMessage(String error) {
    switch (error) {
      case "GIFT_SPENT":
        return "This gift has been redeemed!";
      default:
        return error;
    }
  }

  void executeLNURLResponse(
      BuildContext context, LNUrlBloc lnurlBloc, dynamic response) {
    if (response.runtimeType == ChannelFetchResponse) {
      _openLNURLChannel(context, lnurlBloc, response);
    } else if (response.runtimeType == WithdrawFetchResponse) {
      Navigator.popUntil(context, (route) {
        return route.settings.name == "/";
      });

      Navigator.of(context).push(FadeInRoute(
        builder: (_) =>
            withBreezTheme(context, CreateInvoicePage(lnurlWithdraw: response)),
      ));
    } else if (response is AuthFetchResponse) {
      Navigator.popUntil(context, (route) {
        return route.settings.name == "/";
      });
      promptAreYouSure(
          context,
          null,
          RichText(
              text: TextSpan(
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                  text: "Do you want to anonymously login to ",
                  children: <TextSpan>[
                TextSpan(
                    text: "${response.host}",
                    style: Theme.of(context)
                        .dialogTheme
                        .contentTextStyle
                        .copyWith(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: "?",
                    style: Theme.of(context).dialogTheme.contentTextStyle)
              ]))).then((value) {
        if (value == true) {
          var loaderRoute = createLoaderRoute(context);
          Navigator.of(context).push(loaderRoute);
          var action = Login(response);
          lnurlBloc.actionsSink.add(action);
          action.future.catchError((err) {
            promptError(context, "Login Error",
                Text("Failed to log in.\n" + err.toString()));
          }).whenComplete(() => Navigator.of(context).removeRoute(loaderRoute));
        }
      });
    } else if (response is PayFetchResponse) {
      Navigator.popUntil(context, (route) {
        return route.settings.name == "/";
      });

      Navigator.of(context).push(FadeInRoute(
        builder: (_) => LNURLFetchInvoicePage(response),
      ));
    } else {
      throw "Unsupported LNURL";
    }
  }

  void _openLNURLChannel(BuildContext context, LNUrlBloc lnurlBloc,
      ChannelFetchResponse response) {
    var host = Uri.parse(response.callback).host;
    promptAreYouSure(context, "Open Channel",
            Text("Are you sure you want to open a channel with $host?"))
        .then((value) async {
      if (value) {
        var synced = await showDialog(
            context: context,
            useRootNavigator: false,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: SyncProgressDialog(closeOnSync: true),
                actions: <Widget>[
                  TextButton(
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
          var loaderRoute = createLoaderRoute(context);
          Navigator.of(context).push(loaderRoute);
          var action =
              OpenChannel(response.uri, response.callback, response.k1);
          lnurlBloc.actionsSink.add(action);
          action.future.catchError((err) {
            promptError(context, "Open Channel Error",
                Text("Failed to open channel.\n" + err.toString()));
          }).whenComplete(() => Navigator.of(context).removeRoute(loaderRoute));
        }
      }
    });
  }

  _setLoading(bool visible) {
    if (visible && _loaderRoute == null) {
      _loaderRoute = createLoaderRoute(_context);
      Navigator.of(_context).push(_loaderRoute);
      return;
    }

    if (!visible && _loaderRoute != null) {
      Navigator.removeRoute(_context, _loaderRoute);
      _loaderRoute = null;
    }
  }
}

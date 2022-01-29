import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_model.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/routes/sync_progress_dialog.dart';
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

import '../routes/create_invoice/create_invoice_page.dart';
import '../routes/lnurl_fetch_invoice_page.dart';

class LNURLHandler {
  final BuildContext _context;
  final LNUrlBloc lnurlBloc;
  ModalRoute _loaderRoute;

  LNURLHandler(this._context, this.lnurlBloc) {
    lnurlBloc.listenLNUrl().listen((response) {
      if (response.runtimeType == fetchLNUrlState) {
        _setLoading(response == fetchLNUrlState.started);
      } else {
        return executeLNURLResponse(_context, lnurlBloc, response);
      }
    }).onError((err) async {
      var l10n = _context.l10n;

      final errorMessage = _getErrorMessage(err.toString());
      promptError(
        this._context,
        l10n.handler_lnurl_error_link,
        Text(
          l10n.handler_lnurl_error_process(errorMessage),
          style: _context.dialogTheme.contentTextStyle,
        ),
      );
    });
  }

  String _getErrorMessage(String error) {
    switch (error) {
      case "GIFT_SPENT":
        return _context.l10n.handler_lnurl_error_gift;
      default:
        return error;
    }
  }

  void executeLNURLResponse(
    BuildContext context,
    LNUrlBloc lnurlBloc,
    dynamic response,
  ) {
    var l10n = _context.l10n;
    TextStyle dialogContentTextStyle = _context.dialogTheme.contentTextStyle;

    if (response.runtimeType == ChannelFetchResponse) {
      _openLNURLChannel(context, lnurlBloc, response);
    } else if (response.runtimeType == WithdrawFetchResponse) {
      context.popUntil((route) {
        return route.settings.name == "/";
      });

      context.push(FadeInRoute(
        builder: (_) => withBreezTheme(
          context,
          CreateInvoicePage(lnurlWithdraw: response),
        ),
      ));
    } else if (response is AuthFetchResponse) {
      context.popUntil((route) {
        return route.settings.name == "/";
      });
      promptAreYouSure(
        context,
        null,
        RichText(
          text: TextSpan(
            style: dialogContentTextStyle,
            text: l10n.handler_lnurl_login_anonymously,
            children: [
              TextSpan(
                text: "${response.host}",
                style: dialogContentTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "?",
                style: dialogContentTextStyle,
              ),
            ],
          ),
        ),
      ).then((value) {
        if (value == true) {
          var loaderRoute = createLoaderRoute(context);
          context.push(loaderRoute);
          var action = Login(response);
          lnurlBloc.actionsSink.add(action);
          action.future.catchError((err) {
            promptError(
              context,
              l10n.handler_lnurl_login_error_title,
              Text(
                l10n.handler_lnurl_login_error_message(err.toString()),
              ),
            );
          }).whenComplete(() => context.navigator.removeRoute(loaderRoute));
        }
      });
    } else if (response is PayFetchResponse) {
      context.popUntil((route) {
        return route.settings.name == "/";
      });

      context.push(FadeInRoute(
        builder: (_) => withBreezTheme(
          context,
          LNURLFetchInvoicePage(response),
        ),
      ));
    } else {
      throw l10n.handler_lnurl_login_error_unsupported;
    }
  }

  void _openLNURLChannel(
    BuildContext context,
    LNUrlBloc lnurlBloc,
    ChannelFetchResponse response,
  ) {
    var l10n = _context.l10n;

    promptAreYouSure(
      context,
      l10n.handler_lnurl_open_channel_title,
      Text(l10n.handler_lnurl_open_channel_message(
        Uri.parse(response.callback).host,
      )),
    ).then((value) async {
      if (value) {
        var synced = await showDialog(
          context: context,
          useRootNavigator: false,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SyncProgressDialog(closeOnSync: true),
              actions: [
                TextButton(
                  child: Text(
                    l10n.handler_lnurl_open_channel_action_cancel,
                    style: context.primaryTextTheme.button,
                  ),
                  onPressed: () => context.pop(false),
                ),
              ],
            );
          },
        );
        if (synced == true) {
          var loaderRoute = createLoaderRoute(context);
          context.push(loaderRoute);
          var action = OpenChannel(
            response.uri,
            response.callback,
            response.k1,
          );
          lnurlBloc.actionsSink.add(action);
          action.future.catchError((err) {
            promptError(
              context,
              l10n.handler_lnurl_open_channel_error_title,
              Text(
                l10n.handler_lnurl_open_channel_error_message(
                  err.toString(),
                ),
              ),
            );
          }).whenComplete(() => context.navigator.removeRoute(loaderRoute));
        }
      }
    });
  }

  _setLoading(bool visible) {
    NavigatorState navigator = _context.navigator;
    if (visible && _loaderRoute == null) {
      _loaderRoute = createLoaderRoute(_context);
      navigator.push(_loaderRoute);
      return;
    }

    if (!visible && _loaderRoute != null) {
      navigator.removeRoute(_loaderRoute);
      _loaderRoute = null;
    }
  }
}

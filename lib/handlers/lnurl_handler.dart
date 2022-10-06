import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_model.dart';
import 'package:breez/routes/create_invoice/create_invoice_page.dart';
import 'package:breez/routes/lnurl_fetch_invoice_page.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/routes/sync_progress_dialog.dart';
import 'package:breez/utils/exceptions.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LNURLHandler {
  final LNUrlBloc lnurlBloc;
  ModalRoute _loaderRoute;

  LNURLHandler(BuildContext context, this.lnurlBloc) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    lnurlBloc.listenLNUrl().listen((response) {
      if (response.runtimeType == fetchLNUrlState) {
        _setLoading(context, response == fetchLNUrlState.started);
      } else {
        return executeLNURLResponse(context, lnurlBloc, response);
      }
    }).onError((err) async {
      final errorMessage = _getErrorMessage(texts, err);
      promptError(
        context,
        texts.handler_lnurl_error_link,
        Text(
          texts.handler_lnurl_error_process(errorMessage),
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
    });
  }

  String _getErrorMessage(AppLocalizations texts, Object error) {
    switch (error.toString()) {
      case "GIFT_SPENT":
        return texts.handler_lnurl_error_gift;
      default:
        return extractExceptionMessage(error);
    }
  }

  void executeLNURLResponse(
    BuildContext context,
    LNUrlBloc lnurlBloc,
    dynamic response,
  ) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final navigator = Navigator.of(context);

    if (response.runtimeType == ChannelFetchResponse) {
      _openLNURLChannel(context, lnurlBloc, response);
    } else if (response.runtimeType == WithdrawFetchResponse) {
      Navigator.popUntil(context, (route) {
        return route.settings.name == "/";
      });

      navigator.push(FadeInRoute(
        builder: (_) => withBreezTheme(
          context,
          CreateInvoicePage(lnurlWithdraw: response),
        ),
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
            style: themeData.dialogTheme.contentTextStyle,
            text: texts.handler_lnurl_login_anonymously,
            children: [
              TextSpan(
                text: "${response.host}",
                style: themeData.dialogTheme.contentTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "?",
                style: themeData.dialogTheme.contentTextStyle,
              ),
            ],
          ),
        ),
      ).then((value) {
        if (value == true) {
          var loaderRoute = createLoaderRoute(context);
          navigator.push(loaderRoute);
          var action = Login(response);
          lnurlBloc.actionsSink.add(action);
          action.future.catchError((err) {
            promptError(
              context,
              texts.handler_lnurl_login_error_title,
              Text(
                texts.handler_lnurl_login_error_message(err.toString()),
              ),
            );
          }).whenComplete(() => navigator.removeRoute(loaderRoute));
        }
      });
    } else if (response is PayFetchResponse) {
      Navigator.popUntil(context, (route) {
        return route.settings.name == "/";
      });

      navigator.push(FadeInRoute(
        builder: (_) => withBreezTheme(
          context,
          LNURLFetchInvoicePage(response),
        ),
      ));
    } else {
      throw texts.handler_lnurl_login_error_unsupported;
    }
  }

  void _openLNURLChannel(
    BuildContext context,
    LNUrlBloc lnurlBloc,
    ChannelFetchResponse response,
  ) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final navigator = Navigator.of(context);

    promptAreYouSure(
      context,
      texts.handler_lnurl_open_channel_title,
      Text(texts.handler_lnurl_open_channel_message(
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
                    texts.handler_lnurl_open_channel_action_cancel,
                    style: themeData.primaryTextTheme.button,
                  ),
                  onPressed: () => navigator.pop(false),
                ),
              ],
            );
          },
        );
        if (synced == true) {
          var loaderRoute = createLoaderRoute(context);
          navigator.push(loaderRoute);
          var action = OpenChannel(
            response.uri,
            response.callback,
            response.k1,
          );
          lnurlBloc.actionsSink.add(action);
          action.future.catchError((err) {
            promptError(
              context,
              texts.handler_lnurl_open_channel_error_title,
              Text(
                texts.handler_lnurl_open_channel_error_message(
                  err.toString(),
                ),
              ),
            );
          }).whenComplete(() => navigator.removeRoute(loaderRoute));
        }
      }
    });
  }

  _setLoading(BuildContext context, bool visible) {
    if (visible && _loaderRoute == null) {
      _loaderRoute = createLoaderRoute(context);
      Navigator.of(context).push(_loaderRoute);
      return;
    }

    if (!visible && _loaderRoute != null) {
      Navigator.removeRoute(context, _loaderRoute);
      _loaderRoute = null;
    }
  }
}

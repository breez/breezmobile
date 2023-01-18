import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/widgets/sync_loader.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class SyncUIHandler {
  final AccountBloc _accountBloc;
  final BuildContext _context;
  ModalRoute _syncUIRoute;

  SyncUIHandler(
    this._accountBloc,
    this._context,
  ) {
    _accountBloc.accountStream.listen((acc) {
      showSyncUI(acc);
    });
  }

  void showSyncUI(AccountModel acc) {
    final navigator = Navigator.of(_context);
    if (acc.syncUIState == SyncUIState.BLOCKING) {
      if (_syncUIRoute == null) {
        _syncUIRoute = _createSyncRoute(_context, _accountBloc);
        navigator.push(_syncUIRoute);
      }
    } else {
      if (_syncUIRoute != null) {
        // If we are not on top of the stack let's pop to get the animation
        if (_syncUIRoute.isCurrent) {
          navigator.pop();
        } else {
          // If we are hidden, just remove the route.
          navigator.removeRoute(_syncUIRoute);
        }
        _syncUIRoute = null;
      }
    }
  }
}

ModalRoute _createSyncRoute(BuildContext context, AccountBloc accBloc) {
  final texts = context.texts();
  return SyncUIRoute((context) {
    return StreamBuilder<AccountModel>(
      stream: accBloc.accountStream,
      builder: (ctx, snapshot) {
        var account = snapshot.data;
        double progress = account?.syncProgress ?? 0;
        return withBreezTheme(context, TransparentRouteLoader(
            message: texts.handler_sync_ui_message,
            value: progress,
            opacity: 0.9,
            onClose: () => accBloc.userActionsSink.add(
              ChangeSyncUIState(SyncUIState.COLLAPSED),
            ),
          ),
        );
      },
    );
  });
}

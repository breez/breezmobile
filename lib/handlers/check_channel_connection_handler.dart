import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

final _log = Logger("CheckChannelConnection");

class CheckChannelConnection {
  static final _instance = CheckChannelConnection._internal();

  factory CheckChannelConnection() => _instance;

  CheckChannelConnection._internal();

  Timer _notReadyTimer;
  Flushbar _flushbar;
  StreamSubscription<bool> _subscription;

  void startListen(
    BuildContext context,
    AccountBloc accountBloc,
  ) {
    startSubscription(accountBloc, context);
    ServiceInjector().device.eventStream.distinct().listen((event) {
      switch (event) {
        case NotificationType.RESUME:
          cancelSubscription();
          startSubscription(accountBloc, context);
          break;
        case NotificationType.PAUSE:
          cancelSubscription();
          break;
      }
    });
  }

  void startSubscription(AccountBloc accountBloc, BuildContext context) {
    _subscription = accountBloc.accountStream
        .map((acc) =>
            !(acc.connected && !acc.readyForPayments) ||
            acc.nodeUpgrading == true)
        .distinct()
        .listen((ready) {
      if (ready) {
        _readyForPayments();
        _notReadyTimer?.cancel();
      } else {
        _notReadyTimer = Timer(const Duration(seconds: 30), () {
          _notReadyForPayments(context);
        });
      }
    });
  }

  void cancelSubscription() {
    _flushbar?.dismiss();
    _flushbar = null;
    _subscription?.cancel();
    _subscription = null;
    _notReadyTimer?.cancel();
    _notReadyTimer = null;
  }

  void _readyForPayments() {
    _log.info("Account is ready for payments");
    _flushbar?.dismiss();
    _flushbar = null;
  }

  void _notReadyForPayments(BuildContext context) {
    _log.info("Account is not ready for payments, Breez is offline");
    if (_flushbar != null) {
      return;
    }
    final texts = context.texts();
    _flushbar = showFlushbar(
      context,
      buttonText: texts.handler_channel_connection_close,
      onDismiss: () {
        _flushbar = null;
        return true;
      },
      position: FlushbarPosition.TOP,
      duration: Duration.zero,
      messageWidget: Text(
        texts.handler_channel_connection_message,
        style: theme.snackBarStyle,
        textAlign: TextAlign.start,
      ),
    );
  }
}

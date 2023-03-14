import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/bloc/connect_pay/payer_session.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

import 'payee_session_widget.dart';
import 'payer_session_widget.dart';

class ConnectToPayPage extends StatefulWidget {
  final RemoteSession _currentSession;

  const ConnectToPayPage(
    this._currentSession,
  );

  @override
  State<StatefulWidget> createState() {
    return ConnectToPayPageState(_currentSession);
  }
}

class ConnectToPayPageState extends State<ConnectToPayPage> {
  final _key = GlobalKey<ScaffoldState>();
  bool _payer;
  String _remoteUserName;
  String _title = "";
  StreamSubscription _errorsSubscription;
  StreamSubscription _remotePartyErrorSubscription;
  StreamSubscription _endOfSessionSubscription;
  RemoteSession _currentSession;
  Object _error;
  bool _destroySessionOnTerminate = true;
  bool _isInit = false;

  ConnectToPayPageState(
    this._currentSession,
  );

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final texts = context.texts();
      final ctpBloc = AppBlocsProvider.of<ConnectPayBloc>(context);

      try {
        if (_currentSession == null) {
          _currentSession = ctpBloc.createPayerRemoteSession();
          ctpBloc.startSession(_currentSession);
        }
        _payer = _currentSession.runtimeType == PayerRemoteSession;
        _title = _payer
            ? texts.connect_to_pay_title_payer
            : texts.connect_to_pay_title_payee;
        registerErrorsListener();
        registerEndOfSessionListener(context);
        _isInit = true;
      } catch (error) {
        _error = error;
      }
    }
    super.didChangeDependencies();
  }

  void registerErrorsListener() async {
    _errorsSubscription = _currentSession.sessionErrors.listen((error) {
      _popWithMessage(error.description);
    });

    _remotePartyErrorSubscription =
        _currentSession.paymentSessionStateStream.listen((s) {
      final error = !_payer ? s.payerData?.error : s.payeeData?.error;
      if (error != null) {
        _popWithMessage(error);
      }
    });
  }

  void registerEndOfSessionListener(BuildContext context) async {
    final texts = context.texts();
    _endOfSessionSubscription =
        _currentSession.paymentSessionStateStream.listen(
      (session) {
        _remoteUserName ??= _payer
              ? session.payeeData?.userName
              : session.payerData?.userName;

        if (session.remotePartyCancelled) {
          _popWithMessage(
            _remoteUserName != null
                ? texts.connect_to_pay_canceled_remote_user(_remoteUserName)
                : _payer
                    ? texts.connect_to_pay_canceled_payee
                    : texts.connect_to_pay_canceled_payer,
          );
          return;
        }

        if (session.paymentFulfilled) {
          final formattedAmount = _currentSession.currentUser.currency
              .format(Int64(session.settledAmount));
          _popWithMessage(
            _payer
                ? texts.connect_to_pay_success_payer(
                    _remoteUserName,
                    formattedAmount,
                  )
                : texts.connect_to_pay_success_payee(
                    _remoteUserName,
                    formattedAmount,
                  ),
            destroySession: _payer,
          );
        }
      },
      onDone: () => _popWithMessage(
        null,
        destroySession: false,
      ),
    );
  }

  void _popWithMessage(message, {destroySession = true}) {
    _destroySessionOnTerminate = destroySession;
    Navigator.pop(_key.currentContext);
    if (message != null) {
      showFlushbar(
        _key.currentContext,
        message: message,
      );
    }
  }

  Future _clearSession() async {
    _remoteUserName = null;
    await _endOfSessionSubscription.cancel();
    await _errorsSubscription.cancel();
    await _remotePartyErrorSubscription.cancel();
  }

  @override
  void dispose() {
    if (_currentSession != null) {
      _currentSession.terminate(
        permanent: _destroySessionOnTerminate,
      );
      _clearSession();
    }
    super.dispose();
  }

  void _onTerminateSession(BuildContext context) async {
    final texts = context.texts();
    final themeData = Theme.of(context);

    bool cancel = await promptAreYouSure(
      _key.currentContext,
      null,
      Text(
        texts.connect_to_pay_exit_warning,
        style: themeData.dialogTheme.contentTextStyle,
      ),
      textStyle: themeData.dialogTheme.contentTextStyle,
    );
    if (cancel) {
      _popWithMessage(null);
    }
  }

  void _onBackPressed() async {
    _popWithMessage(
      null,
      destroySession: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: backBtn.BackButton(onPressed: _onBackPressed),
        title: Text(_title),
        actions: _error == null
            ? [
                IconButton(
                  onPressed: () => _onTerminateSession(context),
                  icon: Icon(
                    Icons.close,
                    color: themeData.iconTheme.color,
                  ),
                ),
              ]
            : null,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (_error != null) {
      return SessionErrorWidget(_error);
    }

    if (_currentSession == null) {
      return const Center(child: Loader());
    }

    if (_currentSession == null) {
      return Container();
    }

    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    var lspBloc = AppBlocsProvider.of<LSPBloc>(context);

    return StreamBuilder<PaymentSessionState>(
      stream: _currentSession.paymentSessionStateStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const Center(child: Loader());
        }

        return StreamBuilder<LSPStatus>(
          stream: lspBloc.lspStatusStream,
          builder: (context, lspSnapshot) {
            return StreamBuilder(
              stream: accountBloc.accountStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Loader());
                }
                if (_currentSession.runtimeType == PayerRemoteSession) {
                  return PayerSessionWidget(
                    _currentSession,
                    snapshot.data,
                  );
                } else {
                  return PayeeSessionWidget(
                    _currentSession,
                    snapshot.data,
                    lspSnapshot.data,
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}

class SessionErrorWidget extends StatelessWidget {
  final Object _error;

  const SessionErrorWidget(this._error);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        heightFactor: 0.0,
        child: Text(
          texts.connect_to_pay_failed_to_connect(_error.toString()),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

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
import 'package:breez/utils/i18n.dart';

import 'payee_session_widget.dart';
import 'payer_session_widget.dart';

class ConnectToPayPage extends StatefulWidget {
  final RemoteSession _currentSession;

  const ConnectToPayPage(this._currentSession);

  @override
  State<StatefulWidget> createState() {
    return ConnectToPayPageState(_currentSession);
  }
}

class ConnectToPayPageState extends State<ConnectToPayPage> {
  bool _payer;
  String _remoteUserName;
  String _title = "";
  StreamSubscription _errorsSubscription;
  StreamSubscription _remotePartyErrorSubscription;
  StreamSubscription _endOfSessionSubscription;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  RemoteSession _currentSession;
  Object _error;
  bool _destroySessionOnTerminate = true;
  bool _isInit = false;

  ConnectToPayPageState(this._currentSession);

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      ConnectPayBloc ctpBloc = AppBlocsProvider.of<ConnectPayBloc>(context);
      try {
        if (_currentSession == null) {
          _currentSession = ctpBloc.createPayerRemoteSession();
          ctpBloc.startSession(_currentSession);
        }
        _payer = _currentSession.runtimeType == PayerRemoteSession;
        _title = _payer
            ? t(context, "connect_to_pay")
            : t(context, "receive_payment");
        registerErrorsListener();
        registerEndOfSessionListener();
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
      var error = !_payer ? s.payerData?.error : s.payeeData?.error;
      if (error != null) {
        _popWithMessage(error);
      }
    });
  }

  void registerEndOfSessionListener() async {
    _endOfSessionSubscription =
        _currentSession.paymentSessionStateStream.listen((s) {
      if (_remoteUserName == null) {
        _remoteUserName =
            (_payer ? s.payeeData?.userName : s.payerData?.userName);
      }

      if (s.remotePartyCancelled) {
        _popWithMessage(
            '${_remoteUserName ?? (_payer ? "Payee" : "Payer")} has cancelled the payment session');
        return;
      }

      if (s.paymentFulfilled) {
        String formattedAmount =
            _currentSession.currentUser.currency.format(Int64(s.settledAmount));
        String successMessage = _payer
            ? 'You have successfully paid $_remoteUserName $formattedAmount!'
            : '$_remoteUserName have successfully paid you $formattedAmount!';
        _popWithMessage(successMessage, destroySession: _payer);
      }
    }, onDone: () => _popWithMessage(null, destroySession: false));
  }

  void _popWithMessage(message, {destroySession = true}) {
    _destroySessionOnTerminate = destroySession;
    Navigator.pop(_key.currentContext);
    if (message != null) {
      showFlushbar(_key.currentContext, message: message);
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
      _currentSession.terminate(permanent: _destroySessionOnTerminate);
      _clearSession();
    }
    super.dispose();
  }

  void _onTerminateSession() async {
    String exitSessionMessage =
        'Are you sure you want to cancel this payment session?';
    bool cancel = await promptAreYouSure(
        _key.currentContext,
        null,
        Text(exitSessionMessage,
            style: Theme.of(context).dialogTheme.contentTextStyle),
        textStyle: Theme.of(context).dialogTheme.contentTextStyle);
    if (cancel) {
      _popWithMessage(null);
    }
  }

  void _onBackPressed() async {
    _popWithMessage(null, destroySession: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          actions: _error == null
              ? <Widget>[
                  IconButton(
                      onPressed: () => _onTerminateSession(),
                      icon: Icon(Icons.close,
                          color: Theme.of(context).iconTheme.color))
                ]
              : null,
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          leading: backBtn.BackButton(onPressed: _onBackPressed),
          title: Text(
            _title,
            style: Theme.of(context).appBarTheme.textTheme.headline6,
          ),
          elevation: 0.0,
        ),
        body: buildBody());
  }

  Widget buildBody() {
    if (_error != null) {
      return SessionErrorWidget(_error);
    }

    if (_currentSession == null) {
      return Center(child: Loader());
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
          return Center(child: Loader());
        }

        return StreamBuilder<LSPStatus>(
            stream: lspBloc.lspStatusStream,
            builder: (context, lspSnapshot) {
              return StreamBuilder(
                  stream: accountBloc.accountStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Loader());
                    }
                    if (_currentSession.runtimeType == PayerRemoteSession) {
                      return PayerSessionWidget(_currentSession, snapshot.data);
                    } else {
                      return PayeeSessionWidget(
                          _currentSession, snapshot.data, lspSnapshot.data);
                    }
                  });
            });
      },
    );
  }
}

class SessionErrorWidget extends StatelessWidget {
  final Object _error;

  const SessionErrorWidget(this._error);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
          heightFactor: 0.0,
          child: Text(
            "Failed connecting to session: ${_error.toString()}",
            textAlign: TextAlign.center,
          )),
    );
  }
}

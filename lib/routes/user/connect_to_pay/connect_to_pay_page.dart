import 'dart:async';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/bloc/connect_pay/payer_session.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/user/connect_to_pay/payee_session_widget.dart';
import 'package:breez/routes/user/connect_to_pay/payer_session_widget.dart';
import 'package:breez/routes/user/connect_to_pay/session_instructions.dart';
import 'package:breez/services/deep_links.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

/*
ConnectToPayPage shows the UI for handling a remote payment session between payee and payer.
It is reused for both sides by implementing the shared UI and creating the specific widget for the specific UI of each peer.
*/
class ConnectToPayPage extends StatelessWidget {
  final RemoteSession _currentSession;

  const ConnectToPayPage(this._currentSession);

  @override
  Widget build(BuildContext context) {
    return new BlocConnector<AppBlocs>((context, blocs) => new _ConnectToPayPage(blocs.connectPayBloc, blocs.accountBloc, this._currentSession));
  }
}

class _ConnectToPayPage extends StatefulWidget {
  final ConnectPayBloc _connectPayBloc;
  final AccountBloc _accountBloc;
  final RemoteSession _currentSession;

  const _ConnectToPayPage(this._connectPayBloc, this._accountBloc, this._currentSession);

  @override
  State<StatefulWidget> createState() {
    return new _ConnectToPayState();
  }
}

class _ConnectToPayState extends State<_ConnectToPayPage> {
  bool _warnAreYouSure = false;  
  bool _payer;
  String _remoteUserName;
  String _title = "";
  StreamSubscription _errorsSubscription;
  StreamSubscription cancelSessionSubscription;
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  RemoteSession get _currentSession => widget._currentSession;

  @override
  void initState() {
    super.initState();
    _initSession();
  }

  _initSession() async {
    _payer = _currentSession.runtimeType == PayerRemoteSession;
    _title = _payer ? "Connect To Pay" : "Receive Payment";    
    _errorsSubscription = _currentSession.sessionErrors.listen((error) {      
      _popWithMessage(error.description);
    });

    cancelSessionSubscription = _currentSession.paymentSessionStateStream.listen((s) {
      if (_remoteUserName == null) {
        _remoteUserName = (_payer ? s.payeeData?.userName : s.payerData?.userName);
      }
      if (s.invitationSent) {
        _warnAreYouSure = true;
      }
      var error = !_payer ? s.payerData?.error : s.payeeData?.error;
      if (error != null) {
        _popWithMessage(error);
      } else if (s.paymentFulfilled) {
        String formattedAmount = _currentSession.currentUser.currency.format(Int64(s.settledAmount));
        String successMessage =
            _payer ? 'You have successfully paid $_remoteUserName $formattedAmount!' : '$_remoteUserName have successfully paid you $formattedAmount!';
        _popWithMessage(successMessage);
      }
    });
    cancelSessionSubscription.onDone(() {           
      _popWithMessage(null);
    });  
  }

  void _popWithMessage(message) {
    _warnAreYouSure = false;       
    Navigator.pop(_key.currentContext);
    if (message != null) {
      showFlushbar(_key.currentContext, message: message);
    }
  }

  void _resetSession(){
    _clearSession().then((_) {
      setState((){
        _initSession();
      });       
    });  
  }

  Future _clearSession() async {
    _remoteUserName = null;    
    _warnAreYouSure = false;
    await cancelSessionSubscription.cancel();
    await _errorsSubscription.cancel();
  }

  @override
  void dispose() {
    _currentSession.terminate();    
    _clearSession();    
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_warnAreYouSure) {
      return true;
    }

    TextStyle textStyle = TextStyle(color: Colors.black);
    String exitSessionMessage = 'Are you sure you want to cancel this payment session?';    
    bool result = await promtAreYouSure(_key.currentContext, null, Text(exitSessionMessage, style: textStyle),
        textStyle: textStyle);
    return result;
  }

  void _onBackPressed() async {
    bool shouldPop = await _onWillPop();
    if (shouldPop) {
      Navigator.pop(_key.currentContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _key,
        appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
          leading: backBtn.BackButton(onPressed: _onBackPressed),
          title: new Text(
            _title,
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0,
        ),
        body: WillPopScope(
            onWillPop: _onWillPop,
            child: StreamBuilder<PaymentSessionState>(
              stream: _currentSession.paymentSessionStateStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(child: Loader());
                }

                return StreamBuilder(
                    stream: widget._accountBloc.accountStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Loader());
                      }
                      if (_currentSession.runtimeType == PayerRemoteSession) {
                        return PayerSessionWidget(_currentSession, snapshot.data, _resetSession);
                      } else {
                        return PayeeSessionWidget(_currentSession, snapshot.data);
                      }
                    });
              },
            )));
  }
}

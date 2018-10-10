import 'dart:async';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/bloc/connect_pay/payee_session.dart';
import 'package:breez/bloc/connect_pay/payer_session.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';

/*
Bloc that responsible for creating online payments session.
The handling of the session itself is not done here but within the concrete session implementation.
*/
class ConnectPayBloc {
  RemoteSession _currentSession;
  final StreamController _sessionInvitesController = new BehaviorSubject<String>();
  Stream<String> get sessionInvites => _sessionInvitesController.stream;
  BreezUserModel _currentUser;

  ConnectPayBloc(Stream<BreezUserModel> userStream) {
    userStream.listen((user) => _currentUser = user);
    _monitorSessionInvites();
  }

  PayerRemoteSession startSessionAsPayer() {
    terminateCurrentSession();
    _currentSession = new PayerRemoteSession(_currentUser);
    return _currentSession as PayerRemoteSession;
  }

  PayeeRemoteSession joinSessionAsPayee(String sessionSecret) {
    terminateCurrentSession();
    _currentSession = new PayeeRemoteSession(_currentUser, sessionSecret);
    return _currentSession as PayeeRemoteSession;
  }

  Future terminateCurrentSession() {
    Future res = Future.value(null);
    if (_currentSession != null) {
      res = _currentSession.terminate();
      _currentSession = null;      
    }
    return res;
  }

  _monitorSessionInvites() {
    DeepLinksService deepLinks = ServiceInjector().deepLinks;
    deepLinks.linksNotifications.listen((link) {      
      String sessionSecret = deepLinks.extractSessionSecretFromLink(link);
      if (sessionSecret != null) {        
        _sessionInvitesController.add(sessionSecret);
      }
    });
  }
}

abstract class RemoteSession {
  BreezUserModel _currentUser;
  
  RemoteSession(this._currentUser);

  BreezUserModel get currentUser => _currentUser;
  Stream<PaymentSessionState> get paymentSessionStateStream;
  Stream<PaymentSessionError> get sessionErrors;
  Future terminate();
}

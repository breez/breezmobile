import 'dart:async';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/bloc/connect_pay/payee_session.dart';
import 'package:breez/bloc/connect_pay/payer_session.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';

/*
Bloc that responsible for creating online payments session.
The handling of the session itself is not done here but within the concrete session implementation.
*/
class ConnectPayBloc {
  BreezBridge _breezLib = ServiceInjector().breezBridge;
  RemoteSession _currentSession;
  final StreamController _sessionInvitesController = new BehaviorSubject<SessionLinkModel>();
  Stream<SessionLinkModel> get sessionInvites => _sessionInvitesController.stream;
  BreezUserModel _currentUser;  

  ConnectPayBloc(Stream<BreezUserModel> userStream) {
    userStream.listen((user) => _currentUser = user);
    _monitorSessionInvites();
  }

  Future<PayerRemoteSession> startSessionAsPayer() async {
    await terminateCurrentSession();
    CreateRatchetSessionReply session = await _breezLib.createRatchetSession(); 
    SessionLinkModel payerLink = new SessionLinkModel(session.sessionID, session.secret, session.pubKey);
    _currentSession = new PayerRemoteSession(_currentUser, payerLink)..start();
    return _currentSession as PayerRemoteSession;
  }

  Future<RemoteSession> joinSessionByLink(SessionLinkModel sessionLink) async{
    await terminateCurrentSession();

    //check if we have already a session
    String sessionID;    
    RatchetSessionInfoReply sessionInfo = await _breezLib.ratchetSessionInfo(sessionLink.sessionID);    
    bool existingSession = sessionInfo.sessionID.isNotEmpty;

    //if we have already a session and it is our intiated then we are a returning payer
    if (sessionInfo.initiated) {
      SessionLinkModel payerLink = sessionLink;
      if (!existingSession) {
        CreateRatchetSessionReply session = await _breezLib.createRatchetSession(); 
        payerLink = new SessionLinkModel(sessionID, session.secret, session.pubKey);
      }
      _currentSession = new PayerRemoteSession(_currentUser, payerLink)..start(); 
      
      return _currentSession;
    }

    //we are payers
    if (!existingSession) {
      await _breezLib.createRatchetSession(sessionID: sessionLink.sessionID, secret: sessionLink.sessionSecret,  remotePubKey: sessionLink.initiatorPubKey);      
    }
    _currentSession = new PayeeRemoteSession(_currentUser, sessionLink)..start();
    return _currentSession;    
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
      SessionLinkModel sessionLink = deepLinks.parseSessionInviteLink(link);
      if (sessionLink != null && sessionLink.sessionID != null) {        
        _sessionInvitesController.add(sessionLink);
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

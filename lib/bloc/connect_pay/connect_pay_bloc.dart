import 'dart:async';
import 'dart:convert';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/bloc/connect_pay/payee_session.dart';
import 'package:breez/bloc/connect_pay/payer_session.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/services/breez_server/server.dart';
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
  BreezServer _breezServer = ServiceInjector().breezServer;
  RemoteSession _currentSession;
  final StreamController _sessionInvitesController = new BehaviorSubject<SessionLinkModel>();
  Stream<SessionLinkModel> get sessionInvites => _sessionInvitesController.stream;
  BreezUserModel _currentUser;  

  ConnectPayBloc(Stream<BreezUserModel> userStream) {
    userStream.listen((user) => _currentUser = user);
    _monitorSessionInvites();
    _monitorSessionNotifications();
  }



  PayerRemoteSession startSessionAsPayer() {    
    var currentSession = new PayerRemoteSession(_currentUser);
    _breezServer.joinSession(true, _currentUser.name, _currentUser.token).then((newSessionReply) async {
      CreateRatchetSessionReply session = await _breezLib.createRatchetSession(newSessionReply.sessionID);     
      SessionLinkModel payerLink = new SessionLinkModel(session.sessionID, session.secret, session.pubKey);
      currentSession.start(payerLink);
    });

    //clean current session on terminate
    currentSession.terminationStream.first.then((_) {
      if (_currentSession == currentSession) {
        _currentSession = null;
      }
    });

    return _currentSession = currentSession;
  }

  Future<RemoteSession> joinSessionByLink(SessionLinkModel sessionLink) async{    
        
    RatchetSessionInfoReply sessionInfo = await _breezLib.ratchetSessionInfo(sessionLink.sessionID);    
    bool existingSession = sessionInfo.sessionID.isNotEmpty;

    if (!existingSession && ( sessionLink.sessionSecret == null || sessionLink.initiatorPubKey == null) ) {
      throw new SessionExpiredException();
    }

    RemoteSession currentSession;
    //if we have already a session and it is our intiated then we are a returning payer
    if (sessionInfo.initiated) {      
        currentSession = new PayerRemoteSession(_currentUser);
    } else {
       //otherwise we are payee
      if (!existingSession) {
        await _breezLib.createRatchetSession(sessionLink.sessionID, secret: sessionLink.sessionSecret,  remotePubKey: sessionLink.initiatorPubKey);      
      }
      currentSession = new PayeeRemoteSession(_currentUser);
    }
    try {
      await _breezServer.joinSession(currentSession.runtimeType == PayerRemoteSession, _currentUser.name, _currentUser.token, sessionID: sessionLink.sessionID);
    } catch(e) {
      throw new SessionExpiredException();
    }

    //clean current session on terminate
    currentSession.terminationStream.first.then((_) {
      if (_currentSession == currentSession) {
        _currentSession = null;
      }
    });

    return _currentSession = currentSession..start(sessionLink);    
  }

  RemoteSession get currentSession => _currentSession;

  _monitorSessionInvites() {
    DeepLinksService deepLinks = ServiceInjector().deepLinks;
    deepLinks.linksNotifications.listen((link) {      
      SessionLinkModel sessionLink = deepLinks.parseSessionInviteLink(link);
      if (sessionLink != null && sessionLink.sessionID != null) {        
        _sessionInvitesController.add(sessionLink);
      }
    });
  }

  _monitorSessionNotifications() {
    var notificationService = ServiceInjector().notifications;
    
    notificationService.notifications
    .where(
      (message) => (message["msg"] ?? "").toString().contains("CTPSessionID"))
    .listen((message) {      
      Map<String,dynamic> parsedMsg = json.decode(message["msg"]);
      String sessionID = parsedMsg["CTPSessionID"];      
      _sessionInvitesController.add(SessionLinkModel(sessionID, null, null));
    });
  }
}

abstract class RemoteSession {
  Stream<void> terminationStream;
  BreezUserModel _currentUser;
  
  RemoteSession(this._currentUser);

  String get sessionID;
  BreezUserModel get currentUser => _currentUser;
  Stream<PaymentSessionState> get paymentSessionStateStream;
  Stream<PaymentSessionError> get sessionErrors;
  Future start(SessionLinkModel sessionLink);
  Future terminate();
}

class SessionExpiredException implements Exception {
  String toString() => "This link had expired and is no longer valid for payment.";
}

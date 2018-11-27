import 'dart:async';
import 'dart:convert';
import 'package:breez/bloc/account/account_model.dart';
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
import 'package:breez/logger.dart';

/*
Bloc that responsible for creating online payments session.
The handling of the session itself is not done here but within the concrete session implementation.
*/
class ConnectPayBloc {
  static const String PENDING_CTP_LINK = 'pending_ctp_link';
  BreezBridge _breezLib = ServiceInjector().breezBridge;
  BreezServer _breezServer = ServiceInjector().breezServer;  
  RemoteSession _currentSession;
  final StreamController _sessionInvitesController = new BehaviorSubject<SessionLinkModel>();
  Stream<SessionLinkModel> get sessionInvites => _sessionInvitesController.stream;

  final BehaviorSubject<String> _pendingCTPLinkController = new BehaviorSubject<String>();
  Stream<String> get pendingCTPLinkStream => _pendingCTPLinkController.stream;

  BreezUserModel _currentUser;
  AccountModel _currentAccount;  

  ConnectPayBloc(Stream<BreezUserModel> userStream, Stream<AccountModel> accountStream) {
    userStream.listen((user) => _currentUser = user);
    accountStream.listen(onAccountChanged);
    _monitorSessionInvites();
    _monitorSessionNotifications();
    _monitorPendingCTPLinks();
  }

  void onAccountChanged(AccountModel acc) async {
    _currentAccount = acc;
    if (_currentAccount.active && !_pendingCTPLinkController.isClosed) {
      String pendingLink = _pendingCTPLinkController.value;
      if (pendingLink != null) {
        SessionLinkModel sessionLink = ServiceInjector().deepLinks.parseSessionInviteLink(pendingLink);        
        _sessionInvitesController.add(sessionLink);
      }
      _pendingCTPLinkController.close();
    }
  }

  _monitorPendingCTPLinks() async {
    var preferences = await ServiceInjector().sharedPreferences;
    _pendingCTPLinkController.stream
      .listen((link) async{        
        preferences.setString(PENDING_CTP_LINK, link);
      })
      .onDone(() => preferences.remove(PENDING_CTP_LINK));  
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
        
    log.info('joinSessionByLink - sessionID = ${sessionLink.sessionID} sessionSecret = ${sessionLink.sessionSecret} initiatorPubKey = ${sessionLink.initiatorPubKey}');
    RatchetSessionInfoReply sessionInfo = await _breezLib.ratchetSessionInfo(sessionLink.sessionID);    
    bool existingSession = sessionInfo.sessionID.isNotEmpty;
    log.info('joinSessionByLink - existing session = $existingSession');

    if (!existingSession && ( sessionLink.sessionSecret == null || sessionLink.initiatorPubKey == null) ) {
      log.info('joinSessionByLink - SessionExpiredException because session does not exist on client');
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
      log.info('joinSessionByLink - SessionExpiredException because session does not exist on server', e);
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

  _monitorSessionInvites() async {
    var preferenes = await ServiceInjector().sharedPreferences;
    var pendingLink = preferenes.getString(PENDING_CTP_LINK);
    if (pendingLink != null) {
      _pendingCTPLinkController.add(pendingLink);
    }

    DeepLinksService deepLinks = ServiceInjector().deepLinks;
    deepLinks.linksNotifications
      .listen((link) async {      
        //if our account is not active yet, just persist the link
        if (!_currentAccount.active) {
          _pendingCTPLinkController.add(link);
          _breezLib.registerReceivePaymentReadyNotification(_currentUser.token);
          return;
        }

        //othersise push the link to the invites stream.   
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

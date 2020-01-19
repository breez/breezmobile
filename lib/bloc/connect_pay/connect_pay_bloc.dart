import 'dart:async';
import 'dart:convert';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/async_action.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/bloc/connect_pay/payee_session.dart';
import 'package:breez/bloc/connect_pay/payer_session.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:grpc/grpc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:breez/logger.dart';
import 'package:fixnum/fixnum.dart';

/*
Bloc that responsible for creating online payments session.
The handling of the session itself is not done here but within the concrete session implementation.

*/
class ConnectPayBloc {
  static const String PENDING_CTP_LINK = 'pending_ctp_link';
  BreezBridge _breezLib = ServiceInjector().breezBridge;
  BreezServer _breezServer = ServiceInjector().breezServer;
  RemoteSession _currentSession;
  final StreamController _sessionInvitesController =
      BehaviorSubject<SessionLinkModel>();
  Stream<SessionLinkModel> get sessionInvites =>
      _sessionInvitesController.stream;

  final BehaviorSubject<String> _pendingCTPLinkController =
      BehaviorSubject<String>();
  Stream<String> get pendingCTPLinkStream => _pendingCTPLinkController.stream;

  Stream<BreezUserModel> _userStream;
  Sink<AsyncAction> _accountActions;
  BreezUserModel _currentUser;
  AccountModel _currentAccount;

  ConnectPayBloc(
      Stream<BreezUserModel> userStream, Stream<AccountModel> accountStream, Sink<AsyncAction> accountActions) {
    _userStream = userStream;
    _accountActions = accountActions;
    userStream.listen((user) => _currentUser = user);
    accountStream.listen(onAccountChanged);
    _monitorSessionInvites();
    _monitorSessionNotifications();
    _monitorPendingCTPLinks();
  }

  void onAccountChanged(AccountModel acc) async {
    _currentAccount = acc;
    if (_currentAccount.connected && !_pendingCTPLinkController.isClosed) {
      String pendingLink = _pendingCTPLinkController.value;
      if (pendingLink != null) {
        SessionLinkModel sessionLink =
            ServiceInjector().deepLinks.parseSessionInviteLink(pendingLink);
        _sessionInvitesController.add(sessionLink);
      }
      _pendingCTPLinkController.close();
    }
  }

  _monitorPendingCTPLinks() async {
    var preferences = await ServiceInjector().sharedPreferences;
    _pendingCTPLinkController.stream.listen((link) async {
      preferences.setString(PENDING_CTP_LINK, link);
    }).onDone(() => preferences.remove(PENDING_CTP_LINK));
  }

  Future _sendPayment(String paymentRequest, Int64 amount) { 
    var action = SendPayment(PayRequest(paymentRequest, amount), ignoreGlobalFeedback: true);
    _accountActions.add(action);
    return action.future;
  }

  PayerRemoteSession createPayerRemoteSession() {
    return PayerRemoteSession(_currentUser, _sendPayment);
  }

  Future startSession(PayerRemoteSession currentSession) {
    log.info("starting a remote payment sessino as payer...");
    //clean current session on terminate
    currentSession.terminationStream.first.then((_) {
      if (_currentSession == currentSession) {
        _currentSession = null;
      }
    });
    _currentSession = currentSession;
    return _breezServer
        .joinSession(true, _currentUser.name, _currentUser.token)
        .then((newSessionReply) async {
      log.info("succesfullly joined to a remote session");
      CreateRatchetSessionReply session = await _breezLib.createRatchetSession(
          newSessionReply.sessionID, newSessionReply.expiry);
      log.info("succesfully created an encrypted session");
      SessionLinkModel payerLink =
          SessionLinkModel(session.sessionID, session.secret, session.pubKey);
      currentSession.start(payerLink);
    });
  }

  Future<RemoteSession> joinSessionByLink(SessionLinkModel sessionLink) async {
    log.info(
        'joinSessionByLink - sessionID = ${sessionLink.sessionID} sessionSecret = ${sessionLink.sessionSecret} initiatorPubKey = ${sessionLink.initiatorPubKey}');
    RatchetSessionInfoReply sessionInfo =
        await _breezLib.ratchetSessionInfo(sessionLink.sessionID);
    bool existingSession = sessionInfo.sessionID.isNotEmpty;
    log.info('joinSessionByLink - existing session = $existingSession');

    if (!existingSession &&
        (sessionLink.sessionSecret == null ||
            sessionLink.initiatorPubKey == null)) {
      log.info(
          'joinSessionByLink - SessionExpiredException because session does not exist on client');
      throw SessionExpiredException();
    }

    RemoteSession currentSession;
    try {
      var sessionResponse = await _breezServer.joinSession(
          sessionInfo.initiated, _currentUser.name, _currentUser.token,
          sessionID: sessionLink.sessionID);
      //if we have already a session and it is our intiated then we are a returning payer
      if (sessionInfo.initiated) {
        currentSession = PayerRemoteSession(_currentUser, _sendPayment);
      } else {
        //otherwise we are payee
        if (!existingSession) {
          await _breezLib.createRatchetSession(
              sessionLink.sessionID, sessionResponse.expiry,
              secret: sessionLink.sessionSecret,
              remotePubKey: sessionLink.initiatorPubKey);
        }
        currentSession = PayeeRemoteSession(_currentUser);
      }

      //clean current session on terminate
      currentSession.terminationStream.first.then((_) {
        if (_currentSession == currentSession) {
          _currentSession = null;
        }
      });
    } catch (e) {
      log.info(
          'joinSessionByLink - SessionExpiredException because session does not exist on server',
          e);
      if (e.runtimeType == GrpcError) {
        GrpcError err = e as GrpcError;
        if (err.code == StatusCode.unknown) {
          throw SessionExpiredException();
        }
        throw e;
      }
      throw SessionExpiredException();
    }

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
    deepLinks.linksNotifications.listen((link) async {
      //if our account is not active yet, just persist the link
      if (!_currentAccount.connected) {
        _pendingCTPLinkController.add(link);
        StreamSubscription<BreezUserModel> userSubscription;
        userSubscription = _userStream.listen((user) {
          if (user.token != null) {
            _breezLib.registerReceivePaymentReadyNotification(user.token);
            userSubscription.cancel();
          }
        });
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
        .where((message) =>
            (message["msg"] ?? "").toString().contains("CTPSessionID"))
        .listen((message) async {
      Map<String, dynamic> parsedMsg = json.decode(message["msg"]);
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
  Future terminate({bool permanent = false});
}

class SessionExpiredException implements Exception {
  String toString() =>
      "This link had expired and is no longer valid for payment.";
}

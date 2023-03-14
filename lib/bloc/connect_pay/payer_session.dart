import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/async_action.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/bloc/connect_pay/encryption.dart';
import 'package:breez/bloc/connect_pay/firebase_session_channel.dart';
import 'package:breez/bloc/connect_pay/online_status_updater.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/background_task.dart';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/deep_links.dart';
import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fixnum/fixnum.dart';
import 'package:rxdart/rxdart.dart';

// A concrete implementation of RemoteSession from the payer side.
class PayerRemoteSession extends RemoteSession with OnlineStatusUpdater {
  String _currentSessionInvite;
  Sink<AsyncAction> accountActions;  

  final StreamController<void> _terminationStreamController =
      StreamController<void>();
  @override
  Stream<void> get terminationStream => _terminationStreamController.stream;

  final _sentInvitesController = StreamController<String>();
  Sink<String> get sentInvitesSink => _sentInvitesController.sink;

  final _paymentDetailsController = StreamController<PaymentDetails>();
  Sink<PaymentDetails> get paymentDetailsSink => _paymentDetailsController.sink;

  final _paymentSessionController = BehaviorSubject<PaymentSessionState>();
  @override
  Stream<PaymentSessionState> get paymentSessionStateStream =>
      _paymentSessionController.stream;

  final _sessionErrorsController =
      StreamController<PaymentSessionError>.broadcast();
  @override
  Stream<PaymentSessionError> get sessionErrors =>
      _sessionErrorsController.stream;

  final BreezServer _breezServer = ServiceInjector().breezServer;
  PaymentSessionChannel _channel;
  final BreezBridge _breezLib = ServiceInjector().breezBridge;
  final Device _device = ServiceInjector().device;
  final DeepLinksService _deepLinks = ServiceInjector().deepLinks;
  final BackgroundTaskService _backgroundService =
      ServiceInjector().backgroundTaskService;
  final BreezUserModel _currentUser;
  var sessionState = <String, dynamic>{};
  SessionLinkModel sessionLink;
  final Completer _sessionCompleter = Completer();
  bool _paymentSent = false;
  Future Function(String paymentRequest, Int64 amount) sendPayment;

  @override
  String get sessionID => sessionLink?.sessionID;

  PayerRemoteSession(this._currentUser, this.sendPayment, this.accountActions,
      {PayeeSessionData existingPayeeData})
      : super(_currentUser) {
    var initialState = PaymentSessionState.payerStart(
        sessionID, _currentUser.name, _currentUser.avatarURL);
    if (existingPayeeData != null) {
      initialState = initialState.copyWith(payeeData: existingPayeeData);
    }
    _paymentSessionController.add(initialState);
  }

  @override
  Future start(SessionLinkModel sessionLink) async {
    log.info("payer session starting...");
    this.sessionLink = sessionLink;
    await _loadPersistedSessionInfo();
    log.info("payer session loaded persisted payee info");
    if (sessionLink.sessionSecret != null) {
      _watchInviteRequests(SessionLinkModel(
          sessionID, sessionLink.sessionSecret, sessionLink.initiatorPubKey));
    }
    _channel = PaymentSessionChannel(sessionID, true,
        interceptor: SessionEncryption(_breezLib, sessionID));
    _channel.peerTerminatedStream.listen((_) {
      terminate(permanent: true);
    });
    _resetSessionState();
    if (_currentSession.payeeData.userName != null ||
        _currentSession.payeeData.imageURL != null) {
      _channel.sendResetMessage();
    }
    _handleIncomingMessages();
    log.info("payer session started");
  }

  _loadPersistedSessionInfo() async {
    var sessionInfo = await _breezLib.ratchetSessionInfo(sessionID);
    if (sessionInfo == null || sessionInfo.userInfo.isEmpty) {
      return;
    }
    Map<String, dynamic> decodedSessionInfo = json.decode(sessionInfo.userInfo);
    if (decodedSessionInfo["paymentSent"] == true) {
      _sessionErrorsController.add(
          PaymentSessionError.unknown(SessionExpiredException().toString()));
    }
    var persistedPayee =
        PayeeSessionData.fromJson(decodedSessionInfo["payeeData"])
            .copyWith(status: PeerStatus.start());
    _paymentSessionController
        .add(_currentSession.copyWith(payeeData: persistedPayee));
  }

  _handleIncomingMessages() {
    _paymentDetailsController.stream.listen((details) {
      _sendPaymentDetails(details).catchError(_onError);
    });
    _watchPayeeMessages();
  }

  _handleStatusUpdates() async {
    await stopStatusUpdates();
    startStatusUpdates(
        'remote-payments/$sessionID/payer/status',
        (status) {
          var payerData = _currentSession.payerData;
          _paymentSessionController.add(_currentSession.copyWith(
              payerData: payerData.copyWith(status: status)));
        },
        'remote-payments/$sessionID/payee/status',
        (status) {
          var payeeData = _currentSession.payeeData;
          _paymentSessionController.add(_currentSession.copyWith(
              payeeData: payeeData.copyWith(status: status)));
        });
  }

  Future _resetSessionState() {
    var sessionResetState = PaymentSessionState.payerStart(
            sessionID, _currentUser.name, _currentUser.avatarURL)
        .copyWith(payeeData: _currentSession.payeeData);

    _paymentSessionController.add(sessionResetState);
    _handleStatusUpdates();
    sessionState.clear();
    return pushStateUpdate(
        {"userName": _currentUser.name, "imageURL": _currentUser.avatarURL});
  }

  Future pushStateUpdate(Map<String, dynamic> updates) {
    sessionState.addAll(updates);
    return _channel.sendStateUpdate(sessionState);
  }

  @override
  Future terminate({bool permanent = false}) async {
    if (_isTerminated) {
      return Future.value(null);
    }    
    _sessionCompleter.complete();

    await stopStatusUpdates();
    if (permanent && !_currentSession.paymentFulfilled) {
      await pushStateUpdate({"cancelled": true});
    }
    await _channel.terminate(destroyHistory: permanent);
    await _paymentDetailsController.close();
    await _paymentSessionController.close();
    await _sessionErrorsController.close();
    if (_sentInvitesController.hasListener) {
      await _sentInvitesController.close();
    }
    _terminationStreamController.add(null);
    if (permanent) {
      await _breezServer.terminateSession(sessionID);
    }
  }

  bool get _isTerminated => _terminationStreamController.isClosed;

  void _watchInviteRequests(SessionLinkModel sessionLink) {
    log.info("payer session generating invite link");
    _deepLinks
        .generateSessionInviteLink(SessionLinkModel(sessionLink.sessionID,
            sessionLink.sessionSecret, sessionLink.initiatorPubKey))
        .then((inviteLink) {
      log.info("payer session generating invite link completed");
      _currentSessionInvite = inviteLink;
      _paymentSessionController
          .add(_currentSession.copyWith(invitationReady: true));
    }).catchError((err) {
      log.info(
          "payer session generating invite link failed: $err");
    });

    _sentInvitesController.stream.listen((inviteLink) async {
      final texts = getSystemAppLocalizations();
      var shared = await _device.shareText(
        texts.connect_to_pay_share_text(
          _currentUser.name,
          Uri.encodeFull(_currentSessionInvite),
        ),
      );

      if (shared == true) {
        _paymentSessionController
            .add(_currentSession.copyWith(invitationSent: true));
      }
    });
  }

  void _watchPayeeMessages() {
    _channel.incomingMessagesStream.listen((data) {
      PayeeSessionData newPayeeData = PayeeSessionData.fromJson(data ?? {})
          .copyWith(status: _currentSession.payeeData.status);
      if (newPayeeData.userName == null || newPayeeData.imageURL == null) {
        newPayeeData =
            newPayeeData.copyWith(userName: _currentSession.payeeData.userName);
        newPayeeData =
            newPayeeData.copyWith(imageURL: _currentSession.payeeData.imageURL);
      }
      PaymentSessionState nextState =
          _currentSession.copyWith(payeeData: newPayeeData);

      String paymentRequest = nextState.payeeData.paymentRequest;
      if (paymentRequest != null) {
        _sendPayment(paymentRequest, nextState);
      } else {
        _paymentSessionController.add(nextState);
      }

      _persistSessionInfo(newPayeeData);
    });

    _channel.peerResetStream.listen((_) async {
      _resetSessionState();
    });
  }

  void _sendPayment(String paymentRequest, PaymentSessionState nextState) {
    _breezLib.decodePaymentRequest(paymentRequest).then((invoice) {
      if (invoice.amount.toInt() != _currentSession.payerData.amount) {
        final texts = getSystemAppLocalizations();
        throw Exception(texts.connect_to_pay_error_wrong_amount);
      }
      _paymentSessionController.add(nextState);
      _backgroundService.runAsTask(_sessionCompleter.future, () {
        log.info("payer session background task finished");
      });
      return sendPayment(paymentRequest, invoice.amount).then((_) {
        if (!_paymentSent) {
          _paymentSent = true;
          _onPaymentFulfilled(invoice);
        }
      }).catchError((err) {
        var displayError = err;
        if (err is PaymentError) {
          displayError = err.toDisplayMessage(_currentUser.currency);
        }
        _onError(displayError);
      });
    }).catchError(_onError);
  }

  Future _persistSessionInfo(PayeeSessionData newPayeeData) {
    return _breezLib.ratchetSessionSetInfo(
        sessionID,
        json.encode({
          "payeeData": {
            "imageURL": newPayeeData.imageURL,
            "userName": newPayeeData.userName,
          },
          "paymentSent": _paymentSent
        }));
  }

  _onPaymentFulfilled(InvoiceMemo invoice) {
    _paymentSessionController.add(_currentSession.copyWith(
        paymentFulfilled: true,
        settledAmount: invoice.amount.toInt(),
        payerData: _currentSession.payerData.copyWith(paymentFulfilled: true)));
  }

  _onError(err) {
    pushStateUpdate({"error": err.toString()}).then((_) {
      _sessionErrorsController.add(PaymentSessionError.unknown(err.toString()));
    });
  }

  Future<void> _sendPaymentDetails(PaymentDetails details) {
    return pushStateUpdate({
      "amount": details.amount.toInt(),
      "description": details.description
    }).then((res) {
      _paymentSessionController.add(_currentSession.copyWith(
          payerData: _currentSession.payerData.copyWith(
              amount: details.amount.toInt(),
              description: details.description)));
    });
  }

  PaymentSessionState get _currentSession => _paymentSessionController.value;
}

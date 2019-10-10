import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
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
import 'package:breez/services/injector.dart';
import 'package:fixnum/fixnum.dart';
import 'package:rxdart/rxdart.dart';

import 'connect_pay_model.dart';


/*
A concrete implementation of RemoteSession from the payee side.
*/
class PayeeRemoteSession extends RemoteSession with OnlineStatusUpdater{
  final StreamController<void>  _terminationStreamController = new StreamController<void>();
  Stream<void> get terminationStream => _terminationStreamController.stream;

  final _approvePaymentController = new StreamController<BreezUserModel>();
  Sink<BreezUserModel> get approvePaymentSink => _approvePaymentController.sink;

  final _rejectPaymentController = new StreamController<void>();
  Sink<void> get rejectPaymentSink => _rejectPaymentController.sink;

  final _paymentSessionController = new BehaviorSubject<PaymentSessionState>();
  Stream<PaymentSessionState> get paymentSessionStateStream => _paymentSessionController.stream;

  final _sessionErrorsController = new StreamController<PaymentSessionError>.broadcast();
  Stream<PaymentSessionError> get sessionErrors => _sessionErrorsController.stream;

  BreezServer _breezServer = ServiceInjector().breezServer;
  StreamSubscription _invoicesPaidSubscription;
  PaymentSessionChannel _channel;
  BreezBridge _breezLib = ServiceInjector().breezBridge;
  BackgroundTaskService _backgroundService = ServiceInjector().backgroundTaskService;
  BreezUserModel _currentUser;
  var sessionState = Map<String, dynamic>();
  SessionLinkModel sessionLink;
  String get sessionID => sessionLink?.sessionID;
  Completer _sessionCompleter = new Completer();

  PayeeRemoteSession(this._currentUser, {PayerSessionData existingPayerData}) : super(_currentUser) {
    var initialState = PaymentSessionState.payeeStart(sessionID, _currentUser.name, _currentUser.avatarURL);
    if (existingPayerData != null) {
      initialState = initialState.copyWith(payerData: existingPayerData);
    }
    _paymentSessionController.add(initialState);
  }

  Future start(SessionLinkModel sessionLink) async{    
    this.sessionLink = sessionLink;  
    await _loadPersistedPayerDetails();      
    _channel = new PaymentSessionChannel(sessionID, false, interceptor: new SessionEncryption(_breezLib, sessionID));
    _channel.peerTerminatedStream.listen((_){
      terminate(permanent: true);
    });
    
    _resetSessionState();    

    if (_currentSession.payerData.userName != null || _currentSession.payerData.imageURL != null) {
      _channel.sendResetMessage();
    }
    _handleIncomingMessages();    
  }

  _loadPersistedPayerDetails() async{
    var sessionInfo = await _breezLib.ratchetSessionInfo(sessionID);
    if (sessionInfo == null || sessionInfo.userInfo.isEmpty) {
      return null;
    }
    Map<String, dynamic> payerData =  json.decode(sessionInfo.userInfo);
    var persistedPayer = PayerSessionData.fromJson(payerData["payerData"]).copyWith(status: PeerStatus.start());
    _paymentSessionController.add(_currentSession.copyWith(payerData: persistedPayer));
  }

  _handleIncomingMessages(){    
    _approvePaymentController.stream.first.then((request){
      var payerData = _currentSession.payerData;
      _breezLib
        .addInvoice(Int64(payerData.amount), payeeName: _currentUser.name, payeeImageURL: _currentUser.avatarURL, payerName: payerData.userName, payerImageURL: payerData.imageURL, description: payerData.description)
        .then((payReq) => _sendPaymentRequest(payReq))
        .then((_){
          _backgroundService.runAsTask(_sessionCompleter.future, (){
            log.info("payee session background task finished");
          });
        });
    })
    .catchError(_onInvoiceError);

    _rejectPaymentController.stream.listen((_){
      pushStateUpdate({"error": "Payment rejected"}).then((res) {
        terminate();
      });
    }); 

    _watchPayerMessages();
    _watchPaymentFulfilled();  
  }

  Future _resetSessionState() async {    
    var sessionResetState = PaymentSessionState.payeeStart(sessionID, _currentUser.name, _currentUser.avatarURL)
      .copyWith(payerData: _currentSession.payerData); 
    
    _paymentSessionController.add(sessionResetState);
    _handleStatusUpdates();
    sessionState.clear();
    return pushStateUpdate({"userName": _currentUser.name, "imageURL":  _currentUser.avatarURL});    
  }

  Future _handleStatusUpdates() async {
    await stopStatusUpdates();
    startStatusUpdates('remote-payments/$sessionID/payee/status', (status) {
      var payeeData = _currentSession.payeeData;
      _paymentSessionController.add(_currentSession.copyWith(payeeData: payeeData.copyWith(status: status)));
    },
    'remote-payments/$sessionID/payer/status', (status) {
      var payerData = _currentSession.payerData;
      _paymentSessionController.add(_currentSession.copyWith(payerData: payerData.copyWith(status: status)));
    });  
  }

  Future pushStateUpdate(Map<String, dynamic> updates){
    sessionState.addAll(updates);
    return _channel.sendStateUpdate(sessionState);
  }

  _onInvoiceError(err){
    pushStateUpdate({"error": err.toString()}).then((_){
      _sessionErrorsController.add(PaymentSessionError.unknown(err.toString()));
    });
  }

  Future terminate({bool permanent=false}) async {    
    if (_isTerminated) {
      return Future.value(null);
    }
    _sessionCompleter.complete();
    await _invoicesPaidSubscription.cancel();
    await stopStatusUpdates();
    if (permanent &&  !_currentSession.paymentFulfilled) {  
      await pushStateUpdate({"cancelled":true});
    }
    await _channel.terminate(destroyHistory: permanent);    
    await _approvePaymentController.close();
    await _paymentSessionController.close();
    await _sessionErrorsController.close();
    await _rejectPaymentController.close();    
    _terminationStreamController.add(null);    
    if (permanent) {
      await _breezServer.terminateSession(sessionID);
    }      
  }

   bool get _isTerminated => _terminationStreamController.isClosed;

  Future<void> _sendPaymentRequest(String payReq) {
    return pushStateUpdate({"paymentRequest": payReq}).then((res) {
      _paymentSessionController.add(_currentSession.copyWith(payeeData: _currentSession.payeeData.copyWith(paymentRequest: payReq)));
    });
  }

  void _watchPayerMessages() {
    _channel.peerResetStream.listen((_) async{
      _resetSessionState();
    });

    _channel.incomingMessagesStream.listen((data) {      
      PayerSessionData newPayerData = PayerSessionData.fromJson(data ?? {}).copyWith(status: _currentSession.payerData.status);
      if (newPayerData.userName == null || newPayerData.imageURL == null) {
        newPayerData = newPayerData.copyWith(userName: _currentSession.payerData.userName);
        newPayerData = newPayerData.copyWith(imageURL: _currentSession.payerData.imageURL);
      }
      _persistPayerData(newPayerData);

      _paymentSessionController.add(_currentSession.copyWith(payerData: newPayerData));
    });
  }

  Future _persistPayerData(PayerSessionData newPayerData) {
    return _breezLib.ratchetSessionSetInfo(sessionID, json.encode(
      {"payerData": {
        "imageURL": newPayerData.imageURL,
        "userName": newPayerData.userName
      }})
    );
  }

  void _watchPaymentFulfilled() {
    _invoicesPaidSubscription = _breezLib.notificationStream.where((event) => event.type == NotificationEvent_NotificationType.INVOICE_PAID).listen((_) {
      if (_currentSession.payeeData.paymentRequest != null) {
        _breezLib.getRelatedInvoice(_currentSession.payeeData.paymentRequest).then((invoice) {
          if (invoice.settled) {
            _paymentSessionController.add(_currentSession.copyWith(paymentFulfilled: true, settledAmount: invoice.amtPaid.toInt()));
          }
        }).catchError((err) => _sessionErrorsController.add(PaymentSessionError.unknown(err.toString())));
      }
    });
  }

  PaymentSessionState get _currentSession => _paymentSessionController.value;
}

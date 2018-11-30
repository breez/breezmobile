import 'dart:async';
import 'dart:convert';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/connect_pay/encryption.dart';
import 'package:breez/bloc/connect_pay/firebase_session_channel.dart';
import 'package:breez/bloc/connect_pay/online_status_updater.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:breez/services/share.dart';
import 'connect_pay_model.dart';

/*
A concrete implementation of RemoteSession from the payer side.
*/
class PayerRemoteSession extends RemoteSession with OnlineStatusUpdater {
  String _currentSessionInvite;  

  final StreamController<void>  _terminationStreamController = new StreamController<void>();
  Stream<void> get terminationStream => _terminationStreamController.stream;
  
  final _sentInvitesController = new StreamController<String>();
  Sink<String> get sentInvitesSink => _sentInvitesController.sink;    

  final _amountController = new StreamController<int>();
  Sink<int> get amountSink => _amountController.sink;

  final _paymentSessionController = new BehaviorSubject<PaymentSessionState>();
  Stream<PaymentSessionState> get paymentSessionStateStream => _paymentSessionController.stream;

  final _sessionErrorsController = new StreamController<PaymentSessionError>.broadcast();
  Stream<PaymentSessionError> get sessionErrors => _sessionErrorsController.stream;  

  BreezServer _breezServer = ServiceInjector().breezServer;
  PaymentSessionChannel _channel;  
  BreezBridge _breezLib = ServiceInjector().breezBridge; 
  DeepLinksService _deepLinks = ServiceInjector().deepLinks;
  BreezUserModel _currentUser; 
  var sessionState = Map<String, dynamic>();  
  SessionLinkModel sessionLink;

  String get sessionID => sessionLink?.sessionID;

  PayerRemoteSession(this._currentUser, {PayeeSessionData existingPayeeData}) : super(_currentUser) {
    var initialState = PaymentSessionState.payerStart(sessionID, _currentUser.name, _currentUser.avatarURL);
    if (existingPayeeData != null) {
      initialState = initialState.copyWith(payeeData: existingPayeeData);
    }
    _paymentSessionController.add(initialState);
  }

  Future start(SessionLinkModel sessionLink) async{    
    this.sessionLink = sessionLink;
    await _loadPersistedPayeeDetails();
    if (sessionLink.sessionSecret != null) {             
      _watchInviteRequests(SessionLinkModel(sessionID, sessionLink.sessionSecret, sessionLink.initiatorPubKey));
    }
    _channel = new PaymentSessionChannel(sessionID, true, interceptor: new SessionEncryption(_breezLib, sessionID));    
    _channel.peerTerminatedStream.listen((_){
      terminate(permanent: true);
    });
    _resetSessionState();
    if (_currentSession.payeeData.userName != null || _currentSession.payeeData.imageURL != null) {
      _channel.sendResetMessage();
    }
    _handleIncomingMessages();    
  }

  _loadPersistedPayeeDetails() async{
    var sessionInfo = await _breezLib.ratchetSessionInfo(sessionID);
    if (sessionInfo == null || sessionInfo.userInfo.isEmpty) {
      return null;
    }
    Map<String, dynamic> payeeData =  json.decode(sessionInfo.userInfo);
    var persistedPayee = PayeeSessionData.fromJson(payeeData["payeeData"]).copyWith(status: PeerStatus.start());
    _paymentSessionController.add(_currentSession.copyWith(payeeData: persistedPayee));
  }

  _handleIncomingMessages(){
     _amountController.stream.listen((amount) {
      _sendAmount(amount).catchError(_onError);
    });
    _watchPayeeMessages();    
  }

  _handleStatusUpdates() async{
    await stopStatusUpdates();
    startStatusUpdates('remote-payments/$sessionID/payer/status', (status) {
      var payerData = _currentSession.payerData;
      _paymentSessionController.add(_currentSession.copyWith(payerData: payerData.copyWith(status: status)));
    }, 'remote-payments/$sessionID/payee/status', (status) {
      var payeeData = _currentSession.payeeData;
      _paymentSessionController.add(_currentSession.copyWith(payeeData: payeeData.copyWith(status: status)));
    }); 
  }

  Future _resetSessionState() {
    var sessionResetState = PaymentSessionState.payerStart(sessionID, _currentUser.name, _currentUser.avatarURL)
      .copyWith(payeeData: _currentSession.payeeData);    

    _paymentSessionController.add(sessionResetState);
    _handleStatusUpdates();
    sessionState.clear();
    return pushStateUpdate({"userName": _currentUser.name, "imageURL":  _currentUser.avatarURL});    
  }

  Future pushStateUpdate(Map<String, dynamic> updates){
    sessionState.addAll(updates);
    return _channel.sendStateUpdate(sessionState);
  }

  Future terminate({bool permanent = false}) async {
    if (_isTerminated) {
      return Future.value(null);
    }
    
    await stopStatusUpdates();    
    await _channel.terminate(destroyHistory: permanent);    
    await _amountController.close();    
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

  void _watchInviteRequests(SessionLinkModel sessionLink){        
    _deepLinks.generateSessionInviteLink(SessionLinkModel(sessionLink.sessionID, sessionLink.sessionSecret, sessionLink.initiatorPubKey)).then((inviteLink) {      
      _currentSessionInvite = inviteLink;
      _paymentSessionController.add(
            _currentSession.copyWith(invitationReady: true));
    });  

    _sentInvitesController.stream.listen((inviteLink) async{      
      if (await Share.share('${_currentUser.name} wants to pay you via Breez...\nFollow this link to receive payment: ${Uri.encodeFull(_currentSessionInvite)}')) {
        _paymentSessionController.add(
            _currentSession.copyWith(invitationSent: true));
      }
    });
  }

  void _watchPayeeMessages() {    
    _channel.incomingMessagesStream.listen((data) {
      PayeeSessionData newPayeeData = PayeeSessionData.fromJson(data ?? {}).copyWith(status: _currentSession.payeeData.status);            
      if (newPayeeData.userName == null || newPayeeData.imageURL == null) {
        newPayeeData = newPayeeData.copyWith(userName: _currentSession.payeeData.userName);
        newPayeeData = newPayeeData.copyWith(imageURL: _currentSession.payeeData.imageURL);
      }
      PaymentSessionState nextState = _currentSession.copyWith(payeeData: newPayeeData);
      _persistPayeeData(newPayeeData);

      String paymentRequest = nextState.payeeData.paymentRequest;
      if (paymentRequest != null) {
        _breezLib.decodePaymentRequest(paymentRequest).then((invoice) {  
          if (invoice.amount.toInt() != _currentSession.payerData.amount) {
            throw new Exception("Wrong amount in payment request");
          }        
          _paymentSessionController.add(nextState);
          return _breezLib.sendPaymentForRequest(paymentRequest)
          .then((res) => _onPaymenetFulfilled(invoice));
        })
        .catchError(_onError);
      } else {        
        _paymentSessionController.add(nextState);
      }
    });   

    _channel.peerResetStream.listen((_) async{
      _resetSessionState();
    });
  }

  Future _persistPayeeData(PayeeSessionData newPayeeData){
    return _breezLib.ratchetSessionSetInfo(sessionID, json.encode(
      {"payeeData": {
        "imageURL": newPayeeData.imageURL,
        "userName": newPayeeData.userName
      }})
    );
  }

  _onPaymenetFulfilled(InvoiceMemo invoice){
    pushStateUpdate({"paymentFulfilled": true}).then((_){
      _paymentSessionController.add(_currentSession.copyWith(paymentFulfilled: true, settledAmount: invoice.amount.toInt()));
    });
  }

  _onError(err){
    pushStateUpdate({"error": err.toString()}).then((_){
      _sessionErrorsController.add(PaymentSessionError.unknown(err.toString()));
    });
  }

  Future<void> _sendAmount(int amount) {
    return pushStateUpdate({"amount": amount}).then((res){
         _paymentSessionController.add(_currentSession.copyWith(payerData: _currentSession.payerData.copyWith(amount: amount)));
    });    
  }

  PaymentSessionState get _currentSession => _paymentSessionController.value;
}

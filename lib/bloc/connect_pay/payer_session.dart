import 'dart:async';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/connect_pay/encryption.dart';
import 'package:breez/bloc/connect_pay/firebase_session_channel.dart';
import 'package:breez/bloc/connect_pay/online_status_updater.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:breez/services/share.dart';
import 'package:uuid/uuid.dart';
import 'connect_pay_model.dart';

/*
A concrete implementation of RemoteSession from the payer side.
*/
class PayerRemoteSession extends RemoteSession with OnlineStatusUpdater {
  String _currentSessionInvite;
  
  final _sentInvitesController = new StreamController<String>();
  Sink<String> get sentInvitesSink => _sentInvitesController.sink;

  final _amountController = new StreamController<int>();
  Sink<int> get amountSink => _amountController.sink;

  final _paymentSessionController = new BehaviorSubject<PaymentSessionState>();
  Stream<PaymentSessionState> get paymentSessionStateStream => _paymentSessionController.stream;

  final _sessionErrorsController = new StreamController<PaymentSessionError>.broadcast();
  Stream<PaymentSessionError> get sessionErrors => _sessionErrorsController.stream;  

  PaymentSessionChannel _channel;  
  BreezBridge _breezLib = ServiceInjector().breezBridge; 
  DeepLinksService _deepLinks = ServiceInjector().deepLinks;
  BreezUserModel _currentUser; 
  var sessionState = Map<String, dynamic>();

  PayerRemoteSession(this._currentUser, {String sessionID}) : super(_currentUser){
    _startOrJoinSession(sessionID);
  }

  _startOrJoinSession(String existingSessionID) async {
    String sessionID = existingSessionID;
    if (existingSessionID == null) {
      CreateRatchetSessionReply session = await _breezLib.createRatchetSession();
      _watchInviteRequests(SessionLinkModel(session.sessionID, session.secret, session.pubKey));
      sessionID = session.sessionID;
    }
    _channel = new PaymentSessionChannel(sessionID, true, interceptor: new SessionEncryption(_breezLib, sessionID));     
    if ((existingSessionID ?? "").isNotEmpty) {
      _channel.sendResetMessage();
    }
   
    _amountController.stream.listen((amount) {
      _sendAmount(amount).catchError(_onError);
    });
        
    _watchPayeeMessages();    
    _paymentSessionController.add(PaymentSessionState.payerStart(sessionID, _currentUser.name, _currentUser.avatarURL));
    startStatusUpdates('remote-payments/$sessionID/payer/status', (status) {
      var payerData = _currentSession.payerData;
      _paymentSessionController.add(_currentSession.copyWith(payerData: payerData.copyWith(status: status)));
    }, 'remote-payments/$sessionID/payee/status', (status) {
      var payeeData = _currentSession.payeeData;
      _paymentSessionController.add(_currentSession.copyWith(payeeData: payeeData.copyWith(status: status)));
    });  
    _resetSessionState();
  }

  Future _resetSessionState(){
    sessionState.clear();
    sessionState["userName"] = _currentUser.name;
    return pushStateUpdate("imageURL", _currentUser.avatarURL);
  }

  Future pushStateUpdate(String key, dynamic value){
    sessionState[key] = value;
    return _channel.sendStateUpdate(sessionState);
  }

  Future terminate() async {
    await _channel.terminate(destroyHistory: true);
    await _amountController.close();
    await _paymentSessionController.close();
    await _sessionErrorsController.close();
    await stopStatusUpdates();
  }

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
      PayeeSessionData newPayeeData = PayeeSessionData.fromJson(data ?? {});
      PaymentSessionState nextState = _currentSession.copyWith(payeeData: _currentSession.payeeData.update(newPayeeData));
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
        print("&&&&&&&&&&& got payee message");
        _paymentSessionController.add(nextState);
      }
    });   

    _channel.peerTerminatedStream.listen((_) async{
      print("&&&&&&&&&&& got termination");
      if (!_currentSession.payerData.paymentFulfilled) {                
        pushOnline();
        var startState = PaymentSessionState.payerStart(_paymentSessionController.value.sessionSecret, _currentUser.name, _currentUser.avatarURL);
        _paymentSessionController.add(
          startState.copyWith(payeeData: startState.payeeData.copyWith(status: _currentSession.payeeData.status), payerData: startState.payerData.copyWith(status: _currentSession.payerData.status))
        );        
        _resetSessionState();        
      }
    });
  }

  _onPaymenetFulfilled(InvoiceMemo invoice){
    pushStateUpdate("paymentFulfilled", true).then((_){
      _paymentSessionController.add(_currentSession.copyWith(paymentFulfilled: true, settledAmount: invoice.amount.toInt()));
    });
  }

  _onError(err){
    pushStateUpdate("error", err.toString()).then((_){
      _sessionErrorsController.add(PaymentSessionError.unknown(err.toString()));
    });
  }

  Future<void> _sendAmount(int amount) {
    return pushStateUpdate("amount", amount).then((res){
         _paymentSessionController.add(_currentSession.copyWith(payerData: _currentSession.payerData.copyWith(amount: amount)));
    });    
  }

  PaymentSessionState get _currentSession => _paymentSessionController.value;
}

import 'dart:async';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/connect_pay/encryption.dart';
import 'package:breez/bloc/connect_pay/firebase_session_channel.dart';
import 'package:breez/bloc/connect_pay/online_status_updater.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/deep_links.dart';
import 'package:breez/services/injector.dart';
import 'package:fixnum/fixnum.dart';
import 'package:rxdart/rxdart.dart';
import 'connect_pay_model.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';


/*
A concrete implementation of RemoteSession from the payee side.
*/
class PayeeRemoteSession extends RemoteSession with OnlineStatusUpdater{
  final _approvePaymentController = new StreamController<BreezUserModel>();
  Sink<BreezUserModel> get approvePaymentSink => _approvePaymentController.sink;

  final _rejectPaymentController = new StreamController<void>();
  Sink<void> get rejectPaymentSink => _rejectPaymentController.sink;

  final _paymentSessionController = new BehaviorSubject<PaymentSessionState>();
  Stream<PaymentSessionState> get paymentSessionStateStream => _paymentSessionController.stream;

  final _sessionErrorsController = new StreamController<PaymentSessionError>.broadcast();
  Stream<PaymentSessionError> get sessionErrors => _sessionErrorsController.stream;

  StreamSubscription _invoicesPaidSubscription;
  PaymentSessionChannel _channel;
  BreezBridge _breezLib = ServiceInjector().breezBridge;
  BreezUserModel _currentUser;
  var sessionState = Map<String, dynamic>();

  PayeeRemoteSession(this._currentUser, SessionLinkModel sessionLink) : super(_currentUser) {

    _joinSession(sessionLink);
  }

  _joinSession(SessionLinkModel link) async {
    _approvePaymentController.stream.listen((request) {     
      var payerData = _currentSession.payerData;    
      _breezLib
          .addInvoice(Int64(payerData.amount), payeeName: _currentUser.name, payeeImageURL: _currentUser.avatarURL, payerName: payerData.userName, payerImageURL: payerData.imageURL)
          .then((payReq) => _sendPaymentRequest(payReq))
          .catchError(_onInvoiceError);
    });

    _rejectPaymentController.stream.listen((_){
      pushStateUpdate("error", "Payment rejected").then((res) {
        terminate();
      });
    });

    var reply = await _breezLib.createRatchetSession(secret: link.sessionSecret,  remotePubKey: link.initiatorPubKey);
    _channel = new PaymentSessionChannel(link.sessionID, false, interceptor: new SessionEncryption(_breezLib, reply.sessionID));
    _watchPayerMessages();
    _watchPaymentFulfilled();
    _paymentSessionController.add(PaymentSessionState.payeeStart(link.sessionID, _currentUser.name, _currentUser.avatarURL));
    startStatusUpdates('remote-payments/${link.sessionID}/payee/status', (status) {
      var payeeData = _currentSession.payeeData;
      _paymentSessionController.add(_currentSession.copyWith(payeeData: payeeData.copyWith(status: status)));
    },
    'remote-payments/${link.sessionID}/payer/status', (status) {
      var payerData = _currentSession.payerData;
      _paymentSessionController.add(_currentSession.copyWith(payerData: payerData.copyWith(status: status)));
    });

    sessionState["userName"] = _currentUser.name;
    pushStateUpdate("imageURL", _currentUser.avatarURL);
  }
  
  Future pushStateUpdate(String key, dynamic value){
    sessionState[key] = value;
    return _channel.sendStateUpdate(sessionState);
  }

  _onInvoiceError(err){
    pushStateUpdate("error", err.toString()).then((_){
      _sessionErrorsController.add(PaymentSessionError.unknown(err.toString()));
    });
  }

  Future terminate() async {
    await _invoicesPaidSubscription.cancel();
    await _channel.terminate(destroyHistory: false);
    await _approvePaymentController.close();
    await _paymentSessionController.close();
    await _sessionErrorsController.close();
    await _rejectPaymentController.close();
    await stopStatusUpdates();
  }

  Future<void> _sendPaymentRequest(String payReq) {
    return pushStateUpdate("paymentRequest", payReq).then((res) {
      _paymentSessionController.add(_currentSession.copyWith(payeeData: _currentSession.payeeData.copyWith(paymentRequest: payReq)));
    });
  }

  void _watchPayerMessages() {
    _channel.peerTerminatedStream.listen((_){
      if (!_currentSession.payerData.paymentFulfilled) {
        String remoteUserName = _currentSession.payeeData.userName;
        String terminateMessage =  remoteUserName == null ? 'Payment session has been cancelled' : '$remoteUserName has cancelled the payment session';
        _sessionErrorsController.add(PaymentSessionError(PaymentSessionErrorType.PAYER_CANCELLED, terminateMessage));
      }
    });

    _channel.incomingMessagesStream.listen((data) {      
      PayerSessionData newPayerData = PayerSessionData.fromJson(data ?? {});
      _paymentSessionController.add(_currentSession.copyWith(payerData: _currentSession.payerData.update( newPayerData)));
    });
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

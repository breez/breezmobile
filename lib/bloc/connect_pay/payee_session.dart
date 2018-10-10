import 'dart:async';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/connect_pay/firebase_session_channel.dart';
import 'package:breez/bloc/connect_pay/online_status_updater.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
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

  PayeeRemoteSession(this._currentUser, String sessionSecret) : super(_currentUser) {

    _joinSession(sessionSecret);
  }

  _joinSession(sessionSecret) {
    _approvePaymentController.stream.listen((request) {     
      var payerData = _currentSession.payerData;    
      _breezLib
          .addInvoice(Int64(payerData.amount), _currentUser.name, _currentUser.avatarURL, payerName: payerData.userName, payerImageURL: payerData.imageURL)
          .then((payReq) => _sendPaymentRequest(sessionSecret, payReq))
          .catchError(_onInvoiceError);
    });

    _rejectPaymentController.stream.listen((_){
      _channel.sendDataUpdate("error", "Payment rejected").then((res) {
        terminate();
      });
    });

    _channel = new PaymentSessionChannel(sessionSecret, false);
    _watchPayerMessages();
    _watchPaymentFulfilled();
    _paymentSessionController.add(PaymentSessionState.payeeStart(sessionSecret, _currentUser.name, _currentUser.avatarURL));
    startPushingStatuses('remote-payments/$sessionSecret/payee/status', (status) {
      var payeeData = _currentSession.payeeData;
      _paymentSessionController.add(_currentSession.copyWith(payeeData: payeeData.copyWith(status: status)));
    });
    _channel.sendDataUpdate("userName", _currentUser.name);
    _channel.sendDataUpdate("imageURL", _currentUser.avatarURL);
  }

  _onInvoiceError(err){
    _channel.sendDataUpdate("error", err.toString()).then((_){
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
    await stopPushingStatuses();
  }

  Future<void> _sendPaymentRequest(String connectionSecret, String payReq) {
    return _channel.sendDataUpdate("paymentRequest", payReq).then((res) {
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
      _paymentSessionController.add(_currentSession.copyWith(payerData: newPayerData));
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

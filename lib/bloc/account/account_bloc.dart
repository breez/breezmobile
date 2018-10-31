import 'dart:async';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/services/breez_server/generated/breez.pbenum.dart';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/breezlib/progress_downloader.dart';
import 'package:breez/services/device.dart';
import 'package:breez/services/notifications.dart';
import 'package:breez/utils/retry.dart';
import 'package:fixnum/fixnum.dart';
import 'account_model.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:breez/logger.dart';
import 'package:breez/bloc/status_indicator/status_update_model.dart';
import 'package:connectivity/connectivity.dart';



class AccountBloc {  
    
  bool _allowReconnect;
  final _reconnectStreamController = new StreamController<void>();
  Sink<void> get _reconnectSink => _reconnectStreamController.sink;

  final _requestAddressController = new StreamController<void>();
  Sink<void> get requestAddressSink => _requestAddressController.sink;

  final _addFundController = new BehaviorSubject<AddFundResponse>();
  Stream<AddFundResponse> get addFundStream => _addFundController.stream;
    
  final _accountController = new BehaviorSubject<AccountModel>();
  Stream<AccountModel> get accountStream => _accountController.stream;

  final _routingNodeConnectionController = new BehaviorSubject<bool>();
  Stream<bool> get routingNodeConnectionStream => _routingNodeConnectionController.stream;

  final _posFundingRequestController = new StreamController<Int64>.broadcast();
  Sink<Int64> get posFundingRequestStream => _posFundingRequestController.sink;

  final _withdrawalController = new StreamController<String>.broadcast();
  Sink<String> get withdrawalSink => _withdrawalController.sink;

  final _withdrawalResultController = new StreamController<String>.broadcast();
  Stream<String> get withdrawalResultStream => _withdrawalResultController.stream;

  final _paymentsController = new BehaviorSubject<PaymentsModel>();
  Stream<PaymentsModel> get paymentsStream => _paymentsController.stream;

  final _paymentFilterController = new BehaviorSubject<PaymentFilterModel>();
  Stream<PaymentFilterModel> get paymentFilterStream => _paymentFilterController.stream;
  Sink<PaymentFilterModel> get paymentFilterSink => _paymentFilterController.sink;

  final _accountActionsController = new StreamController<String>.broadcast();
  Stream<String> get accountActionsStream => _accountActionsController.stream;

  final _sentPaymentsController = new StreamController<String>();
  Sink<String> get sentPaymentsSink => _sentPaymentsController.sink;

  final _fulfilledPaymentsController = new StreamController<String>.broadcast();
  Stream<String> get fulfilledPayments => _fulfilledPaymentsController.stream;

  final _lightningDownController = new StreamController<bool>.broadcast();
  Stream<bool> get lightningDownStream => _lightningDownController.stream;


  Stream<Map<String, DownloadFileInfo>>  chainBootstrapProgress;

  Sink<StatusUpdateModel> _statusUpdateSink;

  BreezUserModel _currentUser;  

  AccountBloc(Stream<BreezUserModel> userProfileStream) {
      ServiceInjector injector = new ServiceInjector();    
      BreezBridge breezLib = injector.breezBridge;  
      BreezServer server = injector.breezServer;
      Notifications notificationsService = injector.notifications;
      Device device = injector.device;      

      _accountController.add(AccountModel.initial());
      _paymentFilterController.add(PaymentFilterModel.initial());
      //listen streams      
      _listenUserChanges(userProfileStream, breezLib);
      _listenNewAddressRequests(breezLib);
      _listenWithdrawalRequests(breezLib);  
      _listenSentPayments(breezLib);
      _listenFilterChanges(breezLib);
      _listenAccountChanges(breezLib);
      _listenPOSFundingRequests(server, breezLib);
      _listenMempoolTransactions(device, notificationsService, breezLib);
      _listenRoutingNodeConnectionChanges(breezLib);
       breezLib.bootstrapAndStart();      
       _refreshAccount(breezLib);
       _listenConnectivityChanges(breezLib);   
       _listenReconnects(breezLib);
    }

    void _listenConnectivityChanges(BreezBridge breezLib){
      var connectivity = Connectivity();     
      connectivity.onConnectivityChanged.skip(1).listen((connectivityResult){
          log.info("_listenConnectivityChanges: connection changed to: " + connectivityResult.toString());          
          _allowReconnect = (connectivityResult != ConnectivityResult.none);
          _reconnectSink.add(null);
        });
    }
    
    void _listenReconnects(BreezBridge breezLib){
      Future connectingFuture = Future.value(null);
      _reconnectStreamController.stream.transform(DebounceStreamTransformer(Duration(milliseconds: 500)))
      .listen((_) async {
        log.info("_listenReconnects: got Reconnect request");
        if (_allowReconnect == true && _accountController.value.connected == false) {          
          connectingFuture = connectingFuture.whenComplete((){
            log.info("_listenReconnects: reconnecting...");
            breezLib.connectAccount();
          });
        }
      });
    }

    void _listenMempoolTransactions(Device device, Notifications notificationService, BreezBridge breezLib) {      
      notificationService.notifications
        .where((message) => message["msg"] == "Unconfirmed transaction" ||  message["msg"] == "Confirmed transaction")
        .listen((message) {
          log.severe(message.toString());
          _fetchFundStatus(breezLib);         
        });

        device.eventStream.where((e) => e == NotificationType.RESUME).listen((e){
          log.info("App Resumed - flutter resume called");        
          _reconnectSink.add(null);
          _fetchFundStatus(breezLib);
        });
    }

    _listenUserChanges(Stream<BreezUserModel> userProfileStream, BreezBridge breezLib){
      userProfileStream.listen((user) { 
        _currentUser = user;
        if (_accountController.value != null) {
          _accountController.add(_accountController.value.copyWith(currency: user.currency));
        }
        if (_paymentsController.value != null) {
          _paymentsController.add(PaymentsModel(_paymentsController.value.paymentsList.map((p) => p.copyWith(user.currency)).toList(), _paymentFilterController.value));
        }    

        _fetchFundStatus(breezLib);                 
      });
    }

    void _fetchFundStatus(BreezBridge breezLib){
      if (_currentUser == null) {
        return;
      }
      
      breezLib.getFundStatus(_currentUser.userID)
      .then( (status){
        log.info("Got status " + status.status.toString());
        if (status.status != _accountController.value.addedFundsStatus) {          
          _accountController.add(_accountController.value.copyWith(addedFundsStatus: status.status));          
        }
      })
      .catchError((err){
        log.severe("Error in getFundStatus " + err.toString());
      });
    }
  
    void _listenNewAddressRequests(BreezBridge breezLib) {    
      _requestAddressController.stream.listen((request){
        breezLib.addFunds(_currentUser.userID)
          .then((reply) => _addFundController.add(new AddFundResponse(reply)))
          .catchError(_addFundController.addError);
      });          
    }
  
    void _listenWithdrawalRequests(BreezBridge breezLib) {
      _withdrawalController.stream.listen(
        (address) {
          breezLib.sendNonDepositedCoins(address)
          .then((res) => _withdrawalResultController.add(address))
          .catchError(_withdrawalResultController.addError)
          .whenComplete(() => _refreshAccount(breezLib));
        });    
    }
  
    void _listenSentPayments(BreezBridge breezLib) {
      _sentPaymentsController.stream.listen(
        (bolt11) {
          _accountController.add(_accountController.value.copyWith(paymentRequestInProgress: bolt11));          
          breezLib.sendPaymentForRequest(bolt11)     
          .then((response) {
            _accountController.add(_accountController.value.copyWith(paymentRequestInProgress: ""));          
            _fulfilledPaymentsController.add(bolt11); 
          })        
          .catchError((err) {
           _accountController.add(_accountController.value.copyWith(paymentRequestInProgress: ""));
            log.severe(err.toString());
            _fulfilledPaymentsController.addError(err);
          });
        });    
    }

    void _listenFilterChanges(BreezBridge breezLib) {
      _paymentFilterController.stream.listen((filter) {
        _refreshPayments(breezLib);
      });
    }

    void _refreshPayments(BreezBridge breezLib) {
      DateTime _firstDate;
      if (MockPaymentInfo.isMockData) {
        List<PaymentInfo> _paymentsList = _filterPayments(MockPaymentInfo.createMockData());
        if(_paymentsList.length > 0){
          _firstDate = DateTime.fromMillisecondsSinceEpoch(_paymentsList.last.creationTimestamp.toInt() * 1000);
        }
        _paymentsController.add(PaymentsModel(_paymentsList, _paymentFilterController.value, _firstDate ?? DateTime(DateTime.now().year)));
        return;
      }

      breezLib.getPayments().then( (payments) {
        List<PaymentInfo> _paymentsList =  payments.paymentsList.map((payment) => new PaymentInfo(payment, _currentUser.currency)).toList();
        if(_paymentsList.length > 0){
          _firstDate = DateTime.fromMillisecondsSinceEpoch(_paymentsList.last.creationTimestamp.toInt() * 1000);
        }
        _paymentsController.add(PaymentsModel(_filterPayments(_paymentsList), _paymentFilterController.value, _firstDate ?? DateTime(DateTime.now().year)));
      })
          .catchError(_paymentsController.addError);
    }
  
    _filterPayments(List<PaymentInfo> paymentsList) {
      Set<PaymentInfo> paymentsSet = paymentsList
          .where((p) => _paymentFilterController.value.paymentType.contains(p.type)).toSet();
      if (_paymentFilterController.value.startDate != null && _paymentFilterController.value.endDate != null) {
        Set<PaymentInfo> _dateFilteredPaymentsSet = paymentsList.where((p) =>
        (p.creationTimestamp.toInt() * 1000 >= _paymentFilterController.value.startDate.millisecondsSinceEpoch &&
            p.creationTimestamp.toInt() * 1000 <= _paymentFilterController.value.endDate.millisecondsSinceEpoch)).toSet();
        return _dateFilteredPaymentsSet.intersection(paymentsSet).toList();
      }
      return paymentsSet.toList();
    }

    void _listenPOSFundingRequests(BreezServer server, BreezBridge breezLib) {
      _posFundingRequestController.stream.listen((amount){
        retry(
          () => _fundPOSChannel(server, breezLib, amount) ,
          tryLimit: 3,
          interval: Duration(seconds: 5)
        )      
        .catchError(_accountActionsController.addError);   
      });  
    }
  
    Future _fundPOSChannel(BreezServer server, BreezBridge breezLib, Int64 remoteAmount) {
      return server.requestChannel(_accountController.value.id, remoteAmount)
        .then((FundReply_ReturnCode res) {
          if (res == FundReply_ReturnCode.SUCCESS) {
            return Future.delayed(Duration(seconds: 3), () {
              _refreshAccount(breezLib);
            });
          }
          else {          
            throw new Exception(res.toString());
          }
        });      
    }
  
    void _listenAccountChanges(BreezBridge breezLib) {
      Observable(breezLib.notificationStream)
          .where((event) =>
      event.type == NotificationEvent_NotificationType.LIGHTNING_SERVICE_DOWN)
          .listen((change) {
            _lightningDownController.add(true);
      });

      Observable(breezLib.notificationStream)
      .where((event) => event.type == NotificationEvent_NotificationType.ACCOUNT_CHANGED)
      .listen((change) => _refreshAccount(breezLib));
    }
  
    _refreshAccount(BreezBridge breezLib){
      _refreshPayments(breezLib);
      _fetchFundStatus(breezLib);
      breezLib.getAccount()
        .then((acc) {
          log.info("ACCOUNT CHANGED BALANCE=" + acc.balance.toString() + " STATUS = " + acc.status.toString());
          _accountController.add(_accountController.value.copyWith(accountResponse: acc, currency: _currentUser.currency));          
        })
        .catchError(_accountController.addError);
    }

    void _listenRoutingNodeConnectionChanges(BreezBridge breezLib) {
      Observable(breezLib.notificationStream)
      .where((event) => event.type == NotificationEvent_NotificationType.ROUTING_NODE_CONNECTION_CHANGED)
      .listen((change) => _refreshRoutingNodeConnection(breezLib));
    }

    _refreshRoutingNodeConnection(BreezBridge breezLib){      
      breezLib.isConnectedToRoutingNode()
        .then((connected){
          _accountController.add(_accountController.value.copyWith(connected: connected));  
          if (!connected) {
            _reconnectSink.add(null); //try to reconnect
          }                                      
        })
        .catchError(_routingNodeConnectionController.addError);
    }

  
    close() {
      _requestAddressController.close();
      _addFundController.close();    
      _paymentsController.close();    
      _posFundingRequestController.close();
      _accountActionsController.close();
      _sentPaymentsController.close();
      _withdrawalController.close();
      _paymentFilterController.close();
      _lightningDownController.close();
      _reconnectStreamController.close();
    }
  }  

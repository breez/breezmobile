import 'dart:async';
import 'dart:convert';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/services/backup.dart';
import 'package:breez/services/breez_server/generated/breez.pbenum.dart';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/breezlib/progress_downloader.dart';
import 'package:breez/services/device.dart';
import 'package:breez/services/notifications.dart';
import 'package:breez/utils/retry.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'account_model.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:breez/logger.dart';
import 'package:breez/bloc/status_indicator/status_update_model.dart';
import 'package:connectivity/connectivity.dart';



class AccountBloc {  

  static const String ACCOUNT_SETTINGS_PREFERENCES_KEY = "account_settings";
  static const String BACKUP_BREEZ_ID_PREFERENCE_KEY = "BACKUP_BREEZ_ID";
  static const String PERSISTENT_NODE_ID_PREFERENCES_KEY = "PERSISTENT_NODE_ID";
      
  final _reconnectStreamController = new StreamController<void>.broadcast();
  Sink<void> get _reconnectSink => _reconnectStreamController.sink;

  final _requestAddressController = new StreamController<void>();
  Sink<void> get requestAddressSink => _requestAddressController.sink;

  final _broadcastRefundRequestController = new StreamController<BroadcastRefundRequestModel>.broadcast();
  Sink<BroadcastRefundRequestModel> get broadcastRefundRequestSink => _broadcastRefundRequestController.sink;

  final _broadcastRefundResponseController = new StreamController<BroadcastRefundResponseModel>.broadcast();
  Stream<BroadcastRefundResponseModel> get broadcastRefundResponseStream => _broadcastRefundResponseController.stream;

  final _refundableDepositsController = new BehaviorSubject<List<RefundableDepositModel>>();
  Stream<List<RefundableDepositModel>> get refundableDepositsStream => _refundableDepositsController.stream;

  final _addFundController = new BehaviorSubject<AddFundResponse>();
  Stream<AddFundResponse> get addFundStream => _addFundController.stream;
    
  final _accountController = new BehaviorSubject<AccountModel>();
  Stream<AccountModel> get accountStream => _accountController.stream;

  final _accountSettingsController = new BehaviorSubject<AccountSettings>();
  Stream<AccountSettings> get accountSettingsStream => _accountSettingsController.stream;
  Sink<AccountSettings> get accountSettingsSink => _accountSettingsController.sink;

  final _routingNodeConnectionController = new BehaviorSubject<bool>();
  Stream<bool> get routingNodeConnectionStream => _routingNodeConnectionController.stream;

  final _posFundingRequestController = new StreamController<Int64>.broadcast();
  Sink<Int64> get posFundingRequestStream => _posFundingRequestController.sink;

  final _withdrawalController = new StreamController<RemoveFundRequestModel>.broadcast();
  Sink<RemoveFundRequestModel> get withdrawalSink => _withdrawalController.sink;

  final _withdrawalResultController = new StreamController<RemoveFundResponseModel>.broadcast();
  Stream<RemoveFundResponseModel> get withdrawalResultStream => _withdrawalResultController.stream;

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

  final BehaviorSubject<void> _nodeConflictController = new BehaviorSubject<void>();
  Stream<void> get nodeConflictStream => _nodeConflictController.stream;

  final BehaviorSubject<String> _backupBreezIDController = new BehaviorSubject<String>();
  Stream<void> get backupBreezIDStream => _backupBreezIDController.stream;

  Stream<Map<String, DownloadFileInfo>>  chainBootstrapProgress;

  BackupService _backupService;
  BreezUserModel _currentUser;
  bool _allowReconnect = true;
  bool _startedLightning = false;
  String _backupBreezID;  

  AccountBloc(Stream<BreezUserModel> userProfileStream) {
      ServiceInjector injector = new ServiceInjector();    
      BreezBridge breezLib = injector.breezBridge;
      BreezServer server = injector.breezServer;
      Notifications notificationsService = injector.notifications;
      Device device = injector.device;
      _backupService = injector.backupService;

      _accountController.add(AccountModel.initial());
      _paymentFilterController.add(PaymentFilterModel.initial());
      _accountSettingsController.add(AccountSettings.start());
      
      print("Account bloc started");
      //listen streams      
      _hanleAccountSettings();        
      _listenUserChanges(userProfileStream, breezLib, device);
      _listenNewAddressRequests(breezLib);
      _listenWithdrawalRequests(breezLib);
      _listenSentPayments(breezLib);
      _listenFilterChanges(breezLib);
      _listenAccountChanges(breezLib);
      _listenPOSFundingRequests(server, breezLib);
      _listenMempoolTransactions(device, notificationsService, breezLib);
      _listenRoutingNodeConnectionChanges(breezLib);              
    }

    //settings persistency
    Future _hanleAccountSettings() async {      
      var preferences = await ServiceInjector().sharedPreferences;      
      var accountSettings = preferences.getString(ACCOUNT_SETTINGS_PREFERENCES_KEY);
      if (accountSettings != null) {
        Map<String, dynamic> settings = json.decode(accountSettings);
        _accountSettingsController.add(AccountSettings.fromJson(settings));
      }
      _accountSettingsController.stream.listen((settings){
        preferences.setString(ACCOUNT_SETTINGS_PREFERENCES_KEY, json.encode(settings.toJson()));
      });

      _accountController.stream.listen((acc) async {
        if (acc.id.isNotEmpty) {
          await preferences.setString(PERSISTENT_NODE_ID_PREFERENCES_KEY, acc.id);          
        }
      });

      String backupBreezID =
        preferences.getString(BACKUP_BREEZ_ID_PREFERENCE_KEY);
      if (backupBreezID == null) {
        backupBreezID = new Uuid().v4().toString();
        preferences.setString(
            BACKUP_BREEZ_ID_PREFERENCE_KEY, backupBreezID);
      }
      _backupBreezIDController.add(backupBreezID);
    }

    void _listenRefundableDeposits(BreezBridge breezLib, Device device){
      var refreshRefundableAddresses = (){
        breezLib.getRefundableSwapAddresses()
        .then(
          (addressList){
            _refundableDepositsController.add(addressList.addresses.map((a) => RefundableDepositModel(a)).toList());
          }
        )
        .catchError((err){
          _refundableDepositsController.addError(err);
        });
      };

      refreshRefundableAddresses();
      Observable.merge([
        device.eventStream.where((e) => e == NotificationType.RESUME),
        breezLib.notificationStream.where((n) => n.type == NotificationEvent_NotificationType.FUND_ADDRESS_UNSPENT_CHANGED)
      ])
      .listen((e) => refreshRefundableAddresses());      
    }

    void _listenRefundBroadcasts(BreezBridge breezLib){
      _broadcastRefundRequestController.stream.listen((request){
        breezLib.refund(request.fromAddress, request.toAddress)
          .then((txID){
            _broadcastRefundResponseController.add(new BroadcastRefundResponseModel(request, txID));
          })
          .catchError(_broadcastRefundResponseController.addError);
      });
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
        connectingFuture = connectingFuture.whenComplete(() async {             
          log.info('_listenReconnects: got Reconnect request _alloReconnect=$_allowReconnect connected=${_accountController.value.connected}');  
          if (_allowReconnect == true && _accountController.value.connected == false) { 
            log.info("_listenReconnects: checking node conflicts before reconnecting...");
            await _checkNodeConflict(breezLib);
            log.info("_listenReconnects: no conflict detected, reconnecting...");
            await breezLib.connectAccount();
          }
        });        
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
          log.info("App Resumed - flutter resume called, adding reconnect request");        
          _reconnectSink.add(null);          
          _fetchFundStatus(breezLib);
        });
    }

    _listenUserChanges(Stream<BreezUserModel> userProfileStream, BreezBridge breezLib, Device device){      
      userProfileStream.listen((user) async {
        _currentUser = user; 
               
        if (user.registered && !_startedLightning) {
          print("Account bloc got registered user, starting lightning daemon...");        
          _startedLightning = true;                    
          breezLib.bootstrap().then((done) async {    
            print("Account bloc bootstrap has finished");        
            breezLib.startLightning();
            _checkNodeConflict(breezLib);            
            _refreshAccount(breezLib);            
            _listenConnectivityChanges(breezLib);
            _listenReconnects(breezLib);
            _listenRefundableDeposits(breezLib, device);
            _listenRefundBroadcasts(breezLib);            
          });
        }

        if (_accountController.value != null) {
          _accountController.add(_accountController.value.copyWith(currency: user.currency));
        }
        if (_paymentsController.value != null) {
          _paymentsController.add(PaymentsModel(_paymentsController.value.paymentsList.map((p) => p.copyWith(user.currency)).toList(), _paymentFilterController.value));
        }            
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
        breezLib.addFundsInit(_currentUser.userID)
          .then((reply) => _addFundController.add(new AddFundResponse(reply)))
          .catchError(_addFundController.addError);
      });          
    }
  
    void _listenWithdrawalRequests(BreezBridge breezLib) {
      _withdrawalController.stream.listen(
        (removeFundRequestModel) {
          Future removeFunds = Future.value(null);
          if (removeFundRequestModel.fromWallet) {
            removeFunds = 
              breezLib.sendWalletCoins(removeFundRequestModel.address, removeFundRequestModel.amount, removeFundRequestModel.satPerByteFee)
                .then((txID) => _withdrawalResultController.add(new RemoveFundResponseModel(txID)));
          } else {
            removeFunds = 
              breezLib.removeFund(removeFundRequestModel.address, removeFundRequestModel.amount)
                .then((res) => _withdrawalResultController.add(new RemoveFundResponseModel(res.txid, errorMessage: res.errorMessage)));
          }
                    
          removeFunds.catchError(_withdrawalResultController.addError);          
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
      _paymentFilterController.stream.skip(1).listen((filter) {
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

      print ("refreshing payments...");
      breezLib.getPayments().then( (payments) {
        List<PaymentInfo> _paymentsList =  payments.paymentsList.map((payment) => new PaymentInfo(payment, _currentUser.currency)).toList();
        if(_paymentsList.length > 0){
          _firstDate = DateTime.fromMillisecondsSinceEpoch(_paymentsList.last.creationTimestamp.toInt() * 1000);
        }
        print ("refresh payments finished");
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
      print("Account bloc refreshing account...");                      
      breezLib.getAccount()
        .then((acc) {
          print("ACCOUNT CHANGED BALANCE=" + acc.balance.toString() + " STATUS = " + acc.status.toString());
          _accountController.add(_accountController.value.copyWith(accountResponse: acc, currency: _currentUser.currency));          
        })
        .catchError(_accountController.addError);
      _refreshPayments(breezLib);
      _fetchFundStatus(breezLib);
      if (_accountController.value.onChainFeeRate == null) {
        breezLib.getDefaultOnChainFeeRate().then((rate) => _accountController.add(_accountController.value.copyWith(onChainFeeRate: rate)));     
      }
    }

    void _listenRoutingNodeConnectionChanges(BreezBridge breezLib) {
      Observable(breezLib.notificationStream)
      .where((event) => event.type == NotificationEvent_NotificationType.ROUTING_NODE_CONNECTION_CHANGED)
      .listen((change) => _refreshRoutingNodeConnection(breezLib));
    }

    _refreshRoutingNodeConnection(BreezBridge breezLib){      
      breezLib.isConnectedToRoutingNode()
        .then((connected) async {
          _accountController.add(_accountController.value.copyWith(connected: connected));  
          if (!connected) {          
            log.info("Node disconnected, adding reconnect request");
            _reconnectSink.add(null); //try to reconnect
          }                                      
        })
        .catchError(_routingNodeConnectionController.addError);
    }

    //detecte if safe to connect on drive.
    //if not stop node
    Future _checkNodeConflict(BreezBridge breezLib) async {      
      try {
        String nodeID = await getPersistentNodeID();
        if (nodeID == null) {
          return true;
        }
        String backupBreezID = await _backupBreezIDController.first;
        print("_checkNodeConflict backupBreezID = " + backupBreezID);
        bool isSafe = await _backupService.isSafeForBreezBackupID(nodeID, backupBreezID);                
        log.info("_checkNodeConflict safe = " + isSafe.toString());
      }
      on BackupConflictException{
        breezLib.stop(permanent: true);
        _nodeConflictController.add(null); 
        rethrow;
      }
      on Exception catch(e){
        log.warning("_checkNodeConflict got exception " + e.toString());
      }         
    }

    Future<String> getPersistentNodeID() async {      
      var preferences = await ServiceInjector().sharedPreferences;
      return preferences.getString(PERSISTENT_NODE_ID_PREFERENCES_KEY);
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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_permissions_handler.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/async_action.dart';
import 'package:breez/bloc/csv_exporter.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/background_task.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/currency_data.dart';
import 'package:breez/services/currency_service.dart';
import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/notifications.dart';
import 'package:connectivity/connectivity.dart';
import 'package:rxdart/rxdart.dart';

import 'account_model.dart';
import 'account_synchronizer.dart';

class AccountBloc {
  static const FORCE_BOOTSTRAP_FILE_NAME = "FORCE_BOOTSTRAP";
  static const String ACCOUNT_SETTINGS_PREFERENCES_KEY = "account_settings";
  static const String PERSISTENT_NODE_ID_PREFERENCES_KEY = "PERSISTENT_NODE_ID";

  Timer _exchangeRateTimer;
  Map<String, CurrencyData> _currencyData;

  final _userActionsController = StreamController<AsyncAction>.broadcast();
  AccountSynchronizer _accountSynchronizer;
  Sink<AsyncAction> get userActionsSink => _userActionsController.sink;
  Map<Type, Function> _actionHandlers = Map();

  final _reconnectStreamController = StreamController<void>.broadcast();
  Sink<void> get _reconnectSink => _reconnectStreamController.sink;

  final _broadcastRefundRequestController =
      StreamController<BroadcastRefundRequestModel>.broadcast();
  Sink<BroadcastRefundRequestModel> get broadcastRefundRequestSink =>
      _broadcastRefundRequestController.sink;

  final _broadcastRefundResponseController =
      StreamController<BroadcastRefundResponseModel>.broadcast();
  Stream<BroadcastRefundResponseModel> get broadcastRefundResponseStream =>
      _broadcastRefundResponseController.stream;

  final _accountController = BehaviorSubject<AccountModel>();
  Stream<AccountModel> get accountStream => _accountController.stream;

  final _accountEnableController = StreamController<bool>.broadcast();
  Sink<bool> get accountEnableSink => _accountEnableController.sink;

  final _accountSettingsController = BehaviorSubject<AccountSettings>();
  Stream<AccountSettings> get accountSettingsStream =>
      _accountSettingsController.stream;
  Sink<AccountSettings> get accountSettingsSink =>
      _accountSettingsController.sink;

  final _routingNodeConnectionController = BehaviorSubject<bool>();
  Stream<bool> get routingNodeConnectionStream =>
      _routingNodeConnectionController.stream;

  final _paymentsController = BehaviorSubject<PaymentsModel>();
  Stream<PaymentsModel> get paymentsStream => _paymentsController.stream;

  final _paymentFilterController = BehaviorSubject<PaymentFilterModel>();
  Stream<PaymentFilterModel> get paymentFilterStream =>
      _paymentFilterController.stream;
  Sink<PaymentFilterModel> get paymentFilterSink =>
      _paymentFilterController.sink;

  final _accountNotificationsController = StreamController<String>.broadcast();
  Stream<String> get accountNotificationsStream =>
      _accountNotificationsController.stream;

  final _completedPaymentsController =
      StreamController<CompletedPayment>.broadcast();
  Stream<CompletedPayment> get completedPaymentsStream =>
      _completedPaymentsController.stream;

  Map<String, bool> _ignoredFeedbackPayments = Map<String, bool>();

  Stream<PaymentInfo> get pendingPaymentStream => paymentsStream.map((ps) {
        if (ps.nonFilteredItems.length == 0) {
          return null;
        }
        var topItem = ps.nonFilteredItems.first;
        if (topItem.type != PaymentType.SENT || !topItem.pending) {
          return null;
        }
        return topItem;
      }).distinct((p1, p2) => p1?.paymentHash == p2?.paymentHash);

  final _lightningDownController = StreamController<bool>.broadcast();
  Stream<bool> get lightningDownStream => _lightningDownController.stream;

  final BehaviorSubject<void> _nodeConflictController = BehaviorSubject<void>();
  Stream<void> get nodeConflictStream => _nodeConflictController.stream;

  final AccountPermissionsHandler _permissionsHandler =
      AccountPermissionsHandler();
  Stream<bool> get optimizationWhitelistExplainStream =>
      _permissionsHandler.optimizationWhitelistExplainStream;
  Sink get optimizationWhitelistRequestSink =>
      _permissionsHandler.optimizationWhitelistRequestSink;

  BreezUserModel _currentUser;
  bool _startedLightning = false;
  bool _retryingLightningService = false;
  BreezBridge _breezLib;
  Notifications _notificationsService;
  Device _device;
  BackgroundTaskService _backgroundService;
  CurrencyService _currencyService;
  Completer _onBoardingCompleter = Completer();
  Stream<BreezUserModel> userProfileStream;

  AccountBloc(this.userProfileStream) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    _notificationsService = injector.notifications;
    _device = injector.device;
    _backgroundService = injector.backgroundTaskService;
    _currencyService = injector.currencyService;
    _actionHandlers = {
      SendPaymentFailureReport: _handleSendQueryRoute,
      ResetNetwork: _handleResetNetwork,
      RestartDaemon: _handleRestartDaemon,
      FetchSwapFundStatus: _fetchFundStatusAction,
      SendPayment: _sendPayment,
      CancelPaymentRequest: _cancelPaymentRequest,
      ChangeSyncUIState: _collapseSyncUI,
      FetchRates: _fetchRates,
      ResetChainService: _handleResetChainService,
      ExportPayments: _exportPaymentsAction,
      FetchPayments: _handleFetchPayments,
      SweepAllCoinsTxsAction: _sweepAllCoinsTransactions,
      PublishTransaction: _publishTransaction,
    };

    _accountController.add(AccountModel.initial());
    _paymentsController.add(PaymentsModel.initial());
    _paymentFilterController.add(PaymentFilterModel.initial());
    _accountSettingsController.add(AccountSettings.start());

    log.info("Account bloc started");
    ServiceInjector().sharedPreferences.then((preferences) {
      _refreshAccountAndPayments();
      //listen streams
      _listenAccountActions();
      _handleAccountSettings();
      _listenUserChanges(userProfileStream);
      _listenFilterChanges();
      _listenAccountChanges();
      _listenMempoolTransactions();
      _listenRoutingConnectionChanges();
      _trackOnBoardingStatus();
      _listenEnableAccount();
    });
  }

  Stream<List<PaymentInfo>> get pendingChannelsStream {
    return _paymentsController.map((paymentModel) => paymentModel
        .nonFilteredItems
        .where(
            (item) => item.type == PaymentType.CLOSED_CHANNEL && item.pending)
        .toList());
  }

  void _listenEnableAccount() {
    _accountEnableController.stream.listen((enable) {
      _accountController
          .add(_accountController.value.copyWith(enableInProgress: true));
      _breezLib.enableAccount(enable).whenComplete(() {
        _accountController
            .add(_accountController.value.copyWith(enableInProgress: false));
      });
    });
  }

  //settings persistency
  Future _handleAccountSettings() async {
    var preferences = await ServiceInjector().sharedPreferences;
    var accountSettings =
        preferences.getString(ACCOUNT_SETTINGS_PREFERENCES_KEY);
    if (accountSettings != null) {
      Map<String, dynamic> settings = json.decode(accountSettings);
      _accountSettingsController.add(AccountSettings.fromJson(settings));
    }
    _accountSettingsController.stream.listen((settings) {
      preferences.setString(
          ACCOUNT_SETTINGS_PREFERENCES_KEY, json.encode(settings.toJson()));
    });

    _accountController.stream.listen((acc) async {
      if (acc.id.isNotEmpty) {
        await preferences.setString(PERSISTENT_NODE_ID_PREFERENCES_KEY, acc.id);
      }
    });
  }

  void _listenAccountActions() {
    _userActionsController.stream.listen((action) {
      var handler = _actionHandlers[action.runtimeType];
      if (handler != null) {
        handler(action).catchError((e) {
          log.severe(
              "AccountAction: ${action.runtimeType.toString()} - Error: ${e.toString()}");
          action.resolveError(e);
        });
      }
    });
  }

  Future _fetchRates(FetchRates rates) async {
    if (this._accountController.value.fiatConversionList.isEmpty) {
      await _getExchangeRate();
    }
    rates.resolve(this._accountController.value.fiatConversionList);
  }

  Future _handleSendQueryRoute(SendPaymentFailureReport action) async {
    Map<String, dynamic> jsonReport = json.decode(action.traceReport);
    jsonReport["app version"] = await _device.appVersion();
    JsonEncoder encoder = JsonEncoder.withIndent('\t');
    String report = encoder.convert(jsonReport);
    action.resolve(await _breezLib.sendPaymentFailureBugReport(report));
  }

  Future _handleResetNetwork(ResetNetwork action) async {
    action.resolve(await _breezLib.setPeers([]));
  }

  Future _handleFetchPayments(FetchPayments action) async {
    await _refreshAccountAndPayments();
    action.resolve(_paymentsController.value);
  }

  Future _sweepAllCoinsTransactions(SweepAllCoinsTxsAction action) async {
    var response = await _breezLib.sweepAllCoinsTransactions(action.address);
    action.resolve(SweepAllCoinsTxs(response));
  }

  Future _publishTransaction(PublishTransaction action) async {
    action.resolve(await _breezLib.publishTransaction(action.tx));
  }

  Future _exportPaymentsAction(ExportPayments action) async {
    List currentPaymentList =
        _filterPayments(_paymentsController.value.paymentsList);
    action.resolve(
        await CsvExporter(currentPaymentList, _paymentFilterController.value)
            .export());
  }

  Future _handleResetChainService(ResetChainService action) async {
    var workingDir = await _breezLib.getWorkingDir();
    var bootstrapFile = File(workingDir.path + "/$FORCE_BOOTSTRAP_FILE_NAME");
    action.resolve(await bootstrapFile.create(recursive: true));
  }

  Future _handleRestartDaemon(RestartDaemon action) async {
    action.resolve(await _breezLib.restartLightningDaemon());
  }

  Future _fetchFundStatusAction(FetchSwapFundStatus action) async {
    action.resolve(await _fetchFundStatus());
  }

  Future _sendPayment(SendPayment action) async {
    var payRequest = action.paymentRequest;
    if (action.ignoreGlobalFeedback) {
      _ignoredFeedbackPayments[payRequest.paymentRequest] = true;
    }
    var sendRequest = _breezLib
        .sendPaymentForRequest(payRequest.paymentRequest,
            amount: payRequest.amount)
        .catchError((err) {
      _completedPaymentsController
          .addError(PaymentError(payRequest, err, null));
      return Future.error(err);
    });

    var sendPaymentFuture = Future.wait(
        [sendRequest, _breezLib.waitPayment(payRequest.paymentRequest)],
        eagerError: true);

    _backgroundService.runAsTask(sendPaymentFuture, () {
      log.info("sendpayment background task finished");
    });
    action.resolve(await sendPaymentFuture);
  }

  Future _cancelPaymentRequest(CancelPaymentRequest cancelRequest) {
    _completedPaymentsController
        .add(CompletedPayment(cancelRequest.paymentRequest, cancelled: true));
    return Future.value(null);
  }

  Future _collapseSyncUI(ChangeSyncUIState stateAction) {
    _accountController.add(
        _accountController.value.copyWith(syncUIState: stateAction.nextState));
    return Future.value(null);
  }

  void _trackOnBoardingStatus() {
    _accountController
        .where((acc) => !acc.initial && !acc.isInitialBootstrap)
        .first
        .then((_) {
      _onBoardingCompleter.complete();
    });
  }

  void _listenRefundableDeposits() {
    _breezLib.notificationStream
        .where((n) =>
            n.type ==
            NotificationEvent_NotificationType.FUND_ADDRESS_UNSPENT_CHANGED)
        .listen((e) {
      _fetchFundStatus();
    });
  }

  void _listenRefundBroadcasts() {
    _broadcastRefundRequestController.stream.listen((request) {
      _breezLib
          .refund(request.fromAddress, request.toAddress, request.feeRate)
          .then((txID) {
        _broadcastRefundResponseController
            .add(BroadcastRefundResponseModel(request, txID));
      }).catchError(_broadcastRefundResponseController.addError);
    });
  }

  void _listenConnectivityChanges() {
    var connectivity = Connectivity();
    connectivity.onConnectivityChanged.skip(1).listen((connectivityResult) {
      log.info("_listenConnectivityChanges: connection changed to: " +
          connectivityResult.toString());
      if (connectivityResult != ConnectivityResult.none) {
        _reconnectSink.add(null);
      }
    });
  }

  void _listenReconnects() {
    Future connectingFuture = Future.value(null);
    _reconnectStreamController.stream
        .transform(DebounceStreamTransformer(Duration(milliseconds: 500)))
        .listen((_) async {
      connectingFuture = connectingFuture.whenComplete(() async {
        var acc = _accountController.value;
        log.info(
            "Checking if reconnect needed for account: connected=${acc.connected} readyForPayment=${acc.readyForPayments} processingConnection=${acc.processingConnection}");

        if (acc.connected && acc.readyForPayments == false ||
            acc.processingConnection) {
          log.info("Reconnecting...");
          await _breezLib.connectAccount();
        }
      }).catchError((e) {});
    });
  }

  void _listenMempoolTransactions() {
    _notificationsService.notifications
        .where((message) =>
            message["msg"] == "Unconfirmed transaction" ||
            message["msg"] == "Confirmed transaction")
        .listen((message) {
      log.severe(message.toString());
      if (message["msg"] == "Unconfirmed transaction" &&
          message["user_click"] == null) {
        _accountNotificationsController.add(message["body"].toString());
      }
      _fetchFundStatus();
    });

    _device.eventStream.where((e) => e == NotificationType.RESUME).listen((e) {
      log.info("App Resumed - flutter resume called, adding reconnect request");
      _reconnectSink.add(null);
    });
  }

  _listenUserChanges(Stream<BreezUserModel> userProfileStream) {
    userProfileStream.listen((user) async {
      if (user.token != null && user.token != _currentUser?.token) {
        log.info(
            "user profile bloc registering for channel open notifications");
        _breezLib.registerChannelOpenedNotification(user.token);
      }
      _currentUser = user;
      log.info("account: got new user $user");
      //convert currency.
      _accountController.add(_accountController.value.copyWith(
          currency: user.currency,
          fiatShortName: user.fiatCurrency,
          posCurrencyShortName: user.posCurrencyShortName));
      var updatedPayments = _paymentsController.value.copyWith(
        nonFilteredItems: _paymentsController.value.nonFilteredItems
            .map((p) => p.copyWith(_accountController.value))
            .toList(),
        paymentsList: _paymentsController.value.paymentsList
            .map((p) => p.copyWith(_accountController.value))
            .toList(),
      );
      _paymentsController.add(updatedPayments);

      //start lightning
      if (user.registrationRequested) {
        if (!_startedLightning) {
          log.info(
              "Account bloc got registered user, starting lightning daemon...");
          _startedLightning = true;
          _pollSyncStatus();
          _backgroundService.runAsTask(_onBoardingCompleter.future, () {
            log.info("onboarding background task finished");
          });
          log.info("account: starting lightning...");
          try {
            await _breezLib.startLightning();
            log.info("account: lightning started");
            if (user.token != null) {
              _breezLib.registerPeriodicSync(user.token);
            }
            _fetchFundStatus();
            _listenConnectivityChanges();
            _listenReconnects();
            _listenRefundableDeposits();
            _updateExchangeRates();
            _listenRefundBroadcasts();
          } catch (e) {
            _lightningDownController.add(false);
          }
        }
      }
    });
  }

  void _pollSyncStatus() async {
    if (_accountSynchronizer != null) {
      _accountSynchronizer.dismiss();
    }

    var nodeID = await getPersistentNodeID();

    bool blockingPrompted = false;
    bool newNode = nodeID == null;
    _accountSynchronizer = AccountSynchronizer(_breezLib,
        onProgress:
            (startPollTimestamp, progress, syncedToChain, bootstrap) async {
          bool moreThan3DaysOff = Duration(
                  milliseconds: DateTime.now().millisecondsSinceEpoch -
                      startPollTimestamp) >
              Duration(days: 3);
          var syncUIState = _accountController.value.syncUIState;
          if ((moreThan3DaysOff || newNode) &&
              _accountController.value.syncUIState == SyncUIState.NONE &&
              !blockingPrompted) {
            blockingPrompted = true;
            syncUIState =
                newNode ? SyncUIState.BLOCKING : SyncUIState.COLLAPSED;
          }
          _accountController.add(_accountController.value.copyWith(
              syncUIState: syncUIState,
              syncProgress: progress,
              syncedToChain: syncedToChain));
        },
        onComplete: () => _accountController.add(_accountController.value
            .copyWith(syncUIState: SyncUIState.NONE, syncProgress: 1.0)));
  }

  Future _fetchFundStatus() {
    if (_currentUser == null) {
      return Future.value(null);
    }

    return _breezLib.getFundStatus(_currentUser.userID ?? "").then((status) {
      _accountController
          .add(_accountController.value.copyWith(addedFundsReply: status));
    }).catchError((err) {
      log.severe("Error in getFundStatus " + err.toString());
    });
  }

  void _listenFilterChanges() {
    _paymentFilterController.stream.skip(1).listen((filter) {
      _refreshPayments();
    });
  }

  Future<PaymentsModel> fetchPayments() {
    DateTime _firstDate;
    print("refreshing payments...");
    return _breezLib.getPayments().then((payments) {
      List<PaymentInfo> _paymentsList = payments.paymentsList
          .map((payment) => PaymentInfo(payment, _accountController.value))
          .toList();
      if (_paymentsList.length > 0) {
        _firstDate = DateTime.fromMillisecondsSinceEpoch(
            _paymentsList.last.creationTimestamp.toInt() * 1000);
      }
      print("refresh payments finished " +
          payments.paymentsList.length.toString());
      return PaymentsModel(
          _paymentsList,
          _filterPayments(_paymentsList),
          _paymentFilterController.value,
          _firstDate ?? DateTime(DateTime.now().year));
    });
  }

  Future _refreshPayments() {
    return fetchPayments()
        .then((paymentModel) => _paymentsController.add(paymentModel))
        .catchError(_paymentsController.addError);
  }

  _filterPayments(List<PaymentInfo> paymentsList) {
    Set<PaymentInfo> paymentsSet = paymentsList
        .where(
            (p) => _paymentFilterController.value.paymentType.contains(p.type))
        .toSet();
    if (_paymentFilterController.value.startDate != null &&
        _paymentFilterController.value.endDate != null) {
      Set<PaymentInfo> _dateFilteredPaymentsSet = paymentsList
          .where((p) => (p.creationTimestamp.toInt() * 1000 >=
                  _paymentFilterController
                      .value.startDate.millisecondsSinceEpoch &&
              p.creationTimestamp.toInt() * 1000 <=
                  _paymentFilterController
                      .value.endDate.millisecondsSinceEpoch))
          .toSet();
      return _dateFilteredPaymentsSet.intersection(paymentsSet).toList();
    }
    return paymentsSet.toList();
  }

  void _listenAccountChanges() {
    StreamSubscription<NotificationEvent> eventSubscription;
    eventSubscription =
        Observable(_breezLib.notificationStream).listen((event) async {
      if (event.type ==
          NotificationEvent_NotificationType.LIGHTNING_SERVICE_DOWN) {
        _accountController
            .add(_accountController.value.copyWith(serverReady: false));
        _pollSyncStatus();
        if (!_retryingLightningService) {
          _retryingLightningService = true;
          _breezLib.restartLightningDaemon();
          return;
        }
        _retryingLightningService = false;
        _lightningDownController.add(true);
      }
      if (event.type == NotificationEvent_NotificationType.ACCOUNT_CHANGED) {
        _refreshAccountAndPayments();
      }
      if (event.type == NotificationEvent_NotificationType.READY) {
        _accountController
            .add(_accountController.value.copyWith(serverReady: true));
        _refreshAccountAndPayments();
      }
      if (event.type ==
          NotificationEvent_NotificationType.BACKUP_NODE_CONFLICT) {
        eventSubscription.cancel();
        _nodeConflictController.add(null);
      }
      if (event.type == NotificationEvent_NotificationType.PAYMENT_SUCCEEDED) {
        var paymentRequest = event.data[0];
        var invoice = await _breezLib.decodePaymentRequest(paymentRequest);
        _completedPaymentsController.add(CompletedPayment(
            PayRequest(paymentRequest, invoice.amount),
            cancelled: false,
            ignoreGlobalFeedback:
                _ignoredFeedbackPayments.containsKey(paymentRequest)));
        _ignoredFeedbackPayments.remove(paymentRequest);
      }
      if (event.type == NotificationEvent_NotificationType.PAYMENT_FAILED) {
        var paymentRequest = event.data[0];
        var error = event.data[1];
        var traceReport;
        if (event.data.length > 2) {
          traceReport = event.data[2];
        }
        var invoice = await _breezLib.decodePaymentRequest(paymentRequest);
        _completedPaymentsController.addError(PaymentError(
            PayRequest(paymentRequest, invoice.amount), error, traceReport,
            ignoreGlobalFeedback:
                _ignoredFeedbackPayments.containsKey(paymentRequest)));
        _ignoredFeedbackPayments.remove(paymentRequest);
      }
    });
  }

  Future _fetchAccount() {
    return _breezLib.getAccount().then((acc) {
      if (acc.id.isNotEmpty) {
        print("ACCOUNT CHANGED BALANCE=" +
            acc.balance.toString() +
            " STATUS = " +
            acc.status.toString());
        return _accountController.value.copyWith(
            accountResponse: acc,
            currency: _currentUser?.currency,
            fiatShortName: _currentUser?.fiatCurrency,
            initial: false);
      } else {
        return _accountController.value.copyWith(initial: false);
      }
    });
  }

  _refreshAccountAndPayments() async {
    print("Account bloc refreshing account...");
    await _fetchAccount()
        .then((acc) => _accountController.add(acc))
        .catchError(_accountController.addError);
    await _refreshPayments();
    if (_accountController.value.onChainFeeRate == null) {
      _breezLib.getDefaultOnChainFeeRate().then((rate) {
        if (rate.toInt() > 0) {
          _accountController
              .add(_accountController.value.copyWith(onChainFeeRate: rate));
        }
      });
    }
  }

  void _listenRoutingConnectionChanges() {
    Observable(_accountController.stream)
        .where((acc) => acc.connected || acc.processingConnection)
        .listen((acc) {
      if (!acc.readyForPayments) {
        _reconnectSink.add(null);
      }
    });
  }

  Future<String> getPersistentNodeID() async {
    var preferences = await ServiceInjector().sharedPreferences;
    return preferences.getString(PERSISTENT_NODE_ID_PREFERENCES_KEY);
  }

  _updateExchangeRates() {
    _getExchangeRate();
    _startExchangeRateTimer();
    _device.eventStream.listen((e) {
      if (e == NotificationType.RESUME) {
        _getExchangeRate();
        _startExchangeRateTimer();
      } else {
        // cancel timer when AppLifecycleState is paused, inactive or suspending
        _exchangeRateTimer?.cancel();
      }
    });
  }

  _startExchangeRateTimer() {
    _exchangeRateTimer = Timer.periodic(Duration(seconds: 30), (_) async {
      _getExchangeRate();
    });
  }

  Future _getExchangeRate() async {
    _currencyData = await _currencyService.currencies();
    Rates _rate = await _breezLib.rate();
    List<FiatConversion> _fiatConversionList = _rate.rates
        .map((rate) => FiatConversion(_currencyData[rate.coin], rate.value))
        .toList();
    _fiatConversionList.sort(
        (a, b) => a.currencyData.shortName.compareTo(b.currencyData.shortName));
    _accountController.add(_accountController.value.copyWith(
      fiatConversionList: _fiatConversionList,
      fiatShortName: _currentUser?.fiatCurrency,
    ));
  }

  close() {
    _accountEnableController.close();
    _paymentsController.close();
    _accountNotificationsController.close();
    _paymentFilterController.close();
    _lightningDownController.close();
    _reconnectStreamController.close();
    _routingNodeConnectionController.close();
    _broadcastRefundRequestController.close();
    _userActionsController.close();
    _permissionsHandler.dispose();
  }
}

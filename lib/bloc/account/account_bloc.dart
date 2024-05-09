import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/account_permissions_handler.dart';
import 'package:breez/bloc/account/account_synchronizer.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/async_action.dart';
import 'package:breez/bloc/csv_exporter.dart';
import 'package:breez/bloc/payment_options/payment_options_actions.dart';
import 'package:breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:breez/bloc/pos_catalog/repository.dart';
import 'package:breez/bloc/tor/bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/services/background_task.dart';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/services/currency_data.dart';
import 'package:breez/services/currency_service.dart';
import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/notifications.dart';
import 'package:breez/utils/retry.dart';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

final _log = Logger("AccountBloc");

class AccountBloc {
  static const FORCE_BOOTSTRAP_FILE_NAME = "FORCE_BOOTSTRAP";
  static const String ACCOUNT_SETTINGS_PREFERENCES_KEY = "account_settings";
  static const String PERSISTENT_NODE_ID_PREFERENCES_KEY = "PERSISTENT_NODE_ID";

  final Repository _posRepository;

  Timer _exchangeRateTimer;
  Map<String, CurrencyData> _currencyData;

  final _userActionsController = StreamController<AsyncAction>.broadcast();
  AccountSynchronizer _accountSynchronizer;
  Sink<AsyncAction> get userActionsSink => _userActionsController.sink;
  Map<Type, Function> _actionHandlers = {};

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

  final _lspActivityController = BehaviorSubject<LSPActivity>();
  Stream<LSPActivity> get lspActivityStream => _lspActivityController.stream;

  final _accountNotificationsController = StreamController<String>.broadcast();
  Stream<String> get accountNotificationsStream =>
      _accountNotificationsController.stream;

  final _completedPaymentsController =
      StreamController<CompletedPayment>.broadcast();
  Stream<CompletedPayment> get completedPaymentsStream =>
      _completedPaymentsController.stream;

  final Map<String, bool> _ignoredFeedbackPayments = <String, bool>{};

  Stream<PaymentInfo> get pendingPaymentStream {
    var newestPaymentTime =
        _paymentsController.value.paymentsList.first.creationTimestamp;
    return paymentsStream
        .map((ps) => ps.paymentsList.where((p) =>
            p.creationTimestamp > newestPaymentTime &&
            p.pending &&
            p.type == PaymentType.SENT))
        .expand((ps) => ps)
        .distinct((p1, p2) => p1?.paymentHash == p2?.paymentHash);
  }

  final _lightningDownController = StreamController<bool>.broadcast();
  Stream<bool> get lightningDownStream => _lightningDownController.stream;

  final BehaviorSubject<void> _nodeConflictController = BehaviorSubject<void>();
  Stream<void> get nodeConflictStream => _nodeConflictController.stream;

  final _nodeBackupNotLatestController = BehaviorSubject<void>();
  Stream<void> get nodeBackupNotLatestStream =>
      _nodeBackupNotLatestController.stream;

  final AccountPermissionsHandler _permissionsHandler =
      AccountPermissionsHandler();
  Stream<bool> get optimizationWhitelistExplainStream =>
      _permissionsHandler.optimizationWhitelistExplainStream;
  Sink get optimizationWhitelistRequestSink =>
      _permissionsHandler.optimizationWhitelistRequestSink;

  BreezUserModel _currentUser;
  bool _startedLightning = false;
  bool _retryingLightningService = false;
  BreezServer _breezServer;
  BreezBridge _breezLib;
  Notifications _notificationsService;
  Device _device;
  BackgroundTaskService _backgroundService;
  CurrencyService _currencyService;
  final Completer _onBoardingCompleter = Completer();
  Stream<BreezUserModel> userProfileStream;
  TorBloc torBloc = ServiceInjector().torBloc;
  Completer<bool> startDaemonCompleter = Completer<bool>();
  final PaymentOptionsBloc _paymentOptionsBloc;

  AccountBloc(
    this.userProfileStream,
    this._posRepository,
    this._paymentOptionsBloc,
  ) {
    init();
  }

  init() {
    _log.info("Account Bloc init");
    ServiceInjector injector = ServiceInjector();
    _breezServer = injector.breezServer;
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
      SendSpontaneousPayment: _sendSpontaneousPayment,
      CancelPaymentRequest: _cancelPaymentRequest,
      ChangeSyncUIState: _collapseSyncUI,
      FetchRates: _fetchRates,
      ResetChainService: _handleResetChainService,
      ExportPayments: _exportPaymentsAction,
      FetchPayments: _handleFetchPayments,
      SweepAllCoinsTxsAction: _sweepAllCoinsTransactions,
      PublishTransaction: _publishTransaction,
      CheckClosedChannelMismatchAction: _checkClosedChannelMismatch,
      ResetClosedChannelChainInfoAction: _resetClosedChannelChainInfoAction,
      SetNonBlockingUnconfirmedSwaps: _setNonBlockingUnconfirmedSwaps,
      CloseChannelsAction: _closeChannels,
    };

    _accountController.add(AccountModel.initial());
    _paymentsController.add(PaymentsModel.initial());
    _paymentFilterController.add(PaymentFilterModel.initial());
    _accountSettingsController.add(AccountSettings.initial());

    _start();
  }

  void _start() {
    _log.info("Account bloc started");

    ServiceInjector().sharedPreferences.then((preferences) async {
      _handleRegisterDeviceNode();
      _refreshAccountAndPayments();
      //listen streams
      _listenAccountActions();
      _handleAccountSettings();
      torBloc.torConfig = await _startTorIfNeeded();
      _listenUserChanges(userProfileStream);
      _listenFilterChanges();
      _listenAccountChanges();
      _listenMempoolTransactions();
      _listenRoutingConnectionChanges();
      _trackOnBoardingStatus();
      _listenEnableAccount();
      _log.info("Account finished registration of listeners");
    });
  }

  void setNodeUpgrading(bool upgrading) {
    _accountController
        .add(_accountController.value.copyWith(nodeUpgrading: upgrading));
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

  Future _handleRegisterDeviceNode() async {
    userProfileStream.listen((user) async {
      if (user.token != null) {
        var acc =
            await _accountController.firstWhere((acc) => acc.id?.isNotEmpty);
        try {
          await _breezServer.registerDevice(user.token, acc.id);
        } catch (e) {
          _log.severe("failed to register device ", e);
        }
      }
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
          _log.severe(
              "AccountAction: ${action.runtimeType.toString()} - Error: ${e.toString()}");
          action.resolveError(e);
        });
      }
    });
  }

  Future _fetchRates(FetchRates rates) async {
    if (_accountController.value.fiatConversionList.isEmpty) {
      await _getExchangeRate();
    }
    rates.resolve(_accountController.value.fiatConversionList);
  }

  List<FiatConversion> _sortFiatConversionList({
    List<FiatConversion> fiatConversionList,
  }) {
    var toSort = List<FiatConversion>.from(
        (fiatConversionList ?? _accountController.value.fiatConversionList));

    // First sort by name
    toSort.sort((f1, f2) =>
        f1.currencyData.shortName.compareTo(f2.currencyData.shortName));

    // Then give precedence to the preferred items.
    for (var p in _currentUser.preferredCurrencies.reversed) {
      var preferred = toSort.firstWhere((e) => e.currencyData.shortName == p,
          orElse: () => null);
      if (preferred != null) {
        toSort.remove(preferred);
        toSort.insert(0, preferred);
      }
    }
    return toSort;
  }

  Future _handleSendQueryRoute(SendPaymentFailureReport action) async {
    Map<String, dynamic> jsonReport = json.decode(action.traceReport);
    jsonReport["app version"] = await _device.appVersion();
    JsonEncoder encoder = const JsonEncoder.withIndent('\t');
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

  Future _checkClosedChannelMismatch(
      CheckClosedChannelMismatchAction action) async {
    action.resolve(await _breezLib.checkLSPClosedChannelMismatch(
        action.lsp, action.channelPoint));
  }

  Future _resetClosedChannelChainInfoAction(
      ResetClosedChannelChainInfoAction action) async {
    action.resolve(await _breezLib.resetClosedChannelChainInfo(
        action.blockHeight, action.channelPoint));
  }

  Future _exportPaymentsAction(ExportPayments action) async {
    List<PaymentInfo> currentPaymentList = _filterPayments(
      _paymentsController.value.paymentsList,
    );
    List<CsvData> data = [];
    for (var paymentInfo in currentPaymentList) {
      final sale = await _posRepository.fetchSaleByPaymentHash(
        paymentInfo.paymentHash,
      );
      data.add(CsvData(paymentInfo, sale));
    }
    action.resolve(
      await CsvExporter(data, _paymentFilterController.value).export(),
    );
  }

  Future _handleResetChainService(ResetChainService action) async {
    var workingDir = await _breezLib.getWorkingDir();
    var bootstrapFile = File("${workingDir.path}/$FORCE_BOOTSTRAP_FILE_NAME");
    action.resolve(await bootstrapFile.create(recursive: true));
  }

  Future _handleRestartDaemon(RestartDaemon action) async {
    action.resolve(await _breezLib.restartLightningDaemon());
  }

  Future _fetchFundStatusAction(FetchSwapFundStatus action) async {
    action.resolve(await _fetchFundStatus());
  }

  Future _setNonBlockingUnconfirmedSwaps(
      SetNonBlockingUnconfirmedSwaps action) async {
    action.resolve(await _breezLib.setNonBlockingUnconfirmedSwaps());
  }

  Future _sendSpontaneousPayment(SendSpontaneousPayment action) async {
    var sendRequest = _breezLib
        .sendSpontaneousPayment(
            action.nodeID, action.amount, action.description)
        .then((response) {
      if (response.paymentError.isNotEmpty) {
        var error =
            PaymentError(null, response.paymentError, response.traceReport);
        _completedPaymentsController.addError(error);
        return Future.error(error);
      }
      _completedPaymentsController
          .add(const CompletedPayment(null, null, null));
      return response;
    });

    _backgroundService.runAsTask(sendRequest, () {
      _log.info("sendPayment background task finished");
    });
    action.resolve(await sendRequest);
  }

  Future _sendPayment(SendPayment action) async {
    var payRequest = action.paymentRequest;
    _log.info('_sendPayment: paymentRequest = ${payRequest.paymentRequest}');

    if (action.ignoreGlobalFeedback) {
      _ignoredFeedbackPayments[payRequest.paymentRequest] = true;
    }
    final fee = await _calculateFee(payRequest.amount.toInt());
    var sendRequest = _breezLib
        .sendPaymentForRequest(
      payRequest.paymentRequest,
      amount: payRequest.amount,
      fee: Int64(fee),
    )
        .then((response) async {
      if (response.paymentError.isNotEmpty) {
        var error = PaymentError(
          payRequest,
          response.paymentError,
          response.traceReport,
          ignoreGlobalFeedback: action.ignoreGlobalFeedback,
        );
        _completedPaymentsController.addError(error);
        return Future.error(error);
      }

      final paymentHash =
          await _breezLib.getPaymentRequestHash(payRequest.paymentRequest);
      _log.info(
          '_sendPayment: getPaymentRequestHash found paymentHash  $paymentHash for paymentRequest ${payRequest.paymentRequest}');

      PaymentInfo currentPayment;
      if (paymentHash != '') {
        var allPayments = await fetchPayments();
        currentPayment = allPayments.paymentsList.firstWhere(
            (element) => element.paymentHash == paymentHash,
            orElse: () => null);
      }

      _completedPaymentsController.add(CompletedPayment(
          payRequest, paymentHash, currentPayment,
          ignoreGlobalFeedback: action.ignoreGlobalFeedback == true));
      return response;
    });

    _backgroundService.runAsTask(sendRequest, () {
      _log.info("sendPayment background task finished");
    });
    action.resolve(await sendRequest);
  }

  Future _cancelPaymentRequest(CancelPaymentRequest cancelRequest) async {
    var paymentHash = await _breezLib
        .getPaymentRequestHash(cancelRequest.paymentRequest.paymentRequest);
    _completedPaymentsController.add(CompletedPayment(
        cancelRequest.paymentRequest, paymentHash, null,
        cancelled: true));
    return Future.value(null);
  }

  Future _collapseSyncUI(ChangeSyncUIState stateAction) {
    _accountController.add(
        _accountController.value.copyWith(syncUIState: stateAction.nextState));
    return Future.value(null);
  }

  void _trackOnBoardingStatus() {
    _accountController
        .where((acc) => !acc.initial && acc.synced)
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
      _log.info(
          "_listenConnectivityChanges: connection changed to: $connectivityResult");
      if (connectivityResult != ConnectivityResult.none) {
        _reconnectSink.add(null);
      }
    });
  }

  void _listenReconnects() {
    Future connectingFuture = Future.value(null);
    _reconnectStreamController.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((_) async {
      connectingFuture = connectingFuture.whenComplete(() async {
        var acc = _accountController.value;
        _log.info(
            "Checking if reconnect needed for account: connected=${acc.connected} readyForPayment=${acc.readyForPayments} processingConnection=${acc.processingConnection}");

        if (acc.connected && acc.readyForPayments == false ||
            acc.processingConnection) {
          _log.info("Reconnecting...");
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
      _log.severe(message.toString());
      if (message["msg"] == "Unconfirmed transaction" &&
          message["user_click"] == null) {
        _accountNotificationsController.add(message["body"].toString());
      }
      _fetchFundStatus();
    });

    _device.eventStream.where((e) => e == NotificationType.RESUME).listen((e) {
      _log.info(
          "App Resumed - flutter resume called, adding reconnect request");
      _reconnectSink.add(null);
    });
  }

  Future<TorConfig> _startTorIfNeeded() async {
    if (Platform.isAndroid) {
      // Start tor
      final useTor = await _breezLib.getTorActive();
      _log.info('AccountBloc: useTor : $useTor.');
      if (useTor) {
        _log.info('accountBloc.listenUserChanges: using Tor');
        try {
          torBloc.torConfig ??= await torBloc.startTor();
        } catch (e) {
          _lightningDownController.add(false);
        }
        // throw error
        if (torBloc.torConfig != null) {
          _breezLib.setBackupTorConfig(torBloc.torConfig);
        }
      }
    }
    return torBloc.torConfig;
  }

  _listenUserChanges(Stream<BreezUserModel> userProfileStream) {
    userProfileStream.listen((user) async {
      if (user.token != null && user.token != _currentUser?.token) {
        _log.info(
            "user profile bloc registering for channel open notifications");
        _breezLib.registerChannelOpenedNotification(user.token);
      }
      _currentUser = user;
      _log.info("account: got new user $user");
      //convert currency.
      _accountController.add(_accountController.value.copyWith(
        currency: user.currency,
        fiatShortName: user.fiatCurrency,
        posCurrencyShortName: user.posCurrencyShortName,
        preferredCurrencies: user.preferredCurrencies,
        fiatConversionList: _sortFiatConversionList(
            fiatConversionList: _accountController.value.fiatConversionList),
      ));

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
          _log.info(
              "Account bloc got registered user, starting lightning daemon...");
          _startedLightning = true;
          _pollSyncStatus();
          _backgroundService.runAsTask(_onBoardingCompleter.future, () {
            _log.info("onboarding background task finished");
          });
          _log.info("account: starting lightning...");
          try {
            TorConfig c = torBloc.torConfig;
            _log.info("Starting lightning with $c");
            await _breezLib.startLightning(torBloc.torConfig);
            _log.info("account: lightning started");
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
              const Duration(days: 3);
          var syncUIState = _accountController.value.syncUIState;
          if ((moreThan3DaysOff || newNode) &&
              _accountController.value.syncUIState == SyncUIState.NONE &&
              !blockingPrompted) {
            blockingPrompted = true;
            syncUIState = SyncUIState.COLLAPSED;
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
      _log.severe("fund status = ${status.writeToJson()}");
      _accountController
          .add(_accountController.value.copyWith(addedFundsReply: status));
    }).catchError((err) {
      _log.severe("Error in getFundStatus $err");
    });
  }

  void _listenFilterChanges() {
    _paymentFilterController.stream.skip(1).listen((filter) {
      _refreshPayments();
    });
  }

  Future<PaymentsModel> fetchPayments() async {
    DateTime firstDate;
    _log.info("refreshing payments...");

    final hashedSales = await _posRepository.fetchSaleSummaryByPaymentHashes();

    _log.info("refreshing payments after fetching sales hashes...");
    return _breezLib.getPayments().then((payments) {
      List<PaymentInfo> paymentsList = payments.paymentsList
          .map((payment) => SinglePaymentInfo(
                payment,
                _accountController.value,
                hashedSales[payment.paymentHash],
              ))
          .toList();

      if (paymentsList.isNotEmpty) {
        firstDate = DateTime.fromMillisecondsSinceEpoch(
          paymentsList.last.creationTimestamp.toInt() * 1000,
        );
      }
      _log.info("refresh payments finished ${payments.paymentsList.length}");
      return PaymentsModel(
        paymentsList,
        _filterPayments(paymentsList),
        _paymentFilterController.value,
        firstDate ?? DateTime(DateTime.now().year),
      );
    });
  }

  Future _refreshPayments() {
    _log.info("before _refreshPayments");
    return fetchPayments()
        .then((paymentModel) => _paymentsController.add(paymentModel))
        .catchError((Object err, [StackTrace stack]) {
      _log.severe("failed to fetch payments $err");
      _paymentsController.addError(err, stack);
    });
  }

  List<PaymentInfo> _groupPayments(List<PaymentInfo> paymentsList) {
    var groupedPayments = groupBy<PaymentInfo, String>(paymentsList, (p) {
      return p.paymentGroup;
    });

    var payments = <PaymentInfo>[];
    groupedPayments.forEach((key, singles) {
      if (singles[0].paymentHash == key) {
        payments.add(singles[0]);
      } else {
        payments.add(StreamedPaymentInfo(singles, _accountController.value));
      }
    });
    return payments;
  }

  _refreshLSPActivity() {
    _breezLib.lspActivity().then((lspActivity) {
      _log.info("--- LSPActivity ---\n$lspActivity");
      _lspActivityController.add(lspActivity);
    });
  }

  _filterPayments(List<PaymentInfo> paymentsList) {
    Set<PaymentInfo> paymentsSet = _groupPayments(paymentsList)
        .where(
            (p) => _paymentFilterController.value.paymentType.contains(p.type))
        .toSet();
    if (_paymentFilterController.value.startDate != null &&
        _paymentFilterController.value.endDate != null) {
      Set<PaymentInfo> dateFilteredPaymentsSet = paymentsList
          .where((p) => (p.creationTimestamp.toInt() * 1000 >=
                  _paymentFilterController
                      .value.startDate.millisecondsSinceEpoch &&
              p.creationTimestamp.toInt() * 1000 <=
                  _paymentFilterController
                      .value.endDate.millisecondsSinceEpoch))
          .toSet();
      return dateFilteredPaymentsSet.intersection(paymentsSet).toList();
    }
    return paymentsSet.toList();
  }

  void _listenAccountChanges() {
    StreamSubscription<NotificationEvent> eventSubscription;
    eventSubscription = _breezLib.notificationStream.listen((event) async {
      _log.info('_breezLib.notificationStream received: ${event.type}.');
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
        _log.info("ACCOUNT_CHANGED event triggers _refreshAccountAndPayments");
        _refreshAccountAndPayments();
      }
      if (event.type == NotificationEvent_NotificationType.READY) {
        _accountController
            .add(_accountController.value.copyWith(serverReady: true));
        _log.info("READY event triggers _refreshAccountAndPayments");
        _refreshAccountAndPayments();
      }

      if (event.type ==
          NotificationEvent_NotificationType.BACKUP_NODE_CONFLICT) {
        eventSubscription.cancel();
        _nodeConflictController.add(null);
      }

      if (event.type ==
          NotificationEvent_NotificationType.BACKUP_NOT_LATEST_CONFLICT) {
        _log.info("BACKUP_NOT_LATEST_CONFLICT event triggered");
        eventSubscription.cancel();
        _nodeBackupNotLatestController.add(null);
      }

      if (event.type == NotificationEvent_NotificationType.PAYMENT_SUCCEEDED) {
        var paymentRequest = event.data[0];
        var paymentHash = event.data[1];
        _log.info(
            '_listenAccountChanges: Payment succeeded with paymentHash = $paymentHash');
        PayRequest payRequest;

        if (paymentRequest.isNotEmpty) {
          var invoice = await _breezLib.decodePaymentRequest(paymentRequest);
          payRequest = PayRequest(paymentRequest, invoice.amount);
        }

        _completedPaymentsController.add(CompletedPayment(
            payRequest, paymentHash, null,
            cancelled: false,
            ignoreGlobalFeedback:
                _ignoredFeedbackPayments.containsKey(paymentRequest)));
        _ignoredFeedbackPayments.remove(paymentRequest);
      }

      if (event.type == NotificationEvent_NotificationType.PAYMENT_FAILED) {
        var paymentRequest = event.data[0];
        var error = event.data[2];
        String traceReport;
        if (event.data.length > 3) {
          traceReport = event.data[3];
        }
        PayRequest payRequest;
        if (paymentRequest.isNotEmpty) {
          var invoice = await _breezLib.decodePaymentRequest(paymentRequest);
          payRequest = PayRequest(paymentRequest, invoice.amount);
        }
        _completedPaymentsController.addError(PaymentError(
            payRequest, error, traceReport,
            ignoreGlobalFeedback:
                _ignoredFeedbackPayments.containsKey(paymentRequest)));
        _ignoredFeedbackPayments.remove(paymentRequest);
      }
    });
  }

  Future _fetchAccount() {
    return _breezLib.getAccount().then((acc) {
      _log.info("_fetchAccount id: ${acc.id}");
      if (acc.id.isNotEmpty) {
        _log.info(
            "ACCOUNT CHANGED BALANCE=${acc.balance} STATUS = ${acc.status}");
        return _accountController.value.copyWith(
            accountResponse: acc,
            currency: _currentUser?.currency,
            fiatShortName: _currentUser?.fiatCurrency,
            preferredCurrencies: _currentUser?.preferredCurrencies,
            initial: false);
      } else {
        _log.info("_fetchAccount: setting initial account");
        return _accountController.value.copyWith(initial: false);
      }
    });
  }

  _refreshAccountAndPayments() async {
    _log.info("Account bloc refreshing payments...");
    await _refreshPayments();

    _log.info("Account bloc refreshing account...");
    await _fetchAccount()
        .then((acc) => _accountController.add(acc))
        .catchError((Object err, [StackTrace stack]) {
      _log.severe("failed to fetch account $err");
      _accountController.addError(err, stack);
    });
    _refreshLSPActivity();
    if (_accountController.value.onChainFeeRate == null) {
      _breezLib.getDefaultOnChainFeeRate().then((defaultOnChainFeeRate) {
        if (defaultOnChainFeeRate.toInt() > 0) {
          _accountController.add(
            _accountController.value.copyWith(
              onChainFeeRate: defaultOnChainFeeRate,
            ),
          );
        }
      });
    }
  }

  void _listenRoutingConnectionChanges() {
    _accountController.stream
        .distinct((acc1, acc2) {
          return acc1?.readyForPayments == acc2?.readyForPayments;
        })
        .where((acc) =>
            !acc.readyForPayments &&
            (acc.connected || acc.processingConnection))
        .skip(1)
        .listen((acc) {
          _reconnectSink.add(null);
        });
  }

  Future<String> getPersistentNodeID() async {
    var preferences = await ServiceInjector().sharedPreferences;
    return preferences.getString(PERSISTENT_NODE_ID_PREFERENCES_KEY);
  }

  Future _updateExchangeRates() {
    return retry(_getExchangeRate, interval: const Duration(seconds: 5))
        .whenComplete(() {
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
    });
  }

  _startExchangeRateTimer() {
    _exchangeRateTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      _getExchangeRate();
    });
  }

  Future _getExchangeRate() async {
    _currencyData = await _currencyService.currencies();
    Rates rate = await _breezLib.rate();
    List<FiatConversion> fiatConversionList = rate.rates
        .map((rate) => FiatConversion(_currencyData[rate.coin], rate.value))
        .toList();
    fiatConversionList =
        _sortFiatConversionList(fiatConversionList: fiatConversionList);
    _accountController.add(_accountController.value.copyWith(
      fiatConversionList: fiatConversionList,
      fiatShortName: _currentUser?.fiatCurrency,
      preferredCurrencies: _currentUser?.preferredCurrencies,
    ));
  }

  Future<int> _calculateFee(int amount) async {
    final calculateFee = CalculateFee(amount);
    _paymentOptionsBloc.actionsSink.add(calculateFee);
    return await calculateFee.future;
  }

  Future _closeChannels(CloseChannelsAction action) async {
    var response = await _breezLib.closeChannels(action.address);
    action.resolve(response.channels);
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

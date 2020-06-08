import 'dart:async';
import 'dart:io';
import 'package:breez/logger.dart' as logger;
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ini/ini.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'graph_downloader.dart';

// This is the bridge to the native breez library. Protobuf messages are used as the interface and to generate the classes use the bellow command.
// Note that the version of protoc comiler must be 3-4-0
// protoc --dart_out=grpc:lib/services/breezlib/data/ -Ilib/services/breezlib/ lib/services/breezlib/rpc.proto
class BreezBridge {
  static const _methodChannel = MethodChannel('com.breez.client/breez_lib');
  static const _eventChannel =
      EventChannel('com.breez.client/breez_lib_notifications');

  Completer _readyCompleter = Completer();
  Completer _startedCompleter = Completer();
  StreamController _eventsController =
      StreamController<NotificationEvent>.broadcast();
  Stream<NotificationEvent> get notificationStream => _eventsController.stream;
  bool ready = false;
  Future<Directory> _tempDirFuture;
  GraphDownloader _graphDownloader;
  Future<DateTime> _inProgressGraphSync;

  BreezBridge() {
    _eventChannel.receiveBroadcastStream().listen((event) async {
      var notification = NotificationEvent()..mergeFromBuffer(event);
      if (notification.type == NotificationEvent_NotificationType.READY) {
        ready = true;
        _readyCompleter.complete();
      }
      if (notification.type ==
          NotificationEvent_NotificationType.LIGHTNING_SERVICE_DOWN) {
        _readyCompleter = Completer();
      }
      _eventsController.add(NotificationEvent()..mergeFromBuffer(event));
    });
    _tempDirFuture = getTemporaryDirectory();
    _graphDownloader = GraphDownloader();
    _graphDownloader.init().whenComplete(() => initLightningDir());
  }

  Future syncGraphIfNeeded() async {
    var downloadURL = await graphURL();
      if (downloadURL.isNotEmpty) {
        logger.log.info("downloading graph");
      _inProgressGraphSync = _graphDownloader.downloadGraph(downloadURL).then((file) async {
        logger.log.info("graph synchronization started");
        await syncGraphFromFile(file.path);
        logger.log.info("graph synchronized succesfully");
        return DateTime.now();
      }).whenComplete(() {
        _graphDownloader.deleteDownloads();
      });
    }
  }

  initLightningDir() {
    logger.log.info("initLightningDir started");

    getApplicationDocumentsDirectory().then((workingDir) {
      return copyBreezConfig(workingDir.path).then((_) async {
        var tmpDir = await _tempDirFuture;
        await init(workingDir.path, tmpDir.path);
        Timer(Duration(seconds: 2), syncGraphIfNeeded);
        logger.log.info("breez library init finished");
        _startedCompleter.complete(true);
      });
    });
  }

  Future<Directory> getWorkingDir() {
    return getApplicationDocumentsDirectory();
  }

  Future init(String appDir, String tmpDir) {
    return _methodChannel
        .invokeMethod("init", {"workingDir": appDir, "tempDir": tmpDir});
  }

  Future<Rates> rate() {
    return _invokeMethodImmediate("rate")
        .then((result) => Rates()..mergeFromBuffer(result ?? []));
  }

  Future startLightning() {
    return _startedCompleter.future.then((_) => _start());
  }

  Future restartLightningDaemon() {
    return _methodChannel.invokeMethod("restartDaemon");
  }

  Future _start() async {
    print(" breez bridge - start...");
    return _methodChannel.invokeMethod("start").then((_) {
      print(" breez bridge - start lightning finished");
    });
  }

  Future stop({bool permanent = false}) {
    return _methodChannel.invokeMethod("stop", {"permanent": permanent});
  }

  Future syncGraphFromFile(String sourceFilePath) {
    return _invokeMethodImmediate(
        "syncGraphFromFile", {"argument": sourceFilePath});
  }

  void log(String msg, String level) {
    _invokeMethodImmediate("log", {"msg": msg, "lvl": level});
  }

  Future<LNUrlResponse> fetchLNUrl(String lnurl) {
    return _invokeMethodImmediate("fetchLnurl", {"argument": lnurl})
        .then((result) => LNUrlResponse()..mergeFromBuffer(result ?? []));
  }

  Future withdrawLNUrl(String bolt11Invoice) {
    return _invokeMethodWhenReady("withdrawLnurl", {"argument": bolt11Invoice});
  }

  Future<String> getLogPath() {
    return getApplicationDocumentsDirectory().then((workingDir) {
      return workingDir.path + "/logs/bitcoin/mainnet/lnd.log";
    });
  }

  Future<int> lastSyncedHeaderTimestamp() {
    return _invokeMethodImmediate("lastSyncedHeaderTimestamp")
        .then((res) => res as int);
  }

  Future<Account> getAccount() {
    return _invokeMethodImmediate("getAccountInfo")
        .then((result) => Account()..mergeFromBuffer(result ?? []));
  }

  Future<bool> isConnectedToRoutingNode() {
    return _invokeMethodWhenReady("isConnectedToRoutingNode")
        .then((result) => result as bool);
  }

  Future connectAccount() {
    return _invokeMethodWhenReady("connectAccount");
  }

  Future<LSPList> getLSPList() {
    return _invokeMethodWhenReady("lspList")
        .then((result) => LSPList()..mergeFromBuffer(result ?? []));
  }

  Future connectToLSP(String lspID) {
    return _invokeMethodWhenReady("connectToLSP", {"argument": lspID});
  }

  Future connectToLnurl(String lnurl) {
    return _invokeMethodWhenReady("connectToLnurl", {"argument": lnurl});
  }

  Future connectDirectToLnurl(String uri, String k1, String callback) {
    var channel = LNURLChannel()
      ..uri = uri
      ..k1 = k1
      ..callback = callback;
    return _invokeMethodWhenReady(
        "connectDirectToLnurl", {"argument": channel.writeToBuffer()});
  }

  Future<SweepAllCoinsTransactions> sweepAllCoinsTransactions(String address) {
    return _invokeMethodWhenReady(
            "sweepAllCoinsTransactions", {"argument": address})
        .then((res) => SweepAllCoinsTransactions()..mergeFromBuffer(res ?? []));
  }

  Future publishTransaction(List<int> tx) {
    return _invokeMethodWhenReady("publishTransaction", {"argument": tx});
  }

  Future<ReverseSwapInfo> getReverseSwapPolicy() {
    return _invokeMethodWhenReady("reverseSwapInfo", {})
        .then((res) => ReverseSwapInfo()..mergeFromBuffer(res ?? []));
  }

  Future<String> newReverseSwap(String address, Int64 amount) {
    ReverseSwapRequest request = ReverseSwapRequest()
      ..address = address
      ..amount = amount;
    return _invokeMethodWhenReady(
            "newReverseSwap", {"argument": request.writeToBuffer()})
        .then((res) => res as String);
  }

  Future<ReverseSwap> fetchReverseSwap(String hash) {
    return _invokeMethodWhenReady("fetchReverseSwap", {"argument": hash})
        .then((res) => ReverseSwap()..mergeFromBuffer(res ?? []));
  }

  Future payReverseSwap(
      String hash, String token, String ntfnTitle, String ntfnBody) {
    var ntfnDetails = PushNotificationDetails()
      ..title = ntfnTitle
      ..body = ntfnBody
      ..deviceId = token;
    var request = ReverseSwapPaymentRequest()
      ..pushNotificationDetails = ntfnDetails
      ..hash = hash;
    return _invokeMethodWhenReady(
        "payReverseSwap", {"argument": request.writeToBuffer()});
  }

  Future<ClaimFeeEstimates> reverseSwapClaimFeeEstimates(String claimAddress) {
    return _invokeMethodWhenReady(
            "reverseSwapClaimFeeEstimates", {"argument": claimAddress})
        .then((res) => ClaimFeeEstimates()..mergeFromBuffer(res ?? []));
  }

  Future setReverseSwapClaimFee(String hash, Int64 fee) {
    var arg = ReverseSwapClaimFee()
      ..fee = fee
      ..hash = hash;
    return _invokeMethodWhenReady(
        "setReverseSwapClaimFee", {"argument": arg.writeToBuffer()});
  }

  Future<String> unconfirmedReverseSwapClaimTransaction() {
    return _invokeMethodWhenReady("unconfirmedReverseSwapClaimTransaction")
        .then((s) => s as String);
  }

  Future<ReverseSwapPaymentStatuses> reverseSwapPayments() {
    return _invokeMethodWhenReady("reverseSwapPayments")
        .then((p) => ReverseSwapPaymentStatuses()..mergeFromBuffer(p ?? []));
  }

  Future<PaymentResponse> sendSpontaneousPayment(
      String destNode, Int64 amount, String description) {
    var request = SpontaneousPaymentRequest()
      ..description = description
      ..destNode = destNode
      ..amount = amount;

    var payFunc = () => _invokeMethodWhenReady(
            "sendSpontaneousPayment", {"argument": request.writeToBuffer()})
        .then((res) => PaymentResponse()..mergeFromBuffer(res ?? []));

    return _invokePaymentWithGraphSyncAndRetry(payFunc);
  }

  Future<PaymentResponse> sendPaymentForRequest(
      String blankInvoicePaymentRequest,
      {Int64 amount}) {
    PayInvoiceRequest invoice = PayInvoiceRequest();
    if (amount == null) {
      amount = Int64(0);
    }
    invoice.amount = amount;
    invoice.paymentRequest = blankInvoicePaymentRequest;

    var payFunc = () => _invokeMethodWhenReady(
                "sendPaymentForRequest", {"argument": invoice.writeToBuffer()})
            .then((value) {
          return PaymentResponse()..mergeFromBuffer(value ?? []);
        });

    return _invokePaymentWithGraphSyncAndRetry(payFunc);
  }

  Future<PaymentResponse> _invokePaymentWithGraphSyncAndRetry(
      Future<PaymentResponse> payFunc()) async {
    
    var startPaymentTime = DateTime.now();
    logger.log.info("payment started at ${startPaymentTime.toString()}");
    try {
      var response = await payFunc();
      if (response.paymentError.isNotEmpty) {
        throw response.paymentError;
      }
      return response;
    } catch (err) {
      logger.log.info("payment failed, checking if graph sync is needed");
      if (_inProgressGraphSync != null) {
        logger.log.info("has pending graph sync task, wating...");
        try {
          var lastSyncTime = await _inProgressGraphSync;
          if (lastSyncTime.isAfter(startPaymentTime)) {
            logger.log.info("last sync time is newer than payment start, retrying payment...");
            var res = await payFunc();
            return res;
          }
        } catch (e) {
          return Future.error(e);
        }
      }
      return Future.error(err);
    }
  }

  Future<String> graphURL() {
    return _invokeMethodImmediate("graphURL")
        .then((result) => result as String);
  }

  Future sendPaymentFailureBugReport(String traceReport) {
    return _invokeMethodWhenReady(
        "sendPaymentFailureBugReport", {"argument": traceReport});
  }

  Future<PaymentsList> getPayments() {
    return _invokeMethodImmediate("getPayments")
        .then((result) => PaymentsList()..mergeFromBuffer(result ?? []));
  }

  Future<Peers> getPeers() {
    return _invokeMethodImmediate("getPeers")
        .then((result) => Peers()..mergeFromBuffer(result ?? []));
  }

  Future setPeers(List<String> peers) {
    Peers p = Peers();
    p.peer
      ..clear()
      ..addAll(peers);
    return _invokeMethodImmediate("setPeers", {"argument": p.writeToBuffer()});
  }

  Future testPeer(String address) {
    return _invokeMethodImmediate("testPeer", {"argument": address});
  }

  Future deleteGraph() {
    return _invokeMethodImmediate("deleteGraph", {});
  }

  Future<String> addInvoice(Int64 amount,
      {String payeeName,
      String payeeImageURL,
      String payerName,
      String payerImageURL,
      String description,
      Int64 expiry}) {
    InvoiceMemo invoice = InvoiceMemo();
    invoice.amount = amount;
    if (payeeImageURL != null) {
      invoice.payeeImageURL = payeeImageURL;
    }
    if (payeeName != null) {
      invoice.payeeName = payeeName;
    }
    if (payerImageURL != null) {
      invoice.payerImageURL = payerImageURL;
    }
    if (payerName != null) {
      invoice.payerName = payerName;
    }
    if (description != null) {
      invoice.description = description;
    }

    return _invokeMethodWhenReady(
            "addInvoice", {"argument": invoice.writeToBuffer()})
        .then((payReq) => payReq as String);
  }

  Future<CreateRatchetSessionReply> createRatchetSession(
      String sessionID, Int64 expiry,
      {String secret, String remotePubKey}) {
    var request = CreateRatchetSessionRequest()
      ..sessionID = sessionID
      ..expiry = expiry
      ..secret = secret ?? ""
      ..remotePubKey = remotePubKey ?? "";
    return _invokeMethodImmediate(
            "createRatchetSession", {"argument": request.writeToBuffer()})
        .then((res) => CreateRatchetSessionReply()..mergeFromBuffer(res ?? []));
  }

  Future<RatchetSessionInfoReply> ratchetSessionInfo(String sessionID) {
    return _invokeMethodImmediate("ratchetSessionInfo", {"argument": sessionID})
        .then((res) => RatchetSessionInfoReply()..mergeFromBuffer(res ?? []));
  }

  Future ratchetSessionSetInfo(String sessionID, String userInfo) {
    RatchetSessionSetInfoRequest request = RatchetSessionSetInfoRequest()
      ..sessionID = sessionID
      ..userInfo = userInfo;
    return _invokeMethodImmediate(
        "ratchetSessionSetInfo", {"argument": request.writeToBuffer()});
  }

  Future<String> ratchetEncrypt(String sessionID, String message) {
    var request = RatchetEncryptRequest()
      ..message = message
      ..sessionID = sessionID;
    return _invokeMethodImmediate(
            "ratchetEncrypt", {"argument": request.writeToBuffer()})
        .then((res) => res as String);
  }

  Future<String> ratchetDecrypt(String sessionID, String encryptedMessage) {
    var request = RatchetDecryptRequest()
      ..encryptedMessage = encryptedMessage
      ..sessionID = sessionID;
    return _invokeMethodImmediate(
            "ratchetDecrypt", {"argument": request.writeToBuffer()})
        .then((res) => res as String);
  }

  Future<Invoice> getRelatedInvoice(String paymentRequest) {
    return _invokeMethodWhenReady(
            "getRelatedInvoice", {"argument": paymentRequest})
        .then((invoiceData) => Invoice()..mergeFromBuffer(invoiceData));
  }

  Future<InvoiceMemo> decodePaymentRequest(String payReq) {
    return _invokeMethodWhenReady("decodePaymentRequest", {"argument": payReq})
        .then((result) => InvoiceMemo()..mergeFromBuffer(result ?? []));
  }

  Future<String> getPaymentRequestHash(String payReq) {
    return _invokeMethodWhenReady("getPaymentRequestHash", {"argument": payReq})
        .then((result) => result as String);
  }

  Future<String> newAddress(String breezID) {
    return _invokeMethodWhenReady("newAddress", {"argument": breezID})
        .then((address) => address as String);
  }

  Future<AddFundInitReply> addFundsInit(String breezID) {
    return _invokeMethodWhenReady("addFundsInit", {"argument": breezID})
        .then((reply) => AddFundInitReply()..mergeFromBuffer(reply ?? []));
  }

  Future<String> refund(String address, String refundAddress, Int64 feeRate) {
    var refundRequest = RefundRequest()
      ..satPerByte = feeRate
      ..address = address
      ..refundAddress = refundAddress;
    return _invokeMethodWhenReady(
            "refund", {"argument": refundRequest.writeToBuffer()})
        .then((txID) => txID as String);
  }

  Future<FundStatusReply> getFundStatus(String notificationToken) {
    return _invokeMethodWhenReady(
            "getFundStatus", {"argument": notificationToken})
        .then((result) => FundStatusReply()..mergeFromBuffer(result ?? []));
  }

  Future registerReceivePaymentReadyNotification(String token) {
    return _invokeMethodWhenReady(
        "registerReceivePaymentReadyNotification", {"argument": token});
  }

  Future registerChannelOpenedNotification(String token) {
    return _invokeMethodWhenReady(
        "registerChannelOpenedNotification", {"argument": token});
  }

  Future<String> sendCommand(String command) {
    return _invokeMethodWhenReady("sendCommand", {"argument": command})
        .then((response) => response as String);
  }

  Future checkVersion() {
    return _invokeMethodWhenReady("checkVersion");
  }

  Future<String> validateAddress(String address) {
    String addr = address;
    if (addr.startsWith("bitcoin:")) {
      addr = addr.substring(8);
    }
    return _invokeMethodWhenReady("validateAddress", {"argument": addr})
        .then((response) => addr);
  }

  Future<Int64> getDefaultOnChainFeeRate() {
    return _invokeMethodImmediate("getDefaultOnChainFeeRate")
        .then((res) => Int64(res as int));
  }

  Future registerPeriodicSync(String token) {
    return _invokeMethodImmediate("registerPeriodicSync", {"argument": token});
  }

  Future requestBackup() {
    return _invokeMethodWhenReady("requestBackup");
  }

  Future setBackupEncryptionKey(
      List<int> encryptionKey, String encryptionType) {
    return _invokeMethodImmediate("setBackupEncryptionKey", {
      "encryptionKey": encryptionKey,
      "encryptionType": encryptionType ?? ""
    });
  }

  Future setBackupProvider(String backupProvider) {
    return _invokeMethodImmediate(
        "setBackupProvider", {"argument": backupProvider});
  }

  Future<String> getAvailableBackups() async {
    await signIn(true);
    return await _methodChannel
        .invokeMethod("availableSnapshots")
        .then((res) => res as String);
  }

  Future restore(String nodeId, List<int> encryptionKey) async {
    try {
      await _methodChannel.invokeMethod(
          "restoreBackup", {"nodeID": nodeId, "encryptionKey": encryptionKey});
    } on PlatformException catch (e) {
      throw e.message;
    }
  }

  Future<dynamic> signIn(bool force) {
    return _methodChannel.invokeMethod("signIn", {"force": force});
  }

  Future<dynamic> signOut() {
    return _methodChannel.invokeMethod("signOut");
  }

  Future copyBreezConfig(String workingDir) async {
    logger.log.info("copyBreezConfig started");

    File file = File(workingDir + "/breez.conf");
    String configString = await rootBundle.loadString('conf/breez.conf');
    file.writeAsStringSync(configString, flush: true);

    File lndConf = File(workingDir + "/lnd.conf");
    String data = await rootBundle.loadString('conf/lnd.conf');
    lndConf.writeAsStringSync(data, flush: true);

    logger.log.info("copyBreezConfig finished");
  }

  Future _invokeMethodWhenReady(String methodName, [dynamic arguments]) {
    return _readyCompleter.future.then((completed) {
      return _methodChannel
          .invokeMethod(methodName, arguments)
          .catchError((err) {
        if (err.runtimeType == PlatformException) {
          throw (err as PlatformException).message;
        }
        throw err;
      });
    });
  }

  Future enableAccount(bool enabled) {
    return _invokeMethodWhenReady("enableAccount", {"argument": enabled});
  }

  Future _invokeMethodImmediate(String methodName, [dynamic arguments]) {
    return _startedCompleter.future.then((completed) {
      return _methodChannel
          .invokeMethod(methodName, arguments)
          .catchError((err) {
        if (err.runtimeType == PlatformException) {
          print("Error in calling method " + methodName);
          throw (err as PlatformException).message;
        }
        throw err;
      });
    });
  }

  Future<List<String>> getWalletDBpFilePath() async {
    String lines = await rootBundle.loadString('conf/breez.conf');
    var config = Config.fromString(lines);
    String lndDir = (await getApplicationDocumentsDirectory()).path;
    String network = config.get('Application Options', 'network');
    return [
      '$lndDir/data/chain/bitcoin/$network/admin.macaroon',
      '$lndDir/data/chain/bitcoin/$network/backupevents.macaroon',
      '$lndDir/data/chain/bitcoin/$network/breezbackup.macaroon',
      '$lndDir/data/chain/bitcoin/$network/chainnotifier.macaroon',
      '$lndDir/data/chain/bitcoin/$network/invoice.macaroon',
      '$lndDir/data/chain/bitcoin/$network/invoices.macaroon',
      '$lndDir/data/chain/bitcoin/$network/readonly.macaroon',
      '$lndDir/data/chain/bitcoin/$network/router.macaroon',
      '$lndDir/data/chain/bitcoin/$network/signer.macaroon',
      '$lndDir/data/chain/bitcoin/$network/submarineswap.macaroon',
      '$lndDir/data/chain/bitcoin/$network/walletkit.macaroon',
      '$lndDir/data/chain/bitcoin/$network/macaroons.db'
    ];
  }
}


import 'dart:async';
import 'dart:io';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/breezlib/lnd_bootstrapper.dart';
import 'package:breez/services/breezlib/progress_downloader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

// This is the bridge to the native breez library. Protobuf messages are used as the interface and to generate the classes use the bellow command.
// Note that the version of protoc comiler must be 3-4-0
// protoc --dart_out=grpc:lib/services/breezlib/data/ -Ilib/services/breezlib/ lib/services/breezlib/rpc.proto
class BreezBridge {
  static const _methodChannel = const MethodChannel('com.breez.client/breez_lib');
  static const _eventChannel = const EventChannel('com.breez.client/breez_lib_notifications');

  BehaviorSubject<Map<String, DownloadFileInfo>> _bootstrapDownloadProgressController = new BehaviorSubject<Map<String, DownloadFileInfo>>();
  Stream<Map<String, DownloadFileInfo>> get chainBootstrapProgress => _bootstrapDownloadProgressController.stream;


  Completer _readyCompleter = new Completer();
  Completer _startedCompleter = new Completer();
  StreamController _eventsController = new StreamController<NotificationEvent>.broadcast();
  Stream<NotificationEvent> get notificationStream => _eventsController.stream;
  bool ready = false;  
  Future<Directory> _tempDirFuture;  
  Future<Directory> _copyConfigTasks;

  BreezBridge(){
    _eventChannel.receiveBroadcastStream().listen((event){
      var notification = new NotificationEvent()..mergeFromBuffer(event);
      if (notification.type == NotificationEvent_NotificationType.READY){
        ready = true;
        _readyCompleter.complete();
      }
      _eventsController.add(new NotificationEvent()..mergeFromBuffer(event));
    });
    _tempDirFuture = getTemporaryDirectory();    
    initLightningDir();    
  }

  initLightningDir(){
    print("initLightningDir started");
    
    _copyConfigTasks = getApplicationDocumentsDirectory()
      .then((workingDir) {
        return copyBreezConfig(workingDir.path)
          .then((_) => workingDir);
      });
  }

  Future init(String appDir) {    
    return _methodChannel.invokeMethod("init", {"argument": appDir});
  }

  Future start(String workingDir) async{
    print(" breez bridge - start...");  
    Directory tempDir = await _tempDirFuture;    
    return _methodChannel.invokeMethod("start", {
      "workingDir": workingDir,
      "tempDir": tempDir.path
    })
    .then((_) { 
      print(" breez bridge - start lightning finished");          
    });    
  }

  Future stop({bool permanent = false}){
    return _methodChannel.invokeMethod("stop", {"permanent": permanent});
  }

  Future requestBackup(){
    return _invokeMethodWhenReady("requestBackup");
  }

  void log(String msg, String level) {
    _invokeMethodImmediate("log", {"msg": msg, "lvl": level});
  }

  Future<String> getLogPath() {
    return _invokeMethodWhenReady("getLogPath").then( (logPath) => logPath as String);
  }

  Future<Account> getAccount() {
    return _invokeMethodImmediate("getAccountInfo")
        .then((result) => new Account()..mergeFromBuffer(result ?? []));
  }

  Future<bool> isConnectedToRoutingNode() {
    return _invokeMethodWhenReady("isConnectedToRoutingNode")
        .then((result) => result as bool);
  }

  Future connectAccount(){
    return _invokeMethodWhenReady("connectAccount");
  }

  Future<RemoveFundReply> removeFund(String address, Int64 amount){
    RemoveFundRequest request = new RemoveFundRequest()
      ..address = address
      ..amount = amount;
    return _invokeMethodWhenReady("removeFund", {"argument": request.writeToBuffer()})
        .then( (res) => new RemoveFundReply()..mergeFromBuffer(res ?? []));
  }

  Future sendPaymentForRequest(String blankInvoicePaymentRequest, {Int64 amount}) {
    PayInvoiceRequest invoice = new PayInvoiceRequest();
    if (amount == null) {
      amount = Int64(0);
    }
    invoice.amount = amount;
    invoice.paymentRequest = blankInvoicePaymentRequest;
    return _invokeMethodWhenReady("sendPaymentForRequest", {"argument": invoice.writeToBuffer()}).then((payReq) => payReq as String);
  }

  Future bootstrapFiles(String workingDir, List<String> bootstrapFilesPaths) {
    BootstrapFilesRequest bootstrap = new BootstrapFilesRequest();
    bootstrap.workingDir = workingDir;
    bootstrap.fullPaths..clear()..addAll(bootstrapFilesPaths);
    return _methodChannel.invokeMethod("bootstrapFiles", {"argument": bootstrap.writeToBuffer()});
  }

  Future<PaymentsList> getPayments(){
    return _invokeMethodImmediate("getPayments")
        .then((result) => new PaymentsList()..mergeFromBuffer(result ?? []));
  }

  Future<String> addInvoice(Int64 amount, {String payeeName, String payeeImageURL, String payerName, String payerImageURL, String description, Int64 expiry, bool standard = false}){
    InvoiceMemo invoice = new InvoiceMemo();
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

    if (standard) {
      return _invokeMethodWhenReady(
          "addStandardInvoice", {"argument": invoice.writeToBuffer()}).then((
          payReq) => payReq as String);

    }
    else {
      return _invokeMethodWhenReady(
          "addInvoice", {"argument": invoice.writeToBuffer()}).then((
          payReq) => payReq as String);
    }
  }

  Future<CreateRatchetSessionReply> createRatchetSession(String sessionID, Int64 expiry, {String secret, String remotePubKey}) {
    var request = CreateRatchetSessionRequest()
      ..sessionID = sessionID
      ..expiry = expiry
      ..secret = secret ?? ""      
      ..remotePubKey = remotePubKey ?? "";
    return _invokeMethodImmediate("createRatchetSession", {"argument": request.writeToBuffer()}).then((res) =>  new CreateRatchetSessionReply()..mergeFromBuffer(res ?? []));
  }

  Future<RatchetSessionInfoReply> ratchetSessionInfo(String sessionID) {
    return _invokeMethodImmediate("ratchetSessionInfo", {"argument": sessionID}).then((res) =>  new RatchetSessionInfoReply()..mergeFromBuffer(res ?? []));
  }

  Future ratchetSessionSetInfo(String sessionID, String userInfo) {
    RatchetSessionSetInfoRequest request = RatchetSessionSetInfoRequest()
      ..sessionID = sessionID
      ..userInfo = userInfo;
    return _invokeMethodImmediate("ratchetSessionSetInfo", {"argument": request.writeToBuffer()});
  }

  Future<String> ratchetEncrypt(String sessionID, String message) {
    var request =  RatchetEncryptRequest()
      ..message = message
      ..sessionID = sessionID;
    return _invokeMethodImmediate("ratchetEncrypt", {"argument": request.writeToBuffer()}).then((res) =>  res as String);
  }

  Future<String> ratchetDecrypt(String sessionID, String encryptedMessage) {
    var request =  RatchetDecryptRequest()
      ..encryptedMessage = encryptedMessage
      ..sessionID = sessionID;
    return _invokeMethodImmediate("ratchetDecrypt", {"argument": request.writeToBuffer()}).then((res) =>  res as String);
  }

  Future<Invoice> getRelatedInvoice(String paymentRequest) {
    return _invokeMethodWhenReady("getRelatedInvoice", {"argument": paymentRequest})
        .then((invoiceData) => new Invoice()..mergeFromBuffer(invoiceData));
  }

  Future<InvoiceMemo> decodePaymentRequest(String payReq) {
    return _invokeMethodWhenReady("decodePaymentRequest", {"argument": payReq})
        .then( (result) => new InvoiceMemo()..mergeFromBuffer(result ?? []));
  }

  Future<String> newAddress(String breezID) {
    return _invokeMethodWhenReady("newAddress", {"argument": breezID}).then( (address) => address as String);
  }

  Future<AddFundInitReply> addFundsInit(String breezID) {
    return _invokeMethodWhenReady("addFundsInit", {"argument": breezID}).then((reply) => new AddFundInitReply()..mergeFromBuffer(reply ?? []));
  }

  Future<SwapAddressList> getRefundableSwapAddresses() {
    return _invokeMethodWhenReady("getRefundableSwapAddresses").then((reply) => new SwapAddressList()..mergeFromBuffer(reply ?? []));
  }

  Future<String> refund(String address, String refundAddress) {
    var refundRequest = RefundRequest()
      ..address = address
      ..refundAddress = refundAddress;
    return _invokeMethodWhenReady("refund",  {"argument": refundRequest.writeToBuffer()}).then((txID) => txID as String);
  }

  Future<FundStatusReply> getFundStatus(String notificationToken) {
    return _invokeMethodImmediate("getFundStatus", {"argument": notificationToken}).then(
            (result) => new FundStatusReply()..mergeFromBuffer(result ?? [])
    );
  }

  Future registerReceivePaymentReadyNotification(String token) {
    return _invokeMethodWhenReady("registerReceivePaymentReadyNotification", {"argument": token});       
  }

  Future registerChannelOpenedNotification(String token) {
    return _invokeMethodWhenReady("registerChannelOpenedNotification", {"argument": token});       
  }

  Future<String> sendCommand(String command) {
    return _invokeMethodWhenReady("sendCommand", {"argument": command})
        .then( (response) => response as String);
  }

  Future<String> validateAddress(String address) {
    String addr = address;
    if (addr.startsWith("bitcoin:")) {
      addr = addr.substring(8);
    }
    return _invokeMethodWhenReady("validateAddress", {"argument": addr})
        .then( (response) => addr);
  }

  Future<String> sendWalletCoins(String address, Int64 amount, Int64 satPerByteFee){
    var request = 
      SendWalletCoinsRequest()
        ..address = address
        ..amount = amount
        ..satPerByteFee = satPerByteFee;
    return _invokeMethodWhenReady("sendWalletCoins", {"argument": request.writeToBuffer()}).then((txid) => txid as String);        
  }

  Future<Int64> getDefaultOnChainFeeRate(){
    return _invokeMethodImmediate("getDefaultOnChainFeeRate").then((res) => Int64( res as int));        
  }

  Future registerPeriodicSync(String token){
    return _invokeMethodImmediate("registerPeriodicSync", {"argument": token});        
  }

  Future<String> getBackupIdentifier() {
    return _invokeMethodImmediate("getBackupIdentifier").then((res) => res as String);
  }

  Future copyBreezConfig(String workingDir) async{
    print("copyBreezConfig started");
    
    File file = File(workingDir + "/breez.conf");        
    String configString = await rootBundle.loadString('conf/breez.conf');      
    file.writeAsStringSync(configString, flush: true);          
    
    File lndConf = File(workingDir + "/lnd.conf");    
    String data = await rootBundle.loadString('conf/lnd.conf');      
    lndConf.writeAsStringSync(data, flush: true);    
    
    print("copyBreezConfig finished");
  }

  Future _invokeMethodWhenReady(String methodName, [dynamic arguments]) {
    return _readyCompleter.future.then(
            (completed) {
          return _methodChannel.invokeMethod(methodName, arguments).catchError((err){
            if (err.runtimeType == PlatformException) {
              throw (err as PlatformException).details;
            }
            throw err;
          });
        }
    );
  }

  Future _invokeMethodImmediate(String methodName, [dynamic arguments]) {
    return _startedCompleter.future.then(
            (completed) {            
          return _methodChannel.invokeMethod(methodName, arguments).catchError((err){
            if (err.runtimeType == PlatformException) {
              print("Error in calling method " + methodName);
              throw (err as PlatformException).details;
            }
            throw err;
          });        
        }
    );
  }

  Future<void> bootstrap() async {
    return getApplicationDocumentsDirectory().then(
            (appDir) {
          var lndBootstrapper = new LNDBootstrapper();
          lndBootstrapper.bootstrapProgressStreams
            .listen((downloadFileInfo) {
              var aggregatedStatus = Map<String, DownloadFileInfo>();
              if (_bootstrapDownloadProgressController.value != null) {
                aggregatedStatus.addAll(_bootstrapDownloadProgressController.value);
              }
              aggregatedStatus[downloadFileInfo.fileURL] = downloadFileInfo;
              _bootstrapDownloadProgressController.add(aggregatedStatus);
            },
            onError: (err){
              print("Error");
              _bootstrapDownloadProgressController.addError(err);
            },
            onDone: () {
              _bootstrapDownloadProgressController.close();
              return;
            });
          return lndBootstrapper.downloadBootstrapFiles(appDir.path);
        }
    );
  }

  Future startLightning() {    
    return _copyConfigTasks.then((appDir) async {
      if (!_startedCompleter.isCompleted) {
        await init(appDir.path);  
        _startedCompleter.complete(true);
      }
      return start(appDir.path);
    });
  }
}

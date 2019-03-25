import 'dart:async';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/nfc.dart';
import 'package:breez/services/notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:breez/services/lightning_links.dart';
import 'package:breez/services/device.dart';

class InvoiceBloc {

  final _newInvoiceRequestController = StreamController<InvoiceRequestModel>();
  Sink<InvoiceRequestModel> get newInvoiceRequestSink => _newInvoiceRequestController.sink;

  final _newLightningLinkController = StreamController<String>();
  Sink<String> get newLightningLinkSink => _newLightningLinkController.sink;

  final _readyInvoicesController = new BehaviorSubject<String>();
  Stream<String> get readyInvoicesStream => _readyInvoicesController.stream;

  final _sentInvoicesController = new StreamController<String>.broadcast();
  Stream<String> get sentInvoicesStream => _sentInvoicesController.stream;

  final _decodeInvoiceController = new StreamController<String>();
  Sink<String> get decodeInvoiceSink => _decodeInvoiceController.sink;

  final _receivedInvoicesController = new BehaviorSubject<PaymentRequestModel>();
  Stream<PaymentRequestModel> get receivedInvoicesStream => _receivedInvoicesController.stream;

  final _paidInvoicesController = new StreamController<bool>.broadcast();
  Stream<bool> get paidInvoicesStream => _paidInvoicesController.stream;

  Int64 payBlankAmount = Int64(-1);

  InvoiceBloc() {
    ServiceInjector injector = new ServiceInjector();
    BreezBridge breezLib = injector.breezBridge;    
    NFCService nfc = injector.nfc;
    BreezServer server = injector.breezServer;
    Notifications notificationsService = injector.notifications;
    LightningLinksService lightningLinks = ServiceInjector().lightningLinks;
    Device device = injector.device;

    _listenInvoiceRequests(breezLib, nfc);
    _listenNFCStream(nfc, server, breezLib);
    _listenIncomingInvoices(notificationsService, breezLib, nfc, lightningLinks, device);    
    _listenPaidInvoices(breezLib);    
  }

  void _listenInvoiceRequests(BreezBridge breezLib, NFCService nfc) {
    _newInvoiceRequestController.stream.listen((invoiceRequest){
      _readyInvoicesController.add(null);
      breezLib.addInvoice(invoiceRequest.amount, payeeName: invoiceRequest.payeeName, payeeImageURL: invoiceRequest.logo, description: invoiceRequest.description, expiry: invoiceRequest.expiry)
        .then( (paymentRequest) { 
          nfc.startBolt11Beam(paymentRequest);
          log.info("Payment Request");
          log.info(paymentRequest);
          _readyInvoicesController.add(paymentRequest);
        })
        .catchError(_readyInvoicesController.addError);
    });
  }

  void _listenNFCStream(NFCService nfc, BreezServer server, BreezBridge breezLib) {
    nfc.receivedBreezIds().listen((breezID) async {
      if (_readyInvoicesController.value != null) {
        log.info("Breez card was detected, sending payment request...");
        _sentInvoicesController.add("Breez card was detected...");

        var paymentRequest = _readyInvoicesController.value;

        var memo = await breezLib.decodePaymentRequest(paymentRequest);
        var amount = memo.amount;
        var payee = memo.payeeName;

        server.sendInvoice(breezID, paymentRequest, payee, amount)
        .then((res) => _sentInvoicesController.add("Payment request was sent!"))
        .catchError(_sentInvoicesController.addError);
      }
    });
  }

  // void _listenIncomingBlankInvoices(BreezBridge breezLib, NFCService nfc) {
  //   nfc.receivedBlankInvoices().listen((invoice) {
  //     breezLib.sendPaymentForRequest(invoice, amount: payBlankAmount).catchError(_paidInvoicesController.addError);
  //   }).onError(_paidInvoicesController.addError);
  // }

  void _listenIncomingInvoices(Notifications notificationService, BreezBridge breezLib, NFCService nfc, LightningLinksService links, Device device) {
    Observable<String>.merge([
      Observable(notificationService.notifications)      
        .where((message) => message.containsKey("payment_request"))
        .map((message) {
          return message["payment_request"];
        }),
      nfc.receivedBolt11s(),
      _decodeInvoiceController.stream,
      _newLightningLinkController.stream,
      links.linksNotifications,
      device.deviceClipboardStream
        .where((s) => s.toLowerCase().startsWith("ln") || s.toLowerCase().startsWith("lightning:"))        
    ])
    .map((s) {
      String lower = s.toLowerCase();
      if (lower.startsWith("lightning:")) {
        return s.substring(10);
      }
      return s;
    })
    .asyncMap((paymentRequest) {
      // add stream event before processing and decoding
      _receivedInvoicesController.add(
          new PaymentRequestModel(null, paymentRequest));
      //filter out our own payment requests
      return breezLib.getRelatedInvoice(paymentRequest)
        .then((invoice) {
          log.info("filtering our invoice from clipboard");
          _receivedInvoicesController.addError(new PaymentRequestModel(null, paymentRequest));
          return null;
        })
        .catchError((_) {
          log.info("detected not ours invoice, continue to decoding");
          return paymentRequest;
        });      
    })
    .where((paymentRequest) => paymentRequest != null)    
    .asyncMap( (paymentRequest) {       
      return breezLib.decodePaymentRequest(paymentRequest)
        .then( (invoice) => new PaymentRequestModel(invoice, paymentRequest));          
    })    
    .listen(_receivedInvoicesController.add)
    .onError(_receivedInvoicesController.addError);
  }

  void _listenPaidInvoices(BreezBridge breezLib) {
    breezLib.notificationStream
        .where((event) => event.type == NotificationEvent_NotificationType.INVOICE_PAID)
        .listen((invoice) {
          _paidInvoicesController.add(true);
    });
  }

  close() {    
    _newInvoiceRequestController.close();
    _newLightningLinkController.close();
    _sentInvoicesController.close();
    _receivedInvoicesController.close();
    _paidInvoicesController.close();
    _decodeInvoiceController.close();
  }
}

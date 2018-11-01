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
  Sink<InvoiceRequestModel> get newInvoicerequestSink => _newInvoiceRequestController.sink;

  final _newStandardInvoiceRequestController = StreamController<InvoiceRequestModel>();
  Sink<InvoiceRequestModel> get newStandardInvoiceRequestSink => _newStandardInvoiceRequestController.sink;

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
    _listenIncomingBlankInvoices(breezLib, nfc);
    _listenPaidInvoices(breezLib);
    _listenDecodeInvoiceRequests(breezLib);
  }

  void _listenInvoiceRequests(BreezBridge breezLib, NFCService nfc) {
    _newStandardInvoiceRequestController.stream.listen((invoiceRequest){
      breezLib.addStandardInvoice(invoiceRequest.amount, invoiceRequest.description)
          .then( (paymentRequest) {
        _readyInvoicesController.add(paymentRequest);
      })
          .catchError(_readyInvoicesController.addError);
    });

    _newInvoiceRequestController.stream.listen((invoiceRequest){       
      breezLib.addInvoice( invoiceRequest.amount, invoiceRequest.payeeName, invoiceRequest.logo, description: invoiceRequest.description)
        .then( (paymentRequest) { 
          nfc.startBolt11Beam(paymentRequest);
          log.info("payment request");
          log.info(paymentRequest);
          _readyInvoicesController.add(paymentRequest);
        })
        .catchError(_readyInvoicesController.addError);
    });
  }

  void _listenDecodeInvoiceRequests(BreezBridge breezLib) {
    _decodeInvoiceController.stream.listen((bolt11){
      breezLib.decodePaymentRequest(bolt11)
          .then( (paymentRequest) {
        _receivedInvoicesController.add(PaymentRequestModel(paymentRequest, bolt11));
      })
          .catchError(_receivedInvoicesController.addError);
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

  void _listenIncomingBlankInvoices(BreezBridge breezLib, NFCService nfc) {
    nfc.receivedBlankInvoices().listen((invoice) {
      breezLib.payBlankInvoice(invoice, payBlankAmount).catchError(_paidInvoicesController.addError);
    }).onError(_paidInvoicesController.addError);
  }

  void _listenIncomingInvoices(Notifications notificationService, BreezBridge breezLib, NFCService nfc, LightningLinksService links, Device device) {
    Observable<String>.merge([
      Observable(notificationService.notifications)      
        .where((message) => message["msg"] == "Payment request" || message.containsKey("payment_request"))
        .asyncMap((message) {
          if (message.containsKey("payment_request")) {
            return message["payment_request"];
          }
          else {
            return message["invoice"];
          }
        }),
      nfc.receivedBolt11s(),
      links.linksNotifications,
      device.deviceClipboardStream.distinct()
    ])
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
    _newStandardInvoiceRequestController.close();
    _sentInvoicesController.close();
    _receivedInvoicesController.close();
    _paidInvoicesController.close();
    _decodeInvoiceController.close();
  }
}

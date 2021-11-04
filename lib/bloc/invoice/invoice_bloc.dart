import 'dart:async';

import 'package:breez/bloc/invoice/actions.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/lightning_links.dart';
import 'package:breez/services/nfc.dart';
import 'package:breez/services/notifications.dart';
import 'package:breez/utils/bip21.dart';
import 'package:breez/utils/node_id.dart';
import 'package:breez/utils/lnurl.dart';
import 'package:fixnum/fixnum.dart';
import 'package:rxdart/rxdart.dart';

import '../async_actions_handler.dart';

class InvoiceBloc with AsyncActionsHandler {
  final _newInvoiceRequestController = StreamController<InvoiceRequestModel>();
  Sink<InvoiceRequestModel> get newInvoiceRequestSink =>
      _newInvoiceRequestController.sink;

  final _newLightningLinkController = StreamController<String>();
  Sink<String> get newLightningLinkSink => _newLightningLinkController.sink;

  final _readyInvoicesController = BehaviorSubject<PaymentRequestModel>();
  Stream<PaymentRequestModel> get readyInvoicesStream =>
      _readyInvoicesController.stream;

  final _sentInvoicesController = StreamController<String>.broadcast();
  Stream<String> get sentInvoicesStream => _sentInvoicesController.stream;

  final _decodeInvoiceController = StreamController<String>();
  Sink<String> get decodeInvoiceSink => _decodeInvoiceController.sink;

  final _receivedInvoicesController = BehaviorSubject<PaymentRequestModel>();
  Stream<PaymentRequestModel> get receivedInvoicesStream =>
      _receivedInvoicesController.stream;

  final _paidInvoicesController =
      StreamController<PaymentRequestModel>.broadcast();
  Stream<PaymentRequestModel> get paidInvoicesStream =>
      _paidInvoicesController.stream;

  Int64 payBlankAmount = Int64(-1);
  BreezBridge _breezLib;
  Device device;

  InvoiceBloc() {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    NFCService nfc = injector.nfc;
    Notifications notificationsService = injector.notifications;
    LightningLinksService lightningLinks = ServiceInjector().lightningLinks;
    device = injector.device;

    _listenInvoiceRequests(_breezLib, nfc);
    _listenIncomingInvoices(
        notificationsService, _breezLib, nfc, lightningLinks, device);
    _listenPaidInvoices(_breezLib);
    registerAsyncHandlers({
      NewInvoice: _newInvoice,
    });
    listenActions();
  }

  Stream<Future<DecodedClipboardData>> get decodedClipboardStream =>
      device.rawClipboardStream.map((clipboardData) async {
        if (clipboardData != null && parseNodeId(clipboardData) != null) {
          return DecodedClipboardData(parseNodeId(clipboardData), "nodeID");
        }
        String normalized = clipboardData?.toLowerCase();
        if (normalized == null) {
          return null;
        }
        if (normalized.startsWith("lightning:")) {
          normalized = normalized.substring(10);
        }

        if (normalized.startsWith("lnurl")) {
          return DecodedClipboardData(clipboardData, "lnurl");
        }

        if (isLightningAddress(normalized)) {
          return DecodedClipboardData(normalized, "lightning-address");
        }

        if (normalized.startsWith("ln")) {
          try {
            await _breezLib.getRelatedInvoice(clipboardData);
            return null;
          } catch (e) {
            return DecodedClipboardData(clipboardData, "invoice");
          }
        }
        return null;
      }).where((event) => event != null);

  void _listenInvoiceRequests(BreezBridge breezLib, NFCService nfc) {
    _newInvoiceRequestController.stream.listen((invoiceRequest) {
      _readyInvoicesController.add(null);
      breezLib
          .addInvoice(invoiceRequest.amount,
              payeeName: invoiceRequest.payeeName,
              payeeImageURL: invoiceRequest.logo,
              description: invoiceRequest.description,
              expiry: invoiceRequest.expiry)
          .then((payReq) async {
        log.info("Payment Request: " + payReq.paymentRequest);
        var memo = await _breezLib.decodePaymentRequest(payReq.paymentRequest);
        var paymentHash =
            await _breezLib.getPaymentRequestHash(payReq.paymentRequest);
        _readyInvoicesController.add(PaymentRequestModel(
            memo, payReq.paymentRequest, paymentHash, payReq.lspFee));
      }).catchError(_readyInvoicesController.addError);
    });
  }

  Future _newInvoice(NewInvoice action) async {
    var invoiceRequest = action.request;
    var payReq = await _breezLib.addInvoice(invoiceRequest.amount,
        payeeName: invoiceRequest.payeeName,
        payeeImageURL: invoiceRequest.logo,
        description: invoiceRequest.description,
        expiry: invoiceRequest.expiry);
    var memo = await _breezLib.decodePaymentRequest(payReq.paymentRequest);
    var paymentHash =
        await _breezLib.getPaymentRequestHash(payReq.paymentRequest);
    action.resolve(PaymentRequestModel(
        memo, payReq.paymentRequest, paymentHash, payReq.lspFee));
  }

  void _listenIncomingInvoices(
      Notifications notificationService,
      BreezBridge breezLib,
      NFCService nfc,
      LightningLinksService links,
      Device device) {
    Rx.merge([
      notificationService.notifications
          .where((message) => message.containsKey("payment_request"))
          .map((message) {
        return message["payment_request"];
      }),
      nfc.receivedLnLinks(),
      _decodeInvoiceController.stream,
      _newLightningLinkController.stream,
      links.linksNotifications,
      device.distinctClipboardStream.where((s) =>
          s.toLowerCase().startsWith("ln") ||
          s.toLowerCase().startsWith("lightning:"))
    ])
        .map((s) {
          if (isLightningAddress(s)) {
            return null;
          }

          String lower = s.toLowerCase();
          if (lower.startsWith("lightning:")) {
            return s.substring(10);
          }

          // check bip21 with bolt11
          String bolt11 = extractBolt11FromBip21(lower);
          if (bolt11 != null) {
            return bolt11;
          }

          return s;
        })
        .where((s) => !s.toLowerCase().startsWith("lnurl"))
        .asyncMap((paymentRequest) async {
          // add stream event before processing and decoding
          _receivedInvoicesController
              .add(PaymentRequestModel(null, paymentRequest, null, Int64(0)));

          //filter out our own payment requests
          try {
            await breezLib.getRelatedInvoice(paymentRequest);
            log.info("filtering our invoice from clipboard");
            _receivedInvoicesController.add(null);
            _receivedInvoicesController.addError(
                PaymentRequestModel(null, paymentRequest, null, Int64(0)));
            return null;
          } catch (e) {
            log.info("detected not our invoice, continue to decoding");
            return paymentRequest;
          }
        })
        .where((paymentRequest) => paymentRequest != null)
        .asyncMap((paymentRequest) {
          log.info('Decoding invoice.');
          return breezLib.decodePaymentRequest(paymentRequest).then(
              (invoice) async {
            var paymentHash =
                await breezLib.getPaymentRequestHash(paymentRequest);
            return PaymentRequestModel(
                invoice, paymentRequest, paymentHash, Int64(0));
          }).catchError((err) =>
              throw PaymentRequestError("Lightning invoice was not found."));
        })
        .listen(_receivedInvoicesController.add)
        .onError(_receivedInvoicesController.addError);
  }

  void _listenPaidInvoices(BreezBridge breezLib) {
    breezLib.notificationStream
        .where((event) =>
            event.type == NotificationEvent_NotificationType.INVOICE_PAID)
        .listen((invoice) async {
      var payReq = invoice.data[0];
      var memo = await _breezLib.decodePaymentRequest(payReq);
      var paymentHash = await _breezLib.getPaymentRequestHash(payReq);
      _paidInvoicesController
          .add(PaymentRequestModel(memo, payReq, paymentHash, Int64(0)));
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

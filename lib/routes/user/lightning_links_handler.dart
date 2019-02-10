import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';

class LightningLinksHandler {
  final BuildContext _context;
  final Stream<PaymentRequestModel> _receivedInvoicesStream;

  LightningLinksHandler(this._context, this._receivedInvoicesStream) {
    _receivedInvoicesStream.listen((PaymentRequestModel message) async {
      try {
        if (!message.loaded) {
          Navigator.of(_context).push(createLoaderRoute(_context));
        }
      } catch (e) {
        Navigator.popUntil(
            _context, ModalRoute.withName(Navigator.defaultRouteName));
      }
    });
  }
}

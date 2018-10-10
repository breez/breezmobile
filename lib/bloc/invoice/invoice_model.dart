import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:fixnum/fixnum.dart';

class InvoiceRequestModel {
  final String payeeName;
  final String description;
  final String logo;
  final Int64 amount;

  InvoiceRequestModel(this.payeeName, this.description, this.logo, this.amount);  
}

class PaymentRequestModel {
  final InvoiceMemo _invoice;
  final String _rawPayReq;

  PaymentRequestModel(this._invoice, this._rawPayReq); 

  String get description => _invoice.description;
  String get payeeImageURL => _invoice.payeeImageURL;
  String get payeeName => _invoice.payeeName;
  Int64 get amount => _invoice.amount;
  String get rawPayReq => _rawPayReq;
}
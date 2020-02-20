import 'package:breez/bloc/async_action.dart';

import 'invoice_model.dart';

class NewInvoice extends AsyncAction {
  final InvoiceRequestModel request;

  NewInvoice(this.request);
}

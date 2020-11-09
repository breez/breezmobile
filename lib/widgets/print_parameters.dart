import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';

class PrintParameters {
  final BreezUserModel currentUser;
  final CurrencyWrapper currentCurrency;
  final AccountModel account;
  final Sale submittedSale;
  final PaymentInfo paymentInfo;

  PrintParameters(
      {this.currentUser,
      this.currentCurrency,
      this.account,
      this.submittedSale,
      this.paymentInfo});
}

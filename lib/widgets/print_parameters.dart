import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';

class PrintParameters {
  final BreezUserModel currentUser;
  final AccountModel account;
  final Sale submittedSale;
  final PaymentInfo paymentInfo;

  PrintParameters({
    this.currentUser,
    this.account,
    this.submittedSale,
    this.paymentInfo,
  });
}

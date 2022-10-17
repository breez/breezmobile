import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/bloc/pos_catalog/model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/clovr_user_model.dart';

class PrintParameters {
  final ClovrUserModel currentUser;
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

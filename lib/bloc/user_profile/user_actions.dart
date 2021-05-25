import 'package:breez/bloc/async_action.dart';
import 'package:breez/bloc/podcast_payments/payment_options.dart';

import 'breez_user_model.dart';
import 'security_model.dart';

class UpdateSecurityModel extends AsyncAction {
  final SecurityModel newModel;

  UpdateSecurityModel(this.newModel);
}

class UpdatePreferredCurrencies extends AsyncAction {
  final List<String> currencies;

  UpdatePreferredCurrencies(this.currencies);
}

class ResetSecurityModel extends AsyncAction {}

class UpdatePinCode extends AsyncAction {
  final String newPin;

  UpdatePinCode(this.newPin);
}

class ValidatePinCode extends AsyncAction {
  final String enteredPin;

  ValidatePinCode(this.enteredPin);
}

class ChangeTheme extends AsyncAction {
  final String newTheme;

  ChangeTheme(this.newTheme);
}

class ValidateBiometrics extends AsyncAction {
  final String localizedReason;

  ValidateBiometrics({this.localizedReason});
}

class GetEnrolledBiometrics extends AsyncAction {}

class SetLockState extends AsyncAction {
  final bool locked;

  SetLockState(this.locked);
}

class StopBiometrics extends AsyncAction {}

class CheckVersion extends AsyncAction {}

class SetAppMode extends AsyncAction {
  final AppMode appMode;

  SetAppMode(this.appMode);
}

class SetAdminPassword extends AsyncAction {
  final String password;

  SetAdminPassword(this.password);
}

class VerifyAdminPassword extends AsyncAction {
  final String password;

  VerifyAdminPassword(this.password);
}

class UploadProfilePicture extends AsyncAction {
  final List<int> bytes;

  UploadProfilePicture(this.bytes);
}

class SetPOSCurrency extends AsyncAction {
  final String shortName;

  SetPOSCurrency(this.shortName);
}

class SetPaymentOptions extends AsyncAction {
  final PaymentOptions paymentOptions;

  SetPaymentOptions(this.paymentOptions);
}

class SetSeenPodcastTutorial extends AsyncAction {
  final bool seen;

  SetSeenPodcastTutorial(this.seen);
}

class SetSeenPaymentStripTutorial extends AsyncAction {
  final bool seen;

  SetSeenPaymentStripTutorial(this.seen);
}

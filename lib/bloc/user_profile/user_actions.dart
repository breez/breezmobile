import 'package:breez/bloc/async_action.dart';

import 'security_model.dart';

class UpdateSecurityModel extends AsyncAction {
  final SecurityModel newModel;

  UpdateSecurityModel(this.newModel);
}

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

class SetLockState extends AsyncAction {
  final bool locked;

  SetLockState(this.locked);
}
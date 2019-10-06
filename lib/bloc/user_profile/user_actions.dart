import 'package:breez/bloc/async_action.dart';
import 'package:breez/themes.dart';

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
  final ThemeId newTheme;

  ChangeTheme(this.newTheme);
}
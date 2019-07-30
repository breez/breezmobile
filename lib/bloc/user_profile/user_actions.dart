import 'package:breez/bloc/async_action.dart';

class UpdateSecurityModel extends AsyncAction {
  final String pinCode;
  final bool secureBackupWithPin;

  UpdateSecurityModel({this.pinCode, this.secureBackupWithPin});
}

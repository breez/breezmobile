import 'package:breez/bloc/async_action.dart';
import 'package:breez/bloc/backup/backup_model.dart';

class UpdateBackupSettings extends AsyncAction {
  final BackupSettings settings;

  UpdateBackupSettings(this.settings);
}
import '../async_action.dart';
import 'backup_model.dart';

class SaveBackupKey extends AsyncAction {
  final String backupPhrase;

  SaveBackupKey(this.backupPhrase);
}

class UpdateBackupSettings extends AsyncAction {
  final BackupSettings settings;

  UpdateBackupSettings(this.settings);
}

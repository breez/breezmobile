import 'package:breez/bloc/async_action.dart';
import 'package:breez/bloc/backup/backup_model.dart';

class SaveBackupKey extends AsyncAction {
  final String backupPhrase;

  SaveBackupKey(this.backupPhrase);
}

class UpdateBackupSettings extends AsyncAction {
  final BackupSettings settings;

  UpdateBackupSettings(this.settings);

  @override
  String toString() {
    return 'UpdateBackupSettings{settings: $settings}';
  }
}

class DownloadSnapshot extends AsyncAction {
  final String nodeID;

  DownloadSnapshot(this.nodeID);
}

class ListSnapshots extends AsyncAction {
  ListSnapshots();
}

class RestoreBackup extends AsyncAction {
  final RestoreRequest restoreRequest;

  RestoreBackup(this.restoreRequest);
}

class SignOut extends AsyncAction {
  final bool promptOnError;

  SignOut({this.promptOnError = true});
}

class BackupNow extends AsyncAction {
  final UpdateBackupSettings updateBackupSettings;
  final bool recoverEnabled;

  BackupNow(this.updateBackupSettings, {this.recoverEnabled});

  @override
  String toString() {
    return 'BackupNow{updateBackupSettings: $updateBackupSettings, recoverEnabled: $recoverEnabled}';
  }
}

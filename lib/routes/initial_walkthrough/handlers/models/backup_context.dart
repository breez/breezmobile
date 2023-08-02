import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';

class BackupContext {
  final BackupSettings settings;
  final List<SnapshotInfo> snapshots;

  BackupContext(
    this.snapshots,
    this.settings,
  );
}

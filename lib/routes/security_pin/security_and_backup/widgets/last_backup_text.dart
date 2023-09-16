import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/utils/date.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class LastBackupText extends StatelessWidget {
  const LastBackupText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    final texts = context.texts();

    return StreamBuilder<BackupState>(
      stream: backupBloc.backupStateStream,
      builder: (context, backupStateSnapshot) {
        if (!backupStateSnapshot.hasData) {
          return const SizedBox();
        }

        final backupState = backupStateSnapshot.data;

        final lastBackupTime = backupState.lastBackupTime;
        if (lastBackupTime == null) return const SizedBox();

        final accountName = backupState.lastBackupAccountName;
        final lastBackup = BreezDateUtils.formatYearMonthDayHourMinute(
          lastBackupTime,
        );

        return Text(
          accountName == null || accountName.isEmpty
              ? texts.security_and_backup_last_backup_no_account(lastBackup)
              : texts.security_and_backup_last_backup_with_account(
                  lastBackup,
                  accountName,
                ),
          textAlign: TextAlign.left,
        );
      },
    );
  }
}

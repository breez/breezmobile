import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/routes/security_pin/remote_server_auth/remote_server_auth.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';

class RemoteServerCredentialsTile extends StatefulWidget {
  final BackupBloc backupBloc;
  final AutoSizeGroup autoSizeGroup;

  const RemoteServerCredentialsTile({
    @required this.backupBloc,
    @required this.autoSizeGroup,
  });

  @override
  State<RemoteServerCredentialsTile> createState() =>
      _RemoteServerCredentialsTileState();
}

class _RemoteServerCredentialsTileState
    extends State<RemoteServerCredentialsTile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BackupSettings>(
      stream: widget.backupBloc.backupSettingsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        final backupSettings = snapshot.data;

        return ListTile(
          title: AutoSizeText(
            BackupSettings.remoteServerBackupProvider().displayName,
            style: const TextStyle(color: Colors.white),
            maxLines: 1,
            minFontSize: MinFontSize(context).minFontSize,
            stepGranularity: 0.1,
            group: widget.autoSizeGroup,
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
            size: 30.0,
          ),
          onTap: () async {
            await _enterRemoteServerCredentials(backupSettings);
          },
        );
      },
    );
  }

  Future<void> _enterRemoteServerCredentials(
    BackupSettings backupSettings, {
    BackupProvider backupProvider,
  }) async {
    await promptAuthData(
      context,
      backupSettings,
    ).then(
      (auth) async {
        if (auth != null) {
          await _backupNow(
            backupSettings.copyWith(
              backupProvider: backupProvider ?? backupSettings.backupProvider,
              remoteServerAuthData: auth,
            ),
          );
        }
      },
    );
  }

  Future _backupNow(BackupSettings backupSettings) async {
    final updateBackupSettings = UpdateBackupSettings(backupSettings);
    final backupAction = BackupNow(updateBackupSettings, recoverEnabled: true);
    widget.backupBloc.backupActionsSink.add(backupAction);
    return backupAction.future;
  }
}

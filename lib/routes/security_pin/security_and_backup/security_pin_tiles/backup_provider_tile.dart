import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/routes/security_pin/remote_server_auth/remote_server_auth.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BackupProviderTile extends StatefulWidget {
  final BackupBloc backupBloc;
  final AutoSizeGroup autoSizeGroup;

  const BackupProviderTile({
    @required this.backupBloc,
    @required this.autoSizeGroup,
  });

  @override
  State<BackupProviderTile> createState() => _BackupProviderTileState();
}

class _BackupProviderTileState extends State<BackupProviderTile> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return StreamBuilder<BackupSettings>(
        stream: widget.backupBloc.backupSettingsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final backupSettings = snapshot.data;

          return ListTile(
            title: AutoSizeText(
              texts.security_and_backup_store_location,
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              group: widget.autoSizeGroup,
            ),
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton<BackupProvider>(
                iconEnabledColor: Colors.white,
                value: backupSettings.backupProvider,
                isDense: true,
                onChanged: (BackupProvider selectedProvider) async {
                  await _updateBackupProvider(selectedProvider, backupSettings);
                },
                items:
                    BackupSettings.availableBackupProviders().map((provider) {
                  return DropdownMenuItem(
                    value: provider,
                    child: AutoSizeText(
                      provider.displayName,
                      style: theme.FieldTextStyle.textStyle,
                      maxLines: 1,
                      minFontSize: MinFontSize(context).minFontSize,
                      stepGranularity: 0.1,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        });
  }

  Future<void> _updateBackupProvider(
    BackupProvider selectedProvider,
    BackupSettings backupSettings,
  ) async {
    try {
      EasyLoading.show();

      if (selectedProvider.name ==
          BackupSettings.remoteServerBackupProvider().name) {
        EasyLoading.dismiss();

        await _enterRemoteServerCredentials(
          backupSettings,
          backupProvider: selectedProvider,
        );
      } else {
        await _backupNow(
          backupSettings.copyWith(
            backupProvider: selectedProvider,
          ),
        );
      }
    } finally {
      EasyLoading.dismiss();
    }
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

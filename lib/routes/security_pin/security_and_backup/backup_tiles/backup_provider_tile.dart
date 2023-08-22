import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BackupProviderTile extends StatefulWidget {
  final BackupBloc backupBloc;
  final AutoSizeGroup autoSizeGroup;
  final Future Function(
    BackupSettings backupSettings, {
    BackupProvider backupProvider,
  }) enterRemoteServerCredentials;
  final Future Function(BackupSettings backupSettings) backupNow;

  const BackupProviderTile({
    @required this.backupBloc,
    @required this.autoSizeGroup,
    @required this.enterRemoteServerCredentials,
    @required this.backupNow,
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
              items: BackupSettings.availableBackupProviders().map(
                (provider) {
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
                },
              ).toList(),
            ),
          ),
        );
      },
    );
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

        await widget.enterRemoteServerCredentials(
          backupSettings,
          backupProvider: selectedProvider,
        );
      } else {
        await widget.backupNow(
          backupSettings.copyWith(
            backupProvider: selectedProvider,
          ),
        );
      }
    } finally {
      EasyLoading.dismiss();
    }
  }
}

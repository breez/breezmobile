import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BackupProviderTile extends StatefulWidget {
  final BackupSettings backupSettings;
  final AutoSizeGroup autoSizeGroup;
  final Future Function(
    BackupProvider backupProvider,
  ) enterRemoteServerCredentials;
  final Future Function(BackupSettings backupSettings) backupNow;

  const BackupProviderTile({
    @required this.backupSettings,
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
          value: widget.backupSettings.backupProvider,
          isDense: true,
          onChanged: (BackupProvider selectedProvider) async {
            await _updateBackupProvider(selectedProvider);
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
  }

  Future<void> _updateBackupProvider(
    BackupProvider selectedProvider,
  ) async {
    try {
      EasyLoading.show();

      if (selectedProvider.name ==
          BackupSettings.remoteServerBackupProvider().name) {
        EasyLoading.dismiss();

        await widget.enterRemoteServerCredentials(selectedProvider);
      } else {
        await widget.backupNow(
          widget.backupSettings.copyWith(backupProvider: selectedProvider),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      rethrow;
    }
  }
}

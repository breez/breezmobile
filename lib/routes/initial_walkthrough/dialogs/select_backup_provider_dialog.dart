import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/security_pin/remote_server_auth.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class SelectBackupProviderDialog extends StatefulWidget {
  final BackupSettings backupSettings;
  final List<BackupProvider> backupProviders;
  final Function(BackupProvider backupProvider) onProviderSelected;

  const SelectBackupProviderDialog({
    Key key,
    this.backupSettings,
    this.backupProviders,
    this.onProviderSelected,
  }) : super(key: key);

  @override
  SelectBackupProviderDialogState createState() {
    return SelectBackupProviderDialogState();
  }
}

class SelectBackupProviderDialogState
    extends State<SelectBackupProviderDialog> {
  int _selectedProviderIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 16.0),
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 30,
        child: AutoSizeText(
          texts.backup_provider_dialog_title,
          style: themeData.dialogTheme.titleTextStyle,
          maxLines: 1,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            texts.backup_provider_dialog_message_restore,
            style: themeData.primaryTextTheme.displaySmall.copyWith(
              fontSize: 16,
            ),
          ),
          SizedBox(
            width: 150.0,
            height: widget.backupProviders.length * 50.0,
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: widget.backupProviders.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  selected: _selectedProviderIndex == index,
                  trailing: _selectedProviderIndex == index
                      ? Icon(
                          Icons.check,
                          color: themeData.primaryTextTheme.labelLarge.color,
                        )
                      : Icon(
                          Icons.check,
                          color: themeData.colorScheme.background,
                        ),
                  title: Text(
                    widget.backupProviders[index].displayName,
                    style: themeData.dialogTheme.titleTextStyle.copyWith(
                      fontSize: 14.3,
                      height: 1.2,
                    ), // Color needs to change
                  ),
                  onTap: () {
                    setState(() {
                      _selectedProviderIndex = index;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: themeData.primaryTextTheme.labelLarge.color,
          ),
          onPressed: () => Navigator.pop(context, null),
          child: Text(texts.backup_provider_dialog_action_cancel),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: themeData.primaryTextTheme.labelLarge.color,
          ),
          onPressed: () => _selectProvider(
            widget.backupSettings,
            widget.backupProviders[_selectedProviderIndex],
          ),
          child: Text(texts.backup_provider_dialog_action_ok),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
  }

  Future<void> _selectProvider(
    BackupSettings backupSettings,
    BackupProvider selectedProvider,
  ) async {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);

    if (selectedProvider.name == "remoteserver") {
      final auth = await promptAuthData(
        context,
        restore: true,
      );
      if (auth == null) {
        return;
      }
      backupSettings = backupSettings.copyWith(
        remoteServerAuthData: auth,
      );
    }
    final updateBackupSettingsAction = UpdateBackupSettings(
      backupSettings.copyWith(backupProvider: selectedProvider),
    );
    backupBloc.backupActionsSink.add(updateBackupSettingsAction);
    updateBackupSettingsAction.future.then((updatedBackupSettings) {
      Navigator.pop(context);
      widget.onProviderSelected(selectedProvider);
    }).catchError((err) {
      Navigator.pop(context);
    });
  }
}

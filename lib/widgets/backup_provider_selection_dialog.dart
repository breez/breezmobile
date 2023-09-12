import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/routes/security_pin/remote_server_auth/remote_server_auth.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class BackupProviderSelectionDialog extends StatefulWidget {
  final BackupBloc backupBloc;
  final bool restore;

  const BackupProviderSelectionDialog({
    Key key,
    this.backupBloc,
    this.restore = false,
  }) : super(key: key);

  @override
  BackupProviderSelectionDialogState createState() {
    return BackupProviderSelectionDialogState();
  }
}

class BackupProviderSelectionDialogState
    extends State<BackupProviderSelectionDialog> {
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
            widget.restore
                ? texts.backup_provider_dialog_message_restore
                : texts.backup_provider_dialog_message_store,
            style: themeData.primaryTextTheme.displaySmall.copyWith(
              fontSize: 16,
            ),
          ),
          StreamBuilder<BackupSettings>(
            stream: widget.backupBloc.backupSettingsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              final providers = BackupSettings.availableBackupProviders();
              return SizedBox(
                width: 150.0,
                height: providers.length * 50.0,
                child: ListView.builder(
                  shrinkWrap: false,
                  itemCount: providers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 0.0),
                      selected: _selectedProviderIndex == index,
                      trailing: _selectedProviderIndex == index
                          ? Icon(
                              Icons.check,
                              color:
                                  themeData.primaryTextTheme.labelLarge.color,
                            )
                          : Icon(
                              Icons.check,
                              color: themeData.colorScheme.background,
                            ),
                      title: Text(
                        providers[index].displayName,
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
              );
            },
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
        StreamBuilder<BackupSettings>(
          stream: widget.backupBloc.backupSettingsStream,
          builder: (context, snapshot) {
            return TextButton(
              style: TextButton.styleFrom(
                foregroundColor: themeData.primaryTextTheme.labelLarge.color,
              ),
              onPressed: () => _selectProvider(snapshot.data),
              child: Text(texts.backup_provider_dialog_action_ok),
            );
          },
        )
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
  }

  Future<void> _selectProvider(BackupSettings backupSettings) async {
    if (backupSettings == null) return;

    final providers = BackupSettings.availableBackupProviders();
    final provider = BackupSettings.remoteServerBackupProvider();
    final selectedProvider = providers[_selectedProviderIndex];

    if (selectedProvider.name == provider.name) {
      final auth = await promptAuthData(
        context,
        backupSettings,
        restore: true,
      );
      if (auth == null) {
        return;
      }
      backupSettings = backupSettings.copyWith(
        remoteServerAuthData: auth,
      );
    }
    final setAction = UpdateBackupSettings(backupSettings.copyWith(
      backupProvider: selectedProvider,
    ));
    widget.backupBloc.backupActionsSink.add(setAction);
    setAction.future.then((_) => Navigator.pop(context, selectedProvider));
  }
}

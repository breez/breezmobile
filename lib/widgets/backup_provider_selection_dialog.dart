import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/routes/security_pin/remote_server_auth.dart';
import 'package:breez/utils/build_context.dart';
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
    var l10n = context.l10n;
    ThemeData themeData = context.theme;
    DialogTheme dialogTheme = themeData.dialogTheme;
    TextTheme primaryTextTheme = themeData.primaryTextTheme;

    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 16.0),
      title: Container(
        width: context.mediaQuerySize.width,
        height: 30,
        child: AutoSizeText(
          l10n.backup_provider_dialog_title,
          style: dialogTheme.titleTextStyle,
          maxLines: 1,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.restore
                ? l10n.backup_provider_dialog_message_restore
                : l10n.backup_provider_dialog_message_store,
            style: primaryTextTheme.headline3.copyWith(fontSize: 16),
          ),
          StreamBuilder<BackupSettings>(
            stream: widget.backupBloc.backupSettingsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }

              final providers = BackupSettings.availableBackupProviders();
              return Container(
                width: 150.0,
                height: 100.0,
                child: ListView.builder(
                  shrinkWrap: false,
                  itemCount: providers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      selected: _selectedProviderIndex == index,
                      trailing: _selectedProviderIndex == index
                          ? Icon(
                        Icons.check,
                              color: primaryTextTheme.button.color,
                            )
                          : Icon(
                        Icons.check,
                              color: themeData.backgroundColor,
                            ),
                      title: Text(
                        providers[index].displayName,
                        style: dialogTheme.titleTextStyle.copyWith(
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
            primary: primaryTextTheme.button.color,
          ),
          onPressed: () => context.pop(null),
          child: Text(l10n.backup_provider_dialog_action_cancel),
        ),
        StreamBuilder<BackupSettings>(
          stream: widget.backupBloc.backupSettingsStream,
          builder: (context, snapshot) {
            return TextButton(
              style: TextButton.styleFrom(
                primary: primaryTextTheme.button.color,
              ),
              onPressed: () => _selectProvider(snapshot.data),
              child: Text(l10n.backup_provider_dialog_action_ok),
            );
          },
        )
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
  }

  Future<void> _selectProvider(BackupSettings backupSettings) async {
    if (backupSettings == null) return;

    final providers = BackupSettings.availableBackupProviders();
    final provider = BackupSettings.remoteServerBackupProvider;
    final selectedProvider = providers[_selectedProviderIndex];

    var settings = backupSettings;
    if (selectedProvider.name == provider.name) {
      final auth = await promptAuthData(
        context,
        restore: true,
      );
      if (auth == null) {
        return;
      }
      settings = settings.copyWith(
        remoteServerAuthData: auth,
      );
    }
    final setAction = UpdateBackupSettings(settings.copyWith(
      backupProvider: selectedProvider,
    ));
    widget.backupBloc.backupActionsSink.add(setAction);
    setAction.future.then((_) => context.pop(selectedProvider));
  }
}

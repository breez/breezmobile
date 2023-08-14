import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/initial_walkthrough/dialogs/restore_dialog.dart';
import 'package:breez/routes/initial_walkthrough/loaders/loader_indicator.dart';
import 'package:breez/routes/security_pin/remote_server_auth.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SelectBackupProviderDialog extends StatefulWidget {
  final BackupSettings backupSettings;
  final List<BackupProvider> backupProviders;
  final Sink<bool> reloadDatabaseSink;

  const SelectBackupProviderDialog({
    Key key,
    this.backupSettings,
    this.backupProviders,
    this.reloadDatabaseSink,
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
      _listSnapshots(backupBloc);
    }).catchError((err) {
      Navigator.pop(context);
    });
  }

  Future _listSnapshots(BackupBloc backupBloc) {
    var listBackupsAction = ListSnapshots();

    EasyLoading.show(
      indicator: const LoaderIndicator(
        message: 'Loading Backups',
      ),
    );

    backupBloc.backupActionsSink.add(listBackupsAction);
    return listBackupsAction.future
        .then((snapshots) {
          _handleRestoreRequest(snapshots);
        })
        .catchError((error) => _handleError(error))
        .whenComplete(() {
          Navigator.pop(context);
          EasyLoading.dismiss();
        });
  }

  void _handleError(error) {
    EasyLoading.dismiss();

    Navigator.popUntil(context, (route) {
      return route.settings.name == "/intro";
    });
    if (error.runtimeType != SignInFailedException) {
      SnackBar snackBar = SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(error.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      _handleSignInException(error as SignInFailedException);
    }
  }

  Future _handleSignInException(SignInFailedException e) async {
    if (e.provider == BackupSettings.icloudBackupProvider()) {
      final texts = context.texts();
      final themeData = Theme.of(context);

      await promptError(
        context,
        texts.initial_walk_through_sign_in_icloud_title,
        Text(
          texts.initial_walk_through_sign_in_icloud_message,
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
    } else if (e.provider == BackupSettings.googleBackupProvider()) {
      showFlushbar(
        context,
        duration: const Duration(seconds: 3),
        message: "Failed to sign into Google Drive.",
      );
    }
  }

  void _handleRestoreRequest(List<SnapshotInfo> snapshots) async {
    if (snapshots.isEmpty) {
      _handleEmptySnapshot();
      return;
    }
    _selectSnapshotToRestore(snapshots);
  }

  void _handleEmptySnapshot() {
    Navigator.popUntil(context, (route) {
      return route.settings.name == "/intro";
    });
    final texts = context.texts();
    SnackBar snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(texts.initial_walk_through_error_backup_location),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _selectSnapshotToRestore(
    List<SnapshotInfo> snapshots,
  ) async {
    Navigator.popUntil(context, (route) {
      return route.settings.name == "/intro";
    });
    showDialog<SnapshotInfo>(
      useRootNavigator: false,
      context: context,
      builder: (_) => RestoreDialog(
        snapshots,
        widget.reloadDatabaseSink,
      ),
    );
  }
}

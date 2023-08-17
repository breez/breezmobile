import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/initial_walkthrough/loaders/loader_indicator.dart';
import 'package:breez/routes/security_pin/remote_server_auth.dart';
import 'package:breez/utils/exceptions.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SelectBackupProviderDialog extends StatefulWidget {
  final List<BackupProvider> backupProviders;

  const SelectBackupProviderDialog({
    Key key,
    this.backupProviders,
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
    BackupProvider selectedProvider,
  ) async {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    backupBloc.backupSettingsStream.first.then(
      (backupSettings) async {
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
        EasyLoading.show();

        updateBackupSettingsAction.future.then((updatedBackupSettings) {
          EasyLoading.dismiss();

          _listSnapshots(backupBloc);
        }).catchError((err) {
          EasyLoading.dismiss();

          Navigator.pop(context);
          showFlushbar(
            context,
            duration: const Duration(seconds: 3),
            message: err.toString(),
          );
        });
      },
    );
  }

  Future _listSnapshots(BackupBloc backupBloc) {
    var listBackupsAction = ListSnapshots();

    EasyLoading.show(
      indicator: const LoaderIndicator(
        message: 'Loading Backups',
      ),
    );

    backupBloc.backupActionsSink.add(listBackupsAction);
    return listBackupsAction.future.then((snapshots) {
      EasyLoading.dismiss();

      if (snapshots != null && snapshots is List<SnapshotInfo>) {
        if (snapshots.isEmpty) {
          _handleEmptySnapshot();
        } else {
          Navigator.pop(context, snapshots);
        }
      }
    }).catchError(
      (error) => _handleError(error),
    );
  }

  void _handleEmptySnapshot() {
    Navigator.pop(context);
    final texts = context.texts();
    showFlushbar(
      context,
      duration: const Duration(seconds: 3),
      message: texts.initial_walk_through_error_backup_location,
    );
  }

  void _handleError(error) {
    EasyLoading.dismiss();

    switch (error.runtimeType) {
      case InsufficientPermissionException:
        return;
      case SignInFailedException:
        Navigator.pop(context);
        _handleSignInException(error);
        break;
      default:
        Navigator.pop(context);
        showFlushbar(
          context,
          duration: const Duration(seconds: 3),
          message: error.toString(),
        );
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
}

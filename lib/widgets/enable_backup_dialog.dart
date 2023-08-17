import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/security_pin/remote_server_auth/remote_server_auth.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

import 'backup_provider_selection_dialog.dart';
import 'error_dialog.dart';

class EnableBackupDialog extends StatefulWidget {
  final bool signInNeeded;

  const EnableBackupDialog({this.signInNeeded = false});

  @override
  EnableBackupDialogState createState() {
    return EnableBackupDialogState();
  }
}

class EnableBackupDialogState extends State<EnableBackupDialog> {
  final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  @override
  Widget build(BuildContext context) {
    return createEnableBackupDialog(context);
  }

  Widget createEnableBackupDialog(BuildContext context) {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    final texts = context.texts();
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Theme.of(context).canvasColor,
      ),
      child: AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
        title: Text(
          texts.backup_dialog_title,
          style: Theme.of(context).dialogTheme.titleTextStyle,
        ),
        contentPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
        content: StreamBuilder<BackupSettings>(
          stream: backupBloc.backupSettingsStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final backupSettings = snapshot.data;

            bool isRemoteServer = backupSettings.backupProvider ==
                BackupSettings.remoteServerBackupProvider();
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 12.0),
                    child: AutoSizeText(
                      isRemoteServer
                          ? texts.backup_dialog_message_remote_server
                          : texts.backup_dialog_message_default,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .displaySmall
                          .copyWith(fontSize: 16),
                      minFontSize: MinFontSize(context).minFontSize,
                      stepGranularity: 0.1,
                      group: _autoSizeGroup,
                    ),
                  ),
                  isRemoteServer
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            children: <Widget>[
                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      .color,
                                ),
                                child: Checkbox(
                                  activeColor: Colors.white,
                                  checkColor: Theme.of(context).canvasColor,
                                  value: !backupSettings.promptOnError,
                                  onChanged: (v) {
                                    backupBloc.backupSettingsSink.add(
                                      backupSettings.copyWith(
                                        promptOnError: !v,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  texts.backup_dialog_do_not_prompt_again,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .displaySmall
                                      .copyWith(fontSize: 16),
                                  maxLines: 1,
                                  minFontSize: MinFontSize(context).minFontSize,
                                  stepGranularity: 0.1,
                                  group: _autoSizeGroup,
                                ),
                              )
                            ],
                          ),
                        ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              texts.backup_dialog_option_cancel,
              style: Theme.of(context).primaryTextTheme.labelLarge,
              maxLines: 1,
            ),
          ),
          StreamBuilder<BackupSettings>(
            stream: backupBloc.backupSettingsStream,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container();
              }
              final backupSettings = snapshot.data;
              bool isRemoteServer = backupSettings.backupProvider ==
                  BackupSettings.remoteServerBackupProvider();
              return TextButton(
                onPressed: (() async {
                  final themeData = Theme.of(context);
                  Navigator.pop(context);
                  var provider = backupSettings.backupProvider;
                  provider ??= await showDialog(
                    useRootNavigator: false,
                    context: context,
                    builder: (_) => BackupProviderSelectionDialog(
                      backupBloc: backupBloc,
                    ),
                  );

                  if (provider != null) {
                    if (widget.signInNeeded &&
                        provider == BackupSettings.icloudBackupProvider()) {
                      await promptError(
                        context,
                        texts.backup_dialog_icloud_error_title,
                        Text(
                          texts.backup_dialog_icloud_error_message,
                          style: themeData.dialogTheme.contentTextStyle,
                        ),
                      );
                      return;
                    }
                    if (provider ==
                        BackupSettings.remoteServerBackupProvider()) {
                      promptAuthData(context, backupSettings, restore: false)
                          .then((auth) {
                        if (auth != null) {
                          var action = UpdateBackupSettings(
                            backupSettings.copyWith(
                              remoteServerAuthData: auth,
                            ),
                          );
                          backupBloc.backupActionsSink.add(action);
                          backupBloc.backupNowSink
                              .add(const BackupNowAction(recoverEnabled: true));
                        }
                      });
                      return;
                    }

                    backupBloc.backupNowSink
                        .add(const BackupNowAction(recoverEnabled: true));
                  }
                }),
                child: Text(
                  isRemoteServer
                      ? texts.backup_dialog_option_ok_remote_server
                      : texts.backup_dialog_option_ok_default,
                  style: Theme.of(context).primaryTextTheme.labelLarge,
                  maxLines: 1,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

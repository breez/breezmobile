import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/routes/security_pin/remote_server_auth.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'backup_provider_selection_dialog.dart';
import 'error_dialog.dart';

class EnableBackupDialog extends StatefulWidget {
  final BuildContext context;
  final BackupBloc backupBloc;
  final bool signInNeeded;

  EnableBackupDialog(this.context, this.backupBloc,
      {this.signInNeeded = false});

  @override
  EnableBackupDialogState createState() {
    return EnableBackupDialogState();
  }
}

class EnableBackupDialogState extends State<EnableBackupDialog> {
  AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  @override
  Widget build(BuildContext context) {
    return createEnableBackupDialog(context);
  }

  Widget createEnableBackupDialog(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).canvasColor,
        ),
        child: AlertDialog(
          titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
          title: Text(
            texts.backup_dialog_title,
            style: Theme.of(context).dialogTheme.titleTextStyle,
          ),
          contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
          content: StreamBuilder<BackupSettings>(
              stream: widget.backupBloc.backupSettingsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                bool isRemoteServer = snapshot.data.backupProvider ==
                    BackupSettings.remoteServerBackupProvider;
                return Container(
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
                              .headline3
                              .copyWith(fontSize: 16),
                          minFontSize: MinFontSize(context).minFontSize,
                          stepGranularity: 0.1,
                          group: _autoSizeGroup,
                        ),
                      ),
                      isRemoteServer
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                        unselectedWidgetColor: Theme.of(context)
                                            .textTheme
                                            .button
                                            .color),
                                    child: Checkbox(
                                        activeColor: Colors.white,
                                        checkColor:
                                            Theme.of(context).canvasColor,
                                        value: !snapshot.data.promptOnError,
                                        onChanged: (v) {
                                          var currentSettings = snapshot.data;
                                          widget.backupBloc.backupSettingsSink
                                              .add(currentSettings.copyWith(
                                                  promptOnError: !v));
                                        }),
                                  ),
                                  Expanded(
                                      child: AutoSizeText(
                                    texts.backup_dialog_do_not_prompt_again,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline3
                                        .copyWith(fontSize: 16),
                                    maxLines: 1,
                                    minFontSize:
                                        MinFontSize(context).minFontSize,
                                    stepGranularity: 0.1,
                                    group: _autoSizeGroup,
                                  ))
                                ],
                              ),
                            ),
                    ],
                  ),
                );
              }),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(widget.context),
              child: Text(
                texts.backup_dialog_option_cancel,
                style: Theme.of(context).primaryTextTheme.button,
                maxLines: 1,
              ),
            ),
            StreamBuilder<BackupSettings>(
                stream: widget.backupBloc.backupSettingsStream,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  }
                  bool isRemoteServer = snapshot.data.backupProvider ==
                      BackupSettings.remoteServerBackupProvider;
                  return TextButton(
                    onPressed: (() async {
                      Navigator.pop(widget.context);
                      var provider = snapshot.data.backupProvider;
                      if (provider == null) {
                        provider = await showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (_) => BackupProviderSelectionDialog(
                                backupBloc: widget.backupBloc));
                      }

                      if (provider != null) {
                        if (widget.signInNeeded &&
                            provider == BackupSettings.icloudBackupProvider) {
                          await promptError(
                              context,
                              texts.backup_dialog_icloud_error_title,
                              Text(
                                  texts.backup_dialog_icloud_error_message,
                                  style: Theme.of(context)
                                      .dialogTheme
                                      .contentTextStyle));
                          return;
                        }
                        if (provider ==
                            BackupSettings.remoteServerBackupProvider) {
                          promptAuthData(context, restore: false).then((auth) {
                            if (auth != null) {
                              var action = UpdateBackupSettings(snapshot.data
                                  .copyWith(remoteServerAuthData: auth));
                              widget.backupBloc.backupActionsSink.add(action);
                              widget.backupBloc.backupNowSink.add(true);
                            }
                          });
                          return;
                        }

                        widget.backupBloc.backupNowSink.add(true);
                      }
                    }),
                    child: Text(
                      isRemoteServer
                          ? texts.backup_dialog_option_ok_remote_server
                          : texts.backup_dialog_option_ok_default,
                      style: Theme.of(context).primaryTextTheme.button,
                      maxLines: 1,
                    ),
                  );
                }),
          ],
        ));
  }
}

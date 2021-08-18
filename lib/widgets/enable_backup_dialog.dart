import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/routes/security_pin/remote_server_auth.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return createEnableBackupDialog();
  }

  Widget createEnableBackupDialog() {
    return Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).canvasColor,
        ),
        child: AlertDialog(
          titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
          title: Text(
            "Backup",
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
                              ? "Failed to save backup files to Remote Server. Please review your settings and try again."
                              : "If you want to be able to restore your funds in case this mobile device or this app are no longer available (e.g. lost or stolen device or app uninstall), you are required to backup your information.",
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
                                    "Don't prompt again",
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
                "LATER",
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
                              "Sign in to iCloud",
                              Text(
                                  "Sign in to your iCloud account. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID.",
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
                      isRemoteServer ? "SETTINGS" : "BACKUP NOW",
                      style: Theme.of(context).primaryTextTheme.button,
                      maxLines: 1,
                    ),
                  );
                }),
          ],
        ));
  }
}

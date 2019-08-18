import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnableBackupDialog extends StatefulWidget {
  final BuildContext context;
  final BackupBloc backupBloc;

  EnableBackupDialog(this.context, this.backupBloc);

  @override
  EnableBackupDialogState createState() {
    return new EnableBackupDialogState();
  }
}

class EnableBackupDialogState extends State<EnableBackupDialog> {
  AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  AutoSizeGroup _autoSizeActionBtnGroup = AutoSizeGroup();
  @override
  Widget build(BuildContext context) {
    return createEnableBackupDialog();
  }

  Widget createEnableBackupDialog() {
    return Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).canvasColor,
        ),
        child: new AlertDialog(
          titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
          title: new Text(
            "Backup",
            style: theme.alertTitleStyle,
          ),
          contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
          content: StreamBuilder<BackupSettings>(
              stream: widget.backupBloc.backupSettingsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,                  
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 12.0),
                      child: new AutoSizeText(
                        "If you want to be able to restore your funds in case this mobile device or this app are no longer available (e.g. lost or stolen device or app uninstall), you are required to backup your information.",
                        style: theme.paymentRequestSubtitleStyle,
                        group: _autoSizeGroup,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: <Widget>[
                          Checkbox(                            
                              activeColor: theme.BreezColors.blue[500],
                              value: !snapshot.data.promptOnError,
                              onChanged: (v) {
                                var currentSettings = snapshot.data;
                                widget.backupBloc.backupSettingsSink.add(
                                    currentSettings.copyWith(promptOnError: !v));
                              }),
                          Expanded(child: AutoSizeText("Don't prompt again", style: theme.paymentRequestSubtitleStyle, maxLines: 1, group: _autoSizeGroup,))
                        ],
                      ),
                    ),                    
                  ],
                );
              }),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(widget.context),
              child: AutoSizeText(
                "LATER",
                style: theme.buttonStyle,
                maxLines: 1,
                group: _autoSizeActionBtnGroup,
              ),
            ),
            FlatButton(
              onPressed: (() {
                Navigator.pop(widget.context);
                widget.backupBloc.backupNowSink.add(true);
              }),
              child: AutoSizeText(
                "BACKUP NOW",
                style: theme.buttonStyle,
                maxLines: 1,
                group: _autoSizeActionBtnGroup,
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
        ));
  }
}

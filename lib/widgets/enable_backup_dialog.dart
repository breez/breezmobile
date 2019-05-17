import 'package:breez/bloc/backup/backup_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/bloc/backup/backup_bloc.dart';

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
          title: new Text(
            "Backup",
            style: theme.alertTitleStyle,
          ),
          titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
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
                      child: new Text(
                        "If you want to be able to restore your funds in case this mobile device or this app are no longer available (e.g. lost or stolen device or app uninstall), you are required to backup your information.",
                        style: theme.paymentRequestSubtitleStyle,
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
                          Text(
                            "Don't prompt again",
                            style: theme.paymentRequestSubtitleStyle,
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }),
          contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
          actions: [
            new SimpleDialogOption(
              onPressed: () => Navigator.pop(widget.context),
              child: new Text("LATER", style: theme.buttonStyle),
            ),
            new SimpleDialogOption(
              onPressed: (() {
                Navigator.pop(widget.context);
                widget.backupBloc.backupNowSink.add(true);
              }),
              child: new Text("BACKUP NOW", style: theme.buttonStyle),
            ),
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
        ));
  }
}

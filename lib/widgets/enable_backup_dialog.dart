import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/bloc/backup/backup_bloc.dart';

class EnableBackupDialog extends StatelessWidget {
  final BuildContext context;
  final BackupBloc backupBloc;

  EnableBackupDialog(this.context, this.backupBloc);

  @override
  Widget build(BuildContext context) {
    return showEnableBackupDialog();
  }

  Widget showEnableBackupDialog() {
    return new AlertDialog(
      titlePadding: EdgeInsets.only(top: 48.0),
      title: new Text("Backup"),
      contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Text(
            "If you want to be able to restore your funds in case this mobile device or this app are no longer available (e.g. lost or stolen device or app uninstall), you are required to backup your information.",
            style: theme.paymentRequestSubtitleStyle,
            textAlign: TextAlign.center,
          ),
          new Row(
            children: <Widget>[
              new Checkbox(
                  value: false,
                  onChanged: (enabled) {
                    backupBloc.enableBackupSink.add(enabled);
                  }),
              new Text("Don't prompt again"),
            ],
          ),
          new Padding(padding: EdgeInsets.only(top: 24.0)),
          new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: new Text("LATER", style: theme.buttonStyle),
              ),
              new SimpleDialogOption(
                onPressed: (() {
                  Navigator.pop(context);
                }),
                child: new Text("BACKUP NOW", style: theme.buttonStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

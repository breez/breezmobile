import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/bloc/backup/backup_bloc.dart';

class RestoreDialog extends StatefulWidget {
  final BuildContext context;
  final BackupBloc backupBloc;

  RestoreDialog(this.context, this.backupBloc);

  @override
  RestoreDialogState createState() {
    return new RestoreDialogState();
  }
}

class RestoreDialogState extends State<RestoreDialog> {
  bool _isChecked = true;

  @override
  Widget build(BuildContext context) {
    return showRestoreDialog();
  }

  Widget showRestoreDialog() {
    return new AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
      title: new Text(
        "Restore",
        style: theme.alertTitleStyle,
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Text(
            "You have mulitple Breez backups on your Google Drive, please choose which to restore:",
            style: theme.paymentRequestSubtitleStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
          ),
          new Padding(padding: EdgeInsets.only(top: 24.0)),
          new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () => Navigator.pop(widget.context),
                child: new Text("CANCEL", style: theme.buttonStyle),
              ),
              new SimpleDialogOption(
                onPressed: (() {
                  Navigator.pop(widget.context);
                  //widget.backupBloc.restoreRequestSink
                }),
                child: new Text("RESTORE", style: theme.buttonStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

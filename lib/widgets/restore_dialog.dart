import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/bloc/backup/backup_bloc.dart';

class RestoreDialog extends StatefulWidget {
  final BuildContext context;
  final BackupBloc backupBloc;
  final Map<String, String> optionsMap;
  final Function proceedFunction;

  RestoreDialog(this.context, this.backupBloc, this.optionsMap, this.proceedFunction);

  @override
  RestoreDialogState createState() {
    return new RestoreDialogState();
  }
}

class RestoreDialogState extends State<RestoreDialog> {
  StreamSubscription<bool> _restoreFinishedSubscription;

  @override
  void dispose() {
    _restoreFinishedSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _restoreFinishedSubscription = widget.backupBloc.restoreFinishedStream.listen((restored) {
      if (restored) {
        Navigator.pop(widget.context);
        widget.proceedFunction();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return createRestoreDialog();
  }

  Widget createRestoreDialog() {
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
          new Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: Container(
              width: 150.0,
              height: 100.0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.optionsMap.length,
                itemBuilder: (BuildContext context, int index) {
                  var keys = widget.optionsMap.keys.toList();
                  return ListTile(
                    title: Text(widget.optionsMap[keys[index]], style: theme.alertStyle,),
                    subtitle: Text(keys[index], style: theme.bolt11Style,),
                    onTap: () {
                      widget.backupBloc.restoreRequestSink.add(keys[index]);
                    },
                  );
                },
              ),
            ),
          ),
          new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () => Navigator.pop(widget.context),
                child: new Text("CANCEL", style: theme.buttonStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

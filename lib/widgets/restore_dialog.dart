import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/bloc/backup/backup_bloc.dart';

class RestoreDialog extends StatefulWidget {
  final BuildContext context;
  final BackupBloc backupBloc;
  final Map<String, String> optionsMap;

  RestoreDialog(
      this.context, this.backupBloc, this.optionsMap);

  @override
  RestoreDialogState createState() {
    return new RestoreDialogState();
  }
}

class RestoreDialogState extends State<RestoreDialog> {
  StreamSubscription<bool> _restoreFinishedSubscription;
  String _selectedKey;


  @override
  void dispose() {
    _restoreFinishedSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _restoreFinishedSubscription =
        widget.backupBloc.restoreFinishedStream.listen((restored) {
      if (restored) {
        Navigator.pop(widget.context);
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
         
          new Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Container(
              width: 150.0,
              height: 200.0,
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: widget.optionsMap.length,
                itemBuilder: (BuildContext context, int index) {
                  var keys = widget.optionsMap.keys.toList();
                  return ListTile(          
                    selected:        _selectedKey == keys[index]  ,
                    trailing: _selectedKey == keys[index] ? Icon(Icons.check, color: theme.BreezColors.blue[500],) : Icon(Icons.check),
                    title: Text(
                      widget.optionsMap[keys[index]],                      
                      style: theme.bolt11Style.apply(fontSizeDelta: 1.3),
                    ),
                    subtitle: Text(
                      keys[index],
                      style: theme.bolt11Style,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedKey = keys[index];
                      });
                      //Navigator.pop(widget.context);
                      //widget.backupBloc.restoreRequestSink.add(keys[index]);
                    },
                  );
                },
              ),
            ),
          ),
          StreamBuilder<bool>(
              stream: widget.backupBloc.restoreFinishedStream,
              builder: (context, snapshot) {
                return snapshot.hasError
                    ? new Text(
                        snapshot.error.toString(),
                        style: theme.errorStyle,
                      )
                    : Container();
              }),          
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.pop(widget.context),
          child: new Text("CANCEL", style: theme.buttonStyle),
        ),
        new FlatButton(     
          textColor: theme.BreezColors.blue[500],
          disabledTextColor: theme.BreezColors.blue[500].withOpacity(0.4),               
          onPressed: _selectedKey == null ? null : () { 
            Navigator.pop(widget.context);
            widget.backupBloc.restoreRequestSink.add(_selectedKey);
          },
          child: new Text("OK"),
        )
      ],
    );
  }
}

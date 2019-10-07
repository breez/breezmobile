import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/utils/date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:intl/intl.dart';

class RestoreDialog extends StatefulWidget {
  final BuildContext context;
  final BackupBloc backupBloc;
  final List<SnapshotInfo> snapshots;

  RestoreDialog(
      this.context, this.backupBloc, this.snapshots);

  @override
  RestoreDialogState createState() {
    return new RestoreDialogState();
  }
}

class RestoreDialogState extends State<RestoreDialog> {  
  SnapshotInfo _selectedSnapshot;

  @override
  Widget build(BuildContext context) {
    return createRestoreDialog();
  }

  Widget createRestoreDialog() {
    return new AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
      title: new Text(
        "Restore",
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder<BackupSettings>(
            stream: widget.backupBloc.backupSettingsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }

              return new Text(
                "You have multiple Breez backups on ${snapshot.data.backupProvider.displayName}, please choose which one to restore:",
                style: Theme.of(context).primaryTextTheme.display2.copyWith(fontSize: 16),
              );
            }
          ),
         
          new Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Container(
              width: 150.0,
              height: 200.0,
              child: ListView.builder(                
                shrinkWrap: false,
                itemCount: widget.snapshots.length,
                itemBuilder: (BuildContext context, int index) {                  
                  return ListTile(  
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),                    
                    selected: _selectedSnapshot?.nodeID == widget.snapshots[index].nodeID  ,
                    trailing: _selectedSnapshot?.nodeID == widget.snapshots[index].nodeID ? Icon(Icons.check, color: theme.BreezColors.blue[500],) : Icon(Icons.check),
                    title: Text( 
                      DateUtils.formatYearMonthDayHourMinute(DateTime.parse(widget.snapshots[index].modifiedTime)) + 
                        (widget.snapshots[index].encrypted ? " - (Requires key)" : ""),
                      style: theme.bolt11Style.apply(fontSizeDelta: 1.3),
                    ),
                    subtitle: Text(
                      widget.snapshots[index].nodeID,
                      style: theme.bolt11Style,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedSnapshot = widget.snapshots[index];
                      });                      
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
          onPressed: () =>  Navigator.pop(widget.context, null),
          child: new Text("CANCEL", style: Theme.of(context).primaryTextTheme.button),
        ),
        new FlatButton(     
          textColor: theme.BreezColors.blue[500],
          disabledTextColor: theme.BreezColors.blue[500].withOpacity(0.4),               
          onPressed: _selectedSnapshot == null ? null : () {
            Navigator.pop(widget.context, _selectedSnapshot);
          },
          child: new Text("OK"),
        )
      ],
    );
  }
}

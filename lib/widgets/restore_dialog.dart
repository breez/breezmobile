import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/services/breezlib/data/rpc.pbgrpc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

import 'error_dialog.dart';
import 'loader.dart';

class RestoreDialog extends StatefulWidget {
  final BuildContext context;
  final BackupBloc backupBloc;
  final List<SnapshotInfo> snapshots;

  RestoreDialog(this.context, this.backupBloc, this.snapshots);

  @override
  RestoreDialogState createState() {
    return RestoreDialogState();
  }
}

class RestoreDialogState extends State<RestoreDialog> {
  SnapshotInfo _selectedSnapshot;

  @override
  Widget build(BuildContext context) {
    return createRestoreDialog();
  }

  Widget createRestoreDialog() {
    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
      title: Text(
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

                return Text(
                  "You have multiple Breez backups on ${snapshot.data.backupProvider.displayName}, please choose which one to restore:",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .headline3
                      .copyWith(fontSize: 16),
                );
              }),
          Padding(
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
                    selected: _selectedSnapshot?.nodeID ==
                        widget.snapshots[index].nodeID,
                    trailing: _selectedSnapshot?.nodeID ==
                            widget.snapshots[index].nodeID
                        ? Icon(
                            Icons.check,
                            color: theme.BreezColors.blue[500],
                          )
                        : Icon(Icons.check),
                    title: Text(
                      BreezDateUtils.formatYearMonthDayHourMinute(
                              DateTime.parse(
                                  widget.snapshots[index].modifiedTime)) +
                          (widget.snapshots[index].encrypted
                              ? " - (Requires key)"
                              : ""),
                      style: Theme.of(context)
                          .primaryTextTheme
                          .caption
                          .copyWith(fontSize: 9)
                          .apply(fontSizeDelta: 1.3),
                    ),
                    subtitle: Text(
                      widget.snapshots[index].nodeID,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .caption
                          .copyWith(fontSize: 9),
                    ),
                    onLongPress: () {
                      var nodeID = widget.snapshots[index].nodeID;
                      promptAreYouSure(
                              context,
                              "Download Backup",
                              Text(
                                  "Do you want to download the backup data for node: $nodeID?"))
                          .then((yes) {
                        if (yes) {
                          var downloadAction =
                              DownloadSnapshot(widget.snapshots[index].nodeID);
                          widget.backupBloc.backupActionsSink
                              .add(downloadAction);
                          var loaderRoute = createLoaderRoute(context);
                          Navigator.of(context).push(loaderRoute);
                          downloadAction.future.then((value) {
                            Navigator.removeRoute(context, loaderRoute);
                            _shareBackup(
                                (value as DownloadBackupResponse).files);
                          }).catchError((err) {
                            Navigator.removeRoute(context, loaderRoute);
                            promptError(context, "Download Error",
                                Text(err.toString()));
                          });
                        }
                      });
                    },
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
                    ? Text(
                        snapshot.error.toString(),
                        style: theme.errorStyle,
                      )
                    : Container();
              }),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(widget.context, null),
          child:
              Text("CANCEL", style: Theme.of(context).primaryTextTheme.button),
        ),
        FlatButton(
          textColor: theme.BreezColors.blue[500],
          disabledTextColor: theme.BreezColors.blue[500].withOpacity(0.4),
          onPressed: _selectedSnapshot == null
              ? null
              : () {
                  Navigator.pop(widget.context, _selectedSnapshot);
                },
          child: Text("OK"),
        )
      ],
    );
  }
}

Future _shareBackup(List<String> files) async {
  Directory tempDir = await getTemporaryDirectory();
  tempDir = await tempDir.createTemp("backup");
  var encoder = ZipFileEncoder();
  var zipFile = '${tempDir.path}/backup.zip';
  encoder.create(zipFile);
  files.forEach((f) {
    var file = File(f);
    encoder.addFile(file, "${file.path.split(Platform.pathSeparator).last}");
  });
  encoder.close();
  ShareExtend.share(zipFile, "file");
}

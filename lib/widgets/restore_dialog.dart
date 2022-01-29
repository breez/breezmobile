import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/services/breezlib/data/rpc.pbgrpc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
import 'package:breez/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

import 'error_dialog.dart';
import 'loader.dart';

class RestoreDialog extends StatefulWidget {
  final BuildContext context;
  final BackupBloc backupBloc;
  final List<SnapshotInfo> snapshots;

  const RestoreDialog(
    this.context,
    this.backupBloc,
    this.snapshots,
  );

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
    var l10n = context.l10n;
    ThemeData themeData = context.theme;
    DialogTheme dialogTheme = themeData.dialogTheme;
    TextTheme primaryTextTheme = themeData.primaryTextTheme;

    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
      title: Text(
        l10n.restore_dialog_title,
        style: dialogTheme.titleTextStyle,
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<BackupSettings>(
            stream: widget.backupBloc.backupSettingsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }

              return Text(
                l10n.restore_dialog_multiple_accounts(
                  snapshot.data.backupProvider.displayName,
                ),
                style: primaryTextTheme.headline3.copyWith(
                  fontSize: 16,
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Container(
              width: 150.0,
              height: 200.0,
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: widget.snapshots.length,
                itemBuilder: _itemBuilder,
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
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => widget.context.pop(null),
          child: Text(
            l10n.restore_dialog_action_cancel,
            style: primaryTextTheme.button,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            primary: theme.BreezColors.blue[500],
          ),
          onPressed: _selectedSnapshot == null
              ? null
              : () => widget.context.pop(_selectedSnapshot),
          child: Text(l10n.restore_dialog_action_ok),
        ),
      ],
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var l10n = context.l10n;
    ThemeData themeData = context.theme;
    TextTheme primaryTextTheme = themeData.primaryTextTheme;

    final item = widget.snapshots[index];
    final nodeID = _selectedSnapshot?.nodeID;
    final date = BreezDateUtils.formatYearMonthDayHourMinute(
      DateTime.parse(item.modifiedTime),
    );
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
      selected: nodeID == item.nodeID,
      trailing: nodeID == item.nodeID
          ? Icon(
        Icons.check,
        color: theme.BreezColors.blue[500],
      )
          : Icon(Icons.check),
      title: Text(
        item.encrypted
            ? l10n.restore_dialog_modified_encrypted(date)
            : l10n.restore_dialog_modified_not_encrypted(date),
        style: primaryTextTheme.caption
            .copyWith(fontSize: 9)
            .apply(fontSizeDelta: 1.3),
      ),
      subtitle: Text(
        item.nodeID,
        style: primaryTextTheme.caption.copyWith(fontSize: 9),
      ),
      onLongPress: () {
        var nodeID = item.nodeID;
        promptAreYouSure(
          context,
          l10n.restore_dialog_download_backup,
          Text(l10n.restore_dialog_download_backup_for_node(nodeID)),
        ).then((yes) {
          if (yes) {
            var downloadAction = DownloadSnapshot(item.nodeID);
            widget.backupBloc.backupActionsSink.add(downloadAction);
            var loaderRoute = createLoaderRoute(context);
            context.push(loaderRoute);
            downloadAction.future.then((value) {
              Navigator.removeRoute(context, loaderRoute);
              _shareBackup((value as DownloadBackupResponse).files);
            }).catchError((err) {
              Navigator.removeRoute(context, loaderRoute);
              promptError(
                context,
                l10n.restore_dialog_download_backup_error,
                Text(err.toString()),
              );
            });
          }
        });
      },
      onTap: () {
        setState(() {
          _selectedSnapshot = item;
        });
      },
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

import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/services/breezlib/data/rpc.pbgrpc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
    final texts = context.texts();
    final themeData = Theme.of(context);

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
      title: Text(
        texts.restore_dialog_title,
        style: themeData.dialogTheme.titleTextStyle,
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<BackupSettings>(
            stream: widget.backupBloc.backupSettingsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              return Text(
                texts.restore_dialog_multiple_accounts(
                  snapshot.data.backupProvider.displayName,
                ),
                style: themeData.primaryTextTheme.displaySmall.copyWith(
                  fontSize: 16,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
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
          onPressed: () => Navigator.pop(widget.context, null),
          child: Text(
            texts.restore_dialog_action_cancel,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: theme.BreezColors.blue[500],
          ),
          onPressed: _selectedSnapshot == null
              ? null
              : () => Navigator.pop(widget.context, _selectedSnapshot),
          child: Text(texts.restore_dialog_action_ok),
        ),
      ],
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    final item = widget.snapshots[index];
    final nodeID = _selectedSnapshot?.nodeID;
    var date = item.modifiedTime;
    var parsedDate = DateTime.tryParse(item.modifiedTime);
    if (parsedDate != null) {
      date = BreezDateUtils.formatYearMonthDayHourMinute(parsedDate);
    }
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      selected: nodeID == item.nodeID,
      trailing: nodeID == item.nodeID
          ? Icon(
              Icons.check,
              color: theme.BreezColors.blue[500],
            )
          : const Icon(Icons.check),
      title: Text(
        item.encrypted
            ? texts.restore_dialog_modified_encrypted(date)
            : texts.restore_dialog_modified_not_encrypted(date),
        style: themeData.primaryTextTheme.bodySmall
            .copyWith(fontSize: 9)
            .apply(fontSizeDelta: 1.3),
      ),
      subtitle: Text(
        item.nodeID,
        style: themeData.primaryTextTheme.bodySmall.copyWith(fontSize: 9),
      ),
      onLongPress: () {
        var nodeID = item.nodeID;
        promptAreYouSure(
          context,
          texts.restore_dialog_download_backup,
          Text(texts.restore_dialog_download_backup_for_node(nodeID)),
        ).then((yes) {
          if (yes) {
            var downloadAction = DownloadSnapshot(item.nodeID);
            widget.backupBloc.backupActionsSink.add(downloadAction);
            var loaderRoute = createLoaderRoute(context);
            Navigator.of(context).push(loaderRoute);
            downloadAction.future.then((value) {
              Navigator.removeRoute(context, loaderRoute);
              _shareBackup((value as DownloadBackupResponse).files);
            }).catchError((err) {
              Navigator.removeRoute(context, loaderRoute);
              promptError(
                context,
                texts.restore_dialog_download_backup_error,
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
  var zipFilePath = '${tempDir.path}/backup.zip';
  encoder.create(zipFilePath);
  for (var f in files) {
    var file = File(f);
    encoder.addFile(file, file.path.split(Platform.pathSeparator).last);
  }
  encoder.close();
  final zipFile = XFile(zipFilePath);
  Share.shareXFiles([zipFile]);
}

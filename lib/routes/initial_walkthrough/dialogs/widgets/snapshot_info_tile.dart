import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/services/breezlib/data/messages.pbgrpc.dart';
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SnapshotInfoTile extends StatefulWidget {
  final SnapshotInfo selectedSnapshot;
  final SnapshotInfo snapshotInfo;
  final Function(SnapshotInfo snapshotInfo) onSnapshotSelected;

  const SnapshotInfoTile({
    this.selectedSnapshot,
    this.snapshotInfo,
    this.onSnapshotSelected,
  });

  @override
  State<SnapshotInfoTile> createState() => _SnapshotInfoTileState();
}

class _SnapshotInfoTileState extends State<SnapshotInfoTile> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    final isSelected =
        (widget.selectedSnapshot?.nodeID == widget.snapshotInfo.nodeID);

    var date = widget.snapshotInfo.modifiedTime;
    var parsedDate = DateTime.tryParse(widget.snapshotInfo.modifiedTime);
    if (parsedDate != null) {
      date = BreezDateUtils.formatYearMonthDayHourMinute(parsedDate);
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      selected: isSelected,
      trailing: isSelected
          ? Icon(
              Icons.check,
              color: themeData.primaryColor,
            )
          : const Icon(Icons.check),
      title: Text(
        widget.snapshotInfo.encrypted
            ? texts.restore_dialog_modified_encrypted(date)
            : texts.restore_dialog_modified_not_encrypted(date),
        style: themeData.primaryTextTheme.bodySmall
            .copyWith(fontSize: 9)
            .apply(fontSizeDelta: 1.3),
      ),
      subtitle: Text(
        widget.snapshotInfo.nodeID,
        style: themeData.primaryTextTheme.bodySmall.copyWith(fontSize: 9),
      ),
      onLongPress: () => _downloadAndShareSnapshot(),
      onTap: () => widget.onSnapshotSelected(widget.snapshotInfo),
    );
  }

  void _downloadAndShareSnapshot() {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    final texts = context.texts();

    var nodeID = widget.snapshotInfo.nodeID;
    promptAreYouSure(
      context,
      texts.restore_dialog_download_backup,
      Text(texts.restore_dialog_download_backup_for_node(nodeID)),
    ).then((yes) {
      if (yes) {
        var downloadAction = DownloadSnapshot(nodeID);
        backupBloc.backupActionsSink.add(downloadAction);
        downloadAction.future.then((value) {
          _shareSnapshot(
            (value as DownloadBackupResponse).files,
          );
        }).catchError((err) {
          promptError(
            context,
            texts.restore_dialog_download_backup_error,
            Text(err.toString()),
          );
        });
      }
    });
  }

  Future _shareSnapshot(List<String> files) async {
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
}

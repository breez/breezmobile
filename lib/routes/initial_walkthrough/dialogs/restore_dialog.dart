import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/initial_walkthrough/dialogs/widgets/snapshot_info_tile.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class RestoreDialog extends StatefulWidget {
  final List<SnapshotInfo> snapshots;

  const RestoreDialog(this.snapshots);

  @override
  RestoreDialogState createState() {
    return RestoreDialogState();
  }
}

class RestoreDialogState extends State<RestoreDialog> {
  SnapshotInfo _selectedSnapshot;

  @override
  Widget build(BuildContext context) {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);

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
            stream: backupBloc.backupSettingsStream,
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
                itemBuilder: (BuildContext context, int index) {
                  return SnapshotInfoTile(
                    selectedSnapshot: _selectedSnapshot,
                    snapshotInfo: widget.snapshots[index],
                    onSnapshotSelected: (snapshot) {
                      setState(() {
                        _selectedSnapshot = snapshot;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(
            texts.restore_dialog_action_cancel,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: themeData.primaryColor,
          ),
          onPressed: _selectedSnapshot == null
              ? null
              : () => Navigator.pop(context, _selectedSnapshot),
          child: Text(texts.restore_dialog_action_ok),
        ),
      ],
    );
  }
}

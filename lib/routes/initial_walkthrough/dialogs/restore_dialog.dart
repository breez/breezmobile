import 'dart:convert';

import 'package:bip39/bip39.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/initial_walkthrough/dialogs/widgets/restore_pin_code.dart';
import 'package:breez/routes/initial_walkthrough/dialogs/widgets/snapshot_info_tile.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';

class RestoreDialog extends StatefulWidget {
  final List<SnapshotInfo> snapshots;
  final BackupSettings backupSettings;
  final Sink<bool> reloadDatabaseSink;

  const RestoreDialog(
    this.snapshots,
    this.backupSettings,
    this.reloadDatabaseSink,
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
          if (widget.backupSettings?.backupProvider != null) ...[
            Text(
              texts.restore_dialog_multiple_accounts(
                widget.backupSettings.backupProvider.displayName,
              ),
              style: themeData.primaryTextTheme.displaySmall.copyWith(
                fontSize: 16,
              ),
            )
          ],
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
          onPressed: () => _restoreSnapshot(),
          child: Text(texts.restore_dialog_action_ok),
        ),
      ],
    );
  }

  void _restoreSnapshot() {
    if (_selectedSnapshot == null) {
      showFlushbar(context, message: "Please select a snapshot to restore.");
      return;
    }
    if (_selectedSnapshot.encrypted) {
      if (_selectedSnapshot.encryptionType.startsWith("Mnemonics")) {
        log.info(
          'restoring backup with mnemonic of type ${_selectedSnapshot.encryptionType}',
        );
        _restoreNodeFromMnemonicSeed();
      } else {
        log.info('restoring backup with pin"');
        _restoreNodeUsingPIN();
        return;
      }
    } else {
      _restore(_selectedSnapshot, null);
    }
  }

  void _restoreNodeFromMnemonicSeed() async {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);

    final texts = context.texts();
    final themeData = Theme.of(context);

    String mnemonic = await _getMnemonic(context);
    if (mnemonic != null) {
      String entropy = mnemonicToEntropy(mnemonic);
      // Save Backup Key
      final saveBackupKeyAction = SaveBackupKey(entropy);
      backupBloc.backupActionsSink.add(saveBackupKeyAction);
      await saveBackupKeyAction.future.catchError((err) {
        promptError(
          context,
          texts.initial_walk_through_error_internal,
          Text(
            err.toString(),
            style: themeData.dialogTheme.contentTextStyle,
          ),
        );
      });
      // Update Backup Settings
      final updateAction = UpdateBackupSettings(
        widget.backupSettings.copyWith(
          keyType: BackupKeyType.PHRASE,
        ),
      );
      backupBloc.backupActionsSink.add(updateAction);
      updateAction.future.then((_) {
        _restore(
          _selectedSnapshot,
          HEX.decode(entropy),
        );
      }).catchError((err) {
        promptError(
          context,
          texts.initial_walk_through_error_internal,
          Text(
            err.toString(),
            style: themeData.dialogTheme.contentTextStyle,
          ),
        );
      });
    }
  }

  Future<String> _getMnemonic(BuildContext context) async {
    return Navigator.of(context).pushNamed('/enter_mnemonics');
  }

  void _restoreNodeUsingPIN() async {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);

    String pin = await _getPIN(context);
    if (pin != null) {
      log.info("Restore Node using PIN: $pin");
      final updateAction = UpdateBackupSettings(
        widget.backupSettings.copyWith(keyType: BackupKeyType.NONE),
      );
      final key = sha256.convert(utf8.encode(pin));
      backupBloc.backupActionsSink.add(updateAction);
      updateAction.future
          .then((_) => _restore(_selectedSnapshot, key.bytes))
          .catchError(
        (err) {
          final texts = context.texts();
          final themeData = Theme.of(context);

          promptError(
            context,
            texts.initial_walk_through_error_internal,
            Text(
              err.toString(),
              style: themeData.dialogTheme.contentTextStyle,
            ),
          );
        },
      );
    }
  }

  Future<String> _getPIN(
    BuildContext context,
  ) async {
    return await Navigator.of(context).push(
      FadeInRoute(
        builder: (BuildContext context) {
          return const RestorePinCode();
        },
      ),
    );
  }

  void _restore(SnapshotInfo snapshot, List<int> key) {
    Navigator.pop(
      context,
      RestoreRequest(snapshot, BreezLibBackupKey(key: key)),
    );
  }
}

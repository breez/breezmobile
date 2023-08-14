import 'dart:convert';

import 'package:bip39/bip39.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/initial_walkthrough/dialogs/widgets/restore_pin_code.dart';
import 'package:breez/routes/initial_walkthrough/dialogs/widgets/snapshot_info_tile.dart';
import 'package:breez/routes/initial_walkthrough/loaders/loader_indicator.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hex/hex.dart';

class RestoreDialog extends StatefulWidget {
  final List<SnapshotInfo> snapshots;
  final Sink<bool> reloadDatabaseSink;

  const RestoreDialog(this.snapshots, this.reloadDatabaseSink);

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
          onPressed: _selectedSnapshot == null ? null : () => _restoreSnapshot,
          child: Text(texts.restore_dialog_action_ok),
        ),
      ],
    );
  }

  void _restoreSnapshot(
    SnapshotInfo snapshotInfo,
    BackupSettings backupSettings,
  ) {
    if (snapshotInfo.encrypted) {
      if (snapshotInfo.encryptionType.startsWith("Mnemonics")) {
        log.info(
            'restore_request_handler.dart: restoring backup with mnemonic of type "${snapshotInfo.encryptionType}"');
        _restoreNodeFromMnemonicSeed(context, snapshotInfo, backupSettings);
      } else {
        log.info('restore_request_handler.dart: restoring backup with pin"');
        _restoreNodeUsingPIN(context, snapshotInfo, backupSettings);
        return;
      }
    } else {
      _restore(snapshotInfo, null);
    }
  }

  void _restoreNodeFromMnemonicSeed(
    BuildContext context,
    SnapshotInfo snapshot,
    BackupSettings backupSettings,
  ) async {
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
        backupSettings.copyWith(
          keyType: BackupKeyType.PHRASE,
        ),
      );
      backupBloc.backupActionsSink.add(updateAction);
      updateAction.future.then((_) {
        _restore(
          snapshot,
          HEX.decode(entropy),
        );
      });
    }
  }

  Future<String> _getMnemonic(BuildContext context) async {
    return Navigator.of(context).pushNamed('/enter_mnemonics');
  }

  void _restoreNodeUsingPIN(
    BuildContext context,
    SnapshotInfo snapshot,
    BackupSettings backupSettings,
  ) async {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);

    String pin = await _getPIN(context);
    if (pin != null) {
      log.info("Restore Node using PIN: $pin");
      final updateAction = UpdateBackupSettings(
        backupSettings.copyWith(keyType: BackupKeyType.NONE),
      );
      final key = sha256.convert(utf8.encode(pin));
      backupBloc.backupActionsSink.add(updateAction);
      updateAction.future.then((_) => _restore(snapshot, key.bytes));
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

  Future<void> _restore(SnapshotInfo snapshot, List<int> key) {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);

    const logKey = "restore_request_handler.dart.restore";
    log.info('$logKey: snapshotInfo with timestamp: ${snapshot?.modifiedTime}');
    log.info('$logKey: using key with length: ${key?.length}');

    var restoreBackupAction = RestoreBackup(
      RestoreRequest(
        snapshot,
        BreezLibBackupKey(key: key),
      ),
    );
    backupBloc.backupActionsSink.add(restoreBackupAction);
    final texts = context.texts();
    // TODO Remove ... from translation
    EasyLoading.show(
      indicator: LoaderIndicator(
        message: texts.initial_walk_through_restoring,
      ),
    );
    return restoreBackupAction.future
        .then((isRestored) => _completeRestoration(isRestored),
            onError: (error) => _handleError(error))
        .whenComplete(() => EasyLoading.dismiss());
  }

  void _completeRestoration(bool isRestored) async {
    if (isRestored) {
      final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
      posCatalogBloc.reloadPosItemsSink.add(true);
      widget.reloadDatabaseSink.add(true);
      Navigator.popUntil(context, (route) {
        return route.settings.name == "/intro";
      });
      final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      userProfileBloc.registerSink.add(null);
      Navigator.of(context).pop();
    }
  }

  void _handleError(error) {
    EasyLoading.dismiss();

    if (error.runtimeType != SignInFailedException) {
      String errorMessage = error.toString();
      if (errorMessage.contains("FileSystemException")) {
        errorMessage = context.texts().enter_backup_phrase_error;
      }
      showFlushbar(
        context,
        duration: const Duration(seconds: 3),
        message: errorMessage,
      );
    } else {
      _handleSignInException(error as SignInFailedException);
    }
  }

  Future _handleSignInException(SignInFailedException e) async {
    final texts = context.texts();
    if (e.provider == BackupSettings.icloudBackupProvider()) {
      final themeData = Theme.of(context);

      await promptError(
        context,
        texts.initial_walk_through_sign_in_icloud_title,
        Text(
          texts.initial_walk_through_sign_in_icloud_message,
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
    } else if (e.provider == BackupSettings.googleBackupProvider()) {
      showFlushbar(
        context,
        duration: const Duration(seconds: 3),
        message: "Failed to sign into Google Drive.",
      );
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:bip39/bip39.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/initial_walkthrough/dialogs/restore_dialog.dart';
import 'package:breez/routes/initial_walkthrough/dialogs/widgets/restore_pin_code.dart';
import 'package:breez/routes/initial_walkthrough/handlers/models/backup_context.dart';
import 'package:breez/routes/initial_walkthrough/handlers/models/handler.dart';
import 'package:breez/routes/initial_walkthrough/handlers/models/handler_context_provider.dart';
import 'package:breez/routes/initial_walkthrough/loaders/loader_indicator.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hex/hex.dart';
import 'package:rxdart/rxdart.dart';

class RestoreRequestHandler extends Handler {
  RestoreRequestHandler();

  StreamSubscription<BackupContext> _backupRequestSubscription;

  @override
  void init(HandlerContextProvider contextProvider) {
    super.init(contextProvider);
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      return;
    }
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    _backupRequestSubscription =
        Rx.combineLatest2<List<SnapshotInfo>, BackupSettings, BackupContext>(
      backupBloc.multipleRestoreStream,
      backupBloc.backupSettingsStream,
      (a, b) => BackupContext(a, b),
    ).listen(
      (backupContext) => _handleRestoreRequest(backupContext),
      onError: (error) => _handleError(error),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _backupRequestSubscription?.cancel();
    _backupRequestSubscription = null;
  }

  void _handleRestoreRequest(BackupContext backupContext) async {
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      return;
    }

    EasyLoading.dismiss();

    final snapshots = backupContext.snapshots;
    if (snapshots.isEmpty) {
      _handleEmptySnapshot(context);
      return;
    }
    await _selectSnapshotToRestore(context, snapshots).then(
      (toRestore) {
        if (toRestore != null) {
          _restoreSnapshot(context, toRestore, backupContext.settings);
        }
      },
    );
  }

  Future<SnapshotInfo> _selectSnapshotToRestore(
    BuildContext context,
    List<SnapshotInfo> snapshots,
  ) async {
    if (snapshots.length == 1) {
      return snapshots.first;
    } else {
      EasyLoading.dismiss();

      Navigator.popUntil(context, (route) {
        return route.settings.name == "/intro";
      });
      return await showDialog<SnapshotInfo>(
        useRootNavigator: false,
        context: context,
        builder: (_) => RestoreDialog(snapshots),
      );
    }
  }

  void _restoreSnapshot(
    BuildContext context,
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

  void _handleEmptySnapshot(BuildContext context) {
    Navigator.popUntil(context, (route) {
      return route.settings.name == "/intro";
    });
    final texts = context.texts();
    SnackBar snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(texts.initial_walk_through_error_backup_location),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  void _restore(SnapshotInfo snapshot, List<int> key) {
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      return;
    }
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);

    const logKey = "restore_request_handler.dart.restore";
    log.info('$logKey: snapshotInfo with timestamp: ${snapshot?.modifiedTime}');
    log.info('$logKey: using key with length: ${key?.length}');

    backupBloc.restoreRequestSink.add(
      RestoreRequest(
        snapshot,
        BreezLibBackupKey(key: key),
      ),
    );
    final texts = context.texts();
    EasyLoading.show(
      indicator: LoaderIndicator(
        message: texts.initial_walk_through_restoring,
      ),
    );
  }

  void _handleError(error) {
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      return;
    }

    EasyLoading.dismiss();

    Navigator.popUntil(context, (route) {
      return route.settings.name == "/intro";
    });
    if (error.runtimeType != SignInFailedException) {
      SnackBar snackBar = SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(error.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      _handleSignInException(error as SignInFailedException);
    }
  }

  Future _handleSignInException(SignInFailedException e) async {
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      return;
    }

    if (e.provider == BackupSettings.icloudBackupProvider()) {
      final texts = context.texts();
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

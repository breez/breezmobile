import 'dart:async';

import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/initial_walkthrough/handlers/models/handler.dart';
import 'package:breez/routes/initial_walkthrough/handlers/models/handler_context_provider.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rxdart/rxdart.dart';

class BackupRestoreHandler extends Handler {
  final Sink<bool> reloadDatabaseSink;

  BackupRestoreHandler(this.reloadDatabaseSink);

  StreamSubscription<bool> _restoreFinishedSubscription;

  @override
  void init(HandlerContextProvider contextProvider) {
    super.init(contextProvider);
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      return;
    }
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    _restoreFinishedSubscription = backupBloc.restoreFinishedStream
        .delay(const Duration(seconds: 1))
        .listen(
          (isRestored) => _completeRestoration(isRestored),
          onError: (error) => _handleError(error),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _restoreFinishedSubscription?.cancel();
    _restoreFinishedSubscription = null;
  }

  void _completeRestoration(bool isRestored) async {
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      return;
    }

    EasyLoading.dismiss();

    if (isRestored) {
      final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
      posCatalogBloc.reloadPosItemsSink.add(true);
      reloadDatabaseSink.add(true);
      Navigator.popUntil(context, (route) {
        return route.settings.name == "/intro";
      });
      final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      userProfileBloc.registerSink.add(null);
      Navigator.of(context).pop();
    }
  }

  void _handleError(error) {
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      return;
    }

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
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      return;
    }
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

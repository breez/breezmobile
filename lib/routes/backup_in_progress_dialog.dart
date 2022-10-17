import 'dart:async';

import 'package:clovrlabs_wallet/bloc/backup/backup_model.dart';
import 'package:clovrlabs_wallet/widgets/animated_loader_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget buildBackupInProgressDialog(
  BuildContext context,
  Stream<BackupState> backupStateStream,
) {
  return _BackupInProgressDialog(backupStateStream: backupStateStream);
}

class _BackupInProgressDialog extends StatefulWidget {
  final Stream<BackupState> backupStateStream;

  const _BackupInProgressDialog({
    Key key,
    this.backupStateStream,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BackupInProgressDialogState();
  }
}

class _BackupInProgressDialogState extends State<_BackupInProgressDialog> {
  StreamSubscription<BackupState> _stateSubscription;

  @override
  void initState() {
    super.initState();
    _stateSubscription = widget.backupStateStream.listen((state) {
      if (state.inProgress != true) {
        _pop();
      }
    }, onError: (err) => _pop());
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    super.dispose();
  }

  _pop() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return createAnimatedLoaderDialog(context, texts.backup_in_progress);
  }
}

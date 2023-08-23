import 'dart:async';

import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/widgets/animated_loader_dialog.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

Widget buildBackupInProgressDialog(
  BuildContext context,
  Stream<BackupState> backupStateStream, {
  bool barrierDismissible = true,
}) {
  return _BackupInProgressDialog(
    backupStateStream: backupStateStream,
    barrierDismissible: barrierDismissible,
  );
}

class _BackupInProgressDialog extends StatefulWidget {
  final Stream<BackupState> backupStateStream;
  final bool barrierDismissible;

  const _BackupInProgressDialog({
    Key key,
    @required this.backupStateStream,
    this.barrierDismissible,
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
        Navigator.of(context).pop();
      }
    }, onError: (err) {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return createAnimatedLoaderDialog(
      context,
      texts.backup_in_progress,
      withOKButton: widget.barrierDismissible,
    );
  }
}

import 'dart:async';

import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/widgets/animated_loader_dialog.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

Widget buildBackupInProgressDialog(
  BuildContext context,
  Stream<BackupState> backupStateStream, {
  bool barrierDismissible = true,
  VoidCallback onFinished,
}) {
  return _BackupInProgressDialog(
    backupStateStream: backupStateStream,
    barrierDismissible: barrierDismissible,
    onFinished: onFinished,
  );
}

class _BackupInProgressDialog extends StatefulWidget {
  final Stream<BackupState> backupStateStream;
  final bool barrierDismissible;
  final VoidCallback onFinished;

  const _BackupInProgressDialog({
    Key key,
    @required this.backupStateStream,
    this.barrierDismissible,
    this.onFinished,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BackupInProgressDialogState();
  }
}

class _BackupInProgressDialogState extends State<_BackupInProgressDialog> {
  StreamSubscription<BackupState> _stateSubscription;
  ModalRoute _currentRoute;

  @override
  void initState() {
    super.initState();
    _stateSubscription = widget.backupStateStream.listen((state) {
      if (state.inProgress != true && _currentRoute.isActive) {
        widget.onFinished();
        Navigator.of(context).removeRoute(_currentRoute);
      }
    }, onError: (err) {
      if (_currentRoute.isActive) {
        widget.onFinished();
        Navigator.of(context).removeRoute(_currentRoute);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute ??= ModalRoute.of(context);
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

import 'dart:async';

import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

Widget buildBackupInProgressDialog(
    BuildContext context, Stream<BackupState> backupStateStream) {
  return new _BackupInProgressDialog(backupStateStream: backupStateStream);
}

class _BackupInProgressDialog extends StatefulWidget {
  final Stream<BackupState> backupStateStream;

  const _BackupInProgressDialog({Key key, this.backupStateStream})
      : super(key: key);
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
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new LoadingAnimatedText(
            "Backup is in progress",
            textStyle: theme.alertStyle,
            textAlign: TextAlign.center,
          ),
          new Image.asset(
            'src/images/breez_loader.gif',
            height: 64.0,
            colorBlendMode: BlendMode.multiply,
            gaplessPlayback: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FlatButton(
                child: Text('OK', style: theme.buttonStyle),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              )
            ],
          )
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    );
  }
}

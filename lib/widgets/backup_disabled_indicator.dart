import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:breez/widgets/enable_backup_dialog.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';


class BackupDisabledIndicator extends StatefulWidget {
  final BackupBloc _backupBloc;

  BackupDisabledIndicator(this._backupBloc);

  @override
  BackupDisabledIndicatorState createState() {
    return new BackupDisabledIndicatorState();
  }
}

class BackupDisabledIndicatorState extends State<BackupDisabledIndicator> {
  StreamSubscription<bool> _promptEnableSubscription;

  @override
  void initState() {
    _promptEnableSubscription = widget._backupBloc.promptEnableStream.listen((enable) {
      if (enable) {
        showDialog(context: context, builder: (_) =>
            new EnableBackupDialog(context, widget._backupBloc));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _promptEnableSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<bool>(
        stream: widget._backupBloc.backupDisabledStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data) {
            return Container();
          } else {
            return GestureDetector(
              onTap: () {
                showDialog(context: context, builder: (_) =>
                new EnableBackupDialog(context, widget._backupBloc));
              },
              child:
            SvgPicture.asset(
              "src/icon/warning.svg",
              color: Color.fromRGBO(0, 120, 253, 1.0),
            ));
          }
        });
  }
}

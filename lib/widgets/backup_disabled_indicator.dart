import 'package:flutter/material.dart';
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
  @override
  void initState() {
    widget._backupBloc.promptEnableStream.listen((enable) {
      if (enable) {
        showDialog(context: context, builder: (_) =>
            new EnableBackupDialog(context, widget._backupBloc));
      }
    });
    super.initState();
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

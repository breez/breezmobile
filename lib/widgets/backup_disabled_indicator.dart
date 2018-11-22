import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:breez/widgets/enable_backup_dialog.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';


class BackupDisabledIndicator extends StatelessWidget {
  final BackupBloc _backupBloc;

  BackupDisabledIndicator(this._backupBloc);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<bool>(
        stream: _backupBloc.backupDisabledStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data) {
            return Container();
          } else {
            return GestureDetector(
              onTap: () => new EnableBackupDialog(context, _backupBloc),
              child:
            SvgPicture.asset(
              "src/icon/warning.svg",
              color: Color.fromRGBO(0, 120, 253, 1.0),
            ));
          }
        });
  }
}

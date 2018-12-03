import 'package:breez/bloc/backup/backup_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:breez/widgets/enable_backup_dialog.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:rxdart/rxdart.dart';

class BackupDisabledIndicator extends StatefulWidget {
  final BackupBloc _backupBloc;

  BackupDisabledIndicator(this._backupBloc);

  @override
  BackupDisabledIndicatorState createState() {
    return new BackupDisabledIndicatorState();
  }
}

class BackupDisabledIndicatorState extends State<BackupDisabledIndicator> {
  StreamSubscription<DateTime> _promptEnableSubscription;
  StreamSubscription<BackupSettings> _settingsSubscription;
  BackupSettings _currentSettings;

  @override
  void initState() {
    _settingsSubscription = widget._backupBloc.backupSettingsStream.listen((settings) => _currentSettings = settings);

    _promptEnableSubscription = 
      Observable(widget._backupBloc.lastBackupTimeStream)
      .delay(Duration(seconds: 1))
      .listen(
        (lastBackup){}, 
        onError: (err){
          if(_currentSettings.promptOnError){

            Navigator.popUntil(context, (route) {
              return route.settings.name == "/home" || route.settings.name == "/";          
            });

            showDialog(
                context: context,
                builder: (_) => new EnableBackupDialog(context, widget._backupBloc));
            }
        });

    super.initState();
  }

  @override
  void dispose() {
    _promptEnableSubscription.cancel();
    _settingsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: widget._backupBloc.lastBackupTimeStream,
      builder: (context, snapshot) {
        if (!snapshot.hasError) {
          return Container();
        } else {
          return GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) =>
                        new EnableBackupDialog(context, widget._backupBloc));
              },
              child: SvgPicture.asset(
                "src/icon/warning.svg",
                color: Color.fromRGBO(0, 120, 253, 1.0),
              ));
        }
      });
  }
}

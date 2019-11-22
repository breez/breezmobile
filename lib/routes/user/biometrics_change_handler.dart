import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:flutter/material.dart';

class BiometricsChangeHandler {
  final UserProfileBloc userProfileBloc;
  final BackupBloc backupBloc;
  final BuildContext _context;

  BiometricsChangeHandler(this.userProfileBloc, this.backupBloc, this._context) {
    userProfileBloc.userStream
        .map((u) => u.securityModel.enrolledBiometricIds)
        .distinct()
        .where((enrolledBiometricIds) => enrolledBiometricIds == "")
        .listen((_) {
      showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text("Change Detected", style: Theme.of(_context).dialogTheme.titleTextStyle),
          content: Text(
              "A change to the fingerprint configuration on this device was detected. To reactivate fingerprint, go to Advanced > Security & Backup.",
              style: Theme.of(_context).dialogTheme.contentTextStyle),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK", style: Theme.of(_context).primaryTextTheme.button),
              onPressed: () async {
                Navigator.pop(_context);
              },
            )
          ],
        ),
      );
    });
  }
}

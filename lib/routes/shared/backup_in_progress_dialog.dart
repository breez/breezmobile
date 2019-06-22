
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

Widget buildBackupInProgressDialog(BuildContext context, Stream<BackupState> backupStateStream){
  return new AlertDialog(      
    contentPadding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
      content: StreamBuilder<BackupState>(
        stream: backupStateStream,
        builder: (ctx, snapshot){
          if (snapshot.hasError) {            
            return Text(
                "Backup Failed",
                style: theme.alertStyle,
                textAlign: TextAlign.center,
              );         
          }

          if (!snapshot.hasData) {
            return SizedBox();
          }

          if (!snapshot.data.inProgress) {
            return Text(
                "Backup Completed Succesfully",
                style: theme.alertStyle,
                textAlign: TextAlign.center,
              );
          }
          return Column(
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
                    gaplessPlayback: true,
                  )
            ],
          );
        }),
      actions: <Widget>[
        FlatButton(
          child: Text('OK', style: theme.buttonStyle),          
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ],    
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    );
}    
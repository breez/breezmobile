import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackupProviderSelectionDialog extends StatefulWidget {
  final BackupBloc backupBloc;
  final bool restore;

  const BackupProviderSelectionDialog(
      {Key key, this.backupBloc, this.restore = false})
      : super(key: key);

  @override
  BackupProviderSelectionDialogState createState() {
    return new BackupProviderSelectionDialogState();
  }
}

class BackupProviderSelectionDialogState
    extends State<BackupProviderSelectionDialog> {
  int _selectedProviderIndex = 0;

  @override
  Widget build(BuildContext context) {
    return createRestoreDialog();
  }

  Widget createRestoreDialog() {
    return new AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
      title: new Text(
        "Backup Data Storage",
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Text(
            widget.restore
                ? "Restore backup data from:"
                : "Store backup data in:",
            style: Theme.of(context).primaryTextTheme.display2.copyWith(fontSize: 16),
          ),
          new StreamBuilder<BackupSettings>(
              stream: widget.backupBloc.backupSettingsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                }

                List<BackupProvider> providers =
                    BackupSettings.availableBackupProviders();
                return Container(
                  width: 150.0,
                  height: 100.0,
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: providers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                        selected: _selectedProviderIndex == index,
                        trailing: _selectedProviderIndex == index
                            ? Icon(
                                Icons.check,
                                color: Theme.of(context).primaryTextTheme.button.color,
                              )
                            : Icon(Icons.check, color: Theme.of(context).backgroundColor),
                        title: Text(
                          providers[index].displayName,
                          style: Theme.of(context).dialogTheme.titleTextStyle.copyWith(fontSize: 14.3, height: 1.2), // Color needs to change
                        ),
                        onTap: () {
                          setState(() {
                            _selectedProviderIndex = index;
                          });
                        },
                      );
                    },
                  ),
                );
              }),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text("CANCEL", style: Theme.of(context).textTheme.button,),
          textColor: Theme.of(context).primaryTextTheme.button.color,
        ),
        StreamBuilder<BackupSettings>(
            stream: widget.backupBloc.backupSettingsStream,
            builder: (context, snapshot) {
              return new FlatButton(
                textColor: Theme.of(context).primaryTextTheme.button.color,
                disabledTextColor: Theme.of(context).primaryTextTheme.button.color.withOpacity(0.4),
                onPressed: !snapshot.hasData
                    ? null
                    : () {
                        var selectedProvider = BackupSettings
                            .availableBackupProviders()[_selectedProviderIndex];
                        var setAction = UpdateBackupSettings(snapshot.data
                            .copyWith(backupProvider: selectedProvider));
                        widget.backupBloc.backupActionsSink.add(setAction);
                        setAction.future.then(
                            (_) => Navigator.pop(context, selectedProvider));
                      },
                child: new Text("OK"),
              );
            })
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    );
  }
}

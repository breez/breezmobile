import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/bloc/backup/backup_bloc.dart';

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
        style: theme.alertTitleStyle,
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
            style: theme.paymentRequestSubtitleStyle,
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
                                color: theme.BreezColors.blue[500],
                              )
                            : Icon(Icons.check),
                        title: Text(
                          providers[index].displayName,
                          style: theme.backupProviderTitleStyle,
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
          child: new Text("CANCEL", style: theme.buttonStyle),
        ),
        StreamBuilder<BackupSettings>(
            stream: widget.backupBloc.backupSettingsStream,
            builder: (context, snapshot) {
              return new FlatButton(
                textColor: theme.BreezColors.blue[500],
                disabledTextColor: theme.BreezColors.blue[500].withOpacity(0.4),
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

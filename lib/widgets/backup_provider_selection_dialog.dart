import 'package:auto_size_text/auto_size_text.dart';
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
    return BackupProviderSelectionDialogState();
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
    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 16.0),
      title: Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        child: AutoSizeText(
          "Backup Data Storage",
          style: Theme.of(context).dialogTheme.titleTextStyle,
          maxLines: 1,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            widget.restore
                ? "Restore backup data from:"
                : "Store backup data in:",
            style: Theme.of(context)
                .primaryTextTheme
                .headline3
                .copyWith(fontSize: 16),
          ),
          StreamBuilder<BackupSettings>(
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
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
                              )
                            : Icon(Icons.check,
                                color: Theme.of(context).backgroundColor),
                        title: Text(
                          providers[index].displayName,
                          style: Theme.of(context)
                              .dialogTheme
                              .titleTextStyle
                              .copyWith(
                                  fontSize: 14.3,
                                  height: 1.2), // Color needs to change
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
        TextButton(
          style: TextButton.styleFrom(
              primary: Theme.of(context).primaryTextTheme.button.color),
          onPressed: () => Navigator.pop(context, null),
          child: Text(
            "CANCEL",
            style: Theme.of(context).textTheme.button,
          ),
        ),
        StreamBuilder<BackupSettings>(
            stream: widget.backupBloc.backupSettingsStream,
            builder: (context, snapshot) {
              return TextButton(
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryTextTheme.button.color,
                ),
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
                child: Text("OK"),
              );
            })
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    );
  }
}

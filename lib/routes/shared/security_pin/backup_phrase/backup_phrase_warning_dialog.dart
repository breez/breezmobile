import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class BackupPhraseWarningDialog extends StatefulWidget {
  @override
  _BackupPhraseWarningDialogState createState() => new _BackupPhraseWarningDialogState();
}

class _BackupPhraseWarningDialogState extends State<BackupPhraseWarningDialog> {
  @override
  void initState() {
    super.initState();
  }

  _getContent() {
    List<Widget> children = <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 12.0),
        child: new Text(
          "Your existing backup phrase will no longer be valid and a new one will be generated next time you decide to use a backup phrase. Are you sure you don't want to use a backup phrase?",
          style: Theme.of(context).dialogTheme.contentTextStyle,
        ),
      ),
    ];

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).canvasColor,
        ),
        child: new AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _getContent(),
          ),
          actions: [
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text("NO", style: Theme.of(context).primaryTextTheme.button),
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: new Text("YES", style: Theme.of(context).primaryTextTheme.button),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
        ));
  }
}

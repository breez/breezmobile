import 'package:breez/utils/build_context.dart';
import 'package:flutter/material.dart';

class BackupPhraseWarningDialog extends StatefulWidget {
  @override
  _BackupPhraseWarningDialogState createState() =>
      _BackupPhraseWarningDialogState();
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
        child: Text(
          "Your existing backup phrase will no longer be valid and a new one will be generated next time you decide to use a backup phrase. Are you sure you don't want to use a backup phrase?",
          style: context.dialogTheme.contentTextStyle,
        ),
      ),
    ];

    return children;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = context.theme;
    TextStyle textStyle = themeData.primaryTextTheme.button;
    return Theme(
        data: themeData.copyWith(
          unselectedWidgetColor: themeData.canvasColor,
        ),
        child: AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _getContent(),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text("NO", style: textStyle),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              child: Text("YES", style: textStyle),
            ),
          ],
        ));
  }
}

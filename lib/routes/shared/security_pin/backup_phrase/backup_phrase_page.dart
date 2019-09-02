import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';

class BackupPhraseGeneratorPage extends StatefulWidget {
  @override
  BackupPhraseGeneratorPageState createState() => new BackupPhraseGeneratorPageState();
}

class BackupPhraseGeneratorPageState extends State<BackupPhraseGeneratorPage> {
  bool _isUnderstood = false;
  String _instructions =
      "You will be shown a list of words.\nWrite down the words and store them in a safe place. Without these words, you won't be able to restore from backup and you funds will be lost. Breez won’t be able to help.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            iconTheme: theme.appBarIconTheme,
            textTheme: theme.appBarTextTheme,
            backgroundColor: theme.BreezColors.blue[500],
            automaticallyImplyLeading: false,
            leading: backBtn.BackButton(),
            title: new Text(
              "Generate Backup Phrase",
              style: theme.appBarTextStyle,
            ),
            elevation: 0.0),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 96, bottom: 72),
              child: Image(
                image: AssetImage("src/images/generate_backup_phrase.png"),
                height: 100,
                width: 100,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 48, right: 48),
              child: Text(
                _instructions,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                      activeColor: theme.BreezColors.white[500],
                      checkColor: theme.BreezColors.blue[500],
                      value: _isUnderstood,
                      onChanged: (value) {
                        setState(() {
                          _isUnderstood = value;
                        });
                      }),
                  Text(
                    "I UNDERSTAND",
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

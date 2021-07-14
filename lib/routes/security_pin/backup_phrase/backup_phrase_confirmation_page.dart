import 'package:auto_size_text/auto_size_text.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'generate_backup_phrase_page.dart';

class BackupPhraseGeneratorConfirmationPage extends StatefulWidget {
  @override
  BackupPhraseGeneratorConfirmationPageState createState() =>
      BackupPhraseGeneratorConfirmationPageState();
}

class BackupPhraseGeneratorConfirmationPageState
    extends State<BackupPhraseGeneratorConfirmationPage> {
  bool _isUnderstood = false;
  String _instructions =
      "You will be shown a list of words. Write down the words and store them in a safe place. Without these words, you won't be able to restore from backup and your funds will be lost. Breez won’t be able to help.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
            textTheme: Theme.of(context).appBarTheme.textTheme,
            backgroundColor: Theme.of(context).canvasColor,
            automaticallyImplyLeading: false,
            leading: backBtn.BackButton(),
            title: AutoSizeText(
              "Generate Backup Phrase",
              style: Theme.of(context).appBarTheme.textTheme.headline6,
              maxLines: 1,
            ),
            elevation: 0.0),
        body: Column(
          children: <Widget>[
            _buildBackupPhraseImage(),
            _buildInstructions(),
            _buildCheckbox(),
            SizedBox(
              height: _isUnderstood ? 0 : 48,
            )
          ],
        ),
        bottomNavigationBar: _buildNextBtn(_isUnderstood));
  }

  _buildBackupPhraseImage() {
    return Expanded(
      flex: 2,
      child: Image(
        image: AssetImage("src/images/generate_backup_phrase.png"),
        height: 100,
        width: 100,
      ),
    );
  }

  _buildInstructions() {
    return Padding(
      padding: EdgeInsets.only(
        left: 48,
        right: 48,
      ),
      child: Container(
        height: 96,
        child: AutoSizeText(
          _instructions,
          style: theme.backupPhraseInformationTextStyle,
          textAlign: TextAlign.center,
          minFontSize: MinFontSize(context).minFontSize,
          stepGranularity: 0.1,
        ),
      ),
    );
  }

  _buildCheckbox() {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Theme(
            data:
                Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
            child: Checkbox(
                activeColor: Colors.white,
                checkColor: Theme.of(context).canvasColor,
                value: _isUnderstood,
                onChanged: (value) {
                  setState(() {
                    _isUnderstood = value;
                  });
                }),
          ),
          Text(
            "I UNDERSTAND",
            style: theme.backupPhraseConfirmationTextStyle,
          )
        ],
      ),
    );
  }

  _buildNextBtn(bool isUnderstood) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        isUnderstood
            ? SingleButtonBottomBar(
                text: "NEXT",
                onPressed: () {
                  String mnemonics = bip39.generateMnemonic(strength: 128);
                  Navigator.pushReplacement(
                    context,
                    FadeInRoute(
                      builder: (BuildContext context) => withBreezTheme(
                        context,
                        GenerateBackupPhrasePage(mnemonics),
                      ),
                    ),
                  );
                },
              )
            : Container()
      ]),
    );
  }
}

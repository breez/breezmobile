import 'package:auto_size_text/auto_size_text.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'generate_backup_phrase_page.dart';

class BackupPhraseGeneratorConfirmationPage extends StatefulWidget {
  @override
  BackupPhraseGeneratorConfirmationPageState createState() =>
      BackupPhraseGeneratorConfirmationPageState();
}

class BackupPhraseGeneratorConfirmationPageState
    extends State<BackupPhraseGeneratorConfirmationPage> {
  bool _isUnderstood = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: themeData.appBarTheme.iconTheme,
        textTheme: themeData.appBarTheme.textTheme,
        backgroundColor: themeData.canvasColor,
        automaticallyImplyLeading: false,
        leading: backBtn.BackButton(),
        title: AutoSizeText(
          texts.backup_phrase_generate,
          style: themeData.appBarTheme.textTheme.headline6,
          maxLines: 1,
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          _buildBackupPhraseImage(),
          _buildInstructions(context),
          _buildCheckbox(context),
          SizedBox(
            height: _isUnderstood ? 0 : 48,
          )
        ],
      ),
      bottomNavigationBar: _buildNextBtn(context, _isUnderstood),
    );
  }

  Widget _buildBackupPhraseImage() {
    return Expanded(
      flex: 2,
      child: Image(
        image: AssetImage("src/images/generate_backup_phrase.png"),
        height: 100,
        width: 100,
      ),
    );
  }

  Widget _buildInstructions(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 48,
        right: 48,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 96,
        ),
        child: Text(
          texts.backup_phrase_instructions,
          style: theme.backupPhraseInformationTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Theme(
            data: themeData.copyWith(
              unselectedWidgetColor: Colors.white,
            ),
            child: Checkbox(
              activeColor: Colors.white,
              checkColor: themeData.canvasColor,
              value: _isUnderstood,
              onChanged: (value) => setState(() {
                _isUnderstood = value;
              }),
            ),
          ),
          Text(
            texts.backup_phrase_action_confirm,
            style: theme.backupPhraseConfirmationTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildNextBtn(BuildContext context, bool isUnderstood) {
    final texts = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isUnderstood
              ? SingleButtonBottomBar(
                  text: texts.backup_phrase_action_next,
                  onPressed: () {
                    String mnemonics = bip39.generateMnemonic(
                      strength: 128,
                    );
                    Navigator.pushReplacement(
                      context,
                      FadeInRoute(
                        builder: (context) => withBreezTheme(
                          context,
                          GenerateBackupPhrasePage(mnemonics),
                        ),
                      ),
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}

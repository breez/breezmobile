import 'package:auto_size_text/auto_size_text.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
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

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const backBtn.BackButton(),
        title: AutoSizeText(
          texts.backup_phrase_generate,
          maxLines: 1,
        ),
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
    return const Expanded(
      flex: 2,
      child: Image(
        image: AssetImage("src/images/generate_backup_phrase.png"),
        height: 100,
        width: 100,
      ),
    );
  }

  Widget _buildInstructions(BuildContext context) {
    final texts = context.texts();
    return Padding(
      padding: const EdgeInsets.only(
        left: 48,
        right: 48,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
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
    final texts = context.texts();
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
    final texts = context.texts();
    return Padding(
      padding: const EdgeInsets.only(top: 24),
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

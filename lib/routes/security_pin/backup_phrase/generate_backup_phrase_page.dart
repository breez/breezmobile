import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

import 'verify_backup_phrase_page.dart';

class GenerateBackupPhrasePage extends StatefulWidget {
  final String mnemonics;

  const GenerateBackupPhrasePage(
    this.mnemonics,
  );

  @override
  GenerateBackupPhrasePageState createState() =>
      GenerateBackupPhrasePageState();
}

class GenerateBackupPhrasePageState extends State<GenerateBackupPhrasePage> {
  final _autoSizeGroup = AutoSizeGroup();
  List<String> _mnemonicsList;

  @override
  void initState() {
    _mnemonicsList = widget.mnemonics.split(" ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: backBtn.BackButton(
            onPressed: () => _onWillPop(context),
          ),
          title: AutoSizeText(
            texts.backup_phrase_generation_write_words,
            maxLines: 1,
          ),
        ),
        body: _buildMnemonicSeedList(context, 0),
        bottomNavigationBar: _buildNextBtn(context),
      ),
    );
  }

  Widget _buildMnemonicItem(
    BuildContext context,
    int index,
    String mnemonic,
  ) {
    final texts = context.texts();
    return Container(
      height: 48,
      width: 150,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30),
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Row(
        children: [
          Text(
            texts.backup_phrase_generation_index(index + 1),
            style: theme.mnemonicsTextStyle,
          ),
          Expanded(
            child: AutoSizeText(
              mnemonic,
              style: theme.mnemonicsTextStyle,
              textAlign: TextAlign.center,
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              group: _autoSizeGroup,
            ),
          ),
        ],
      ),
    );
  }

  Row _buildMnemonicSeedList(BuildContext context, int page) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: List<Widget>.generate(
            6,
            (index) => _buildMnemonicItem(
              context,
              2 * index + (12 * (page)),
              _mnemonicsList[2 * index + (12 * (page))],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: List<Widget>.generate(
            6,
            (index) => _buildMnemonicItem(
              context,
              1 + 2 * index + 12 * (page),
              _mnemonicsList[1 + 2 * index + 12 * (page)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextBtn(BuildContext context) {
    final texts = context.texts();
    return SingleButtonBottomBar(
      text: texts.backup_phrase_warning_action_next,
      onPressed: () {
        Navigator.push(
          context,
          FadeInRoute(
            builder: (_) => withBreezTheme(
              context,
              VerifyBackupPhrasePage(widget.mnemonics),
            ),
          ),
        );
      },
    );
  }

  _onWillPop(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName("/security"));
  }
}
